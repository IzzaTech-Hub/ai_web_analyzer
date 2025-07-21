import 'package:ai_web_analyzer/app/fire_base/fire_base.dart';
import 'package:ai_web_analyzer/app/fire_base/remoteconfig_services.dart';
import 'package:ai_web_analyzer/app/providers/admob_ads_provider.dart';
import 'package:ai_web_analyzer/app/routes/app_pages.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyFireBaseHandle.initialize();
  await RemoteConfigService().initialize();
AdMobAdsProvider.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
