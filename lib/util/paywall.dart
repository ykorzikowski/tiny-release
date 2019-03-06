import 'dart:io';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// this class contains features to check payment status and do payments
class PayWall {

  final List<String>_productLists = Platform.isAndroid
      ? [
        'android.test.purchased',
        PayFeature.PAY_ABO,
        PayFeature.PAY_PDF_EXPORT,
        'android.test.canceled',
        ]
      : [PayFeature.PAY_ABO, PayFeature.PAY_PDF_EXPORT];

  _initPaymentService() async {
    await FlutterInappPurchase.initConnection;
  }

  _endPaymentService() async {
    await FlutterInappPurchase.endConnection;
  }

  /// check if user has payed for item or abo
  /// pf - string
  /// cbs - callback success
  /// cbf - callback failure
  Future<bool> checkIfPaid(pf, cbs, cbf) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAlreadyPaid = prefs.getBool(pf);
    bool hasAbo = prefs.getBool(PayFeature.PAY_ABO);

    hasAlreadyPaid || hasAbo ? cbs() : cbf();

    return hasAlreadyPaid || hasAbo;
  }

  /// pay for feature
  /// cbs - callback success
  /// cbf - callback failure
  void pay(pf, cbs, cbf) async{
    await _initPaymentService();
    bool hasAlreadyPaid = await checkIfPaid(pf, (){}, (){});

    if ( hasAlreadyPaid ) {
      return;
    }

    try {
      PurchasedItem purchased = await FlutterInappPurchase.buyProduct(pf);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(pf, true);
      print(purchased.toString());
    } catch(error) {
      cbf(error);
    } finally {
      await _endPaymentService();
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

  Future<List<String>> purchasedFeatures() async {
    var list = await getItems();
  }

  Future<List<IAPItem>> getItems () async {
    return FlutterInappPurchase.getProducts(_productLists);
  }

  /// restore payments
  void restore() {
    // todo restore
  }

}

class PayFeature {
  static const PAY_ABO = "abo";
  static const PAY_PDF_EXPORT = "pdf_export";
}