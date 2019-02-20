
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/selectable_tags.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/data/tiny_preset.dart';
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
  final TinyState _controlState;
  final TinyPeopleRepo _tinyPeopleRepo = new TinyPeopleRepo();
  TinyContract _tinyContract;
  TinyPeople _tinyModel;
  TinyPeople _tinyPhotographer;
  TinyPreset _tinyPreset;
  Map<int, Tag> _receptionAreas = Map();
  List<Tag> _tags = List();

  bool _enabledWitness = false;
  TinyPeople _tinyWitness;

  bool _enabledParent = false;
  TinyPeople _tinyParent;

  _ContractEditWidgetState(this._controlState) {
    _tinyContract = TinyContract.fromMap( TinyContract.toMap (_controlState.curDBO ) );
  }

  bool validContract() {
    return _tinyContract.displayName != null && _tinyContract.displayName.isNotEmpty &&
        _tinyContract.photographerId != null &&
        _tinyContract.modelId != null;
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  Future<List<TinyPeople>>  _getPeopleFor( TinyRepo repo, int pageIndex ) async {
    return repo.getAll(
        pageIndex * PeopleListWidget.PAGE_SIZE,
        PeopleListWidget.PAGE_SIZE);
  }

  _getPeopleView(TinyPeople people, TinyRepo repo, String text, Function _onPeopleTap, Function _onPeopleTrash) =>
      CupertinoButton(
        child: Row(children: <Widget>[
          PeopleListWidget.getCircleAvatar( people, people == null ? "?" : PeopleListWidget.getCircleText(people) ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: people == null ? Text( text ) : Row(children: <Widget>[
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
                  _controlState,
                      (pageIndex) => _getPeopleFor(repo, pageIndex),
                      (item, context) => _onPeopleTap( people, item, context )
              );
            }
          ));
        },
      );

  _getPresetSelection() =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoButton(
            child:
            _tinyPreset == null ? Text(S.of(context).select_preset) : Text(_tinyPreset.title),
            onPressed: () =>
                Navigator.of(context).push(TinyPageWrapper(
                    transitionDuration: ControlHelper
                        .getScreenSizeBasedDuration(
                        context),
                    builder: (context) =>
                        PresetListWidget(_controlState, (item, context) {
                          _tinyPreset = item;
                          Navigator.of(context).pop();
                        },)
                ),
                ),),
          _tinyPreset != null ? CupertinoButton(
            child: Icon(CupertinoIcons.delete_solid),
            onPressed: () {
              setState(() {
                _tinyPreset = null;
              });
            },
          ) : Container()
        ],);

  _getReceptionSelection() =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoButton(
            child: Icon(CupertinoIcons.add_circled_solid,
              color: CupertinoColors.activeGreen,),
            onPressed: () =>
                Navigator.of(context).push(TinyPageWrapper(
                    transitionDuration: ControlHelper
                        .getScreenSizeBasedDuration(context),
                    builder: (context) =>
                        ReceptionListWidget(_controlState, (context, item) {
                          setState(() {
                            // todo check if already in list
                            var tag = new Tag(
                                id: item.id,
                                title: item.displayName
                            );
                            _receptionAreas.putIfAbsent(item.id, () => tag);
                            _tags.clear();
                            _tags.addAll( _receptionAreas.values.toList());
                          });
                          Navigator.of(context).pop();
                        }))),
          )
        ],);

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
            _controlState.curDBO = _tinyContract;
            Navigator.of(context).popUntil((route) => !Navigator.of(context).canPop());
            Navigator.of(context).pushNamed(NavRoutes.CONTRACT_PREVIEW);
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
                    _tinyPhotographer, _tinyPeopleRepo, S.of(context).choose_photographer, (people, item, context) {
                  setState(() {
                    _tinyPhotographer = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyPhotographer = null;});
                }),

                Divider(),

                Text(S.of(context).and, style: TextStyle(
                  fontSize: 24.0,
                ), textAlign: TextAlign.center,),

                Divider(),

                /// Model section
                _getPeopleView(
                    _tinyModel, _tinyPeopleRepo, S.of(context).choose_model, (people, item, context) {
                  setState(() {
                    _tinyModel = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyModel = null;});
                }),

                Divider(),

                /// Represented by section
                MergeSemantics(
                  child: ListTile(
                    title: Text(S.of(context).represented_by),
                    trailing: CupertinoSwitch(
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
                    _tinyParent, _tinyPeopleRepo, S.of(context).choose_parent, (people, item, context)
                {
                  setState(() {
                    _tinyParent = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyParent = null;});
                }) : Container(),

                Divider(),

                /// Witnessed by section
                MergeSemantics(
                  child: ListTile(
                    title: Text(S.of(context).witnessed_by),
                    trailing: CupertinoSwitch(
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
                    _tinyWitness, _tinyPeopleRepo, S.of(context).choose_witness, (people, item, context) {
                  setState(() {
                    _tinyWitness = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyWitness = null;});
                }) : Container(),

                Divider(),

                /// preset selection
                ListTile(
                  title: Text(S.of(context).selected_preset),
                  trailing: _getPresetSelection(),
                ),

                Divider(),

                /// Reception areas
                ListTile(
                  title: Text(S.of(context).title_reception),
                  trailing: _getReceptionSelection(),
                ),
                SelectableTags(
                  // todo check on removal possible
                  tags: _tags,
                  backgroundContainer: Colors.transparent,
                  onPressed: (tag) {
                    setState(() {
                      _receptionAreas.removeWhere((k, v) => v.title == tag.title);
                      _tags.remove(tag);
                    });
                  },
                ),
                Divider(),

                /// Location
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    onChanged: (t) => _tinyContract.location = t,
                    controller: initialValue(_tinyContract.location),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: S.of(context).hint_location,
                    ),),
                ),

                /// subject
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    onChanged: (t) => _tinyContract.displayName = t,
                    controller: initialValue(_tinyContract.displayName),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: S.of(context).shooting_subject,
                    ),),
                ),

                /// shooting date
                CupertinoButton(
                  child: TextField(
                    key: Key('tf_shooting_date'),
                    enabled: false,
                    controller: _tinyContract.date == null ? initialValue("") : initialValue(BaseUtil.getLocalFormattedDateTime(context, _tinyContract.date)),
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: S.of(context).shooting_date,
                    ),
                  ),
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
                              middle: Text(S.of(context).choose_date),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.dateAndTime,
                                minimumYear: 1900,
                                initialDateTime: _tinyContract.date != null ? DateTime.parse(_tinyContract.date) : DateTime.now(),
                                onDateTimeChanged: (t) => _tinyContract.date = t.toIso8601String(),
                              ),
                            )

                          ],)),
                ),

                /// button generate contract
                CupertinoButton(
                  child: Text(S.of(context).add_contract),
                  onPressed: validContract() ? () {
                    // todo generate contract
                  } : null,
                ),
              ],),
            ),],
          ),
        )
    );
  }

}