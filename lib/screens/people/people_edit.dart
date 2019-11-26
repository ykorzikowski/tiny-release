
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paperflavor/data/repo/tiny_people_repo.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

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

  _PeopleTextControllerBundle _peopleTextControllerBundle;
  final Map _addressTextControllers = Map<TinyAddress, _AddressTextControllerBundle>();
  final Map _mailTextControllers = Map<TinyPeopleItem, _MailTextControllerBundle>();
  final Map _phoneTextControllers = Map<TinyPeopleItem, _PhoneTextControllerBundle>();

  _PeopleEditWidgetState(this._tinyState);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).title_add_people),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(13),
          child: Text(S.of(context).brn_save, key: Key('btn_navbar_save')),
          onPressed: validContact() ? _onPeopleSave : null,),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                imageAndNameSection(),
                Divider(),
                infoWidget(),
                Divider(),
                mailSection(),
                FlatButton.icon(
                    key: Key('btn_add_mail'),
                    icon: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen,),
                    label: Text(S.of(context).btn_add_mail),
                    onPressed: _onAddMailPressed
                ),
                Divider(),

                _buildPhoneSection(),
                FlatButton.icon(
                    key: Key('btn_add_phone'),
                    icon: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen,),
                    label: Text(S.of(context).btn_add_phone),
                    onPressed: _onAddPhonePressed
                ),
                Divider(),

                addressSection(),
                FlatButton.icon(
                    key: Key('btn_add_address'),
                    icon: Icon(CupertinoIcons.add_circled_solid, color: CupertinoColors.activeGreen,),
                    label: Text(S.of(context).btn_add_address),
                    onPressed: _onAddAddressPressed
                ),
                Divider(),
                CupertinoButton(
                  child: Text(S.of(context).btn_import_contacts),
                  onPressed: _onPeopleImportPressed,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _tinyPeople = TinyPeople.fromMap( TinyPeople.toMap (_tinyState.curDBO ) );
    if (_tinyPeople.postalAddresses.length < 1) _tinyPeople.postalAddresses.add(TinyAddress());

    _initControllers();
  }

  _initControllers() {
    _peopleTextControllerBundle = _PeopleTextControllerBundle(_tinyPeople);
    _tinyPeople.postalAddresses.forEach((addr) => _addressTextControllers.putIfAbsent(addr, () => _AddressTextControllerBundle(addr)));
    _tinyPeople.emails.forEach((mail) => _mailTextControllers.putIfAbsent(mail, () => _MailTextControllerBundle(mail)));
    _tinyPeople.phones.forEach((phone) => _phoneTextControllers.putIfAbsent(phone, () => _PhoneTextControllerBundle(phone)));
  }

  /// button onPressed

  _onPeopleImportPressed() {
    _tinyState.tinyEditCallback = () {
      setState(() {
        _tinyPeople = TinyPeople.fromMap( TinyPeople.toMap (_tinyState.curDBO ) );
        _initControllers();
      });
    };

    _requestContactPermission(
        authorized: () => Navigator.of(context).pushNamed(NavRoutes.PEOPLE_IMPORT),
        denied: () => showDialog(context: context, builder: (ctx) => _buildPermissionDeniedDialog()),
    );
  }

  Widget _buildPermissionDeniedDialog() => CupertinoAlertDialog(
    title: Text("Permission Denied"),
    content: Text("If you want to use this feature, you have to give TinyRelease access to your contacts. "),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(S.of(context).ok),
        onPressed: () => Navigator.of(context).pop(),
      )
    ],
  );

  _requestContactPermission( {authorized, denied} ) async {
    PermissionStatus canReadContacts = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);

    if( canReadContacts != PermissionStatus.granted ) {
      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      if ( permissions[PermissionGroup.contacts] != PermissionStatus.granted ) {
        return denied();
      }
    }
    return authorized();
  }

  _onPeopleSave() {
    new TinyPeopleRepo().save(_tinyPeople);
    _tinyState.curDBO = _tinyPeople;
    Navigator.of(context).pop();
  }

  _onAddMailPressed() {
    setState(() {
      var mail = TinyPeopleItem();
      _tinyPeople.emails.add(mail);
      _mailTextControllers.putIfAbsent(mail, () => _MailTextControllerBundle(mail));
    });
  }

  _onAddPhonePressed() {
    setState(() {
      var phone = TinyPeopleItem();
      _tinyPeople.phones.add(phone);
      _phoneTextControllers.putIfAbsent(phone, () => _PhoneTextControllerBundle(phone));
    });
  }

  _onAddAddressPressed() {
    setState(() {
      var address = TinyAddress();
      _tinyPeople.postalAddresses.add(address);
      _addressTextControllers.putIfAbsent(address, () => _AddressTextControllerBundle(address));
    });
  }

  _updateTextWidgetState(txt) {
    setState(() {
      _tinyPeople.givenName = _peopleTextControllerBundle.givenNameController.text;
      _tinyPeople.familyName = _peopleTextControllerBundle.familyNameController.text;
      _tinyPeople.company = _peopleTextControllerBundle.companyController.text;
      _tinyPeople.idType = _peopleTextControllerBundle.idTypeController.text;
      _tinyPeople.idNumber = _peopleTextControllerBundle.idNumberController.text;

      for ( var addr in _tinyPeople.postalAddresses) {
        _AddressTextControllerBundle addressTextController = _addressTextControllers[addr];

        addr.label = addressTextController.addressLabelController.text;
        addr.street = addressTextController.addressStreetController.text;
        addr.postcode = addressTextController.addressPostcodeController.text;
        addr.city = addressTextController.addressCityController.text;
        addr.region = addressTextController.addressRegionController.text;
        addr.country = addressTextController.addressCountryController.text;
      }

      for ( var phone in _tinyPeople.phones ) {
        _PhoneTextControllerBundle phoneTextController = _phoneTextControllers[phone];
        phone.label = phoneTextController.phoneLabelController.text;
        phone.value = phoneTextController.phoneController.text;
      }

      for( var mail in _tinyPeople.emails ) {
        _MailTextControllerBundle mailTextControllerBundle = _mailTextControllers[mail];
        mail.label = mailTextControllerBundle.mailLabelController.text;
        mail.value = mailTextControllerBundle.mailController.text;
      }
    });
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
      BaseUtil.storeFile("people_", 'png', croppedFile).then((file) => setState((){
        _tinyPeople.avatar = path.basename(file.path);
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
                    : new FileImage(BaseUtil.getFileSync(_tinyPeople.avatar)),
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
                    onChanged: _updateTextWidgetState,
                    controller: _peopleTextControllerBundle.givenNameController,
                    placeholder: S.of(context).hint_givenname,
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  CupertinoTextField(
                    key: Key('tf_familyName'),
                    onChanged: _updateTextWidgetState,
                    controller: _peopleTextControllerBundle.familyNameController,
                    placeholder: S.of(context).hint_familyname,
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  CupertinoTextField(
                    key: Key('tf_company'),
                    onChanged: _updateTextWidgetState,
                    controller: _peopleTextControllerBundle.companyController,
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
              onChanged: _updateTextWidgetState,
              controller: _peopleTextControllerBundle.idTypeController,
              placeholder:  S.of(context).hint_id_type,
            ),),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child:
            CupertinoTextField(
              key: Key('tf_idNumber'),
              onChanged: _updateTextWidgetState,
              controller: _peopleTextControllerBundle.idNumberController,
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
                                padding: EdgeInsets.all(13),
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
                                onDateTimeChanged: (t) {
                                  setState(() {
                                    _tinyPeople.birthday = t.toIso8601String();
                                  });
                                },
                              ),
                            )

                            ],)),
                ),
              )

        ],
      );

  /// get phone widgets
  List<Widget> _buildPhoneWidgets() {
    var list = List<Widget>();

    for (var i = 0; i < _tinyPeople.phones.length; i++) {
      var phone = _tinyPeople.phones[i];

      list.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Dismissible(
            key: Key('dismissible_phone_$i'),
            direction: DismissDirection.endToStart,
            background: BaseUtil.getDismissibleBackground(),
            onDismissed: (direction) =>
                setState(() {
                  _tinyPeople.phones.remove(phone);
                }),
            child: _buildPhoneWidget(phone, i)
        ),
      ),);
    }

    return list;
  }

  /// get single phone widget
  Widget _buildPhoneWidget(phone, i) {
    _PhoneTextControllerBundle bundle = _phoneTextControllers[phone];

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_phone_label_$i'),
            onChanged: _updateTextWidgetState,
            controller: bundle.phoneLabelController,
            placeholder: S
                .of(context)
                .hint_phone_label,
          ),),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_phone_number_$i'),
            onChanged: _updateTextWidgetState,
            controller: bundle.phoneController,
            keyboardType: TextInputType.phone,
            placeholder: S
                .of(context)
                .hint_phone,
          ),),
      ],
    );
  }
  /// phone section
  Widget _buildPhoneSection() =>
      Container(
        child: Column(
          children: _buildPhoneWidgets(),
        ),
      );

  /// get mail widgets
  List< Widget > _buildMailWidgets() {
    var list = List<Widget>();

    for( var i = 0; i < _tinyPeople.emails.length; i++ ) {
      var mail = _tinyPeople.emails[i];
      list.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Dismissible(
              key: Key('dismissible_mail_$i'),
              direction: DismissDirection.endToStart,
              background: BaseUtil.getDismissibleBackground(),
              onDismissed: (direction) =>
                  setState(() {
                    _tinyPeople.emails.remove(mail);
                  }),
              child: _buildMailWidget(mail, i)
          ),
        ),);
    }

    return list;
  }

  /// get single mail widget
  Widget _buildMailWidget(mail, i) {
    _MailTextControllerBundle bundle = _mailTextControllers[mail];

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_mail_label_$i'),
            onChanged: _updateTextWidgetState,
            controller: bundle.mailLabelController,
            placeholder: S.of(context).hint_mail_label,
          ),),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: CupertinoTextField(
            key: Key('tf_mail_address_$i'),
            onChanged: _updateTextWidgetState,
            controller: bundle.mailController,
            keyboardType: TextInputType.emailAddress,
            placeholder: S.of(context).hint_mail,
          ),),
      ],
    );
  }

  /// mail section
  Widget mailSection() =>
      Container(
        child: Column(
          children: _buildMailWidgets(),
        ),
      );

  /// get address widgets
  List<Widget> getAddressWidgets() {
    var list = List<Widget>();

    for ( int i = 0; i <  _tinyPeople.postalAddresses.length; i++ ) {
      var ta = _tinyPeople.postalAddresses[i];
      list.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: i == 0
                ? getAddressWidget(ta, i)
                : Dismissible(
                key: Key('dismissible_address_$i'),
                direction: DismissDirection.endToStart,
                background: BaseUtil.getDismissibleBackground(),
                onDismissed: (direction) => setState(() {_tinyPeople.postalAddresses.remove(ta); }),
                child: getAddressWidget(ta, i)
            ),
          ));
    }
    return list;
  }

  /// get single address widget
  Widget getAddressWidget(address, index) {
    _AddressTextControllerBundle bundle = _addressTextControllers[address];

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_label_$index'),
            onChanged: _updateTextWidgetState,
            controller: bundle.addressLabelController,
            placeholder: S
                .of(context)
                .hint_adresslabel,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_street_$index'),
            onChanged: _updateTextWidgetState,
            controller: bundle.addressStreetController,
            placeholder: S
                .of(context)
                .hint_street,
          ),),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          Row(
            children: <Widget>[
              Flexible(child: CupertinoTextField(
                key: Key('tf_postcode_$index'),
                onChanged: _updateTextWidgetState,
                controller: bundle.addressPostcodeController,
                keyboardType: TextInputType.number,
                placeholder: S
                    .of(context)
                    .hint_postcode,
              )),
              Flexible(child: CupertinoTextField(
                key: Key('tf_city_$index'),
                onChanged: _updateTextWidgetState,
                controller: bundle.addressCityController,
                placeholder: S
                    .of(context)
                    .hint_city,
              )),
            ],
          ),),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_region_$index'),
            onChanged: _updateTextWidgetState,
            controller: bundle.addressRegionController,
            placeholder: S
                .of(context)
                .hint_region,
          ),),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child:
          CupertinoTextField(
            key: Key('tf_country_$index'),
            onChanged: _updateTextWidgetState,
            controller: bundle.addressCountryController,
            placeholder: S
                .of(context)
                .hint_country,
          ),),
      ],
    );
  }

  /// address section
  Widget addressSection() =>
      Container(
        child: Column(
          children: getAddressWidgets(),
        ),
      );

  /// validation
  ///
  ///
  bool validContact() {
    return
      validAddresses() &&
          _tinyPeople.familyName != null && _tinyPeople.familyName.isNotEmpty &&
          _tinyPeople.givenName != null && _tinyPeople.givenName.isNotEmpty;
  }

  bool validAddresses() {
    for ( var adr in _tinyPeople.postalAddresses ) {
      if ( !validAddress(adr) ) {
        return false;
      }
    }
    return true;
  }

  bool validAddress(TinyAddress adr) {
    return adr.street != null && adr.street.isNotEmpty &&
        adr.city != null && adr.city.isNotEmpty &&
        adr.postcode != null && adr.postcode.isNotEmpty;
  }
}

class _PeopleTextControllerBundle {
  final TextEditingController givenNameController = TextEditingController();
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController idTypeController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();

  _PeopleTextControllerBundle(TinyPeople tinyPeople) {
    givenNameController.text = tinyPeople.givenName;
    familyNameController.text = tinyPeople.familyName;
    companyController.text = tinyPeople.company;
    idNumberController.text = tinyPeople.idNumber;
    idTypeController.text = tinyPeople.idType;
  }

}

class _AddressTextControllerBundle {
  final TextEditingController addressLabelController = TextEditingController();
  final TextEditingController addressStreetController = TextEditingController();
  final TextEditingController addressPostcodeController = TextEditingController();
  final TextEditingController addressCityController = TextEditingController();
  final TextEditingController addressRegionController = TextEditingController();
  final TextEditingController addressCountryController = TextEditingController();

  _AddressTextControllerBundle(TinyAddress addr) {
    addressLabelController.text = addr.label;
    addressStreetController.text = addr.street;
    addressPostcodeController.text = addr.postcode;
    addressCityController.text = addr.city;
    addressRegionController.text = addr.region;
    addressCountryController.text = addr.country;
  }
}

class _MailTextControllerBundle {
  final TextEditingController mailLabelController = TextEditingController();
  final TextEditingController mailController = TextEditingController();

  _MailTextControllerBundle(TinyPeopleItem mail) {
    mailLabelController.text = mail.label;
    mailController.text = mail.value;
  }
}

class _PhoneTextControllerBundle {
  final TextEditingController phoneLabelController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  _PhoneTextControllerBundle(TinyPeopleItem phone) {
    phoneLabelController.text = phone.label;
    phoneController.text = phone.value;
  }
}
