import 'dart:async';

import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/language_provider.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/trip_manager.dart';
import 'package:benzinapp/services/theme_provider.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/start.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() {
  runZonedGuarded(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ChangeNotifierProvider(create: (context) => FuelFillRecordManager()),
          ChangeNotifierProvider(create: (context) => MalfunctionManager()),
          ChangeNotifierProvider(create: (context) => ServiceManager()),
          ChangeNotifierProvider(create: (context) => TripManager()),
          ChangeNotifierProvider(create: (context) => CarManager()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: const MainApp(),
      ),
    );
  }, (error, stackTrace) {
    switch (error.runtimeType) {
      case UnauthorizedException:
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage(message: 'Session ended!',)),
        );
        break;
    }

    print("ERROR IS: $error");
    print("STACK TRACE: $stackTrace");
  });


}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'BenzinApp',
      locale: languageProvider.currentLocale,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('el'), // Greek
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const Start(),
    );
  }

}