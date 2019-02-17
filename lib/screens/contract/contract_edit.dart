
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/repo/tiny_people_repo.dart';
import 'package:tiny_release/data/repo/tiny_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_people.dart';
import 'package:tiny_release/screens/control/control_helper.dart';
import 'package:tiny_release/screens/people/people_list.dart';
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'contract',
        transitionBetweenRoutes: false,
        middle: Text("Contract hinzufügen"),
        trailing: CupertinoButton(
          child: Text("Vorschau"),
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
                Text("Es wird ein Vertrag geschlossen zwischen", style: TextStyle(
                  fontSize: 24.0,
                ), textAlign: TextAlign.center),

                Divider(),

                _getPeopleView(
                    _tinyPhotographer, _tinyPeopleRepo, "Fotograf wählen", (people, item, context) {
                  setState(() {
                    _tinyPhotographer = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyPhotographer = null;});
                }),

                Divider(),

                Text("und", style: TextStyle(
                  fontSize: 24.0,
                ), textAlign: TextAlign.center,),

                Divider(),

                _getPeopleView(
                    _tinyModel, _tinyPeopleRepo, "Model wählen", (people, item, context) {
                  setState(() {
                    _tinyModel = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyModel = null;});
                }),

                Divider(),

                MergeSemantics(
                  child: ListTile(
                    title: Text('Vertreten durch'),
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
                    _tinyParent, _tinyPeopleRepo, "Gesetzl. Vertretung\n wählen", (people, item, context)
                {
                  setState(() {
                    _tinyParent = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyParent = null;});
                }) : Container(),

                Divider(),

                MergeSemantics(
                  child: ListTile(
                    title: Text('Bezeugt durch'),
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
                    _tinyWitness, _tinyPeopleRepo, "Zeuge wählen", (people, item, context) {
                  setState(() {
                    _tinyWitness = item;
                  });
                  Navigator.pop(context);
                }, () {
                  setState(() {_tinyWitness = null;});
                }) : Container(),

                Divider(),

                Text("in den Aufnahmebereichen", style: TextStyle(
                  fontSize: 24.0,
                ), textAlign: TextAlign.center,),

                Divider(),

                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    onChanged: (t) => _tinyContract.location = t,
                    controller: initialValue(_tinyContract.location),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Location',
                    ),),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child:
                  TextField(
                    onChanged: (t) => _tinyContract.displayName = t,
                    controller: initialValue(_tinyContract.displayName),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Betreff des Shootings',
                    ),),
                ),

                CupertinoButton(
                  child: Text("Wähle Aufnahmedatum"),
                  onPressed: () {
//                CupertinoDatePicker(
//                  initialDateTime: DateTime.now(),
//                  mode: CupertinoDatePickerMode.dateAndTime,
//                  onDateTimeChanged: (dateTime) {_tinyContract.date = dateTime.toIso8601String(); },
//                )
                  },
                ),

                CupertinoButton(
                  child: Text("Vertrag generieren"),
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