import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:paperflavor/generated/i18n.dart';
import 'package:paperflavor/util/nav_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef ErrorCallback = void Function(String error);
typedef SuccessCallback = void Function();

abstract class PayWallInterface {

  Future<bool> checkIfPaid(pf, SuccessCallback cbs, ErrorCallback cbf);
  Future<List<ProductDetails>> getProductsForSale();
  void restore();

  void pay(ProductDetails productDetails, SuccessCallback cbs, ErrorCallback cbf);
  void initSubscriptionService();
  void endSubscriptionService();
}

/// this class contains features to check payment status and do payments
class PayWall implements PayWallInterface {
  StreamSubscription<List<PurchaseDetails>> _subscription;

  Map<String, ErrorCallback> _errorCallbacks = Map();
  Map<String, SuccessCallback> _successCallbacks = Map();

  static const PAY_ABO = "tinyr_abo";
  static PayWall _singleton = PayWall();

  final Set<String>_productIds = Platform.isAndroid
      ? {
    PayFeature.PAY_ABO_MONTH,
    PayFeature.PAY_ABO_YEAR,
    PayFeature.PAY_PDF_EXPORT,
    PayFeature.PAY_UNLIMITED_PEOPLE,
    PayFeature.PAY_UNLIMITED_CONTRACTS,
  }
      : {
    PayFeature.PAY_ABO_MONTH,
    PayFeature.PAY_ABO_YEAR,
    PayFeature.PAY_PDF_EXPORT,
    PayFeature.PAY_UNLIMITED_PEOPLE,
    PayFeature.PAY_UNLIMITED_CONTRACTS,
  };

  static PayWall getSingleton() {
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

  static String _getText(String pf, ctx) => pf.startsWith(PAY_ABO)
      ? S.of(ctx).dialog_pay_for_subscription
      : S.of(ctx).dialog_pay_for_subscription_or_feature;

  static Widget getSubscriptionDialog(pf, ctx) => CupertinoAlertDialog(
    title: Text(S.of(ctx).dialog_title_pro_feature),
    content: Text(_getText(pf, ctx)),
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

  initSubscriptionService() async {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
  }

  endSubscriptionService() async {
    _subscription.cancel();
  }

  _handlePurchaseUpdates(List<PurchaseDetails> purchases) {

    for(PurchaseDetails purchase in purchases) {
      if (Platform.isIOS) {
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }

      if ( purchase.status == PurchaseStatus.purchased ) {
        _successCallbacks[purchase.productID]();
        _savePurchaseInPrefs(purchase.productID, true);
        _successCallbacks.remove(purchase.productID);
      }

      if( purchase.status == PurchaseStatus.error ) {
        _errorCallbacks[purchase.productID](purchase.error.message);
        _errorCallbacks.remove(purchase.productID);
      }

    }

  }

  _savePurchaseInPrefs(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(key, value);
  }

  /// check if user has payed for item or abo
  /// pf - string
  /// cbs - callback success
  /// cbf - callback failure
  Future<bool> checkIfPaid(pf, SuccessCallback cbs, ErrorCallback cbf) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasBoughtFeature = _nullMeansFalse(prefs.getBool("paywall_" + pf));
    bool hasSubscription =  _nullMeansFalse(prefs.getBool("paywall_subscription"));
    bool hasPaid = hasBoughtFeature || hasSubscription;

    // TODO: check that prefs is updated

    hasPaid ? cbs() : cbf('you shall not pass');

    return hasPaid;
  }

  bool _nullMeansFalse(bool) => bool == null ? false : bool;

  /// pay for feature
  /// cbs - callback success
  /// cbf - callback failure
  void pay(ProductDetails productDetails, SuccessCallback cbs, ErrorCallback cbf) async{
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    _errorCallbacks.putIfAbsent(productDetails.id, () => cbf);
    _successCallbacks.putIfAbsent(productDetails.id, () => cbs);

    InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<List<ProductDetailWrapper>> getWrappedProductsForSale() async {
    List<ProductDetails> productsForSale = await getProductsForSale();
    Map<String, ProductDetailWrapper> productsForSaleWrapped = Map();
    QueryPurchaseDetailsResponse queryPastPurchases = await _queryPastPurchases();

    productsForSale.forEach((pd) => productsForSaleWrapped.putIfAbsent(pd.id, () => ProductDetailWrapper(pd, false)));

    queryPastPurchases.pastPurchases.forEach((purchase) => productsForSaleWrapped[purchase.productID].purchased = true);

    return productsForSaleWrapped.values.toList();
  }

  Future<List<ProductDetails>> getProductsForSale() async {
    final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails(_productIds);
    if (response.notFoundIDs.isNotEmpty) {
      print("Following productIds not found in store: ");
      print(response.notFoundIDs);
    }
    List<ProductDetails> products = response.productDetails;

    return products;
  }

  Future<QueryPurchaseDetailsResponse> _queryPastPurchases() async {
    final QueryPurchaseDetailsResponse response = await InAppPurchaseConnection.instance.queryPastPurchases();
    if (response.error != null) {
      // Handle the error.
    }

    return response;
  }

  /// restore payments
  Future restore() async {
    final QueryPurchaseDetailsResponse response = await _queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      _verifyPurchase(purchase);  // Verify the purchase following the best practices for each storefront.
      _deliverPurchase(purchase); // Deliver the purchase to the user in your app.
      if (Platform.isIOS) {
        // Mark that you've delivered the purchase. Only the App Store requires
        // this final confirmation.
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
  }

  void _verifyPurchase(purchase) {

  }

  Future _deliverPurchase(PurchaseDetails purchase) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var productId;
    if (purchase.productID == PAY_ABO) {
      productId = "subscription";
    } else {
      productId = purchase.productID;
    }
    prefs.setBool("paywall_$productId", true);
  }

}

class ProductDetailWrapper {
  ProductDetails productDetail;
  bool purchased;

  ProductDetailWrapper(this.productDetail, this.purchased);
}

class PayFeature {
  static const PAY_ABO_MONTH = "tinyr_abo";
  static const PAY_ABO_YEAR = "tinyr_abo_year";
  static const PAY_PDF_EXPORT = "tinyr_pdf_export";
  static const PAY_UNLIMITED_PEOPLE = "tinyr_unlimited_people";
  static const PAY_UNLIMITED_CONTRACTS = "tinyr_unlimited_contracts";
  static const PAY_PDF_PRESET = "tinyr_pdf_presets";
}
