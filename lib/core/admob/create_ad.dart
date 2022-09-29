import 'package:google_mobile_ads/google_mobile_ads.dart';

class CreateAd {
  static BannerAd bannerAd = BannerAd(
    adUnitId: "ca-app-pub-3940256099942544/6300978111",
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        // emit(state.copyWith(isLoadAd: true));
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    ),
    size: AdSize.banner,
  );
}
