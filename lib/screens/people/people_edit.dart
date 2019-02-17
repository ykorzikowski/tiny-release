
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/NavRoutes.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleEditWidget extends StatefulWidget {

  final TinyState _controlState;

  PeopleEditWidget(this._controlState);

  @override
  _PeopleEditWidgetState createState() => _PeopleEditWidgetState(_controlState);
}

class _PeopleEditWidgetState extends State<PeopleEditWidget> {
  final TinyState _controlState;
  TinyPeople _tinyPeople;

  _PeopleEditWidgetState(this._controlState) {
    _tinyPeople = TinyPeople.fromMap( TinyPeople.toMap (_controlState.curDBO ) );
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  Widget imageAndNameSection() =>
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: _tinyPeople.avatar == null
                  ? null
                  : new MemoryImage(_tinyPeople.avatar),
              backgroundColor: Colors.lightGreen,
              radius: 32.0,
            ),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    key: Key('tf_givenName'),
                    onChanged: (t) => _tinyPeople.givenName = t,
                    controller: initialValue(_tinyPeople.givenName),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'givenname',
                    ),
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    key: Key('tf_familyName'),
                    onChanged: (t) => _tinyPeople.familyName = t,
                    controller: initialValue(_tinyPeople.familyName),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'familyName',
                    ),
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    key: Key('tf_company'),
                    onChanged: (t) => _tinyPeople.company = t,
                    controller: initialValue(_tinyPeople.company),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'company',
                    ),
                  ),),
              ],
            ) ,
          )

        ],
      );


  /// get info widget
  Widget infoWidget() =>
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              key: Key('tf_idType'),
              onChanged: (t) => _tinyPeople.idType = t,
              controller: initialValue(_tinyPeople.idType),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'id type',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              key: Key('tf_idNumber'),
              onChanged: (t) => _tinyPeople.idNumber = t,
              controller: initialValue(_tinyPeople.idNumber),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'id number',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              key: Key('tf_birthday'),
              onChanged: (t) => _tinyPeople.birthday = t,
              controller: initialValue(_tinyPeople.birthday),
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'birthday',
              ),
            ),),

        ],
      );

  /// get phone widgets
  List< Widget > getPhoneWidgets() =>
      _tinyPeople.phones.map((phone) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Dismissible(
                direction: DismissDirection.endToStart,
                background: BaseUtil.getDismissibleBackground(),
                key: Key(phone.hashCode.toString()),
                onDismissed: (direction) => setState(() {_tinyPeople.phones.remove(phone); }),
                child: getPhoneWidget(phone)
            ),
          ),
      ).toList();

  /// get single phone widget
  Widget getPhoneWidget(phone) =>
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => phone.label = t,
              controller: initialValue(phone.label),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'phone label',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => phone.value = t,
              controller: initialValue(phone.value),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'phone',
              ),
            ),),
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
      _tinyPeople.emails.map((mail) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Dismissible(
                direction: DismissDirection.endToStart,
                background: BaseUtil.getDismissibleBackground(),
                key: Key(mail.hashCode.toString()),
                onDismissed: (direction) => setState(() {_tinyPeople.emails.remove(mail); }),
                child: getMailWidget(mail)
            ),
          ),
      ).toList();

  /// get single mail widget
  Widget getMailWidget(mail) =>
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => mail.label = t,
              controller: initialValue(mail.label),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'mail label',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: TextField(
              onChanged: (t) => mail.value = t,
              controller: initialValue(mail.value),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'mail',
              ),
            ),),
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
      _tinyPeople.postalAddresses.map((ta) =>
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Dismissible(
                direction: DismissDirection.endToStart,
                background: BaseUtil.getDismissibleBackground(),
                key: Key(ta.hashCode.toString()),
                onDismissed: (direction) => setState(() {_tinyPeople.postalAddresses.remove(ta); }),
                child: getAddressWidget(ta)
            ),
          ),
      ).toList();

  /// get single address widget
  Widget getAddressWidget(address) =>
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => address.label = t,
              controller: initialValue(address.label),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'adress_label',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => address.street = t,
              controller: initialValue(address.street),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'street',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            Row(
              children: <Widget>[
                Flexible(child: TextField(
                  onChanged: (t) => address.postcode = t,
                  controller: initialValue(address.postcode),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'postcode',
                  ),
                )),
                Flexible(child: TextField(
                  onChanged: (t) => address.city = t,
                  controller: initialValue(address.city),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'city',
                  ),
                )),
              ],
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => address.region = t,
              controller: initialValue(address.region),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'region',
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            TextField(
              onChanged: (t) => address.country = t,
              controller: initialValue(address.country),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'country',
              ),
            ),),
        ],
      );

  /// address section
  Widget addressSection() =>
      Container(
        child: Column(
          children: getAddressWidgets(),
        ),
      );

  bool validContact() {
    return
      _tinyPeople.familyName != null && _tinyPeople.familyName.isNotEmpty &&
          _tinyPeople.givenName != null && _tinyPeople.givenName.isNotEmpty &&
            _tinyPeople.familyName != null && _tinyPeople.familyName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("People hinzufügen"),
        trailing: CupertinoButton(
          child: Text("Speichern", key: Key('btn_navbar_save')),
          onPressed: validContact() ? () {
            if (!validContact()) {
              return;
            }
            new TinyPeopleRepo().save(_tinyPeople);
            Navigator.of(context).popUntil((route) =>
            !Navigator.of(context)
                .canPop());
            Navigator.of(context).pushNamed(NavRoutes.PEOPLE_PREVIEW);
          } : null,),),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          imageAndNameSection(),
          Divider(),
          infoWidget(),
          Divider(),
          mailSection(),
          FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Mail"),
              onPressed: () =>
                  setState(() {
                    _tinyPeople.emails.add(TinyPeopleItem());
                  })
          ),
          Divider(),

          phoneSection(),
          FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Phone"),
              onPressed: () =>
                  setState(() {
                    _tinyPeople.phones.add(TinyPeopleItem());
                  })
          ),
          Divider(),

          addressSection(),
          FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Address"),
              onPressed: () =>
                  setState(() {
                    _tinyPeople.postalAddresses.add(TinyAddress());
                  })
          ),
          Divider(),
          CupertinoButton(
            child: Text("Aus Kontakten importieren"),
            onPressed: () {
              Navigator.of(context).pushNamed(NavRoutes.PEOPLE_IMPORT);
            },
          )
        ],
      ),
    );
  }
}