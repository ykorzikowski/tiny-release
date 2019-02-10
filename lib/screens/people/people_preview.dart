
import 'package:flutter/material.dart';
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
        body: Text("Hello World")
    );
  }

}