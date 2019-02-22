
import 'dart:io' as Io;
import 'dart:typed_data';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:tiny_release/data/repo/tiny_contract_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_signature.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/screens/contract/contract_preview.dart';
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
  Signature _modelSignature, _photographerSignature, _parentSignature, _witnessSignature;

  final TinyContractRepo _tinyContractRepo = TinyContractRepo();

  /// keys for signature pads
  final _modelKey = GlobalKey<SignatureState>();
  final _photographerKey = GlobalKey<SignatureState>();
  final _parentKey = GlobalKey<SignatureState>();
  final _witnessKey = GlobalKey<SignatureState>();

  static const TextStyle btnStyle = TextStyle(color: CupertinoColors.activeBlue, fontSize: 16);

  _ContractGeneratedWidgetState(this._tinyState) {
    _tinyContract = _tinyState.curDBO;
  }

  _signatureValid(sig) => sig != null && sig.key.currentState != null && sig.key.currentState.hasPoints();

  _signaturesValid() =>
      _signatureValid(_modelSignature) &&
          _signatureValid(_photographerSignature) &&
          (_witnessSignature == null || _signatureValid(_witnessSignature)) &&
          (_parentSignature == null || _signatureValid(_parentSignature));

  _getSignaturePad(GlobalKey key) => Signature(
      key: key,
      color: CupertinoColors.black,
      strokeWidth: 5,
      backgroundPainter: _WatermarkPaint("32.0", "32.0"),
      onSign: () {
        setState(() {

        });
      }
  );

  Widget _wrapSignature(sig, name) =>
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
                  onPressed: () => setState(() => sig.clear()),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  padding: EdgeInsets.all(0),
                ) : Container(),
                Text(name),
              ],)
          ),
        ],
      );

  _buildPrimarySignatureSection() {
    _modelSignature = _getSignaturePad(_modelKey);
    _photographerSignature = _getSignaturePad(_photographerKey);

    return <Widget> [
      Flexible( fit: FlexFit.loose,
        child: _wrapSignature(_modelSignature, _tinyContract.model.displayName),),
      Flexible( fit: FlexFit.loose,
        child: _wrapSignature(_photographerSignature, _tinyContract.photographer.displayName),),
    ];
  }

  _buildSecondarySignatureSection() {
    if ( _tinyContract.witness != null ) {
      _witnessSignature = _getSignaturePad(_witnessKey);
    }

    if ( _tinyContract.parent != null ) {
      _parentSignature = _getSignaturePad(_parentKey);
    }

    return <Widget> [
      Flexible( fit: FlexFit.loose,
        child: _tinyContract.witness != null ? _wrapSignature(_witnessSignature, _tinyContract.witness.displayName) : Container()),
      Flexible( fit: FlexFit.loose,
        child: _tinyContract.parent != null ?  _wrapSignature(_parentSignature, _tinyContract.parent.displayName) : Container()),
    ];
  }

  _getImg(TinySignature sig) {
    return Container(height: 150, child: Image.file(Io.File(sig.path)));
  }

  List<Widget> _buildSignatureImageSection() {
  return <Widget> [
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.photographer != null ? _wrapSignature(_getImg(_tinyContract.photographerSignature), _tinyContract.photographer.displayName) : Container()),
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.model != null ? _wrapSignature(_getImg(_tinyContract.modelSignature), _tinyContract.model.displayName) : Container()),
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.parent != null ? _wrapSignature(_getImg(_tinyContract.parentSignature), _tinyContract.parent.displayName) : Container()),
    Flexible( fit: FlexFit.loose,
    child: _tinyContract.witness != null ? _wrapSignature(_getImg(_tinyContract.witnessSignature), _tinyContract.witness.displayName) : Container()),
    ];
  }

  Future<ByteData> _getBytesFromImg(ui.Image img) async => img.toByteData(format: ui.ImageByteFormat.png);

  _saveSignatures() async {
    if (_signatureValid(_modelSignature))
      _tinyContract.modelSignature =
        TinySignature(
          type: SignatureType.SIG_MODEL,
          contractId: _tinyContract.id,
          path: (await BaseUtil.storeBlob('signature', await _getBytesFromImg(_modelSignature.getData()))).path
        );
    if (_signatureValid(_photographerSignature))
      _tinyContract.photographerSignature =
        TinySignature(
            type: SignatureType.SIG_PHOTOGRAPHER,
            contractId: _tinyContract.id,
            path: (await BaseUtil.storeBlob('signature', await _getBytesFromImg(_photographerSignature.getData()))).path
        );
    if (_signatureValid(_parentSignature))
      _tinyContract.parentSignature =
        TinySignature(
            type: SignatureType.SIG_PARENT,
            contractId: _tinyContract.id,
            path: (await BaseUtil.storeBlob('signature', await _getBytesFromImg( _parentSignature.getData()))).path
        );
    if (_signatureValid(_witnessSignature))
      _tinyContract.witnessSignature =
        TinySignature(
            type: SignatureType.SIG_WITNESS,
            contractId: _tinyContract.id,
            path: (await BaseUtil.storeBlob('signature', await _getBytesFromImg(_witnessSignature.getData()))).path
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
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[

                /// contract preview
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ContractPreviewWidget.buildPreview(
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

                !_tinyContract.isLocked ? CupertinoButton(
                  child: Text(S.of(context).btn_complete_contract),
                  onPressed: _signaturesValid() ? () async {
                    print("save signatures");
                    await _saveSignatures();
                    print("saved signatures");

                    _tinyContract.isLocked = true;
                    print("sqlite start");
                    await _tinyContractRepo.save(_tinyContract);
                    _tinyState.curDBO = _tinyContract;

                    Navigator.of(context).popUntil((route) => !Navigator.of(context).canPop());
                    Navigator.of(context).pushNamed(NavRoutes.CONTRACT_GENERATED);
                  } : null,
                ) : Container()
              ],
            ), ),

            CupertinoTabBar(
              onTap: (sel) {
                switch(sel) {
                  case 0:
                  //todo: new based on this
                  case 1:
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