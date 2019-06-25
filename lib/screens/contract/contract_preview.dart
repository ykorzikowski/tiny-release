
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_people.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/screens/contract/contract_generator.dart';
import 'package:paperflavor/screens/contract/parser/parser.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ContractPreviewWidget extends StatefulWidget {

  final TinyState _controlState;

  ContractPreviewWidget(this._controlState);

  @override
  _ContractPreviewWidgetState createState() => _ContractPreviewWidgetState(_controlState);
}

class _ContractPreviewWidgetState extends State<ContractPreviewWidget> {
  final TinyState _tinyState;
  TinyContract _tinyContract;

  // todo get from database
  String photographerLabel, modelLabel, parentLabel, witnessLabel, shootingSubject;

  static const TextStyle _personSmallStyle = TextStyle( color: CupertinoColors.activeBlue, fontSize: 16 );
  static const TextStyle _personLargeStyle = TextStyle( fontSize: 18, fontWeight: FontWeight.bold );

  _ContractPreviewWidgetState(this._tinyState) {
    photographerLabel = "Fotograf";
    modelLabel = "Model";
    shootingSubject = "Betreff";
    parentLabel = "Erziehungsberechtigter";
    witnessLabel = "Zeuge";
    shootingSubject = "Betreff";
  }


  Widget _addressBuilder(context, index, persons, cb) => Column(
      children: <Widget>[
        ListTile(
          title: Column(children: <Widget>[
            Text(persons[index].street),
            Text(persons[index].postcode + " " + persons[index].city),
            persons[index].country != null ? Text(persons[index].country) : Container(),
          ],),
          onTap: () {
            Navigator.of(context).pop();
            cb(persons[index]);
            },
        ),
        Divider(),
      ]);

  _getAddressPicker(context, TinyPeople person, cb) =>
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            heroTag: 'control',
            transitionBetweenRoutes: false,
            leading: BaseUtil.isLargeScreen(context) ? Container() : null,
            middle: Text(S.of(context).select_address),),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: ListView.builder(
              itemCount: person.postalAddresses.length,
              padding: EdgeInsets.only(top: 10.0),
              itemBuilder: (BuildContext context, int index) => this._addressBuilder(context, index, person.postalAddresses, cb),
            ),
          ),),
      );

  _addressSelectionButton(context, person, cb, child) =>
      BaseUtil.isLargeScreen(context) ? CupertinoPopoverButton(
          child: child,
          popoverHeight: 500,
          popoverWidth: 400,
          popoverBuild: (context) => _getAddressPicker(context, person, cb)
      ) : CupertinoButton(
          child: child,
          onPressed: () =>
              showModalBottomSheet(context: context,
                builder: (context) => _getAddressPicker(context, person, cb),)
      );

  Widget _buildContractHeader(context) =>
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        _tinyContract.photographer != null ? Column(
          children: <Widget>[
            Text(photographerLabel, style: _personLargeStyle),
            _addressSelectionButton(context, _tinyContract.photographer, (sel) => setState(() => _tinyContract.selectedPhotographerAddress = sel), Column(children: <Widget>[
              Text(_tinyContract.photographer.displayName, style: _personSmallStyle),
              Text(_tinyContract.selectedPhotographerAddress.street, style: _personSmallStyle),
              Text(_tinyContract.selectedPhotographerAddress.postcode + " " +
                  _tinyContract.selectedPhotographerAddress.city, style: _personSmallStyle),
            ],), ),
          ],
        ) : Container(),


        _tinyContract.model != null ? Column(
          children: <Widget>[
            Text(modelLabel, style: _personLargeStyle),
            _addressSelectionButton(context, _tinyContract.model, (sel) => setState(() => _tinyContract.selectedModelAddress = sel), Column(children: <Widget>[
              Text(_tinyContract.model.displayName, style: _personSmallStyle),
              Text(_tinyContract.selectedModelAddress.street, style: _personSmallStyle),
              Text(_tinyContract.selectedModelAddress.postcode + " " +
                  _tinyContract.selectedModelAddress.city, style: _personSmallStyle),
            ]), )
          ],
        ) : Container(),


        _tinyContract.parent != null ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(parentLabel, style: _personLargeStyle),
          _addressSelectionButton(context, _tinyContract.parent, (sel) => setState(() => _tinyContract.selectedParentAddress = sel), Column(children: <Widget>[
            Text(_tinyContract.parent.displayName, style: _personSmallStyle),
            Text(_tinyContract.selectedParentAddress.street, style: _personSmallStyle),
            Text(_tinyContract.selectedParentAddress.postcode + " " +
                _tinyContract.selectedParentAddress.city, style: _personSmallStyle),
          ],), ), ]) : Container(),

        _tinyContract.witness != null ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(witnessLabel, style: _personLargeStyle),
          _addressSelectionButton(context, _tinyContract.witness, (sel) => setState(() => _tinyContract.selectedWitnessAddress = sel), Column(children: <Widget>[
            Text(_tinyContract.witness.displayName, style: _personSmallStyle),
            Text(_tinyContract.selectedWitnessAddress.street, style: _personSmallStyle),
            Text(_tinyContract.selectedWitnessAddress.postcode + " " +
                _tinyContract.selectedWitnessAddress.city, style: _personSmallStyle),
          ],), ), ]) : Container(),

      ],);

  @override
  Widget build(BuildContext context) {
    _tinyContract = TinyContract.fromMap(TinyContract.toMap(_tinyState.curDBO));
    _tinyContract.preset = Parser(_tinyContract, context).parsePreset();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'contract',
        transitionBetweenRoutes: false,
        border: null,
        middle: Text(S.of(context).tile_contact_preview),
        trailing: !BaseUtil.isLargeScreen(context) ? CupertinoButton(
          child: Text(S.of(context).btn_edit),
          padding: EdgeInsets.all(10),
          onPressed: () =>
              Navigator.of(context).pushNamed(NavRoutes.PRESET_EDIT),
        ) : null,),
      child:
      Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: SingleChildScrollView(
              child: _tinyContract.preset == null ? Text("No preset selected") :
                Column( children: <Widget>[
                  _buildContractHeader(context),

                  Divider(),

                  /// paragraphs
                  Column(children: ContractGenerator.buildParagraphs(context, _tinyContract),)

                ] ),
            ),
        ),
      ),
    );
  }

}
