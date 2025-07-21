import 'package:ai_web_analyzer/app/utills/appstring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_web_analyzer/app/routes/ad_navigator.dart';

class AdMobAdsProvider {
  AdMobAdsProvider._privateConstructor();

  static final AdMobAdsProvider instance =
      AdMobAdsProvider._privateConstructor();

  InterstitialAd? _interstitialAd;

  int _numInterstitialLoadAttempts = 0;

  // AppOpenAd? appOpenAd;[j.]
  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  // RewardedInterstitialAd? _rewardedInterstitialAdGame;
  // int _numRewardedInterstitialLoadAttemptsGame = 0;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  RxBool isAdEnable = true.obs;

  String get interstitialAdUnitId => 'your_interstitial_ad_unit_id_here';
  int maxFailedLoadAttempts = 3;
  int adShowDelay = 20;
  DateTime? _lastInterstitialShownTime;

  void initialize() {
    print("Admob Initialize call");
    // Initialize AdMob SDK
    RequestConfiguration(testDeviceIds: ["4B3877ACBC411B954D545151A96C676D"]);
    // Preload interstitial ad
    _lastInterstitialShownTime = DateTime.now().subtract(Duration(seconds: 50));
    _createInterstitialAd();
    createRewardedAd();
    // _createRewardedInterstitialAd();[j.]
    // _createRewardedInterstitialAdGame();
    // loadAdRewardedInter();
    // createGameRewardedAd();
    // appOpenLoad();[j.]
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AppStrings.ADMOB_INTERSTITIAL,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 1;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd(Function onRewardedAdWatched) {
    int adShowDelay = 20;

    // Calculate the time difference between the current time and the last shown time
    Duration timeSinceLastShown =
        DateTime.now().difference(_lastInterstitialShownTime ?? DateTime.now());

    // Check if the minimum adShowDelay time has passed since the last ad was shown
    if (timeSinceLastShown.inSeconds < adShowDelay) {
      int remainingTime = adShowDelay - timeSinceLastShown.inSeconds;
      print(
          'Showing interstitial ad is not allowed yet. Remaining time: $remainingTime seconds.');
      return;
    }

    if (_interstitialAd == null) {
      _createInterstitialAd();
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
        onRewardedAdWatched();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    _lastInterstitialShownTime = DateTime.now();
  }

//? ----------------------------------AppOPEN--------------------------------
  // late AppLifecycleReactor _appLifecycleReactor;
  // late AppOpenAdManager appOpenAdManager;
  // void appOpenLoad() {
  //   appOpenAdManager = AppOpenAdManager()..loadAppOpenAd();
  //   _appLifecycleReactor =
  //       AppLifecycleReactor(appOpenAdManager: appOpenAdManager);

  //   _appLifecycleReactor.listenToAppStateChanges();
  //   print("AppOpen Load from HomeCTL");
  // }

  // void showAppOpen() {
  //   appOpenAdManager.showAdIfAvailable();
  // }[j.]

//?-----------------------------------End App Open--------------------------

// Banner Implementation

  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

  initBanner() {
    BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        isBannerLoaded.value = true;
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) {
        print('Ad opened.');
      },
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        print('Ad closed.');
      },
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) {
        print('Ad impression.');
      },
    );

    BannerAd myBanner = BannerAd(
      adUnitId: AppStrings.ADMOB_BANNER,
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    );
    myBanner.load();
  }

  //? Native Ad Implementation
  NativeAd? _nativeAd;
  RxBool nativeAdIsLoaded = false.obs;

  initNative() {
    _nativeAd = NativeAd(
      adUnitId: AppStrings.ADMOB_NATIVE,
      request: AdRequest(),
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');

          nativeAdIsLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  //?Reward Inter Implementation

  /// Loads a rewarded ad.
  // void _createRewardedInterstitialAd() {
  //   RewardedInterstitialAd.load(
  //       adUnitId: AppStrings.ADMOB_REWARDED_Inter,
  //       request: AdRequest(),
  //       rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
  //         onAdLoaded: (RewardedInterstitialAd ad) {
  //           print('$ad loaded.');
  //           _rewardedInterstitialAd = ad;
  //           _numRewardedInterstitialLoadAttempts = 0;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('RewardedInterstitialAd failed to load: $error');
  //           _rewardedInterstitialAd = null;
  //           _numRewardedInterstitialLoadAttempts += 1;
  //           if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
  //             _createRewardedInterstitialAd();
  //           }
  //         },
  //       ));
  // }

  // bool isRewardedInterAdLoaded() {
  //   if (_rewardedInterstitialAd == null) {
  //     print('Warning: attempt to show rewarded interstitial before loaded.');
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  // showRewardedInter(Function onRewardedFun) {
  //   print("Show Rewarded Called");

  //   if (_rewardedInterstitialAd == null) {
  //     print('Warning: attempt to show rewarded interstitial before loaded.');
  //     return;
  //   }
  //   _rewardedInterstitialAd!.fullScreenContentCallback =
  //       FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
  //         print('$ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       // _createRewardedInterstitialAd();[j.]
  //     },
  //     onAdFailedToShowFullScreenContent:
  //         (RewardedInterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       // _createRewardedInterstitialAd();[j.]
  //     },
  //   );

  //   _rewardedInterstitialAd!.setImmersiveMode(true);

  //   _rewardedInterstitialAd?.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
  //     onRewardedFun();
  //     // Reward the user for watching an ad.
  //   });
  // }

  showRewardedInterGame(Function onReward) {
    print("Show Rewarded Called");

    if (_rewardedInterstitialAd == null) {
      print('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('$ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        // _createRewardedInterstitialAd();[j.]
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        // _createRewardedInterstitialAd();[j.]
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);

    _rewardedInterstitialAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) async {
      onReward();
      // Reward the user for watching an ad.
    });
  }

  //? Rewarded Ad Implementation
  void createRewardedAd() {
    print("Reward Ad Load Called");
    if (_rewardedAd == null) {
      print("Reward Ad was Null");

      RewardedAd.load(
          adUnitId: AppStrings.ADMOB_REWARDED,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              print('$ad loaded. Reward Ad');
              _rewardedAd = ad;
              _numRewardedLoadAttempts = 0;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
              _rewardedAd = null;
              _numRewardedLoadAttempts += 1;
              if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
                createRewardedAd();
              }
            },
          ));
    }
  }

  bool isRewardedAdLoaded() {
    if (_rewardedAd == null) {
      return false;
    } else {
      return true;
    }
  }

  ShowRewardedAd(Function onReward) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');

      Get.back();
      EasyLoading.showError("No Ad Available try again later",
          duration: Duration(seconds: 2));
      showNoAdAvailableDialog();

      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _rewardedAd = null;

        // createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _rewardedAd = null;

        ad.dispose();
        // createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
      onReward();
    });
  }

  void showNoAdAvailableDialog() {
    Get.defaultDialog(
      title: "No Ad available",
      content: Text("Please try again later."),
      confirm: ElevatedButton(
        onPressed: () => AdNavigator.back(),
        child: Text("OK"),
      ),
    );
  }
}
