import 'package:flutter/material.dart';

class DiscoveryWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    print('build discover');
    return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          child: Text('Discovery'),
        ));
  }
}
