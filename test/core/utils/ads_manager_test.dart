import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vehiclemanager/core/utils/ads/ads_manager.dart';
import 'package:vehiclemanager/core/utils/ads/banner_ad.dart';

void main() {
  testWidgets('ads are skipped on unsupported platforms', (tester) async {
    final previousPlatform = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;

    try {
      final adsManager = AdsManager();

      expect(adsManager.isPlatformSupported, isFalse);
      await adsManager.initAll();
      await adsManager.showRewardedAd(onRewarded: () {});
      await adsManager.showInterstitialAd();
      await tester.pumpWidget(const MaterialApp(home: BannerAdvert()));

      expect(tester.takeException(), isNull);
    } finally {
      debugDefaultTargetPlatformOverride = previousPlatform;
    }
  });

  testWidgets('pro users do not render a banner ad', (tester) async {
    final previousPlatform = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final adsManager = AdsManager();
    adsManager.setPro(true);

    try {
      await tester.pumpWidget(const MaterialApp(home: BannerAdvert()));
      expect(find.byType(AdWidget), findsNothing);
      expect(tester.takeException(), isNull);
    } finally {
      adsManager.setPro(false);
      debugDefaultTargetPlatformOverride = previousPlatform;
    }
  });
}
