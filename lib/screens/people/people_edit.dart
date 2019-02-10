
import 'package:flutter/material.dart';
import 'package:tiny_release/data/contact_full.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';
import 'package:tiny_release/data/contact_repository.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleEditWidget extends StatefulWidget {

  final ControlScreenState peopleTypeState;
  final TinyContact tinyContact;

  PeopleEditWidget(this.peopleTypeState, this.tinyContact);

  @override
  _PeopleEditWidgetState createState() => _PeopleEditWidgetState(peopleTypeState);
}

class _PeopleEditWidgetState extends State<PeopleEditWidget> {
  final ContactRepository contactRepository = new ContactRepository();
  final ControlScreenState peopleTypeState;

  _PeopleEditWidgetState(this.peopleTypeState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: !BaseUtil.isLargeScreen(context) ? AppBar(
          title: Text("Edit"),
        ) : null,
        body: Text("Edit People")
    );
  }

}