
import 'package:flutter/material.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/data/contact_repository.dart';

typedef Null ItemSelectedCallback(int value);

class PeoplePreviewWidget extends StatefulWidget {

  final ControlScreenState peopleTypeState;

  PeoplePreviewWidget(this.peopleTypeState);

  @override
  _PeoplePreviewWidgetState createState() => _PeoplePreviewWidgetState(peopleTypeState);
}

class _PeoplePreviewWidgetState extends State<PeoplePreviewWidget> {
  final ContactRepository contactRepository = new ContactRepository();
  final ControlScreenState peopleTypeState;

  _PeoplePreviewWidgetState(this.peopleTypeState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("Hello World"),
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Preview"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () {
                ControlHelper.handleEditButton( peopleTypeState, Navigator.of(context) );
              },
            ),
          ],
        ) : null,
    );
  }

}