
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:tiny_release/data/tiny_contract.dart';
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
  ScrollPhysics _scrollPhysics = BouncingScrollPhysics();

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
          print("end");
          _scrollPhysics = BouncingScrollPhysics();
        });
      }
  );

  _wrapSignature(Signature sig, name) =>
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
                CupertinoButton(
                  child: Icon(CupertinoIcons.delete_solid),
                  onPressed: () => setState(() => sig.clear()),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  padding: EdgeInsets.all(0),
                ),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'contract',
          transitionBetweenRoutes: false,
          middle: Text(S.of(context).add_contract),
          trailing: CupertinoButton(
            child: Text(S.of(context).btn_edit),
            onPressed: () {
              //todo: edit contract
              _tinyState.curDBO = _tinyContract;
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER);
            }),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child:
          ListView(
            physics: _scrollPhysics,
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: ContractPreviewWidget.buildPreview(
                    context, _tinyContract),
              ),
              Column( mainAxisSize: MainAxisSize.min, children: _buildPrimarySignatureSection(),),
              _tinyContract.witness != null || _tinyContract.parent != null ? Column( mainAxisSize: MainAxisSize.min, children: _buildSecondarySignatureSection(),) : Container(),
              CupertinoButton(
                child: Text("Complete Contract"),
                onPressed: _signaturesValid() ?  () {
                  print(_signaturesValid());
                  // todo: Save signatures and lock contract
                } : null,
              )
            ],
          ),),
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