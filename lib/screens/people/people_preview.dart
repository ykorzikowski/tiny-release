
import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/screens/people/people_list.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:paperflavor/util/nav_routes.dart';

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
                  backgroundColor: Colors.lightBlue,
                  child: tinyPeople.avatar == null ? Text(
                    PeopleListWidget.getCircleText(tinyPeople),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ) : null,
                  backgroundImage: tinyPeople.avatar != null ? new FileImage(Io.File(tinyPeople.avatar)) : null,
                  radius: 32.0,
                ),
              ),
            ],
      );

  bool shouldPrintInfoDivider() {
    return tinyPeople.idType != null ||
        tinyPeople.idNumber != null ||
        tinyPeople.birthday != null;
  }

  /// get info widget
  Widget infoWidget() =>
      Column(
        children: <Widget>[
          tinyPeople.idType != null ? Text(tinyPeople.idType) : Container(),
          tinyPeople.idNumber != null ? Text(tinyPeople.idNumber) : Container(),
          tinyPeople.birthday != null ? Text(S.of(context).birthday) : Container(),
          tinyPeople.birthday != null ? Text(BaseUtil.getLocalFormattedDate(context, tinyPeople.birthday)) : Container(),
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
          address.region != null ? Text(address.region) : Container(),
          address.country != null ? Text(address.country) : Container(),
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
        heroTag: 'control',
        transitionBetweenRoutes: false,
        border: null,
        trailing: CupertinoButton(
          padding: EdgeInsets.all(13),
          child: Text(S.of(context).btn_edit),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavRoutes.PEOPLE_EDIT),
        ),),
      child:
      Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverAppBar(
              flexibleSpace:
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      background: imageAndNameSection(),
                      title: Text(tinyPeople.displayName, style: TextStyle(
                        color: CupertinoColors.black,
                      ),),
                    );
                  }),
              expandedHeight: 125,
              leading: Container(),
              backgroundColor: CupertinoColors.white,
              primary: false,
              snap: false,
              floating: false,
              pinned: true,
            ),
            SliverList(delegate:
            SliverChildListDelegate([
              Column(
                children: <Widget>[
                  Divider(),
                  tinyPeople.company != null ? Text(tinyPeople.company) : Container(),
                  infoWidget(),
                  shouldPrintInfoDivider() ? Divider() : Container(),
                  mailSection(),
                  tinyPeople.emails.length > 0 ? Divider() : Container(),
                  phoneSection(),
                  tinyPeople.phones.length > 0 ? Divider() : Container(),
                  addressSection(),
                  tinyPeople.postalAddresses.length > 0
                      ? Divider()
                      : Container(),
                ],
              ),
            ]),
            )
          ]),
        ),

      ),
    );
  }

}
