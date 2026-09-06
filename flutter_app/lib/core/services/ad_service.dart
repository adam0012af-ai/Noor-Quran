import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static const testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  BannerAd createBanner({required void Function() onLoaded}) {
    return BannerAd(
      adUnitId: testBannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) => onLoaded()),
    )..load();
  }

  void showRewarded({required void Function() onReward}) {
    RewardedAd.load(
      adUnitId: testRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show(onUserEarnedReward: (_, __) => onReward());
        },
        onAdFailedToLoad: (_) {},
      ),
    );
  }
}
