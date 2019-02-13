
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/NavRoutes.dart';

typedef Null ItemSelectedCallback(int value);

class PeoplePreviewWidget extends StatefulWidget {

  final TinyState peopleTypeState;

  PeoplePreviewWidget(this.peopleTypeState);

  @override
  _PeoplePreviewWidgetState createState() => _PeoplePreviewWidgetState(peopleTypeState);
}

class _PeoplePreviewWidgetState extends State<PeoplePreviewWidget> {
  final TinyState peopleTypeState;
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
              Text(tinyPeople.givenName + " " + tinyPeople.familyName,
                style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),),
              tinyPeople.company != null ? Text(tinyPeople.company) : Container(),
            ],
      );


  /// get info widget
  Widget infoWidget() =>
      Column(
        children: <Widget>[
          tinyPeople.idType != null ? Text(tinyPeople.idType) : Container(),
          tinyPeople.idNumber != null ? Text(tinyPeople.idNumber) : Container(),
          tinyPeople.birthday != null ? Text("Geburtstag") : Container(),
          tinyPeople.birthday != null ? Text(tinyPeople.birthday) : Container(),
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
          border: null,
        trailing: CupertinoButton(
          child: Text("Bearbeiten"),
          onPressed: () => Navigator.of(context).pushNamed(NavRoutes.PEOPLE_EDIT),
        ),),
      child:
      Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              imageAndNameSection(),
              Divider(),
              infoWidget(),
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
                      tinyPeople.postalAddresses.length > 0
                          ? Divider()
                          : Container(),
                    ],
                  )
              )
            ],
          ),),
      ),
    );
  }

}