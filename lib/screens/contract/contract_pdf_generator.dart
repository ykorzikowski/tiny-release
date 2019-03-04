import 'dart:io' as Io;
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:image/image.dart' as img;

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

  static TextStyle _personPdfSmallStyle = TextStyle( fontSize: 16, font: Font.times() );
  static TextStyle _personPdfLargeStyle = TextStyle( fontSize: 18, font: Font.timesBold() );
  
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

  Document generatePdf(buildContext) {
    var doc = Document(deflate: zlib.encode);

    doc.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      crossAxisAlignment: CrossAxisAlignment.start,
      build: (context) => <Widget> [
        buildPdfContractHeader(buildContext, doc.document),
        buildPdfShootingInformationSection(buildContext),
        //Column(children: buildPdfParagraphs(buildContext)),
        //buildPdfSignatures(buildContext, doc.document),
      ],
    ));

    return doc;
  }

  /// pdf section
  Widget buildPdfContractHeader(context, pdfDoc) =>
      Row(mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(photographerLabel, style: _personPdfLargeStyle),
                Text(_tinyContract.photographer.displayName,
                    style: _personPdfSmallStyle),
                Text(_tinyContract.selectedPhotographerAddress.street,
                    style: _personPdfSmallStyle),
                Text(
                    _tinyContract.selectedPhotographerAddress.postcode + " " +
                        _tinyContract.selectedPhotographerAddress.city,
                    style: _personPdfSmallStyle),
              ],),
          ),
          Expanded(
            flex: 3,
            child: _tinyContract.model.avatar != null ? _getPdfImage(pdfDoc, _tinyContract.model.avatar, width: 150, height: 150) : Container(),
          ),
          Expanded(
            flex: 4,
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Text(modelLabel, style: _personPdfLargeStyle),
              Text(
                  _tinyContract.model.displayName, style: _personPdfSmallStyle),
              Text(_tinyContract.selectedModelAddress.street,
                  style: _personPdfSmallStyle),
              Text(_tinyContract.selectedModelAddress.postcode + " " +
                  _tinyContract.selectedModelAddress.city,
                  style: _personPdfSmallStyle),
              _tinyContract.parent != null ? Column(
                mainAxisSize: MainAxisSize.max, children: <Widget>[
                Text(parentLabel, style: _personPdfLargeStyle),
                Text(_tinyContract.parent.displayName,
                    style: _personPdfSmallStyle),
                Text(_tinyContract.selectedParentAddress.street,
                    style: _personPdfSmallStyle),
                Text(_tinyContract.selectedParentAddress.postcode + " " +
                    _tinyContract.selectedParentAddress.city,
                    style: _personPdfSmallStyle),
              ],) : Container(),
              _tinyContract.witness != null ? Column(
                mainAxisSize: MainAxisSize.max, children: <Widget>[
                Text(witnessLabel, style: _personPdfLargeStyle),
                Text(_tinyContract.witness.displayName,
                    style: _personPdfSmallStyle),
                Text(_tinyContract.selectedWitnessAddress.street,
                    style: _personPdfSmallStyle),
                Text(_tinyContract.selectedWitnessAddress.postcode + " " +
                    _tinyContract.selectedWitnessAddress.city,
                    style: _personPdfSmallStyle),
              ],) : Container(),
            ],),
          )
        ],);

  Widget buildPdfShootingInformationSection(context) => Column(children: <Widget>[
    Text(S.of(context).shooting_subject + doppelPinkt + _tinyContract.displayName),
    Text(S.of(context).shooting_date + doppelPinkt + BaseUtil.getLocalFormattedDate(context, _tinyContract.date)),
    _tinyContract.receptions != null ? Text(S.of(context).reception_area + doppelPinkt + _getReceptionString()) : Container(),
  ],);


  List<Widget> buildPdfParagraphs(context) {
    var widgetList = List<Widget>();
    for (int i = 0; i < _tinyContract.preset.paragraphs.length; i++) {
      var paragraph  = _tinyContract.preset.paragraphs[i];
      widgetList.add(Header(level: 2, text: BaseUtil.getParagraphTitle(context, paragraph, (i+1)),));
      widgetList.add(Paragraph(text: paragraph.content));
    }
    _tinyContract.preset.paragraphs.forEach((paragraph) {
    });

    return widgetList;
  }

  Widget buildPdfSignatures(context, pdfDoc) =>
      Container(
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            _tinyContract.photographer != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.photographerSignature, _tinyContract.photographer.displayName) : Container(),
            _tinyContract.model != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.modelSignature, _tinyContract.model.displayName) : Container(),
          ]),
          Row(children: <Widget>[
            _tinyContract.parent != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.parentSignature, _tinyContract.parent.displayName) : Container(),
            _tinyContract.witness != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.witnessSignature, _tinyContract.witness.displayName) : Container(),
          ]),
        ],),
      );

  Widget _wrapPdfSignature(context, pdfDoc, TinySignature sig, name) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0),
            child: Container(height: 150, child: sig != null ? _getPdfImage(pdfDoc, sig.path, scale: 3) : Container(decoration: BoxDecoration( border: BoxBorder(width: 2.0, color: PdfColor.black, ), ), ), ), ),
          Row(children: <Widget>[
            Padding(padding: EdgeInsets.all(8.0), child: Text(name),),
            Padding(padding: EdgeInsets.all(8.0), child: Text(_tinyContract.location + ", den " + BaseUtil.getLocalFormattedDate(context, DateTime.now().toIso8601String())),),
          ]),
        ],
      );

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

  Widget _getPdfImage(pdfDoc, url, {int width: 0, int height: 0, scale: 1}) {
    var fileImg = img.decodeImage(Io.File(url).readAsBytesSync());

    if ( width == 0 ) width = (fileImg.width / scale).round();
    if ( height == 0 ) height = (fileImg.height / scale).round();

    PdfImage pdfImg = PdfImage(
        pdfDoc,
        image: img.copyResize(fileImg, width, height).data.buffer.asUint8List(),
        width: width,
        height: height);

    return Image(pdfImg);
  }
}