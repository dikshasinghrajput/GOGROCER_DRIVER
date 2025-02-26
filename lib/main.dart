import 'dart:io';
import 'package:driver/Auth/Login/sign_in.dart';
import 'package:driver/Locale/locales.dart';
import 'package:driver/Pages/home_page.dart';
import 'package:driver/Routes/routes.dart';
import 'package:driver/Theme/colors.dart';
import 'package:driver/Theme/style.dart';
// import 'package:driver/firebase_options.dart';
import 'package:driver/language_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'networking/my_http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform
      );
    AwesomeNotifications().initialize('resource://drawable/icon', [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'GoGrocer Notification',
        channelDescription: 'Incoming Order Delivery Request Notification',
        defaultColor: kMainColor,
        ledColor: kWhiteColor,
        importance: NotificationImportance.High,
      )
    ]).then((value) {
      debugPrint('FIRE - $value');
    });
  } catch (e) {
    debugPrint('FIRE - $e');
  }
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? result;
  if (prefs.containsKey('islogin')) {
    result = prefs.getBool('islogin');
  } else {
    result = false;
  }
  runApp(Phoenix(child: (result != null && result) ? const DeliveryBoyHome() : const DeliveryBoyLogin()));
}

class DeliveryBoyLogin extends StatelessWidget {
  const DeliveryBoyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('pt'),
              Locale('fr'),
              Locale('id'),
              Locale('es'),
            ],
            locale: locale,
            theme: ThemeUtils.defaultAppThemeData,
            darkTheme: ThemeUtils.darkAppThemData,
            home: const SignIn(),
            routes: PageRoutes().routes(),
          );
        },
      ),
    );
  }
}

class DeliveryBoyHome extends StatelessWidget {
  const DeliveryBoyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return MaterialApp(
            title: "GoGrocer",
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('pt'),
              Locale('fr'),
              Locale('id'),
              Locale('es'),
            ],
            locale: locale,
            theme: ThemeUtils.defaultAppThemeData,
            darkTheme: ThemeUtils.darkAppThemData,
            home: const HomePage(),
            routes: PageRoutes().routes(),
          );
        },
      ),
    );
  }
}
