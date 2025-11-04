import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing ads and ad removal status
class AdService {
  static const String _adRemovedKey = 'ads_removed';
  static bool _isInitialized = false;
  
  // TODO: Replace with actual Ad Unit ID from AdMob console
  // iOS Banner Ad Unit ID (for testing, use test ID)
  static const String _iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  
  /// Initialize Google Mobile Ads (iOS only, platform-safe)
  static Future<void> initialize() async {
    // Only initialize on iOS, not on web or other platforms
    if (kIsWeb || !Platform.isIOS) {
      return; // Skip initialization on non-iOS platforms
    }
    
    // Prevent double initialization
    if (_isInitialized) {
      return;
    }
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (e) {
      // Fail silently - app should continue without ads
      debugPrint('MobileAds initialization error: $e');
    }
  }
  
  /// Check if ads are removed
  static Future<bool> areAdsRemoved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_adRemovedKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Set ads as removed (called after successful IAP purchase)
  static Future<void> setAdsRemoved(bool removed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_adRemovedKey, removed);
    } catch (e) {
      // Fail silently
    }
  }
  
  /// Get banner ad unit ID for current platform
  static String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return _iosBannerAdUnitId;
    }
    // Android support can be added later
    return _iosBannerAdUnitId; // Fallback to iOS test ID
  }
}

