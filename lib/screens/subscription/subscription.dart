
import 'dart:async';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/paywall.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:paperflavor/util/base_util.dart';

typedef Null ItemSelectedCallback(int value);

class SubscriptionListWidget extends StatefulWidget {

  @override
  _SubscriptionListWidgetState createState() => _SubscriptionListWidgetState();
}

class _SubscriptionListWidgetState extends State<SubscriptionListWidget> {

  _SubscriptionListWidgetState();

  PagewiseLoadController moduleController, subscriptionController;
  final PayWall _payWall = PayWall.getSingleton();

  @override
  void initState() {
    _payWall.initSubscriptionService(); // async is not allowed on initState() directly
    super.initState();
  }

  @override
  void dispose() {
    _payWall.endSubscriptionService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var productsForSale = _payWall.getProductsForSale();

    moduleController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (pageIndex) => productsForSale
    );

    subscriptionController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (pageIndex) => productsForSale
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: 'control',
        transitionBetweenRoutes: false,
        leading: BaseUtil.isLargeScreen(context) ? Container() : null,
        middle: Text(S.of(context).payment_title),
      ),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: _getSubscriptionContent()
      ),),
    );
  }

  // build subscription items
  Widget _itemBuilder(ctx, productDetailWrapper, _) {
    VoidCallback onSubscription = () =>
      _payWall.pay(productDetailWrapper.productDetail, () {
        _showSubscriptionSuccessDialog(ctx);
      }, (error) {
        _showSubscriptionFailedDialog(ctx);
      });
    Widget priceTag = _buildPrice(productDetailWrapper.productDetail);

    if ( productDetailWrapper.purchased ) {
      onSubscription = null;
      priceTag = Icon(CupertinoIcons.check_mark_circled_solid, color: CupertinoColors.activeBlue);
    }

    return
      ExpandablePanel(
        header: ListTile(
          key: Key(productDetailWrapper.productDetail.id),
          leading: _getIcon(productDetailWrapper.productDetail.id),
          title: Text(productDetailWrapper.productDetail.title),
          trailing: CupertinoButton(padding: EdgeInsets.all(13), child: priceTag, onPressed: onSubscription),
        ),
        expanded: _buildDescription(productDetailWrapper.productDetail),
      );
  }

  /// sections

  Widget _getIosSubscriptionContent() =>
      Column(
        children: <Widget>[
          Divider(),
          Text(S.of(context).plans, style: _headerStyle(),),
          _buildSubscriptionList(),
        ],
      );

  Widget _getAndroidSubscriptionContent() =>
      Column(
        children: <Widget>[
          Divider(),
          Text(S.of(context).subscriptions, style: _headerStyle(),),
          _buildSubscriptionList(),

          Divider(),
          Text(S.of(context).modules, style: _headerStyle(),),
          _buildModuleList(),
        ],
      );

  Widget _getSubscriptionContent() =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(S.of(context).payment_introduction_text, softWrap: true,),
            ),

            Platform.isAndroid
                ? _getAndroidSubscriptionContent()
                : _getIosSubscriptionContent(),
          ],),
      );

  /// build lists

  /// used on android, android differs on subs and normal ip purchases
  Widget _buildSubscriptionList() =>
      PagewiseListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        showRetry: false,
        padding: EdgeInsets.only(top: 10.0),
        itemBuilder: this._itemBuilder,
        pageLoadController: this.subscriptionController,
        noItemsFoundBuilder: (context) {
          return Text(S.of(context).error_subscriptions,
              style: TextStyle(color: CupertinoColors.inactiveGray));
        },
      );

  Widget _buildModuleList() =>
      PagewiseListView(
        physics: const NeverScrollableScrollPhysics(),
        showRetry: false,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10.0),
        itemBuilder: this._itemBuilder,
        pageLoadController: this.moduleController,
        noItemsFoundBuilder: (context) {
          return Text(S.of(context).error_subscriptions,
              style: TextStyle(color: CupertinoColors.inactiveGray));
        },
      );

  /// single subscription widgets

  _headerStyle() => TextStyle( fontSize: 24);

  String _getSpecialPrice(ProductDetails productDetail) {
    return Platform.isAndroid ? productDetail.skuDetail.introductoryPrice : productDetail.skProduct.introductoryPrice.priceLocale;
  }

  String _getSubscriptionPeriod(ProductDetails productDetails) {
    return Platform.isAndroid ? productDetails.skuDetail.subscriptionPeriod : productDetails.skProduct.subscriptionPeriod.numberOfUnits;
  }

  Widget _buildPrice(ProductDetails productDetail) {
    TextStyle normalPriceStyle = TextStyle();
    String normalPriceText = productDetail.price;
    String specialPrice =  _getSpecialPrice(productDetail);
    var widgets = List<Widget>();

    if ( specialPrice.isNotEmpty) {
      normalPriceStyle = TextStyle(decoration: TextDecoration.lineThrough);
    }

    widgets.add(Text(normalPriceText, style: normalPriceStyle,),);
    if ( specialPrice != null ) {
      widgets.add(Text(specialPrice),);
    }

    String subscriptionPeriod = _getSubscriptionPeriod(productDetail);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        subscriptionPeriod.isNotEmpty ? _subDurationWidget(subscriptionPeriod) : Container(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,),
      ],
    );
  }

  Icon _getIcon(String pf) => pf.startsWith(PayFeature.PAY_ABO_MONTH) ? Icon(Icons.stars, color: Colors.amber,) : Icon(Icons.local_offer);

  Widget _subDurationWidget(subscriptionLength) =>
      Padding(
          padding: EdgeInsets.all(8),
          child:
          Column(
            children: <Widget>[
              Icon(Icons.calendar_today, color: CupertinoColors.activeBlue,
                size: 18,),
              Text(PayWall.subscriptionDurationInMonths(subscriptionLength)),
            ],
          )
      );


  Widget _buildDescription(ProductDetails productDetails) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(productDetails.description, softWrap: true, style: TextStyle(color: CupertinoColors.inactiveGray)),
        ],);

  /// dialog confirmations

  _showSubscriptionFailedDialog(ctx) =>
      showDialog(context: ctx, builder: (ctx) =>
          CupertinoAlertDialog(
            title: Text(S.of(context).payment_was_not_successfull),
            content: Text(S.of(context).try_again_or_write_me_an_email),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ));

  _showSubscriptionSuccessDialog(ctx) =>
      showDialog(context: ctx, builder: (ctx) =>
          CupertinoAlertDialog(
            title: Text(S.of(context).payment_was_successfull),
            content: Text(S.of(context).thanks_for_supporting_me),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(S.of(context).select_date_ok),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ));
}
