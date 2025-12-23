import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/token_manager.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:benzinapp/views/login.dart';
import 'package:flutter/material.dart';
import '../services/data_holder.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/images/benzinapp_logo_round.png",
              width: 250,
              height: 250,
            ),

            const SizedBox(height: 15.0),

            const LinearProgressIndicator(
                value: null
            )
          ],
        ),
      )

    );
  }

  void _load() async {
    // this is too fast, and the BenzinApp logo might not appear.
    // honestly, suffering from success.
    // Delay the process of checking a token's validity (if there is any) by
    // one second.
    await Future.delayed(const Duration(seconds: 1));

    // it's best that the token manager is initialized in the very start
    // of the application.
    await TokenManager.initialize();

    // once it's initialized, check if there is a token.
    if (TokenManager().isTokenPresent) {
      // also check its validity.
      _attemptLogin();
    }
    // if there is no token, it means that the user will be navigated
    // straight to the login page.
    else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage()
          ));
    }
  }

  void _attemptLogin() async {
    final result = await SessionManager().testConnection();

    if (result) {
      await DataHolder().initializeValues();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const Dashboard()
          ));
    }
    else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LoginPage(message: translate('sessionEnded')),
          )
      );
    }
  }
}