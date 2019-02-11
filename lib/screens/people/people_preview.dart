
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/ControlState.dart';

typedef Null ItemSelectedCallback(int value);

class PeoplePreviewWidget extends StatefulWidget {

  final ControlScreenState peopleTypeState;

  PeoplePreviewWidget(this.peopleTypeState);

  @override
  _PeoplePreviewWidgetState createState() => _PeoplePreviewWidgetState(peopleTypeState);
}

class _PeoplePreviewWidgetState extends State<PeoplePreviewWidget> {
  final ControlScreenState peopleTypeState;
  TinyPeople tinyPeople;

  _PeoplePreviewWidgetState(this.peopleTypeState) {
    tinyPeople = peopleTypeState.curDBO;
  }

  Widget imageAndNameSection() =>
      Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: tinyPeople.avatar == null
                      ? null
                      : new MemoryImage(tinyPeople.avatar),
                  backgroundColor: Colors.lightGreen,
                  radius: 32.0,
                ),
              ),
              Text(tinyPeople.displayName,
                style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),),
              Text(tinyPeople.company),
            ],
      );

  /// get phone widgets
  List< Widget > getPhoneWidgets() =>
      tinyPeople.phones.map((phone) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: getPhoneWidget(phone),
          ),
      ).toList();

  /// get single phone widget
  Widget getPhoneWidget(phone) =>
      Column(
        children: <Widget>[
          Text(phone.label),
          Text(phone.value,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),)
        ],
      );

  /// phone section
  Widget phoneSection() =>
      Container(
        child: Column(
          children: getPhoneWidgets(),
        ),
      );

  /// get mail widgets
  List< Widget > getMailWidgets() =>
      tinyPeople.emails.map((mail) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: getMailWidget(mail),
          ),
      ).toList();

  /// get single mail widget
  Widget getMailWidget(mail) =>
      Column(
        children: <Widget>[
          Text(mail.label),
          Text(mail.value,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),)
        ],
      );

  /// mail section
  Widget mailSection() =>
      Container(
        child: Column(
          children: getMailWidgets(),
        ),
      );

  /// get address widgets
  List<Widget> getAddressWidgets() =>
      tinyPeople.postalAddresses.map((ta) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: getAddressWidget(ta),
          ),
      ).toList();

  /// get single address widget
  Widget getAddressWidget(address) =>
      Column(
        children: <Widget>[
          Text(address.label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
          ),),
          Text(address.street),
          Text(
              address.postcode +
                  " " +
                  address.city),
          Text(address.region),
          Text(address.country),
        ],
      );

  /// address section
  Widget addressSection() =>
      Container(
        child: Column(
            children: getAddressWidgets(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          children: <Widget>[
            imageAndNameSection(),
            Divider(),
            new Expanded(
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    mailSection(),
                    tinyPeople.emails.length > 0 ? Divider() : Container(),
                    phoneSection(),
                    tinyPeople.phones.length > 0 ? Divider() : Container(),
                    addressSection(),
                    tinyPeople.postalAddresses.length > 0 ? Divider() : Container(),
                  ],
                )
            )

          ],
        ),
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