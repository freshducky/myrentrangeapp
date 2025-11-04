import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ad_service.dart';

/// Banner ad widget for iOS
/// Auto-hides when ads are removed via IAP
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _adsRemoved = false;

  @override
  void initState() {
    super.initState();
    _checkAdStatus();
  }

  Future<void> _checkAdStatus() async {
    final removed = await AdService.areAdsRemoved();
    if (mounted) {
      setState(() {
        _adsRemoved = removed;
      });
      
      if (!removed && Platform.isIOS) {
        _loadAd();
      }
    }
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdService.getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          // Ad failed to load - hide widget
          ad.dispose();
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
            });
          }
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show ad if removed or not loaded
    if (_adsRemoved || !_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    // Only show on iOS for now
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}

