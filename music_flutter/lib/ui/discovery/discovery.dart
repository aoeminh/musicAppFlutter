import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:music_flutter/generated/l10n.dart';
import 'bloc/discover_block.dart';
import 'bloc/discover_event_state.dart';
import '../podcast_list.dart';
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
    bloc = Provider.of<DiscoverBloc>(context, listen: false);
    bloc.getDisCover(DiscoverGetListEvent(10));
  }

  @override
  Widget build(BuildContext context) {
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
      if(state.result.items.isNotEmpty){
        return SliverFillRemaining(
            child: PodcastList(
              result: state.result,
              bloc: bloc,
            ));
      }else{
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(S.of(context).no_search_results_message),
            FlatButton(
              onPressed: (){
                bloc.getDisCover(DiscoverGetListEvent(10));
              },
              child: Text('Refresh'),
            )

          ],
        );
      }

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
