import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';

class ContractGenerator {
  final TinyContract _tinyContract;

  static const doppelPinkt = ": ";

  static const TextStyle _personSmallStyle = TextStyle( fontSize: 16 );
  static const TextStyle _personLargeStyle = TextStyle( fontSize: 18, fontWeight: FontWeight.bold );

  ContractGenerator(this._tinyContract);

  /// flutter section
  Widget buildSignatures(context) =>
      Container(
        child: Column(children: <Widget>[
          _tinyContract.photographer != null ? _wrapSignature(context, _tinyContract.photographerSignature, _tinyContract.photographer.displayName) : Container(),
          _tinyContract.model != null ? _wrapSignature(context, _tinyContract.modelSignature, _tinyContract.model.displayName) : Container(),
          _tinyContract.parent != null ? _wrapSignature(context, _tinyContract.parentSignature, _tinyContract.parent.displayName) : Container(),
          _tinyContract.witness != null ? _wrapSignature(context, _tinyContract.witnessSignature, _tinyContract.witness.displayName) : Container(),
        ],),
      );

  Widget _wrapSignature(context, sig, name) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0),
            child: SizedBox(height: 150, child: sig != null ? sig : Container(decoration: BoxDecoration( border: Border.all(width: 2.0, color: CupertinoColors.black, ), ), ), ), ),
          ListTile(
            leading:  Text(name),
            trailing: Text(_tinyContract.location + S.of(context).location_date_seperator +
                BaseUtil.getLocalFormattedDate(
                    context, DateTime.now().toIso8601String())),
          ),
        ],
      );

  static buildParagraphs(context, tinyContract) {
    var widgetList = List<Widget>();
    for (int i = 0; i < tinyContract.preset.paragraphs.length; i++) {
      var paragraph = tinyContract.preset.paragraphs[i];
      widgetList.add(Text(BaseUtil.getParagraphTitle(context, paragraph, (i+1)), style: TextStyle( fontSize: 24 ),));
      widgetList.add(Text(paragraph.content));
    }
    tinyContract.preset.paragraphs.forEach((paragraph) {
    });

    return widgetList;
  }

  String _getReceptionString() {
    String rec = "";

    var iterator = _tinyContract.receptions.iterator;
    bool hasNext = iterator.moveNext();
    while ( hasNext ) {
      rec += iterator.current.displayName;
      hasNext = iterator.moveNext();
      if ( hasNext ) {
        rec += ", ";
      }

    }

    return rec;
  }

  Widget buildShootingInformationSection(context) => Column(children: <Widget>[
    Text(S.of(context).shooting_subject + doppelPinkt + _tinyContract.displayName),
    Text(S.of(context).shooting_date + doppelPinkt + BaseUtil.getLocalFormattedDate(context, _tinyContract.date)),
    _tinyContract.receptions != null ? Text(S.of(context).reception_area + doppelPinkt + _getReceptionString()) : Container(),
  ],);

  Widget buildContractHeader(context) =>
  Padding(
    padding: EdgeInsets.all(8.0),
    child:
      Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Expanded(
          flex: 3,
          child: Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Text(S.of(context).photographer, style: _personLargeStyle),
            Text(_tinyContract.photographer.displayName, style: _personSmallStyle),
            Text(_tinyContract.selectedPhotographerAddress.street, style: _personSmallStyle),
            Text(_tinyContract.selectedPhotographerAddress.postcode + " " +
                _tinyContract.selectedPhotographerAddress.city, style: _personSmallStyle),
          ],),
        ),
        Expanded(
          flex: 3,
          child: _tinyContract.model.avatar != null ? Image.file(
            BaseUtil.getFileSync(_tinyContract.model.avatar), fit: BoxFit.scaleDown, height: 150,) : Container(),
        ),
        Expanded(
          flex: 3,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(S.of(context).model, style: _personLargeStyle),
            Text(_tinyContract.model.displayName, style: _personSmallStyle),
            Text(_tinyContract.selectedModelAddress.street, style: _personSmallStyle),
            Text(_tinyContract.selectedModelAddress.postcode + " " +
                _tinyContract.selectedModelAddress.city, style: _personSmallStyle),
            _tinyContract.parent != null ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Divider(),
              Text(S.of(context).parent, style: _personLargeStyle),
              Text(_tinyContract.parent.displayName, style: _personSmallStyle),
              Text(_tinyContract.selectedParentAddress.street, style: _personSmallStyle),
              Text(_tinyContract.selectedParentAddress.postcode + " " +
                  _tinyContract.selectedParentAddress.city, style: _personSmallStyle),
            ],) : Container(),
            _tinyContract.witness != null ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Divider(),
              Text(S.of(context).witness, style: _personLargeStyle),
              Text(_tinyContract.witness.displayName, style: _personSmallStyle),
              Text(_tinyContract.selectedWitnessAddress.street, style: _personSmallStyle),
              Text(_tinyContract.selectedWitnessAddress.postcode + " " +
                  _tinyContract.selectedWitnessAddress.city, style: _personSmallStyle),
            ],) : Container(),
          ],),
        )
      ],),);
}
