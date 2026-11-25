import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vehiclemanager/core/utils/ads/ad_ids.dart';
import 'package:vehiclemanager/core/utils/ads/request_ads.dart';

class AdsManager {
  static final AdsManager _instance = AdsManager._internal();
  factory AdsManager() => _instance;
  AdsManager._internal();

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;

  bool _isRewardLoading = false;
  bool _isInterstitialLoading = false;

  bool _isPro = false;

  void setPro(bool value) {
    _isPro = value;
    if (_isPro) {
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _interstitialAd?.dispose();
      _interstitialAd = null;
    }
  }

  bool get isPro => _isPro;
  bool get isPlatformSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> initAll() async {
    loadRewardedAd();
    loadInterstitialAd();
  }

  // ---------------- Rewarded ----------------
  Future<void> loadRewardedAd() async {
    if (!isPlatformSupported ||
        _isPro ||
        _isRewardLoading ||
        _rewardedAd != null) {
      return;
    }
    _isRewardLoading = true;

    await RewardedAd.load(
      adUnitId: AdIds.rewardedAdId,
      request: requestAd(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isRewardLoading = false;
          if (_isPro) {
            ad.dispose();
          } else {
            _rewardedAd = ad;
            if (kDebugMode) print('Rewarded Ad loaded');
          }
        },
        onAdFailedToLoad: (error) {
          _isRewardLoading = false;
          _rewardedAd = null;
          if (kDebugMode) print('Rewarded Ad failed: $error');
        },
      ),
    );
  }

  Future<void> showRewardedAd({
    required Function onRewarded,
    Function? onAdClosed,
  }) async {
    if (!isPlatformSupported || _isPro) return;

    if (_rewardedAd == null) {
      await loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        onAdClosed?.call();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (_, _) => onRewarded());
    _rewardedAd = null;
  }

  // ---------------- Interstitial ----------------
  Future<void> loadInterstitialAd() async {
    if (!isPlatformSupported ||
        _isPro ||
        _isInterstitialLoading ||
        _interstitialAd != null) {
      return;
    }
    _isInterstitialLoading = true;

    await InterstitialAd.load(
      adUnitId: AdIds.interstitialAdId,
      request: requestAd(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isInterstitialLoading = false;
          if (_isPro) {
            ad.dispose();
          } else {
            _interstitialAd = ad;
          }
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          _interstitialAd = null;
          if (kDebugMode) print('Interstitial failed: $error');
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (!isPlatformSupported || _isPro) return;

    if (_interstitialAd == null) {
      await loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
