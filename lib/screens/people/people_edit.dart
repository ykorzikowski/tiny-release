
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'package:tiny_release/util/NavRoutes.dart';

typedef Null ItemSelectedCallback(int value);

class PeopleEditWidget extends StatefulWidget {

  final TinyState _tinyState;

  PeopleEditWidget(this._tinyState);

  @override
  _PeopleEditWidgetState createState() => _PeopleEditWidgetState(_tinyState);
}

class _PeopleEditWidgetState extends State<PeopleEditWidget> {
  final TinyState _tinyState;
  TinyPeople _tinyPeople;

  _PeopleEditWidgetState(this._tinyState) {
    _tinyPeople = TinyPeople.fromMap( TinyPeople.toMap (_tinyState.curDBO ) );
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  Future getImage(ImageSource source) async {
    File selectedFile = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: selectedFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    if ( croppedFile != null ) {
      BaseUtil.storeFile("people_", croppedFile).then((file) => setState((){
        _tinyPeople.avatar = file.path;
      }));
    }
  }

  Widget imageAndNameSection() =>
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(context: context, builder: (context) =>
                    CupertinoActionSheet(
                      title: Text(S.of(context).choose_source), actions: <Widget>[
                      CupertinoActionSheetAction(
                        child: Text(S.of(context).camera),
                        onPressed: () {
                          getImage(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Text(S.of(context).gallery),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text(S
                            .of(context)
                            .cancel, style: TextStyle(
                            color: CupertinoColors.destructiveRed),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),

                    ),);
              },
              child: CircleAvatar(
                child: _tinyPeople.avatar == null ? Icon(CupertinoIcons.add, color: CupertinoColors.white,) : Container(),
                backgroundImage: _tinyPeople.avatar == null
                    ? null
                    : new FileImage(File(_tinyPeople.avatar)),
                backgroundColor: CupertinoColors.activeBlue,
                radius: 32.0,
              ),
            ),
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  CupertinoTextField(
                    key: Key('tf_givenName'),
                    onChanged: (t) => _tinyPeople.givenName = t,
                    controller: initialValue(_tinyPeople.givenName),
                    placeholder: S.of(context).hint_givenname,
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  CupertinoTextField(
                    key: Key('tf_familyName'),
                    onChanged: (t) => _tinyPeople.familyName = t,
                    controller: initialValue(_tinyPeople.familyName),
                    placeholder: S.of(context).hint_familyname,
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  CupertinoTextField(
                    key: Key('tf_company'),
                    onChanged: (t) => _tinyPeople.company = t,
                    controller: initialValue(_tinyPeople.company),
                    placeholder:  S.of(context).hint_company,
                  ),),
              ],
            ) ,
          )

        ],
      );


  /// get info widget
  Widget infoWidget() =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              key: Key('tf_idType'),
              onChanged: (t) => _tinyPeople.idType = t,
              controller: initialValue(_tinyPeople.idType),
              placeholder:  S.of(context).hint_id_type,
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              key: Key('tf_idNumber'),
              onChanged: (t) => _tinyPeople.idNumber = t,
              controller: initialValue(_tinyPeople.idNumber),
              placeholder:  S.of(context).hint_id_number,
            ),),
              ListTile(
                leading: Text(S.of(context).hint_birthday),
                title: CupertinoButton(
                  child: _tinyPeople.birthday != null ? Text(BaseUtil.getLocalFormattedDate(context, _tinyPeople.birthday)) : Text(S.of(context).chose_brithday),
                  onPressed: () =>
                      showModalBottomSheet(
                        context: context, builder: (context) =>
                          Column(children: <Widget>[
                            CupertinoNavigationBar(
                              trailing: CupertinoButton(
                                child: Text(S.of(context).select_date_ok),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              middle: Text(S.of(context).select_birthday),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                maximumYear: DateTime.now().year,
                                minimumYear: 1900,
                                initialDateTime: _tinyPeople.birthday != null ? DateTime.parse(_tinyPeople.birthday) : DateTime.now(),
                                onDateTimeChanged: (t) => _tinyPeople.birthday = t.toIso8601String(),
                              ),
                            )

                            ],)),
                ),
              )

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
            CupertinoTextField(
              onChanged: (t) => phone.label = t,
              controller: initialValue(phone.label),
              placeholder:  S.of(context).hint_phone_label,
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              onChanged: (t) => phone.value = t,
              controller: initialValue(phone.value),
              keyboardType: TextInputType.phone,
              placeholder:  S.of(context).hint_phone,
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
            CupertinoTextField(
              onChanged: (t) => mail.label = t,
              controller: initialValue(mail.label),
              placeholder:  S.of(context).hint_mail_label,
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: CupertinoTextField(
              onChanged: (t) => mail.value = t,
              controller: initialValue(mail.value),
              keyboardType: TextInputType.emailAddress,
              placeholder:  S.of(context).hint_mail,
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
            CupertinoTextField(
              onChanged: (t) => address.label = t,
              controller: initialValue(address.label),
              placeholder:  S.of(context).hint_adresslabel,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              onChanged: (t) => address.street = t,
              controller: initialValue(address.street),
              placeholder:  S.of(context).hint_street,
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            Row(
              children: <Widget>[
                Flexible(child: CupertinoTextField(
                  onChanged: (t) => address.postcode = t,
                  controller: initialValue(address.postcode),
                  keyboardType: TextInputType.number,
                  placeholder:  S.of(context).hint_postcode,
                )),
                Flexible(child: CupertinoTextField(
                  onChanged: (t) => address.city = t,
                  controller: initialValue(address.city),
                  placeholder:  S.of(context).hint_city,
                )),
              ],
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              onChanged: (t) => address.region = t,
              controller: initialValue(address.region),
              placeholder:  S.of(context).hint_region,
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              onChanged: (t) => address.country = t,
              controller: initialValue(address.country),
              placeholder:  S.of(context).hint_country,
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
        heroTag: 'control',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).title_add_people),
        trailing: CupertinoButton(
          child: Text(S.of(context).brn_save, key: Key('btn_navbar_save')),
          onPressed: validContact() ? () {
            if (!validContact()) {
              return;
            }
            new TinyPeopleRepo().save(_tinyPeople);
            _tinyState.curDBO = _tinyPeople;
              Navigator.of(context).pop();
//            Navigator.of(context).popUntil((route) => route.settings.name == NavRoutes.PEOPLE_LIST);
//            Navigator.of(context).pushNamed(NavRoutes.PEOPLE_PREVIEW);
          } : null,),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            imageAndNameSection(),
            Divider(),
            infoWidget(),
            Divider(),
            mailSection(),
            FlatButton.icon(
                icon: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen,),
                label: Text(S.of(context).btn_add_mail),
                onPressed: () =>
                    setState(() {
                      _tinyPeople.emails.add(TinyPeopleItem());
                    })
            ),
            Divider(),

            phoneSection(),
            FlatButton.icon(
                icon: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen,),
                label: Text(S.of(context).btn_add_phone),
                onPressed: () =>
                    setState(() {
                      _tinyPeople.phones.add(TinyPeopleItem());
                    })
            ),
            Divider(),

            addressSection(),
            FlatButton.icon(
                icon: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen,),
                label: Text(S.of(context).btn_add_address),
                onPressed: () =>
                    setState(() {
                      _tinyPeople.postalAddresses.add(TinyAddress());
                    })
            ),
            Divider(),
            CupertinoButton(
              child: Text(S.of(context).btn_import_contacts),
              onPressed: () {
                _tinyState.tinyEditCallback = () {
                  setState(() {
                    _tinyPeople = TinyPeople.fromMap( TinyPeople.toMap (_tinyState.curDBO ) );
                  });
                };
                Navigator.of(context).pushNamed(NavRoutes.PEOPLE_IMPORT);
              },
            )
          ],
        ),
      ),
    );
  }
}