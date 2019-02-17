// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/contract/contract_list.dart';
import 'package:tiny_release/screens/control/control_master.dart';
import 'package:tiny_release/util/tiny_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final TinyState tinyState = new TinyState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for material.AppBar.actions',
      routes: tinyState.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyStatelessWidget(tinyState),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  TinyState tinyState = new TinyState();

  MyStatelessWidget(this.tinyState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    title: Text("Model Release"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),

                ],),
              tabBuilder: (BuildContext context, int index) {

                switch(index) {
                  case 0:
                    return new ContractListWidget(tinyState);
                  case 1:
                    return new MasterControlWidget(tinyState);
                }
              },
        );
  }
}
