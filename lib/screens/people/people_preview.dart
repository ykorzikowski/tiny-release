
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
      Flexible(
          child: Column(
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
          )
      );

  Widget phoneSection() =>
      Flexible(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: tinyPeople.phones.length,
            itemBuilder: (ctxt, index) =>
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                      children: <Widget>[
                        Text(tinyPeople.phones[index].label),
                        Text(tinyPeople.phones[index].value,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),)
                      ]
                  ),
                ),
          ));

  Widget mailSection() => Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tinyPeople.emails.length,
          itemBuilder: (ctxt, index) =>
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: <Widget>[
                    Text(tinyPeople.emails[index].label),
                    Text(tinyPeople.emails[index].value,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),)
                  ],
                ),),
        ),
      );

  List<Widget> getAddressWidgets() {
    var list = List();

    for( var address in tinyPeople.postalAddresses ) {
      list.add(
          Column(
        children: <Widget>[
          Text(address.label),
          Text(address.street),
          Text(
              address.postcode +
                  " " +
                  address.city),
          Text(address.region),
          Text(address.country),
        ],
      ) );
    }

    return list;
  }

  Widget addressSection() =>
      Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tinyPeople.postalAddresses.length,
          itemBuilder: (ctxt, index) =>
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                    children: <Widget>[
                      Text(tinyPeople.postalAddresses[index].label),
                      Text(tinyPeople.postalAddresses[index].street),
                      Text(
                          tinyPeople.postalAddresses[index].postcode +
                              " " +
                              tinyPeople.postalAddresses[index].city),
                      Text(tinyPeople.postalAddresses[index].region),
                      Text(tinyPeople.postalAddresses[index].country),
                    ]
                ),),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          children: <Widget>[
            imageAndNameSection(),
            Divider(),
            mailSection(),
            tinyPeople.emails.length > 0 ? Divider() : Container(),
            phoneSection(),
            tinyPeople.phones.length > 0 ? Divider() : Container(),
            addressSection(),
            tinyPeople.postalAddresses.length > 0 ? Divider() : Container(),
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