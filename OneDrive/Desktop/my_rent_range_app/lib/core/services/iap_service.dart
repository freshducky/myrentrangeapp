import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ad_service.dart';

/// Service for managing In-App Purchases
class IAPService {
  static const String _removeAdsProductId = 'remove_ads';
  static const String _purchasedKey = 'iap_remove_ads_purchased';
  
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  
  /// Product details for "Remove Ads"
  static const Set<String> _productIds = {_removeAdsProductId};
  
  /// Initialize IAP service
  Future<void> initialize() async {
    // Listen to purchase updates
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        // Handle error
      },
    );
  }
  
  /// Dispose IAP service
  void dispose() {
    _subscription?.cancel();
  }
  
  /// Get available products
  Future<List<ProductDetails>> getProducts() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      return [];
    }
    
    final ProductDetailsResponse response = await _iap.queryProductDetails(_productIds);
    return response.productDetails;
  }
  
  /// Purchase "Remove Ads"
  Future<bool> purchaseRemoveAds(ProductDetails productDetails) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
      
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      return false;
    }
  }
  
  /// Restore previous purchases
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
  
  /// Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI if needed
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        // Verify purchase
        if (purchaseDetails.productID == _removeAdsProductId) {
          await AdService.setAdsRemoved(true);
          await _savePurchaseStatus(true);
        }
        
        // Complete the purchase
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }
  
  /// Save purchase status
  Future<void> _savePurchaseStatus(bool purchased) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_purchasedKey, purchased);
    } catch (e) {
      // Fail silently
    }
  }
  
  /// Check if Remove Ads was previously purchased
  Future<bool> hasPurchasedRemoveAds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_purchasedKey) ?? false;
    } catch (e) {
      return false;
    }
  }
}

