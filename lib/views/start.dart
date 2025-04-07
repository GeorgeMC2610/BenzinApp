import 'package:benzinapp/services/request_handler.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/home.dart';
import 'package:benzinapp/views/login.dart';
import 'package:http/http.dart' as http;
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

  void _load() {
    // this is too fast, and the BenzinApp logo might not appear.
    // honestly, suffering from success.
    // Delay the process of checking a token's validity (if there is any) by
    // one second.
    Future.delayed(const Duration(seconds: 1),
        () {
          // it's best that the token manager is initialized in the very start
          // of the application.
          TokenManager.initialize().then((value) {
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
          });
        }
    );
  }

  void _attemptLogin() async {
    // an attempt to login is to test the validity of the token using the car
    // url. If the url responds with 200, then the token is still valid.
    var uri = '${DataHolder.destination}/car';

    RequestHandler.sendGetRequest(uri, () {}, (response) {
      switch (response.statusCode) {
        // this is the case, where the token is invalid, in such case
        // the login page will be shown
        case 422:
          // show a message to the user that their session has ended.
          // navigate the user to the login page.
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoginPage(message: 'Your session has ended. Please log in again.'), // TODO: Localize
              )
          );

          break;
        case 200:
          // response 200 means that the token is still valid.
          // navigate the user to the home page.
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage()
              ));
          // make sure that the values are initialized
          DataHolder().initializeValues();
      }
    });
  }
}