
import 'package:flutter/material.dart';
import 'package:tiny_release/data/contact_full.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/data/contact_repository.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleEditWidget extends StatefulWidget {

  final ControlScreenState _controlState;
  final TinyContact tinyContact;

  PeopleEditWidget(this._controlState, this.tinyContact);

  @override
  _PeopleEditWidgetState createState() => _PeopleEditWidgetState(_controlState);
}

class _PeopleEditWidgetState extends State<PeopleEditWidget> {
  final ContactRepository contactRepository = new ContactRepository();
  final ControlScreenState _controlState;

  _PeopleEditWidgetState(this._controlState);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Edit"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save_alt),
              tooltip: 'Save',
              onPressed: () {
                _controlState.setToolbarButtonsOnEdit();
                ControlHelper.handleSaveButton( _controlState, Navigator.of(context) );
              },
            ),
          ],
        ) : null,
        body: Text("Edit People")
    );
  }

}