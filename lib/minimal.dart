// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MinimalApp());

class MinimalApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.AppBar.actions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageOneWidget(),
    );
  }
}

class PageOneWidget extends StatelessWidget {
  PageOneWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child:
      Scaffold(
        body: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              maximumYear: DateTime.now().year,
              minimumYear: 1900,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (t) => {},
    ),
      ),
    );
  }
}

class PageTwoWidget extends StatelessWidget {
  PageTwoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(),
      child: Text("Page2"),
    );
  }
}