
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paperflavor/data/tiny_signature.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/tiny_state.dart';
import 'dart:ui' as ui;

class SignatureWidget extends StatefulWidget {

  final TinyState _tinyState;

  SignatureWidget( this._tinyState );

  @override
  _SignatureWidgetState createState() => _SignatureWidgetState(_tinyState);
}

class _SignatureWidgetState extends State<SignatureWidget> {

  Uint8List _modelSignatureBytes, _photographerSignatureBytes, _parentSignatureBytes, _witnessSignatureBytes;

  /// keys for signature pads
  final _modelKey = GlobalKey<SignatureState>();
  final _photographerKey = GlobalKey<SignatureState>();
  final _parentKey = GlobalKey<SignatureState>();
  final _witnessKey = GlobalKey<SignatureState>();

  /// signature widgets
  Signature _modelSignatureWidget, _photographerSignatureWidget, _witnessSignatureWidget, _parentSignatureWidget;

  final TinyState _tinyState;
  TinyContract _tinyContract;
  final TinyContractRepo _tinyContractRepo = TinyContractRepo();

  _SignatureWidgetState(this._tinyState){
    _tinyContract = _tinyState.curDBO;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
      ],
    );
  }

  ///         ///
  /// signatures
  ///         ///

  ///
  /// helpers
  ///

  _signaturesValid() =>
      _modelSignatureBytes != null &&
          _photographerSignatureBytes != null &&
          (_tinyContract.witness == null || _witnessSignatureBytes != null ) &&
          (_tinyContract.parent == null || _parentSignatureBytes != null);

  ///
  /// widgets
  ///

  Signature _getSignaturePad(GlobalKey key) =>
      Signature(
        key: key,
        color: CupertinoColors.black,
        strokeWidth: 5,
        backgroundPainter: _WatermarkPaint("32.0", "32.0"),
      );

  Widget _buildSignatureDeleteButton(onDelete) =>
      CupertinoButton(
        child: Icon(CupertinoIcons.delete_solid),
        onPressed: () => setState(() => onDelete()),
        borderRadius: BorderRadius.all(Radius.circular(0)),
        padding: EdgeInsets.all(0),
      );

  Widget _buildSignatureSubtext() =>
      Text(_tinyContract.location + S.of(context).location_date_seperator +
          BaseUtil.getLocalFormattedDate(context, DateTime.now().toIso8601String()));

  /// wrap signature with data and location
  Widget _wrapSignature(sig, name, onDelete) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8.0),
              child: SizedBox(height: 150, child: sig)),
          ListTile(
              trailing: _buildSignatureSubtext(),
              leading: Row(children: <Widget>[
                !_tinyContract.isLocked ? _buildSignatureDeleteButton(onDelete) : Container(),
                Text(name),
              ],)
          ),
        ],
      );

  _signatureFinishedCallback(signatureWidget, saveCallback) async {
    var imageBytesFromSignature = await _getImageBytesFromSignature(signatureWidget);
    saveCallback(imageBytesFromSignature);
  }

  /// save methods for signatures

  _savePhotographerSignature(bytes) => setState(() {
    if(_photographerKey.currentState.hasPoints()) _photographerSignatureBytes = _byteDataToUint8(bytes);
    _saveSignature(_photographerSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.photographerSignature = ts);
  });

  _saveModelSignature(bytes) => setState(() {
    if(_modelKey.currentState.hasPoints()) _modelSignatureBytes = _byteDataToUint8(bytes);
    _saveSignature(_modelSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.modelSignature = ts);
  });

  _saveWitnessSignature(bytes) => setState(() {
    if(_witnessKey.currentState.hasPoints()) _witnessSignatureBytes = _byteDataToUint8(bytes);
    _saveSignature(_witnessSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.witnessSignature = ts);
  });

  _saveParentSignature(bytes) => setState(() {
    if(_parentKey.currentState.hasPoints()) _parentSignatureBytes = _byteDataToUint8(bytes);
    _saveSignature(_parentSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.parentSignature = ts);
  });

  /// signature dialog
  _onSignatureComplete(dialogKey, signatureWidget, signerName, saveCallback) =>
      showCupertinoModalPopup(context: context, builder: (context) =>
          Dialog(
            key: Key(dialogKey),
            child:
            _wrapSignature(
                signatureWidget, signerName, () => signatureWidget.clear()),))
          .then((v) => _signatureFinishedCallback(signatureWidget, saveCallback));

  _buildSignButton({signatureBytes, signatureWidget, signerName, buttonKey, dialogKey, saveSignatureCallback}) =>
      CupertinoButton(
        child: signatureBytes != null
            ? Image(image: MemoryImage(signatureBytes), key: Key(buttonKey))
            : Container(child: Icon(CupertinoIcons.pen, key: Key(buttonKey),),),
        onPressed: () => _onSignatureComplete(
            dialogKey,
            signatureWidget,
            signerName,
            saveSignatureCallback
    ),);

  _buildPrimarySignatureSection() {
    _modelSignatureWidget = _getSignaturePad(_modelKey);
    _photographerSignatureWidget = _getSignaturePad(_photographerKey);

    return <Widget> [
      Flexible(fit: FlexFit.loose,
        key: Key('signature_photographer_flex'),
        child:
        _wrapSignature(
            _buildSignButton(
                saveSignatureCallback: _savePhotographerSignature,
                signatureBytes: _photographerSignatureBytes,
                signatureWidget: _photographerSignatureWidget,
                signerName: _tinyContract.photographer.displayName,
                buttonKey: 'signature_photographer',
                dialogKey: 'signature_photographer_dialog'),
            _tinyContract.photographer.displayName, () =>
            setState(() => _photographerSignatureBytes = null)),),

      Flexible(fit: FlexFit.loose,
        child:
        _wrapSignature(
            _buildSignButton(
                saveSignatureCallback: _saveModelSignature,
                signatureBytes: _modelSignatureBytes,
                signatureWidget: _modelSignatureWidget,
                signerName: _tinyContract.model.displayName,
                buttonKey: 'signature_model',
                dialogKey: 'signature_model_dialog'),
            _tinyContract.model.displayName, () =>
            setState(() => _modelSignatureBytes = null)),),

    ];
  }

  _buildSecondarySignatureSection() {
    if ( _tinyContract.witness != null ) {
      _witnessSignatureWidget = _getSignaturePad(_witnessKey);
    }

    if ( _tinyContract.parent != null ) {
      _parentSignatureWidget = _getSignaturePad(_parentKey);
    }

    return <Widget> [
      _tinyContract.witness != null ? Flexible(fit: FlexFit.loose,
        child:
        _wrapSignature(
            _buildSignButton(
                saveSignatureCallback: _saveWitnessSignature,
                signatureBytes: _witnessSignatureBytes,
                signatureWidget: _witnessSignatureWidget,
                signerName: _tinyContract.witness.displayName,
                buttonKey: 'signature_witness',
                dialogKey: 'signature_witness_dialog'),
            _tinyContract.witness.displayName, () =>
            setState(() => _witnessSignatureBytes = null)),) : Container(),

      _tinyContract.parent != null ? Flexible(fit: FlexFit.loose,
        child:
        _wrapSignature(
            _buildSignButton(
                saveSignatureCallback: _saveParentSignature,
                signatureBytes: _parentSignatureBytes,
                signatureWidget: _parentSignatureWidget,
                signerName: _tinyContract.parent.displayName,
                buttonKey: 'signature_parent',
                dialogKey: 'signature_parent_dialog'),
            _tinyContract.witness.displayName, () =>
            setState(() => _witnessSignatureBytes = null)),) : Container(),
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

  Uint8List _byteDataToUint8(ByteData bd) => bd.buffer.asUint8List(bd.offsetInBytes, bd.lengthInBytes);

  Future<ByteData> _getImageBytesFromSignature(signatureWidget) async {
    var img = await signatureWidget.getData();

    return _getBytesFromImg(img);
  }

  Future<ByteData> _getBytesFromImg(ui.Image img) async => img.toByteData(format: ui.ImageByteFormat.png);

  /// saves signature to file
  static Future<TinySignature> _saveSignature(Uint8List sig, int contractId) async {
    if (sig != null) {
      return TinySignature(
          contractId: contractId,
          path: (await BaseUtil.storeBlobUint8('signature', 'png', sig)).path
      );
    }
    return null;
  }

  /// saves all signatures
  _saveSignatures() async {
    if (_modelSignatureBytes != null && _tinyContract.modelSignature == null)
      _saveSignature(_modelSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.modelSignature = ts);
    if (_photographerSignatureBytes != null && _tinyContract.photographerSignature == null)
      _saveSignature(_photographerSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.photographerSignature = ts);
    if (_parentSignatureBytes != null && _tinyContract.parentSignature == null)
      _saveSignature(_parentSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.parentSignature = ts);
    if (_witnessSignatureBytes != null && _tinyContract.witnessSignature == null)
      _saveSignature(_witnessSignatureBytes, _tinyContract.id).then((ts) => _tinyContract.witnessSignature = ts);
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
