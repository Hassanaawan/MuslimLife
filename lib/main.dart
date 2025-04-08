import 'package:Muslimlife/services/notification_service.dart';
import 'package:Muslimlife/viewmodel/Providers/location_data_provider.dart';
import 'package:Muslimlife/viewmodel/providers/hadith_provider.dart';
import 'package:Muslimlife/viewmodel/providers/link_data_provider.dart';
import 'package:Muslimlife/viewmodel/providers/note_data_provider.dart';
import 'package:Muslimlife/viewmodel/providers/user_data_provider.dart';
import 'package:Muslimlife/viewmodel/providers/wallpaper_data_provider.dart';
import 'package:Muslimlife/viewmodel/providers/zikir_counter_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app.dart';
import 'constants/localization/dependency_inj.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices().initNotification();
  tz.initializeTimeZones();

  ///.env file define
  await dotenv.load(fileName: ".env");

  ///One Signal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(dotenv.env['oneSignalKey']!);
  OneSignal.Notifications.requestPermission(true).then((accepted) {
    print("Accepted permission: $accepted");
  });

  Map<String, Map<String, String>> _languages = await LanguageDependency.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserDataProvider()),
        ChangeNotifierProvider(create: (context) => NoteDataProvider()),
        ChangeNotifierProvider(create: (context) => LocationDataProvider()),
        ChangeNotifierProvider(create: (context) => ZikirCountProvider()),
        ChangeNotifierProvider(create: (context) => HadithProvider()),
        ChangeNotifierProvider(create: (context) => LinkDataProvider()),
        ChangeNotifierProvider(create: (context) => WallpaperDataProvider()),
      ],
      child: MuslimLife(languages: _languages),
    ),
  );
}
