import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/api/podcast_api_impl.dart';
import 'package:music_flutter/bloc/audio_bloc.dart';
import 'package:music_flutter/bloc/page_bloc.dart';
import 'package:music_flutter/service/audio/audio_service.dart';
import 'package:music_flutter/service/audio/audio_service_impl.dart';
import 'package:music_flutter/service/podcast_service.dart';
import 'package:music_flutter/service/podcast_service_impl.dart';
import 'package:music_flutter/themes.dart';
import 'package:music_flutter/ui/now_playing.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'repository/repository.dart';
import 'repository/sembast/sembast_repository.dart';
import 'ui/discovery/bloc/discover_block.dart';
import 'ui/discovery/discovery.dart';
import 'ui/download/download.dart';
import 'ui/library/library_widget.dart';
import 'ui/podcast_detail/bloc/podcast_bloc.dart';
import 'ui/search/search.dart';
import 'ui/widget/mini_player.dart';

void main() {
  Logger.root.level = Level.FINE;

  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}');
  });

  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  // This widget is the root of your application.
  final themes = ThemeApp.primary();
  final PodCastApiImpl podCastApi;
  final Repository repository;
  PodcastService podcastService;
  AudioPlayerService audioPlayerService;

  MusicApp()
      : repository = SembastRepository(),
        audioPlayerService = AudioPlayerServiceImpl(),
        podCastApi = PodCastApiImpl() {
    this.podcastService = PodcastServiceImpl(podCastApi, repository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PageBlock>(
          create: (_) => PageBlock(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<DiscoverBloc>(
          create: (_) => DiscoverBloc(podcastService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PodcastBloc>(
          create: (_) => PodcastBloc(podcastService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AudioBloc>(
          create: (_) => AudioBloc(audioPlayerService: audioPlayerService),
          dispose: (_, value) => value.dispose(),
        )
      ],
      child: MaterialApp(
        title: 'Music Flutter',
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: themes.themeData,
        home: MusicAppHome(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MusicAppHome extends StatefulWidget {
  MusicAppHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MusicAppHomeState createState() => _MusicAppHomeState();
}

class _MusicAppHomeState extends State<MusicAppHome>
    with WidgetsBindingObserver {
  Logger log;

  @override
  void initState() {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    audioBloc.changeLifecycle(AppLifecycleState.resumed);


    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState $state');
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      audioBloc.changeLifecycle(state);
    } else if (state == AppLifecycleState.paused) {
      audioBloc.changeLifecycle(state);
    }
  }

  @override
  void dispose() {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    WidgetsBinding.instance.removeObserver(this);
    audioBloc.changeLifecycle(AppLifecycleState.paused);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<PageBlock>(context);
    return Scaffold(
        body: _buildBody(page),
        bottomNavigationBar: StreamBuilder(
          initialData: 0,
          stream: page.currentPage,
          builder: (context, AsyncSnapshot<int> snapshot) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: snapshot.data,
              onTap: page.changePage,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  title: Text(S.of(context).library),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  title: Text(S.of(context).discover),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_download),
                  title: Text(S.of(context).downloads),
                ),
              ],
            );
          },
        ));
  }

  _buildBody(PageBlock pageBlock) => AudioServiceWidget(
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(slivers: <Widget>[
                buildAppBar(),
                StreamBuilder<int>(
                  initialData: 0,
                  stream: pageBlock.currentPage,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return buildCurrentPage(snapshot.data);
                  },
                )
              ]),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NowPlaying()));
                },
                child: MiniPlayer())
          ],
        ),
      );

  Route createNowPlayingRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondAnimation) => NowPlaying(),
        transitionsBuilder: (context, animation, secondAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curves = CurveTween(curve: Curves.easeIn);
          var tween = Tween(begin: begin, end: end).chain(curves);

          var tweenAnimation = animation.drive(tween);
          return SlideTransition(
            position: tweenAnimation,
            child: child,
          );
        });
  }

  buildAppBar() => SliverAppBar(
        floating: false,
        pinned: true,
        snap: false,
//        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Text('Anytime', style: TextStyle(color: Colors.red)),
            Text(' Player', style: TextStyle(color: Colors.black))
          ],
        ),
        actions: <Widget>[
          InkWell(
              onTap: () => Navigator.push(context, createRoute()),
              child: Icon(Icons.search)),
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  child: Text('Settings'),
                  value: 'settings',
                ),
                PopupMenuItem(
                  child: Text(S.of(context).about_label),
                  value: 'about',
                )
              ];
            },
          )
        ],
      );

  Route createRoute() =>
      PageRouteBuilder(pageBuilder: (context, animation, secondAnimation) {
        return SearchWidget();
      }, transitionsBuilder: (context, animation, secondAnimation, child) {
        final begin = Offset(1.0, 0.0);
        final end = Offset.zero;
        var curvesTween = CurveTween(curve: Curves.ease);
        var tween = Tween(begin: begin, end: end).chain(curvesTween);
        var animationSearch = animation.drive(tween);
        return SlideTransition(
          position: animationSearch,
          child: child,
        );
      });

  buildCurrentPage(int index) {
    if (index == 0) {
      return LibraryWidget();
    } else if (index == 1) {
      return DiscoveryWidget();
    } else {
      return DownloadWidget();
    }
  }

  Future<SearchResult> _search(String term) {
    return Search().search(term, limit: 1).timeout(Duration(seconds: 10));
  }
}
