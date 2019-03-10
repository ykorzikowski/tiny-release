import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiny_release/util/NavRoutes.dart';

typedef ErrorCallback = void Function(String error);
typedef SuccessCallback = void Function();


/// this class contains features to check payment status and do payments
class PayWall {

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

  static String getText(String pf) => pf.startsWith(PayFeature.PAY_ABO_MONTH)
      ? "To use this feature, you have to pay for a monthly subscription"
      : "To use this feature, you can buy the feature $pf or pay for a monthly subscription";

  static Widget getPaymentDialog(pf, ctx) => CupertinoAlertDialog(
    title: Text("Pro Feature"),
    content: Text(getText(pf)),
    actions: <Widget>[
      CupertinoDialogAction(child: Text("OK"), onPressed: () {
        Navigator.of(ctx).pushNamed(NavRoutes.PAYMENT);
      },),
      CupertinoDialogAction(child: Text("No thanks"),
      onPressed: () {
        Navigator.of(ctx).pop();
      },)
    ],
  );

  final List<String>_productLists = Platform.isAndroid
      ? [
        'android.test.purchased',
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

  initPaymentService() async {
    await FlutterInappPurchase.initConnection;
  }

  endPaymentService() async {
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
  void pay(pf, SuccessCallback cbs, ErrorCallback cbf) async{
    await initPaymentService();
    bool hasAlreadyPaid = await checkIfPaid(pf, (){}, (error){});

    if ( hasAlreadyPaid ) {
      return;
    }

    try {
      PurchasedItem purchased = await FlutterInappPurchase.buyProduct(pf);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(pf, true);
      print(purchased.toString());
    } catch(error) {
      cbf(error.toString());
    } finally {
      await endPaymentService();
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