import 'dart:io' as Io;
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:image/image.dart' as img;

import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/data/tiny_signature.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';

class ContractPdfGenerator {
  final TinyContract _tinyContract;

  static const doppelPinkt = ": ";

  TextStyle _personPdfSmallStyle, _personPdfLargeStyle, _textStyle;

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

  Future<Document> generatePdf(buildContext) async {
    var doc = Document(deflate: zlib.encode);
    _personPdfSmallStyle = TextStyle( fontSize: 14, font: Font.times() );
    _textStyle = TextStyle( fontSize: 12, font: Font.times() );
    _personPdfLargeStyle = TextStyle( fontSize: 16, font: Font.timesBold() );

    var widgetList = List<Widget>();
    widgetList.add(buildPdfContractHeader(buildContext, doc.document));
    widgetList.add(Padding(padding: EdgeInsets.only(top: 14.0), child: buildPdfShootingInformationSection(buildContext)));
    widgetList.addAll(buildPdfParagraphs(buildContext));
    widgetList.add(Padding(padding: EdgeInsets.only(top: 14.0), child: buildPdfSignatures(buildContext, doc.document)));

    doc.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => widgetList,
    ));
    return doc;
  }

  Widget buildPeopleSection(label, people, address) {
    return Column(mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(label, style: _personPdfLargeStyle),
        Text(people.displayName,
            style: _personPdfSmallStyle),
        Text(address.street,
            style: _personPdfSmallStyle),
        Text(
            address.postcode + " " +
                address.city,
            style: _personPdfSmallStyle),
      ],);
  }

  Widget buildPdfContractHeader(context, pdfDoc) =>
    GridView(crossAxisCount: 3, childAspectRatio: 1.0, children: <Widget>[
      Expanded(
        child: buildPeopleSection(photographerLabel, _tinyContract.photographer, _tinyContract.selectedPhotographerAddress)
      ),
      Expanded(
        child: _tinyContract.model.hasAvatar ? _getPdfImage(pdfDoc, _tinyContract.model.avatar) : Container(),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 14.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: <Widget>[
              buildPeopleSection(modelLabel, _tinyContract.model, _tinyContract.selectedModelAddress),
              _tinyContract.parent != null ? buildPeopleSection(parentLabel, _tinyContract.parent, _tinyContract.selectedParentAddress) : Container(),
              _tinyContract.witness != null ? buildPeopleSection(witnessLabel, _tinyContract.witness, _tinyContract.selectedWitnessAddress) : Container(),
            ],),
         )
      )
    ]);

  Widget buildPdfShootingInformationSection(context) =>
      Column(mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(S.of(context).shooting_subject + doppelPinkt + _tinyContract.displayName,
              style: _personPdfSmallStyle),
          Text(S.of(context).shooting_date + doppelPinkt + BaseUtil.getLocalFormattedDate(context, _tinyContract.date),
              style: _personPdfSmallStyle),
          _tinyContract.receptions != null ? Text(S.of(context).reception_area + doppelPinkt + _tinyContract.receptionsToString(),
              style: _personPdfSmallStyle) : Container(),
        ],);

  List<Widget> buildPdfParagraphs(context) {
    var widgetList = List<Widget>();
    for (int i = 0; i < _tinyContract.preset.paragraphs.length; i++) {
      var paragraph  = _tinyContract.preset.paragraphs[i];
      widgetList.add(
          Column(children: [
            Header(level: 1, textStyle: _personPdfLargeStyle, text: BaseUtil.getParagraphTitle(context, paragraph, (i+1)),),
            Text(paragraph.content, style: _textStyle)
      ]));
    }
    _tinyContract.preset.paragraphs.forEach((paragraph) {
    });

    return widgetList;
  }

  Widget buildPdfSignatures(context, pdfDoc) =>
      Container(
        child: Column(children: <Widget>[
          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            _tinyContract.photographer != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.photographerSignature, _tinyContract.photographer.displayName) : Container(),
            _tinyContract.model != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.modelSignature, _tinyContract.model.displayName) : Container(),
          ]),
          Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
            _tinyContract.parent != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.parentSignature, _tinyContract.parent.displayName) : Container(),
            _tinyContract.witness != null ? _wrapPdfSignature(context, pdfDoc, _tinyContract.witnessSignature, _tinyContract.witness.displayName) : Container(),
          ]),
        ],),
      );

  Widget _wrapPdfSignature(context, pdfDoc, TinySignature sig, name) =>
      Column(mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // location
          Padding(padding: EdgeInsets.all(8.0),
            child: Text(_tinyContract.location + S.of(context).location_date_seperator + BaseUtil.getLocalFormattedDate(context, DateTime.now().toIso8601String()),
                style: _textStyle),),

          // signature
          Padding(padding: EdgeInsets.all(8.0),
            child: Container( height: 50, child: sig != null ?
              _getPdfImage(pdfDoc, sig.path, scale: 3) :
              Container(height: 50))),

          // signature line & name
          FittedBox(fit: BoxFit.fill,
              child: Container(
                decoration: BoxDecoration( border: BoxBorder(top: true)),
                child: Row(children: <Widget>[
                  Padding(padding: EdgeInsets.all(8.0),
                    child: Text(name, style: _textStyle,),),
            ]),
          )
          ),
        ],
      );

  Widget _getPdfImage(pdfDoc, url, {int width: 0, int height: 0, scale: 1}) {
    var fileImg = img.decodeImage(BaseUtil.getFileSync(url).readAsBytesSync());

    if ( width == 0 ) width = (fileImg.width / scale).round();
    if ( height == 0 ) height = (fileImg.height / scale).round();

    PdfImage pdfImg = PdfImage(
        pdfDoc,
        image: img.copyResize(fileImg, width: width, height: height).data.buffer.asUint8List(),
        width: width,
        height: height);

    return Image(pdfImg);
  }
}
