import 'package:flutter/material.dart';

final ThemeData primaryTheme = ThemeData.light().copyWith(
    primaryColor: Colors.green,
    iconTheme: IconThemeData(color: Colors.green),

  canvasColor: Colors.transparent,
  primaryIconTheme: IconThemeData(color: Colors.grey[800]),
);

class ThemeApp {
  final ThemeData themeData;

  ThemeApp(this.themeData);

  factory ThemeApp.primary() => ThemeApp(primaryTheme);

}

