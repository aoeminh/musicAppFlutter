import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/bloc/page_bloc.dart';
import 'package:music_flutter/widget/discovery/discovery.dart';
import 'package:music_flutter/widget/download/download.dart';
import 'package:music_flutter/widget/library/library_widget.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

void main() {
  Logger.root.level = Level.FINE;

  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record
            .message}');
  });

  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicAppHome(title: 'Flutter Demo Home Page'),
    );
  }
}

class MusicAppHome extends StatefulWidget {
  MusicAppHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MusicAppHomeState createState() => _MusicAppHomeState();
}

class _MusicAppHomeState extends State<MusicAppHome> {
  Logger log;

  @override
  void initState() {
    super.initState();
    log = Logger('_MyHomePageState');
  }

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<PageBlock>(context);
    return Scaffold(appBar: AppBar(), body: _buildBody(page),
        bottomNavigationBar: StreamBuilder(
          stream: page.currentPage,
          initialData: 0,
          builder: (context, AsyncSnapshot<int> snapshot){
            return BottomNavigationBar(
              currentIndex: snapshot.data,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  title: Text('')
                )
              ],
            );
          },
        ));
  }

  _buildBody(PageBlock pageBlock) =>
      Column(
        children: <Widget>[
          CustomScrollView(slivers: <Widget>[
            SliverAppBar(
                title: RichText(
                    text: TextSpan(
                        text: 'AnyTime',
                        style: TextStyle(color: Colors.red),
                        children: <TextSpan>[TextSpan(text: 'Player')])
                )
            ),
            StreamBuilder<int>(
              stream: pageBlock.currentPage,
              builder: (context, AsyncSnapshot<int> snapshot) {
                return buildCurrentPage(snapshot.data);
              },
            )

          ])
        ]
        ,
      );

  buildCurrentPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return LibraryWidget();
      case 1:
        return DiscoveryWidget();
      case 2:
        return DownloadWidget();
      default:
        return LibraryWidget();
    }
  }

  Future<SearchResult> _search(String term) {
    return Search().search(term, limit: 1).timeout(Duration(seconds: 10));
  }
}
