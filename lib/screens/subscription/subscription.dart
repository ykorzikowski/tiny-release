
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/paywall.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:tiny_release/util/base_util.dart';

typedef Null ItemSelectedCallback(int value);

class SubscriptionListWidget extends StatefulWidget {

  @override
  _SubscriptionListWidgetState createState() => _SubscriptionListWidgetState();
}

class _SubscriptionListWidgetState extends State<SubscriptionListWidget> {

  _SubscriptionListWidgetState();

  PagewiseLoadController moduleController, subscriptionController;
  PayWall _payWall = PayWall();

  @override
  void initState() {
    super.initState();
    _payWall.initSubscriptionService(); // async is not allowed on initState() directly
  }

  @override
  void dispose() {
    _payWall.endSubscriptionService();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    moduleController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (pageIndex) =>
            _payWall.getItems()
    );

    subscriptionController = PagewiseLoadController(
        pageSize: 10,
        pageFuture: (pageIndex) =>
            _payWall.getSubscriptions()
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
  Widget _itemBuilder(ctx, wrapper, _) {
    VoidCallback onSubscription = () =>
      _payWall.pay(wrapper.iapItem.productId, () {
        _showSubscriptionSuccessDialog(ctx);
      }, (error) {
        _showSubscriptionFailedDialog(ctx);
      });
    Widget priceTag = _buildPrice(wrapper.iapItem);

    if ( wrapper.purchased ) {
      onSubscription = null;
      priceTag = Icon(CupertinoIcons.check_mark_circled_solid, color: CupertinoColors.activeBlue);
    }

    return
      ExpandablePanel(
        header: ListTile(
          key: Key(wrapper.iapItem.productId),
          leading: _getIcon(wrapper.iapItem.productId),
          title: Text(wrapper.iapItem.title),
          trailing: CupertinoButton(child: priceTag, onPressed: onSubscription),
        ),
        expanded: _buildDescription(wrapper.iapItem),
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
      ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(S.of(context).payment_introduction_text, softWrap: true, ),
          ),

          Platform.isAndroid ? _getAndroidSubscriptionContent() : _getIosSubscriptionContent(),
        ],);

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

  Widget _buildPrice(IAPItem iap) {
    TextStyle normalPriceStyle = TextStyle();
    String normalPriceText = iap.price;
    String specialPrice;
    var widgets = List<Widget>();
    normalPriceText = iap.localizedPrice;

    if ( iap.introductoryPrice.isNotEmpty) {
      normalPriceStyle = TextStyle(decoration: TextDecoration.lineThrough);
      specialPrice = iap.introductoryPrice;
    }

    widgets.add(Text(normalPriceText, style: normalPriceStyle,),);
    if ( specialPrice != null ) {
      widgets.add(Text(specialPrice),);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        iap.subscriptionPeriodAndroid.isNotEmpty ? _subDurationWidget(iap.subscriptionPeriodAndroid) : Container(),
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


  Widget _buildDescription(IAPItem iap) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(iap.description, softWrap: true, style: TextStyle(color: CupertinoColors.inactiveGray)),
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