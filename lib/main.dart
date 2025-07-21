import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cookpal/database/shared_preferences.dart';
import 'package:cookpal/ui/home/screen/home_screen.dart';
import 'package:cookpal/ui/login/screen/login_screen.dart';
import 'package:cookpal/ui/onboarding/app_onboarding.dart';
import 'package:cookpal/utils/colors.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB5A1pSHVM_niHDL0N-_XJIYBN5az7z16Q",
      appId: "1:387257112747:android:30056c26c5bde72c64ffee",
      messagingSenderId: "387257112747",
      projectId: "cookpal-ec834",
      storageBucket: "cookpal-ec834.appspot.com",
    ),
  );
  await PreferenceUtils.init();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: primaryColor,
        appBarTheme: const AppBarTheme(backgroundColor: primaryColor),
        drawerTheme: const DrawerThemeData(backgroundColor: primaryColor),
      ),
      dark: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => ScreenUtilInit(
        designSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: theme,
          darkTheme: darkTheme,
          home: homeScreen(),
        ),
      ),
    );
  }

  Widget homeScreen() {
    if (PreferenceUtils.getBool(PrefKeys.isLoggedIn)) {
      return const HomeScreen();
    } else {
      if (PreferenceUtils.getBool(PrefKeys.onBoarding)) {
        return const LoginScreen();
      } else {
        return const AppOnBoarding();
      }
    }
  }
}
