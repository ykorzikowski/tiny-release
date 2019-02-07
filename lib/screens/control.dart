// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';

class ControlWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Verwaltung';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('Models'),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('Fotografen'),
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('Zeugen'),
            ),
            ListTile(
              leading: Icon(Icons.wallpaper),
              title: Text('Vorlagen'),
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Aufnahmebereiche'),
            ),
            ListTile(
              leading: Icon(Icons.layers),
              title: Text('Layouts'),
            ),
            ListTile(
              leading: Icon(Icons.speaker_notes),
              title: Text('Wording'),
            ),
          ],
        ),
      ),
    );
  }
}