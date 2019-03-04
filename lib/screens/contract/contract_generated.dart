
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pdf;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:share_extend/share_extend.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_signature.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/contract/contract_generator.dart';
import 'package:tiny_release/screens/contract/contract_pdf_generator.dart';
import 'package:tiny_release/util/BaseUtil.dart';
import 'package:tiny_release/util/NavRoutes.dart';
import 'package:tiny_release/util/tiny_state.dart';
import 'dart:ui' as ui;

typedef Null ItemSelectedCallback(int value);

class ContractGeneratedWidget extends StatefulWidget {

  final TinyState _controlState;

  ContractGeneratedWidget( this._controlState );

  @override
  _ContractGeneratedWidgetState createState() => _ContractGeneratedWidgetState(_controlState);
}

class _ContractGeneratedWidgetState extends State<ContractGeneratedWidget> {
  final TinyState _tinyState;
  TinyContract _tinyContract;
  Uint8List _modelSignature, _photographerSignature, _parentSignature, _witnessSignature;

  final TinyContractRepo _tinyContractRepo = TinyContractRepo();
  ContractPdfGenerator _contractPdfGenerator;
  ContractGenerator _contractGenerator;

  /// keys for signature pads
  final _modelKey = GlobalKey<SignatureState>();
  final _photographerKey = GlobalKey<SignatureState>();
  final _parentKey = GlobalKey<SignatureState>();
  final _witnessKey = GlobalKey<SignatureState>();

  static const TextStyle btnStyle = TextStyle(color: CupertinoColors.activeBlue, fontSize: 16);

  _ContractGeneratedWidgetState(this._tinyState) {
    _tinyContract = _tinyState.curDBO;
    _contractPdfGenerator = ContractPdfGenerator(_tinyContract);
    _contractGenerator = ContractGenerator(_tinyContract);
  }

  _signaturesValid() =>
      _modelSignature != null &&
          _photographerSignature != null &&
          (_tinyContract.witness == null || _witnessSignature != null ) &&
          (_tinyContract.parent == null || _parentSignature != null);

  Signature _getSignaturePad(GlobalKey key) =>
      Signature(
            key: key,
            color: CupertinoColors.black,
            strokeWidth: 5,
            backgroundPainter: _WatermarkPaint("32.0", "32.0"),
      );

  Widget _wrapSignature(sig, name, onDelete) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0),
              child: SizedBox(height: 150, child: sig)),
          ListTile(
              trailing: Text(_tinyContract.location + ", den " +
                  BaseUtil.getLocalFormattedDate(
                      context, DateTime.now().toIso8601String())),
              leading: Row(children: <Widget>[
                !_tinyContract.isLocked ? CupertinoButton(
                  child: Icon(CupertinoIcons.delete_solid),
                  onPressed: () => setState(() => onDelete()),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  padding: EdgeInsets.all(0),
                ) : Container(),
                Text(name),
              ],)
          ),
        ],
      );

  _buildPrimarySignatureSection() {
    Signature _modelSignatureW = _getSignaturePad(_modelKey);
    Signature _photographerSignatureW = _getSignaturePad(_photographerKey);

    return <Widget> [
      Flexible( fit: FlexFit.loose,
        child:
        _wrapSignature(CupertinoButton(
            child: _photographerSignature != null ? Image(image: MemoryImage(_photographerSignature)) : Container(child: Icon(CupertinoIcons.pen),),
            onPressed: () =>
                showCupertinoModalPopup(context: context, builder: (context) =>
                    Dialog(child: _wrapSignature(_photographerSignatureW, _tinyContract.photographer.displayName, () => _photographerSignatureW.clear()),))
                    .then((r) => _photographerSignatureW.getData().then((image) => _getBytesFromImg(image)
                    .then((bv) => setState(() => _photographerKey.currentState.hasPoints() ? _photographerSignature = bv.buffer.asUint8List(bv.offsetInBytes, bv.lengthInBytes) : null)))),),
    _tinyContract.photographer.displayName, () => setState(() => _photographerSignature = null )),),

      Flexible( fit: FlexFit.loose,
        child:
        _wrapSignature(CupertinoButton(
          child: _modelSignature != null ? Image(image: MemoryImage(_modelSignature)) : Container(child: Icon(CupertinoIcons.pen),),
          onPressed: () =>
              showCupertinoModalPopup(context: context, builder: (context) =>
                  Dialog(child: _wrapSignature(_modelSignatureW, _tinyContract.model.displayName, () => _modelSignatureW.clear()),))
                  .then((r) => _modelSignatureW.getData().then((image) => _getBytesFromImg(image)
                  .then((bv) => setState(() => _modelKey.currentState.hasPoints() ? _modelSignature = bv.buffer.asUint8List(bv.offsetInBytes, bv.lengthInBytes) : null)))),),
            _tinyContract.model.displayName,  () => setState(() => _modelSignature = null )),),

    ];
  }

  _buildSecondarySignatureSection() {
    Signature _witnessSignatureW, _parentSignatureW;
    if ( _tinyContract.witness != null ) {
      _witnessSignatureW = _getSignaturePad(_witnessKey);
    }

    if ( _tinyContract.parent != null ) {
      _parentSignatureW = _getSignaturePad(_parentKey);
    }

    return <Widget> [
      _tinyContract.witness != null ? Flexible( fit: FlexFit.loose,
        child:
        _wrapSignature(CupertinoButton(
          child: _witnessSignature != null ? Image(image: MemoryImage(_witnessSignature)) : Container(child: Icon(CupertinoIcons.pen),),
          onPressed: () =>
              showCupertinoModalPopup(context: context, builder: (context) =>
                  Dialog(child: _wrapSignature(_witnessSignatureW, _tinyContract.witness.displayName, () => _witnessSignatureW.clear()),))
                  .then((r) =>_witnessSignatureW.getData().then((image) => _getBytesFromImg(image)
                  .then((bv) => setState(() => _witnessKey.currentState.hasPoints() ? _witnessSignature = bv.buffer.asUint8List(bv.offsetInBytes, bv.lengthInBytes) : null)))),),
            _tinyContract.witness.displayName, () => setState(() => _witnessSignature = null )),) : Container(),
      _tinyContract.parent != null ? Flexible( fit: FlexFit.loose,
        child:
        _wrapSignature(CupertinoButton(
          child: _parentSignature != null ? Image(image: MemoryImage(_parentSignature)) : Container(child: Icon(CupertinoIcons.pen),),
          onPressed: () =>
              showCupertinoModalPopup(context: context, builder: (context) =>
                  Dialog(child: _wrapSignature(_parentSignatureW, _tinyContract.parent.displayName, () => _parentSignatureW.clear()),))
                  .then((r) => _parentSignatureW.getData().then((image) => _getBytesFromImg(image)
                  .then((bv) => setState(() => _parentKey.currentState.hasPoints() ? _parentSignature = bv.buffer.asUint8List(bv.offsetInBytes, bv.lengthInBytes) : null)))),),
            _tinyContract.parent.displayName, () => setState(() => _parentSignature = null )),) : Container(),
    ];
  }

  _getImg(TinySignature sig) {
    return Container(height: 150, child: Image.file(Io.File(sig.path)));
  }

  List<Widget> _buildSignatureImageSection() {
  return <Widget> [
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.photographer != null ? _wrapSignature(_getImg(_tinyContract.photographerSignature), _tinyContract.photographer.displayName, null) : Container()),
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.model != null ? _wrapSignature(_getImg(_tinyContract.modelSignature), _tinyContract.model.displayName, null) : Container()),
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.parent != null ? _wrapSignature(_getImg(_tinyContract.parentSignature), _tinyContract.parent.displayName, null) : Container()),
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.witness != null ? _wrapSignature(_getImg(_tinyContract.witnessSignature), _tinyContract.witness.displayName, null) : Container()),
    ];
  }

  Future<ByteData> _getBytesFromImg(ui.Image img) async => img.toByteData(format: ui.ImageByteFormat.png);

  _saveSignatures() async {
    if (_modelSignature != null)
      _tinyContract.modelSignature =
        TinySignature(
          type: SignatureType.SIG_MODEL,
          contractId: _tinyContract.id,
          path: (await BaseUtil.storeBlobUint8('signature', 'png', _modelSignature)).path
        );
    if (_photographerSignature != null)
      _tinyContract.photographerSignature =
        TinySignature(
            type: SignatureType.SIG_PHOTOGRAPHER,
            contractId: _tinyContract.id,
            path: (await BaseUtil.storeBlobUint8('signature', 'png', _photographerSignature)).path
        );
    if (_parentSignature != null)
      _tinyContract.parentSignature =
        TinySignature(
            type: SignatureType.SIG_PARENT,
            contractId: _tinyContract.id,
            path: (await BaseUtil.storeBlobUint8('signature', 'png', _parentSignature)).path
        );
    if (_witnessSignature != null)
      _tinyContract.witnessSignature =
        TinySignature(
            type: SignatureType.SIG_WITNESS,
            contractId: _tinyContract.id,
            path: (await BaseUtil.storeBlobUint8('signature','png', _witnessSignature)).path
        );
  }

  List<BottomNavigationBarItem> _getButtonsForFinishedContract() =>
      <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.create),
        ),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.share),
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.delete_solid),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'contract',
          transitionBetweenRoutes: false,
          middle: _tinyContract.isLocked ? Text(S.of(context).finished_contract) : Text(S.of(context).finish_contract) ,
          trailing: !_tinyContract.isLocked ? CupertinoButton(
            child: Text(S.of(context).btn_edit),
            onPressed: () {
              //todo: edit contract
              _tinyState.curDBO = _tinyContract;
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER);
            }) : Text(""),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child:
          Column(
              mainAxisSize: MainAxisSize.max,
              children: [
          Expanded(child: ListView(
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              children: <Widget>[

                /// header
                Text(_tinyContract.preset.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 32),),

                /// contract head
                _contractGenerator.buildContractHeader(context),

                Divider(),

                _contractGenerator.buildShootingInformationSection(context),

                Divider(),

                /// contract preview
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ContractGenerator.buildParagraphs(
                      context, _tinyContract),
                ),

                Divider(),

                /// signatures
                !_tinyContract.isLocked ? Column(children: <Widget>[

                  /// signatures model and photographer
                  Column(mainAxisSize: MainAxisSize.min,
                    children: _buildPrimarySignatureSection(),),

                  /// signatures witness and parent
                  _tinyContract.witness != null || _tinyContract.parent != null
                      ? Column(mainAxisSize: MainAxisSize.min,
                    children: _buildSecondarySignatureSection(),)
                      : Container(),
                ],) :
                Column(mainAxisSize: MainAxisSize.min,
                    children: _buildSignatureImageSection()),

                /// button to complete contract
                !_tinyContract.isLocked ? CupertinoButton(
                  child: Text(S.of(context).btn_complete_contract),
                  onPressed: _signaturesValid() ? () async {
                    await _saveSignatures();

                    _tinyContract.isLocked = true;
                    await _tinyContractRepo.save(_tinyContract);
                    _tinyState.curDBO = _tinyContract;

                    Navigator.of(context).popUntil((route) => !Navigator.of(context).canPop());
                    Navigator.of(context).pushNamed(NavRoutes.CONTRACT_GENERATED);
                  } : null,
                ) : Container(),

                _tinyContract.isLocked ? Text(S.of(context).hint_completed_contracts, textAlign: TextAlign.center, style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 10),) : Container(),
              ],
            ), ),

            CupertinoTabBar(
              onTap: (sel) {
                switch(sel) {
                  case 0:
                  //todo: new based on this
                  case 1:
                    pdf.Document pdfDoc = _contractPdfGenerator.generatePdf(context);
                    // Share.file(path: saved.path, mimeType: ShareType.TYPE_FILE, title: 'pdf', text: 'pdf'))
                    BaseUtil.storeBlobUint8('contract', 'pdf', Uint8List.fromList(pdfDoc.save())).then((saved) {
                      print(saved.path);
                      saved.exists().then((val) => print(val));
                      ShareExtend.share(saved.path, 'file');
                    });
                    break;
                    //todo: share
                  case 2:
                    // todo: delete
                }
              },
                inactiveColor: CupertinoColors.activeBlue,
                items: _getButtonsForFinishedContract())
          ]),),
      ),);
  }

}

// todo: ad own watermark impl
class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10.8, Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is _WatermarkPaint && runtimeType == other.runtimeType && price == other.price && watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}