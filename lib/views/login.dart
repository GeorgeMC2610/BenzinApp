import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/home.dart';
import 'package:benzinapp/views/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  bool isLoggingIn = false;

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

    var client = http.Client();
    var url = Uri.parse('${DataHolder.destination}/auth/login');

    client.post(
      url,
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      }
    ).whenComplete(() {
      setState(() {
        isLoggingIn = false;
      });
    }).then((response) {
      switch (response.statusCode) {
        case 401:
          setState(() {
            usernameError = 'Wrong Credentials.';
            passwordError = 'Wrong Credentials.';
          });
          break;
        case 200:
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('successfully logged in'),
              )
          );

          TokenManager().setToken(
            jsonDecode(response.body)['auth_token']
          ).whenComplete(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage()
                ));
          });

          break;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
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
            icon: isLoggingIn? const CircularProgressIndicator(
              value: null,
              strokeWidth: 5,
              strokeCap: StrokeCap.square,
            ) : const Icon(Icons.login, color: Colors.black),
          ),
        ),
      ),
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

              const SizedBox(height: 100),
            ]
          ),
        ),
      ));
  }
}
