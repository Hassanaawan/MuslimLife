import 'package:Muslimlife/utils/initial_binder.dart';
import 'package:Muslimlife/viewmodel/app_localization_controller.dart';
import 'package:Muslimlife/views/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/localization/app_constants.dart';
import 'constants/localization/messages.dart';
import 'constants/theme_manager.dart';


class MuslimLife extends StatelessWidget {
  const MuslimLife({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;

  @override
  Widget build(BuildContext context) {
    /// Lock the orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<AppLocalizationController>(
          builder: (localizationController) {
            return GetMaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'USA'),
                Locale('ar', 'SA'),
              ],
              debugShowCheckedModeBanner: false,
              title: 'Muslim Life',
              theme: ThemeManager.getAppTheme(),
              locale: localizationController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
              initialBinding: InitialBinder(),
              home: const Splash(),
            );
          },
        );
      },
    );
  }
}
