import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/widget/discovery/bloc/discover_block.dart';
import 'package:music_flutter/widget/discovery/bloc/discover_event_state.dart';
import 'package:music_flutter/widget/podcast_list.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class DiscoveryWidget extends StatefulWidget {
  @override
  _DiscoveryWidgetState createState() => _DiscoveryWidgetState();
}

class _DiscoveryWidgetState extends State<DiscoveryWidget> {
  final log = Logger('Episode');
  DiscoverBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('build initState');
    bloc = Provider.of<DiscoverBloc>(context, listen: false);
    bloc.getDisCover(DiscoverGetListEvent(10));
  }

  @override
  Widget build(BuildContext context) {
    print('build discover');
    return StreamBuilder<DiscoveryState>(
      initialData: DiscoveryLoadingState(),
      stream: bloc.discoverStream,
      builder: (context, AsyncSnapshot<DiscoveryState> snapshot) {
        return _buildBody(snapshot);
      },
    );
  }

  _buildBody(AsyncSnapshot<DiscoveryState> snapshot) {
    var state = snapshot.data;
    if (state is DiscoveryLoadingState) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
      );
    } else if (state is DiscoveryResultState) {
      return SliverFillRemaining(
          child: PodcastList(
        result: state.result,
      ));
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          child: Text(''),
        ),
      );
    }
  }
}
