import 'dart:io' as Io;
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:image/image.dart' as img;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_address_repo.dart';
import 'package:tiny_release/data/repo/tiny_settings_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_signature.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/BaseUtil.dart';

class ContractPdfGenerator {
  final TinySettingRepo _tinySettingRepo = TinySettingRepo();
  final TinyAddressRepo _tinyAddressRepo = TinyAddressRepo();
  final TinyContract _tinyContract;

  static const doppelPinkt = ": ";

  static const TextStyle _personSmallStyle = TextStyle( fontSize: 16 );
  static const TextStyle _personLargeStyle = TextStyle( fontSize: 18, fontWeight: FontWeight.bold );

  static pdf.TextStyle _personPdfSmallStyle = pdf.TextStyle( fontSize: 16, font: pdf.Font.times() );
  static pdf.TextStyle _personPdfLargeStyle = pdf.TextStyle( fontSize: 18, font: pdf.Font.timesBold() );
  
  String photographerLabel, modelLabel, parentLabel, witnessLabel, shootingSubject;

  ContractPdfGenerator(this._tinyContract) {
    photographerLabel = "Fotograf";
    modelLabel = "Model";
    shootingSubject = "Betreff";
    parentLabel = "Erziehungsberechtigter";
    witnessLabel = "Zeuge";
    shootingSubject = "Betreff";

//    _tinySettingRepo.getForKey(TinySettingKey.PHOTOGRAPHER_LABEL).then((ts) => this.photographerLabel = ts.value);
//    _tinySettingRepo.getForKey(TinySettingKey.MODEL_LABEL).then((ts) => this.modelLabel = ts.value);
  }

  pdf.Document generatePdf(buildContext) {
    var doc = pdf.Document(deflate: zlib.encode);

    doc.addPage(pdf.MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: pdf.CrossAxisAlignment.start,
      build: (context) => <pdf.Widget> [
        buildPdfContractHeader(buildContext, doc.document),
        buildPdfShootingInformationSection(buildContext),
        //pdf.Column(children: buildPdfParagraphs(buildContext)),
        //buildPdfSignatures(buildContext, doc.document),
      ],
    ));

    return doc;
  }

  /// pdf section
  pdf.Widget buildPdfContractHeader(context, pdfDoc) =>
      pdf.Row(mainAxisSize: pdf.MainAxisSize.max,
        crossAxisAlignment: pdf.CrossAxisAlignment.center,
        children: <pdf.Widget>[
          pdf.Expanded(
            flex: 3,
            child: pdf.Column(mainAxisAlignment: pdf.MainAxisAlignment.center,
              crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
              children: <pdf.Widget>[
                pdf.Text(photographerLabel, style: _personPdfLargeStyle),
                pdf.Text(_tinyContract.photographer.displayName,
                    style: _personPdfSmallStyle),
                pdf.Text(_tinyContract.selectedPhotographerAddress.street,
                    style: _personPdfSmallStyle),
                pdf.Text(
                    _tinyContract.selectedPhotographerAddress.postcode + " " +
                        _tinyContract.selectedPhotographerAddress.city,
                    style: _personPdfSmallStyle),
              ],),
          ),
          pdf.Expanded(
            flex: 3,
            child: _tinyContract.model.avatar != null ? _getPdfImage(pdfDoc, _tinyContract.model.avatar, width: 150, height: 150) : pdf.Container(),
          ),
          pdf.Expanded(
            flex: 4,
            child: pdf.Column(mainAxisSize: pdf.MainAxisSize.max, children: <pdf.Widget>[
              pdf.Text(modelLabel, style: _personPdfLargeStyle),
              pdf.Text(
                  _tinyContract.model.displayName, style: _personPdfSmallStyle),
              pdf.Text(_tinyContract.selectedModelAddress.street,
                  style: _personPdfSmallStyle),
              pdf.Text(_tinyContract.selectedModelAddress.postcode + " " +
                  _tinyContract.selectedModelAddress.city,
                  style: _personPdfSmallStyle),
              _tinyContract.parent != null ? pdf.Column(
                mainAxisSize: pdf.MainAxisSize.max, children: <pdf.Widget>[
                pdf.Text(parentLabel, style: _personPdfLargeStyle),
                pdf.Text(_tinyContract.parent.displayName,
                    style: _personPdfSmallStyle),
                pdf.Text(_tinyContract.selectedParentAddress.street,
                    style: _personPdfSmallStyle),
                pdf.Text(_tinyContract.selectedParentAddress.postcode + " " +
                    _tinyContract.selectedParentAddress.city,
                    style: _personPdfSmallStyle),
              ],) : pdf.Container(),
              _tinyContract.witness != null ? pdf.Column(
                mainAxisSize: pdf.MainAxisSize.max, children: <pdf.Widget>[
                pdf.Text(witnessLabel, style: _personPdfLargeStyle),
                pdf.Text(_tinyContract.witness.displayName,
                    style: _personPdfSmallStyle),
                pdf.Text(_tinyContract.selectedWitnessAddress.street,
                    style: _personPdfSmallStyle),
                pdf.Text(_tinyContract.selectedWitnessAddress.postcode + " " +
                    _tinyContract.selectedWitnessAddress.city,
                    style: _personPdfSmallStyle),
              ],) : pdf.Container(),
            ],),
          )
        ],);

  pdf.Widget buildPdfShootingInformationSection(context) => pdf.Column(children: <pdf.Widget>[
    pdf.Text(S.of(context).shooting_subject + doppelPinkt + _tinyContract.displayName),
    pdf.Text(S.of(context).shooting_date + doppelPinkt + BaseUtil.getLocalFormattedDate(context, _tinyContract.date)),
    _tinyContract.receptions != null ? pdf.Text(S.of(context).reception_area + doppelPinkt + _getReceptionString()) : Container(),
  ],);


  List<pdf.Widget> buildPdfParagraphs(context) {
    var widgetList = List<pdf.Widget>();
    for (int i = 0; i < _tinyContract.preset.paragraphs.length; i++) {
      var paragraph  = _tinyContract.preset.paragraphs[i];
      widgetList.add(pdf.Header(level: 2, text: BaseUtil.getParagraphTitle(context, paragraph, (i+1)),));
      widgetList.add(pdf.Paragraph(text: paragraph.content));
    }
    _tinyContract.preset.paragraphs.forEach((paragraph) {
    });

    return widgetList;
  }

  pdf.Widget buildPdfSignatures(context, pdfDoc) =>
      pdf.Container(
        child: pdf.Column(children: <pdf.Widget>[
          pdf.Row(children: <pdf.Widget>[
            _tinyContract.photographer != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.photographerSignature, _tinyContract.photographer.displayName) : pdf.Container(),
            _tinyContract.model != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.modelSignature, _tinyContract.model.displayName) : pdf.Container(),
          ]),
          pdf.Row(children: <pdf.Widget>[
            _tinyContract.parent != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.parentSignature, _tinyContract.parent.displayName) : pdf.Container(),
            _tinyContract.witness != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.witnessSignature, _tinyContract.witness.displayName) : pdf.Container(),
          ]),
        ],),
      );

  pdf.Widget _wrapPdfSignature(context, pdfDoc, TinySignature sig, name) =>
      pdf.Column(
        mainAxisSize: pdf.MainAxisSize.min,
        children: <pdf.Widget>[
          pdf.Padding(padding: pdf.EdgeInsets.all(8.0),
            child: pdf.Container(height: 150, child: sig != null ? _getPdfImage(pdfDoc, sig.path, scale: 3) : pdf.Container(decoration: pdf.BoxDecoration( border: pdf.BoxBorder(width: 2.0, color: PdfColor.black, ), ), ), ), ),
          pdf.Row(children: <pdf.Widget>[
            pdf.Padding(padding: pdf.EdgeInsets.all(8.0), child: pdf.Text(name),),
            pdf.Padding(padding: pdf.EdgeInsets.all(8.0), child: pdf.Text(_tinyContract.location + ", den " + BaseUtil.getLocalFormattedDate(context, DateTime.now().toIso8601String())),),
          ]),
        ],
      );

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
              trailing: Text(_tinyContract.location + ", den " +
                  BaseUtil.getLocalFormattedDate(
                      context, DateTime.now().toIso8601String())),
          ),
        ],
      );

  static buildParagraphs(context, tinyContract) {
    var widgetList = List<Widget>();
    for (int i = 0; i < tinyContract.preset.paragraphs.length; i++) {
      var paragraph  =tinyContract.preset.paragraphs[i];
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

  pdf.Widget _getPdfImage(pdfDoc, url, {int width: 0, int height: 0, scale: 1}) {
    var fileImg = img.decodeImage(Io.File(url).readAsBytesSync());

    if ( width == 0 ) width = (fileImg.width / scale).round();
    if ( height == 0 ) height = (fileImg.height / scale).round();

    PdfImage pdfImg = PdfImage(
        pdfDoc,
        image: img.copyResize(fileImg, width, height).data.buffer.asUint8List(),
        width: width,
        height: height);

    return pdf.Image(pdfImg);
  }

  Widget buildContractHeader(context) =>
      Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Expanded(
          flex: 3,
          child: Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Text(photographerLabel, style: _personLargeStyle),
            Text(_tinyContract.photographer.displayName, style: _personSmallStyle),
            Text(_tinyContract.selectedPhotographerAddress.street, style: _personSmallStyle),
            Text(_tinyContract.selectedPhotographerAddress.postcode + " " +
                _tinyContract.selectedPhotographerAddress.city, style: _personSmallStyle),
          ],),
        ),
        Expanded(
          flex: 3,
          child: _tinyContract.model.avatar != null ? Image.file(
            Io.File(_tinyContract.model.avatar), fit: BoxFit.scaleDown, height: 150,) : Container(),
        ),
        Expanded(
          flex: 3,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(modelLabel, style: _personLargeStyle),
            Text(_tinyContract.model.displayName, style: _personSmallStyle),
            Text(_tinyContract.selectedModelAddress.street, style: _personSmallStyle),
            Text(_tinyContract.selectedModelAddress.postcode + " " +
                _tinyContract.selectedModelAddress.city, style: _personSmallStyle),
            _tinyContract.parent != null ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Divider(),
              Text(parentLabel, style: _personLargeStyle),
              Text(_tinyContract.parent.displayName, style: _personSmallStyle),
              Text(_tinyContract.selectedParentAddress.street, style: _personSmallStyle),
              Text(_tinyContract.selectedParentAddress.postcode + " " +
                  _tinyContract.selectedParentAddress.city, style: _personSmallStyle),
            ],) : Container(),
            _tinyContract.witness != null ? Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Divider(),
              Text(witnessLabel, style: _personLargeStyle),
              Text(_tinyContract.witness.displayName, style: _personSmallStyle),
              Text(_tinyContract.selectedWitnessAddress.street, style: _personSmallStyle),
              Text(_tinyContract.selectedWitnessAddress.postcode + " " +
                  _tinyContract.selectedWitnessAddress.city, style: _personSmallStyle),
            ],) : Container(),
          ],),
        )
      ],);
}