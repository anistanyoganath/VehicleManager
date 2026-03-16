import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:vehiclemanager/core/utils/ads/ads_manager.dart';
import 'package:vehiclemanager/data/local_db/hive_service.dart';

class IAPManager with ChangeNotifier {
  IAPManager._internal();
  static final IAPManager _instance = IAPManager._internal();
  factory IAPManager() => _instance;

  static const String productIdPro = 'vehicle_manager_pro';
  static const String _settingsKeyIsPro = 'isPro';

  final InAppPurchase _iap = InAppPurchase.instance;
  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isAvailable = false;
  bool _isLoading = false;
  bool _isPro = false;
  ProductDetails? _product;
  String _statusMessage = '';

  bool get isAvailable => _isAvailable;
  bool get isLoading => _isLoading;
  bool get isPro => _isPro;
  ProductDetails? get product => _product;
  String get statusMessage => _statusMessage;

  Future<void> init() async {
    _isAvailable = await _iap.isAvailable();
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) {
        _statusMessage = 'Purchase stream error: $error';
        notifyListeners();
      },
    );

    await _loadProStatus();

    if (_isAvailable) {
      final response = await _iap.queryProductDetails({productIdPro});
      if (response.notFoundIDs.isNotEmpty) {
        _statusMessage = 'Product ID not found in store';
      } else {
        _product = response.productDetails.firstWhere(
          (p) => p.id == productIdPro,
          orElse: () => throw StateError('Pro product missing'),
        );
      }
      notifyListeners();
    } else {
      _statusMessage = 'IAP not available on this device';
      notifyListeners();
    }
  }

  Future<void> _loadProStatus() async {
    final box = Hive.box(HiveService.settingsBox);
    _isPro = box.get(_settingsKeyIsPro, defaultValue: false) as bool;
    AdsManager().setPro(_isPro);
    notifyListeners();
  }

  Future<void> _saveProStatus(bool value) async {
    final box = Hive.box(HiveService.settingsBox);
    await box.put(_settingsKeyIsPro, value);
    _isPro = value;
    AdsManager().setPro(value);
    notifyListeners();
  }

  Future<void> buyPro() async {
    if (!_isAvailable || _product == null) {
      _statusMessage = 'Store unavailable or product not loaded';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    final purchaseParam = PurchaseParam(productDetails: _product!);

    final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

    if (!success) {
      _statusMessage = 'Purchase request failed';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.productID != productIdPro) continue;

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          _statusMessage = 'Purchase pending...';
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyPurchase(purchaseDetails);
          break;
        case PurchaseStatus.error:
          _statusMessage =
              'Purchase error: ${purchaseDetails.error?.message ?? 'unknown'}';
          break;
        case PurchaseStatus.canceled:
          _statusMessage = 'Purchase canceled';
          break;
        default:
          break;
      }
    }
    notifyListeners();
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // TODO: Add real server-side purchase verification if required.
    await _iap.completePurchase(purchaseDetails);
    await _saveProStatus(true);
    _statusMessage = 'Thanks for upgrading to Vehicle Manager Pro!';
    _isLoading = false;
    notifyListeners();
  }

  void disposeManager() {
    _subscription.cancel();
  }
}
