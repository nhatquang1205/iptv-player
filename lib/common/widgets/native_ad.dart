import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatefulWidget {
  final String adUnitId;
  final String fallbackAdUnitId;

  NativeAdWidget({required this.adUnitId, required this.fallbackAdUnitId});

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  bool isUseSecondAdUnit = false;

  @override
  void initState() {
    super.initState();
    _loadAd(widget.adUnitId);
  }

  void _loadAd(String unitId) {
    _nativeAd = NativeAd(
      adUnitId: unitId, // Replace with your real AdMob native ad ID
      factoryId:
          'listTile', // 👈 This should match the factory ID in Android/iOS setup
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          if (!isUseSecondAdUnit) {
            isUseSecondAdUnit = true;
            _loadAd(widget.fallbackAdUnitId);
            return;
          }
          ad.dispose();
          print('Native ad failed to load: $error');
        },
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isAdLoaded
        ? SizedBox(
            height: 150, // Adjust height as needed
            child: AdWidget(ad: _nativeAd!),
          )
        : SizedBox.shrink();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
