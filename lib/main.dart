// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_master.dart';
import 'package:tiny_release/util/NavRoutes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.AppBar.actions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model Releases'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Open control screen',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new MasterControlWidget()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'New release',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new MasterControlWidget()),
              );
            },

          ),
        ],
      ),
    );
  }
}
