
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/selectable_tags.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_reception_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_reception.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/people/people_list.dart';
import 'package:tiny_release/screens/preset/preset_list.dart';
import 'package:tiny_release/screens/reception_area/reception_list.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_page_wrapper.dart';
import 'package:tiny_release/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ContractEditWidget extends StatefulWidget {

  final TinyState _controlState;

  ContractEditWidget( this._controlState );

  @override
  _ContractEditWidgetState createState() => _ContractEditWidgetState(_controlState);
}

class _ContractEditWidgetState extends State<ContractEditWidget> {
  final TinyState _tinyState;
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();
  final TinyContractRepo _tinyContractRepo = new TinyContractRepo();
  TinyContract _tinyContract;
  Map<int, Tag> _receptionAreas = Map();
  List<Tag> _tags = List();

  static const TextStyle btnStyle = TextStyle(color: CupertinoColors.activeBlue, fontSize: 16);

  bool _enabledWitness = false;

  bool _enabledParent = false;

  _ContractEditWidgetState(this._tinyState) {
//    _tinyContract = TinyContract.fromMap( TinyContract.toMap (_controlState.curDBO ) );
    _tinyContract = _tinyState.curDBO;
    if (_tinyContract.receptions != null) {
      _tinyContract.receptions.forEach((rec) => _tags.add(Tag(id: rec.id, title: rec.displayName)));
      _tinyContract.receptions.forEach((rec) => _receptionAreas.putIfAbsent(rec.id, () => Tag(id: rec.id, title: rec.displayName)));
    }
  }

  bool validContract() {
    return _tinyContract.displayName != null && _tinyContract.displayName.isNotEmpty &&
        _tinyContract.preset != null &&
        _tinyContract.photographer != null &&
        _tinyContract.model != null &&
        _tinyContract.date != null &&
        _tinyContract.location != null;
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  Future<List<TinyPeople>>  _getPeopleFor( TinyRepo repo, int pageIndex ) async {
    return repo.getAll(
        pageIndex * PeopleListWidget.PAGE_SIZE,
        PeopleListWidget.PAGE_SIZE);
  }

  /// opens people selection widget
  _getPeopleView(String person, TinyPeople people, TinyRepo repo, String text,
      Function _onPeopleTap, Function _onPeopleTrash) =>
      BaseUtil.isLargeScreen(context) ? CupertinoPopoverButton(
          child: ListTile(
            key: Key('select_$person'),
            title: Row(children: <Widget>[
              PeopleListWidget.getCircleAvatar(people,
                  people == null ? "?" : PeopleListWidget.getCircleText(people)),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: people == null ? Text(text, style: btnStyle,) : Row(children: <Widget>[
                    Text(people.givenName + " " + people.familyName, style: btnStyle,),
                    CupertinoButton(
                      child: Icon(CupertinoIcons.delete_solid),
                      onPressed: _onPeopleTrash,
                    )
                  ],)
              )
            ],),
          ),
          popoverHeight: 500,
          popoverWidth: 400,
          popoverBuild: (context) =>
              PeopleListWidget(
                  _tinyState,
                      (pageIndex) => _getPeopleFor(repo, pageIndex),
                      (item, context) => _onPeopleTap(people, item, context)
              )
      ) : CupertinoButton(
        child: Row(
          key: Key('select_$person'),
          children: <Widget>[
          PeopleListWidget.getCircleAvatar(people,
              people == null ? "?" : PeopleListWidget.getCircleText(people)),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: people == null ? Text(text) : Row(children: <Widget>[
                Text(people.givenName + " " + people.familyName),
                CupertinoButton(
                  child: Icon(CupertinoIcons.delete_solid),
                  onPressed: _onPeopleTrash,
                )
              ],)
          )
        ],),
        onPressed: () {
          Navigator.of(context).push(TinyPageWrapper(
              transitionDuration: ControlHelper.getScreenSizeBasedDuration(context),
              builder: (context) {
              return PeopleListWidget(
                  _tinyState,
                      (pageIndex) => _getPeopleFor(repo, pageIndex),
                      (item, context) => _onPeopleTap( people, item, context )
              );
            }
          ));
        },
      );

  _getPresetWidget(context) =>
      PresetListWidget(_tinyState, (item, context) {
        setState(() {
          _tinyContract.preset = item;
        });
        Navigator.of(context).pop();
      },);

  _getPresetSelection() =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BaseUtil.isLargeScreen(context) ? CupertinoPopoverButton(
              child: _tinyContract.preset == null ? Text(S.of(context).choose, style: btnStyle, key: Key("btn_add_preset"),) : Text(
                _tinyContract.preset.title, style: btnStyle, key: Key("btn_add_preset")),
              popoverHeight: 500,
              popoverWidth: 400,
              popoverBuild: (context) => _getPresetWidget(context)) :
          CupertinoButton(
            child: _tinyContract.preset == null ? Text(S.of(context).choose, key: Key("btn_add_preset")) : Text(_tinyContract.preset.title, key: Key("btn_add_preset")),
            onPressed: () =>
                Navigator.of(context).push(TinyPageWrapper(
                    transitionDuration: ControlHelper
                        .getScreenSizeBasedDuration(
                        context),
                    builder: (context) => _getPresetWidget(context)),
                ),),

          _tinyContract.preset != null ? CupertinoButton(
            child: Icon(CupertinoIcons.delete_solid),
            onPressed: () {
              setState(() {
                _tinyContract.preset = null;
              });
            },
          ) : Container()
        ],);

  _getReceptionWidget(context) => ReceptionListWidget(_tinyState, (context, item) {
    setState(() {
      var tag = new Tag(
          id: item.id,
          title: item.displayName
      );
      _receptionAreas.putIfAbsent(item.id, () => tag);
      _tags.clear();
      _tags.addAll( _receptionAreas.values.toList());
    });
    Navigator.of(context).pop();
  },);

  _getReceptionSelection() =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BaseUtil.isLargeScreen(context) ? CupertinoPopoverButton(
              child:Icon(CupertinoIcons.add_circled_solid,
                color: CupertinoColors.activeGreen, key: Key('btn_set_reception'),),
              popoverHeight: 500,
              popoverWidth: 400,
              popoverBuild: (context) => _getReceptionWidget(context)
          ) : CupertinoButton(
            child:
            _tinyContract.preset == null ? Text(S.of(context).choose, key: Key('btn_set_reception')) : Text(_tinyContract.preset.title, key: Key('btn_set_reception')),
            onPressed: () =>
                Navigator.of(context).push(TinyPageWrapper(
                    transitionDuration: ControlHelper
                        .getScreenSizeBasedDuration(
                        context),
                    builder: (context) => _getReceptionWidget(context)
                ),
                ),),
        ],);

  _getCaptureDatePicker(context) => Column(children: <Widget>[
    CupertinoNavigationBar(
      trailing: CupertinoButton(
        child: Text(S.of(context).select_date_ok, key: Key('btn_ok'),),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      middle: Text(S.of(context).choose_date),
    ),
    Flexible(
      key: Key('datepicker'),
      fit: FlexFit.loose,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        minimumYear: 1900,
        initialDateTime: _tinyContract.date != null ? DateTime.parse(_tinyContract.date) : DateTime.now(),
        onDateTimeChanged: (t) => setState( () => _tinyContract.date = t.toIso8601String() ),
      ),
    )
  ],);

  _getCaptureDateSelection() =>
      BaseUtil.isLargeScreen(context) ?  CupertinoPopoverButton(
          child: _tinyContract.date != null ? Text(BaseUtil.getLocalFormattedDateTime(context, _tinyContract.date), style: btnStyle, key: Key('btn_select_date'),) : Text(S.of(context).choose, style: btnStyle, key: Key('btn_select_date')),
          popoverHeight: 500,
          popoverWidth: 400,
          popoverBuild: (context) => _getCaptureDatePicker(context)
      ) : CupertinoButton(
          child: _tinyContract.date != null ? Text(BaseUtil.getLocalFormattedDateTime(context, _tinyContract.date), key: Key('btn_select_date')) : Text(S.of(context).choose, key: Key('btn_select_date')),
          onPressed: () => showModalBottomSheet( context: context, builder: (context) => _getCaptureDatePicker(context),)
      );

  _getCountTexts() {
    int i = 0;

    var widgets = <Widget>[];
    while (i <= 100 ) {
      widgets.add(Text(i.toString()));
      i++;
    }

    return widgets;
  }

  _getImageCounterPicker(context) =>
      Column(children: <Widget>[
        CupertinoNavigationBar(
          trailing: CupertinoButton(
            child: Text(S.of(context).select_date_ok, key: Key('btn_ok'),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          middle: Text(S.of(context).choose),
        ),
        Flexible(
          key: Key('image_count_picker'),
          fit: FlexFit.loose,
          child: CupertinoPicker(
            itemExtent: 30,
            onSelectedItemChanged: (selected) => setState(() =>_tinyContract.imagesCount = selected ),
            children: _getCountTexts(),
          ),
        )

      ],);

  _getImagesCountSelection() =>
      BaseUtil.isLargeScreen(context) ?  CupertinoPopoverButton(
          child: _tinyContract.imagesCount != null ? Text(_tinyContract.imagesCount.toString(), style: btnStyle, key: Key('btn_set_images_count'),) : Text(S.of(context).choose, style: btnStyle, key: Key('btn_set_images_count')),
          popoverHeight: 200,
          popoverWidth: 300,
          popoverBuild: (context) => _getImageCounterPicker(context)
      ) : CupertinoButton(
        child: _tinyContract.imagesCount != null ? Text(_tinyContract.imagesCount.toString(), key: Key('btn_set_images_count')) : Text(S.of(context).choose, key: Key('btn_set_images_count')),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _getImageCounterPicker(context),);
        },
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'contract',
        transitionBetweenRoutes: false,
        middle: Text(S.of(context).add_contract),
        trailing: CupertinoButton(
          child: Text(S.of(context).preset),
          onPressed: validContract() ? () {
            if (!validContract()) {
              return;
            }
            new TinyContractRepo().save(_tinyContract);
            _tinyState.curDBO = _tinyContract;
            Navigator.of(context).popUntil((route) => !Navigator.of(context).canPop());
            Navigator.of(context, rootNavigator: true).pushNamed(NavRoutes.CONTRACT_PREVIEW);
          } : null,),),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: ListView(
            children: <Widget>[
              SafeArea(
              child:
              Column(children: <Widget>[
                /// text
                Text(S.of(context).contract_will_made_between, style: TextStyle(
                  fontSize: 24.0,
                ), textAlign: TextAlign.center),

                Divider(),

                /// Photographer section
                _getPeopleView(
                    'photographer',
                    _tinyContract.photographer, _tinyPeopleRepo, S.of(context).choose_photographer, (people, item, context) {
                  setState(() {
                    _tinyContract.photographer = item;
                    _tinyContract.selectedPhotographerAddress = item.postalAddresses[0];
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() { _tinyContract.photographer = null;});
                }),

                Divider(),

                /// Model section
                _getPeopleView(
                    'model',
                    _tinyContract.model, _tinyPeopleRepo, S.of(context).choose_model, (people, item, context) {
                  setState(() {
                    _tinyContract.model = item;
                    _tinyContract.selectedModelAddress = item.postalAddresses[0];
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() { _tinyContract.model = null;});
                }),

                Divider(),

                /// Represented by section
                MergeSemantics(
                  child: ListTile(
                    title: Text(S.of(context).represented_by),
                    trailing: CupertinoSwitch(
                      key: Key('switch_parent'),
                      value: _enabledParent,
                      onChanged: (bool value) {
                        setState(() {
                          _enabledParent = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _enabledParent = !_enabledParent;
                      });
                    },
                  ),
                ),
                _enabledParent ? _getPeopleView(
                    'parent',
                    _tinyContract.parent, _tinyPeopleRepo, S.of(context).choose_parent, (people, item, context)
                {
                  setState(() {
                    _tinyContract.parent = item;
                    _tinyContract.selectedParentAddress = item.postalAddresses[0];
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyContract.parent = null;});
                }) : Container(),

                Divider(),

                /// Witnessed by section
                MergeSemantics(
                  child: ListTile(
                    title: Text(S.of(context).witnessed_by),
                    trailing: CupertinoSwitch(
                      key: Key('switch_witness'),
                      value: _enabledWitness,
                      onChanged: (bool value) {
                        setState(() {
                          _enabledWitness = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _enabledWitness = !_enabledWitness;
                      });
                    },
                  ),
                ),
                _enabledWitness ? _getPeopleView(
                    'witness',
                    _tinyContract.witness, _tinyPeopleRepo, S.of(context).choose_witness, (people, item, context) {
                  setState(() {
                    _tinyContract.witness = item;
                    _tinyContract.selectedWitnessAddress = item.postalAddresses[0];
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyContract.witness = null;});
                }) : Container(),

                Divider(),

                /// preset selection
                ListTile(
                  title: Text(S.of(context).selected_preset),
                  trailing: _getPresetSelection(),
                ),

                Divider(),

                /// capture date selection
                ListTile(
                  title: Text(S.of(context).shooting_date),
                  trailing: _getCaptureDateSelection(),
                ),

                Divider(),

                /// number of images
                ListTile(
                  title: Text(S.of(context).contract_images),
                  trailing: _getImagesCountSelection(),
                ),

                Divider(),


                /// location
                ListTile(
                  title: Text(S.of(context).hint_location),
                  trailing: Container(
                    width: 250,
                    child: CupertinoTextField(
                        key: Key('tf_location'),
                        keyboardType: TextInputType.text,
                        maxLength: 50,
                        onChanged: (t) => setState(() =>_tinyContract.location = t ),
                        controller: initialValue(_tinyContract.location),
                        ),
                  ),
                ),

                Divider(),

                /// subject
                ListTile(
                  title: Text(S.of(context).shooting_subject),
                  trailing: Container(
                    width: 250,
                    child: CupertinoTextField(
                      key: Key('tf_subject'),
                      maxLength: 50,
                      onChanged: (t) => setState(() => _tinyContract.displayName = t),
                      controller: initialValue(_tinyContract.displayName),
                    ),
                  ),
                ),

                Divider(),

                /// Reception areas
                ListTile(
                  title: Text(S.of(context).title_reception),
                  trailing: _getReceptionSelection(),
                ),
                SelectableTags(
                  tags: _tags,
                  backgroundContainer: Colors.transparent,
                  onPressed: (tag) {
                    setState(() {
                      _receptionAreas.removeWhere((k, v) => v.title == tag.title);
                      _tags.remove(tag);
                    });
                  },
                ),

                /// button generate contract
                CupertinoButton(
                  child: Text(S.of(context).btn_sign_contract, key: Key('btn_sign_contract'),),
                  onPressed: validContract() ? () {
                    List<TinyReception> recs = List();
                    _tags.forEach((tag) => recs.add(TinyReception(id: tag.id, displayName: tag.title)));
                    _tinyContract.receptions = recs;
                    _tinyContractRepo.save(_tinyContract);
                    _tinyState.curDBO = _tinyContract;
                    //Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pushNamed(NavRoutes.CONTRACT_GENERATED);
                  } : null,
                ),

                /// button save contract
                CupertinoButton(
                  child: Text(S.of(context).btn_save),
                  onPressed: validContract() ? () {
                    List<TinyReception> recs = List();
                    _tags.forEach((tag) => recs.add(TinyReception(id: tag.id, displayName: tag.title)));
                    _tinyContract.receptions = recs;
                    _tinyContractRepo.save(_tinyContract);
                    Navigator.of(context, rootNavigator: true).pop();
                  } : null,
                ),
              ],),
            ),],
          ),
        )
    );
  }

}