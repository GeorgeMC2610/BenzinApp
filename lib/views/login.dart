import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/home.dart';
import 'package:benzinapp/views/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.message});

  final String? message;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  bool isLoggingIn = false;

  Future<void> _onLoginResponse(http.Response response) async {
    switch (response.statusCode) {
      // wrong credentials are shown in the view
      case 401:
        setState(() {
          usernameError = 'Wrong Credentials.';
          passwordError = 'Wrong Credentials.';
        });
        break;
      // response code 200 means that the user is authorized and the
      // app can proceed.
      case 200:

        // show the message that the user is authorized successfully.
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('successfully logged in'), // TODO: Localize
            )
        );

        // save the token received by the server in the token manager.
        TokenManager().setToken(
            jsonDecode(response.body)['auth_token']
        ).whenComplete(() {
          // when the token is saved, initialize the values
          DataHolder().initializeValues();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const HomePage()
              ));

        });
        break;
    }
  }

  void sendLoginPayload() {

    setState(() {
      usernameError = usernameController.text.trim().isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      passwordError = passwordController.text.isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;
    });

    if (usernameError != null || passwordError != null) {
      return;
    }

    setState(() {
      isLoggingIn = true;
    });

    var url = '${DataHolder.destination}/auth/login';
    var body = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    // send the payload to the server and all the other things will be handled
    RequestHandler.sendPostRequest(url, false, body, () {
      setState(() {
        isLoggingIn = false;
      });
    }, _onLoginResponse);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.message!), // TODO: Localize
            )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.loginToBenzinApp),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterPage()
                )
            );

          }, icon: const Icon(Icons.app_registration)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.key_off)),

        ],
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isLoggingIn? null : sendLoginPayload,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: Text(
                AppLocalizations.of(context)!.login,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black
                ),
              ),
              icon: isLoggingIn? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  value: null,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.square,
                ),
              ) : const Icon(Icons.login, color: Colors.black),
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: AutoSizeText(
                    AppLocalizations.of(context)!.welcomeBack,
                    maxLines: 1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35
                    ),
                  )
              ),

              const SizedBox(height: 20),

              Center(
                child: Image.asset(
                  "lib/assets/images/benzinapp_logo_round.png",
                  height: 150,
                  width: 150,
                ),
              ),

              const SizedBox(height: 80),

              // BenzinApp Logo
              TextField(
                enabled: !isLoggingIn,
                controller: usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  errorText: usernameError,
                  hintText: AppLocalizations.of(context)!.usernameHint,
                  labelText: AppLocalizations.of(context)!.username,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Password TextField
              TextField(
                enabled: !isLoggingIn,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  errorText: passwordError,
                  hintText: AppLocalizations.of(context)!.passwordHint,
                  labelText: AppLocalizations.of(context)!.password,
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 75),

              Row(
                 children: [
                   Expanded(
                     child: AutoSizeText(maxLines: 1, "• ${AppLocalizations.of(context)!.dontHaveAnAccount}"),
                   ),
                   const SizedBox(width: 5),
                   const Icon(Icons.app_registration, size: 18,)
                 ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText( maxLines: 1, "• ${AppLocalizations.of(context)!.forgotPassword}"),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.key_off, size: 18,)
                ],
              ),
            ]
          ),
        ),
      ));
  }
}
