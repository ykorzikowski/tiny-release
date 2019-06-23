// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paperflavor/cupertino_localizations.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/screens/contract/contract_list.dart';
import 'package:paperflavor/screens/control/control_master.dart';
import 'package:paperflavor/util/tiny_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final TinyState tinyState = new TinyState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        FallbackCupertinoLocalisationsDelegate(),
        //DefaultCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate.resolution(fallback: const Locale('en', '')),
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
  final TinyState tinyState;

  MyStatelessWidget(this.tinyState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                key: Key('tap_bar'),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.add, key: Key('tab_bar_add'),),
                    title: Text(S.of(context).model_release),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.settings, key: Key('tab_bar_settings'),),
                    title: Text(S.of(context).control),
                  ),

                ],),
              tabBuilder: (BuildContext context, int index) {

                switch(index) {
                  case 0:
                    return new ContractListWidget(tinyState: tinyState);
                  case 1:
                    return new MasterControlWidget(tinyState);
                }
              },
        );
  }
}
