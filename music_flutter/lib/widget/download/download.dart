import 'package:flutter/material.dart';

class DownloadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
        hasScrollBody: false,
        child: Container(
          child: Text('Download'),
        ));
  }
}
