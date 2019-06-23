
import 'dart:typed_data';

import 'package:cool_ui/cool_ui.dart';
import 'package:rect_getter/rect_getter.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:paperflavor/data/repo/tiny_contract_repo.dart';
import 'package:paperflavor/data/tiny_contract.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/screens/contract/contract_generator.dart';
import 'package:paperflavor/screens/contract/contract_pdf_generator.dart';
import 'package:paperflavor/screens/contract/parser/parser.dart';
import 'package:paperflavor/screens/contract/signature_widget.dart';
import 'package:paperflavor/util/base_util.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:paperflavor/util/paywall.dart';
import 'package:paperflavor/util/tiny_state.dart';

typedef Null ItemSelectedCallback(int value);

class ContractGeneratedWidget extends StatefulWidget {

  final TinyState _controlState;

  ContractGeneratedWidget( this._controlState );

  @override
  _ContractGeneratedWidgetState createState() => _ContractGeneratedWidgetState(_controlState);
}

class _ContractGeneratedWidgetState extends State<ContractGeneratedWidget> {
  static const TextStyle btnStyle = TextStyle(color: CupertinoColors.activeBlue, fontSize: 16);

  final TinyContractRepo _tinyContractRepo = TinyContractRepo();
  final PayWall _payWall = PayWall();
  final TinyState _tinyState;
  TinyContract _tinyContract;

  ContractPdfGenerator _contractPdfGenerator;
  ContractGenerator _contractGenerator;

  /// global key for shareDialogPosition
  var _shareDialogPosGlobalKey = RectGetter.createGlobalKey();

  _ContractGeneratedWidgetState(this._tinyState) {
    _contractPdfGenerator = ContractPdfGenerator(_tinyContract);
    _contractGenerator = ContractGenerator(_tinyContract);
  }

  @override
  void initState() {
    super.initState();

    _tinyContract = TinyContract.fromMap(TinyContract.toMap(_tinyState.curDBO));
    _tinyContract.preset = Parser(_tinyContract, context).parsePreset();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'contract',
        transitionBetweenRoutes: false,
        middle: _tinyContract.isLocked ? Text(S.of(context).finished_contract) : Text(S.of(context).finish_contract) ,
        trailing: !_tinyContract.isLocked ? _buildNavBarButton() : Text(""),),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _buildPageContent()),);
  }

  Widget _buildPageContent() => Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                /// header
                Text(_tinyContract.preset.title, textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32),),

                /// contract head
                _contractGenerator.buildContractHeader(context),

                Divider(),

                _contractGenerator.buildShootingInformationSection(context),

                Divider(),

                /// contract preview
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ContractGenerator.buildParagraphs(
                        context, _tinyContract),
                  ),
                ),

                Divider(),

                /// signatures
                SignatureWidget(_tinyState),

                _tinyContract.isLocked ? _buildCompletedHint() : Container(),
              ],
            ),
          ),),
        _buildContentFooterAction(),

      ]);

  Widget _buildNavBarButton() => CupertinoButton(
      child: Text(S.of(context).btn_edit),
      onPressed: () {
        //todo: edit contract
        _tinyState.curDBO = _tinyContract;
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(NavRoutes.CONTRACT_MASTER);
      });


  ///         ///
  /// footer  ///
  ///         ///

  _onClonePressed() {
    var clone = TinyContract.fromMap(TinyContract.toMap(_tinyContract));
    clone.id = null;
    clone.isLocked = false;
    clone.modelSignature = null;
    clone.photographerSignature = null;
    clone.parentSignature = null;
    clone.witnessSignature = null;
    clone.displayName = clone.displayName + S.of(context).cloned_suffix;

    _tinyContractRepo.save(clone);
    Navigator.of(context).popUntil((r) => !Navigator.of(context).canPop());
  }

  _onSharePressed() {
    /// close the popover
    Navigator.of(context).pop();

    _payWall.checkIfPaid(PayFeature.PAY_PDF_EXPORT, _exportPdf,
            (error) => showCupertinoDialog(context: context, builder: (ctx) => PayWall.getSubscriptionDialog(PayFeature.PAY_PDF_EXPORT, ctx) ));
  }

  _onDeletePressed() {
    _tinyContractRepo.delete(_tinyContract);
    Navigator.of(context).popUntil((r) => !Navigator.of(context).canPop());
  }

  _exportPdf() {
    var hideLoading = showWeuiLoadingToast(context: context, message: Text(S.of(context).loading_pdf, textAlign: TextAlign.center,));

    _contractPdfGenerator.generatePdf(context).then((pdfDoc) =>
        BaseUtil.storeTempBlobUint8('contract', 'pdf', Uint8List.fromList(pdfDoc.save())).then((saved) {
          hideLoading();
          ShareExtend.share(saved.path, 'file', sharePositionOrigin: RectGetter.getRectFromKey(_shareDialogPosGlobalKey));
        }));
  }

  Widget _buildFooterCloneButton() => CupertinoPopoverButton(
    child: Icon(CupertinoIcons.create, color: CupertinoColors.activeBlue, size: 32),
    popoverBuild: (context) => CupertinoPopoverMenuList(
      children: <Widget>[
        CupertinoPopoverMenuItem(
          child: SizedBox(
            child: Center(child: Text(S.of(context).use_as_template, textAlign: TextAlign.center, style: TextStyle(fontSize: 21),)),
            width: 80,
            height: 50,
          ),
          onTap: () => _onClonePressed(),)
      ],
    ),
  );

  Widget _buildFooterShareButton() => CupertinoPopoverButton(
    child: Icon(CupertinoIcons.share, color: CupertinoColors.activeBlue, size: 32),
    popoverBuild: (context) => CupertinoPopoverMenuList(
      children: <Widget>[
        CupertinoPopoverMenuItem(
          child: SizedBox(
            child: Center(child: Text(S.of(context).share_pdf, textAlign: TextAlign.center, style: TextStyle(fontSize: 21),)),
            width: 80,
            height: 50,
          ),
          onTap: () => _onSharePressed(),)
      ],
    ),
  );

  Widget _buildFooterDeleteButton() => CupertinoPopoverButton(
    child: Icon(CupertinoIcons.delete, color: CupertinoColors.activeBlue, size: 32),
    popoverBuild: (context) => CupertinoPopoverMenuList(
      children: <Widget>[
        CupertinoPopoverMenuItem(
          child: SizedBox(
            child: Center(child: Text(S.of(context).dialog_delete, textAlign: TextAlign.center, style: TextStyle(color: CupertinoColors.destructiveRed, fontSize: 21),)),
            width: 80,
            height: 50,
          ),
          onTap: () => _onDeletePressed(),)
      ],
    ),
  );

  Widget _buildContentFooterAction() => RectGetter(
    key: _shareDialogPosGlobalKey,
    child: IntrinsicWidth(
      stepHeight: 32,
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        /// clone button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildFooterCloneButton(),
          ),
        ),

        /// share button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildFooterShareButton(),
          ),
        ),

        /// delete button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildFooterDeleteButton(),
          ),
        ),
      ],),
    ),
  );

  Widget _buildCompletedHint() =>
      Text(S.of(context).hint_completed_contracts, textAlign: TextAlign.center, style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 10),);

}
