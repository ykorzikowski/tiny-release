import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:tiny_release/generated/i18n.dart';
import 'package:tiny_release/util/nav_routes.dart';

typedef ErrorCallback = void Function(String error);
typedef SuccessCallback = void Function();


/// this class contains features to check payment status and do payments
class PayWall {
  static const PAY_ABO = "tinyr_abo";
  static PayWall _singleton = PayWall();

  static PayWall getShared() {
    return _singleton;
  }

  static String subscriptionDurationInMonths(str) {
    switch(str) {
      case 'P1Y':
        return '12';
      case 'P1M':
        return '1';
    }
    return null;
  }

  static String getText(String pf, ctx) => pf.startsWith(PAY_ABO)
      ? S.of(ctx).dialog_pay_for_subscription
      : S.of(ctx).dialog_pay_for_subscription_or_feature;

  static Widget getSubscriptionDialog(pf, ctx) => CupertinoAlertDialog(
    title: Text(S.of(ctx).dialog_title_pro_feature),
    content: Text(getText(pf, ctx)),
    actions: <Widget>[
      CupertinoDialogAction(child: Text(S.of(ctx).ok), onPressed: () {
        Navigator.of(ctx).pushNamed(NavRoutes.PAYMENT);
      },),
      CupertinoDialogAction(child: Text(S.of(ctx).no_thanks),
      onPressed: () {
        Navigator.of(ctx).pop();
      },)
    ],
  );

  final List<String>_productLists = Platform.isAndroid
      ? [
        PayFeature.PAY_ABO_MONTH,
        PayFeature.PAY_ABO_YEAR,
        PayFeature.PAY_PDF_EXPORT,
        PayFeature.PAY_UNLIMITED_PEOPLE,
        PayFeature.PAY_UNLIMITED_CONTRACTS,
        ]
      : [
        PayFeature.PAY_ABO_MONTH,
        PayFeature.PAY_ABO_YEAR,
        PayFeature.PAY_PDF_EXPORT,
        PayFeature.PAY_UNLIMITED_PEOPLE,
        PayFeature.PAY_UNLIMITED_CONTRACTS,
  ];

  initSubscriptionService() async {
    await FlutterInappPurchase.initConnection;
  }

  endSubscriptionService() async {
    await FlutterInappPurchase.endConnection;
  }

  /// check if user has payed for item or abo
  /// pf - string
  /// cbs - callback success
  /// cbf - callback failure
  Future<bool> checkIfPaid(pf, SuccessCallback cbs, ErrorCallback cbf) async {
    bool hasAlreadyPaid = await FlutterInappPurchase.checkSubscribed(sku: pf) ?? false;
    bool hasAbo = await FlutterInappPurchase.checkSubscribed(sku: PayFeature.PAY_ABO_MONTH) ?? false || await FlutterInappPurchase.checkSubscribed(sku: PayFeature.PAY_ABO_YEAR) ?? false;

    hasAlreadyPaid || hasAbo ? cbs() : cbf('you shall not pass');

    return hasAlreadyPaid || hasAbo;
  }

  /// pay for feature
  /// cbs - callback success
  /// cbf - callback failure
  void pay(String pf, SuccessCallback cbs, ErrorCallback cbf) async{
    await initSubscriptionService();

    print('Prepare for purchasing $pf');

    try {
      PurchasedItem purchased;
      if ( pf.startsWith(PAY_ABO) ) {
        purchased = await FlutterInappPurchase.buySubscription(pf);
      } else {
        purchased = await FlutterInappPurchase.buyProduct(pf);
      }

      print(purchased.toString());
    } catch(error) {
      cbf(error.toString());
    } finally {
      await endSubscriptionService();
    }
  }

  IAPItem getItemForFeature(pf, List<IAPItem> items) {
    for (var value in items) {
      if ( value.productId == pf) {
        return value;
      }
    }
    return null;
  }

  Future<List<IAPItemWrapper>> getItems () async {
    List<IAPItem> subscriptions = await FlutterInappPurchase.getProducts(_productLists);


    var returnList = List<IAPItemWrapper>();
    for ( var iap in subscriptions ) {
      var bool = await checkIfPaid(iap.productId, (){}, (error){});
      returnList.add(IAPItemWrapper(iap, bool));
    }

    return returnList;
  }

  Future<List<IAPItemWrapper>> getSubscriptions () async {
    List<IAPItem> subscriptions = await FlutterInappPurchase.getSubscriptions(_productLists);

    var returnList = List<IAPItemWrapper>();
    for ( var iap in subscriptions ) {
      var bool = await checkIfPaid(iap.productId, (){}, (error){});
      returnList.add(IAPItemWrapper(iap, bool));
    }

    return returnList;
  }

  /// restore payments
  void restore() {
    // todo restore
  }

}

class IAPItemWrapper {
  IAPItem iapItem;
  bool purchased;

  IAPItemWrapper(this.iapItem, this.purchased);
}

class PayFeature {
  static const PAY_ABO_MONTH = "tinyr_abo";
  static const PAY_ABO_YEAR = "tinyr_abo_year";
  static const PAY_PDF_EXPORT = "tinyr_pdf_export";
  static const PAY_UNLIMITED_PEOPLE = "tinyr_unlimited_people";
  static const PAY_UNLIMITED_CONTRACTS = "tinyr_unlimited_contracts";
  static const PAY_PDF_PRESET = "tinyr_pdf_presets";
}