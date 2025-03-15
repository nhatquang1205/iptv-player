import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iptv_player/common/constants/constants.dart';
import 'package:iptv_player/common/constants/language_constants.dart';
import 'package:iptv_player/presentation/home/home_page.dart';
import 'package:iptv_player/presentation/language/language.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 1;
  bool isUseSecondAdUnit = false;
  String adUnitId = "ca-app-pub-1009785731919817/9736327161";

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) async {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd();
          } else if (!isUseSecondAdUnit) {
            isUseSecondAdUnit = true;
            adUnitId = "ca-app-pub-1009785731919817/3438248797";
            _createInterstitialAd();
          } else {
            var isExists = await isLocaleExists();
            Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                  builder: (context) => isExists
                      ? MyHomePage(title: 'IPTV Player HomePage')
                      : LanguageWidget()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) async {
        var isExists = await isLocaleExists();
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => isExists
                  ? MyHomePage(title: 'IPTV Player HomePage')
                  : LanguageWidget()),
          (route) => false,
        );
        ad.dispose();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            Color(0xFFFC5C7D),
            Color(0xFF6A82FB),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 90.0),
      child: Image.asset(
        Constants.icSplashLogo,
        fit: BoxFit.scaleDown,
      ),
    ));
  }
}
