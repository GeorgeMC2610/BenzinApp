import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/request_handler.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/managers/token_manager.dart';
import 'about/terms_and_conditions.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  String? usernameError, passwordError, passwordConfirmError, manufacturerError,
  modelError, yearError;

  bool isRegistering = false;

  void _sendRegisterPayload() async {
    // empty checks
    setState(() {
      usernameError = usernameController.text.trim().isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      passwordError = passwordController.text.isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      passwordConfirmError = passwordConfirmController.text.isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      manufacturerError = manufacturerController.text.isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      modelError = modelController.text.isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      yearError = yearController.text.isEmpty?
      AppLocalizations.of(context)!.cannotBeEmpty :
      null;

      // other checks
      yearError ??= int.parse(yearController.text) < 1886 ?
      AppLocalizations.of(context)!.carsNotExistingBackThen :
        null;

      if (passwordConfirmError == null && passwordError == null) {
        passwordConfirmError = passwordConfirmController.text != passwordController.text ?
        AppLocalizations.of(context)!.confirmPasswordCorrectly :
        null;
      }
    });

    if (
    usernameError != null || passwordError != null || passwordConfirmError != null ||
    manufacturerError != null || modelError != null || yearError != null
    ) {
      return;
    }

    setState(() {
      isRegistering = true;
    });

    var result = await SessionManager().signup(
        usernameController.text, passwordController.text,
        passwordConfirmController.text, manufacturerController.text,
        modelController.text, int.parse(yearController.text)
    );

    setState(() {
      isRegistering = false;
    });

    if (result) {
      setState(() {
        usernameError = AppLocalizations.of(context)!.usernameAlreadyTaken;
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.successfullyCreatedAccount),
          )
      );

      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage()
          ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.registerToBenzinApp),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsAndConditions()
                    )
                );
              },
              icon: const Icon(Icons.newspaper)
            )
          ],
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isRegistering ? null : _sendRegisterPayload,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary
                ),
                label: Text(
                  AppLocalizations.of(context)!.register,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                icon: isRegistering? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3,
                    strokeCap: StrokeCap.square,
                  ),
                ) : const Icon(Icons.app_registration),
              ),
            ),
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: AutoSizeText(
                        AppLocalizations.of(context)!.welcome,
                        maxLines: 1,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
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

                  const SizedBox(height: 20),

                  Text(AppLocalizations.of(context)!.agreeToTheTandC),

                  const SizedBox(height: 20),

                  DividerWithText(
                    text: AppLocalizations.of(context)!.accountDetails,
                    textSize: 17,
                    lineColor: Colors.black, textColor: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  // BenzinApp Logo
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorText: usernameError,
                      hintText: AppLocalizations.of(context)!.usernameRegisterHint,
                      labelText: AppLocalizations.of(context)!.username,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // ACCOUNT DETAILS REGION
                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
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
                      ),

                      const SizedBox(width: 7.5),

                      Expanded(
                        child: TextField(
                          controller: passwordConfirmController,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: InputDecoration(
                            errorText: passwordConfirmError,
                            hintText: AppLocalizations.of(context)!.passwordConfirmationHint,
                            labelText: AppLocalizations.of(context)!.passwordConfirmation,
                            suffixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),

                  // CAR DETAILS REGION
                  const SizedBox(height: 50),

                  DividerWithText(
                    text: AppLocalizations.of(context)!.carDetails,
                    textSize: 17,
                    lineColor: Colors.black, textColor: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  // BenzinApp Logo
                  TextField(
                    controller: manufacturerController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorText: manufacturerError,
                      hintText: AppLocalizations.of(context)!.carManufacturerHint,
                      labelText: AppLocalizations.of(context)!.carManufacturer,
                      prefixIcon: const Icon(Icons.car_rental),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Password TextField

                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          controller: modelController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: modelError,
                            hintText: AppLocalizations.of(context)!.carModelHint,
                            labelText: AppLocalizations.of(context)!.carModel,
                            prefixIcon: const Icon(Icons.car_rental_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 7.5),

                      Expanded(
                        child: TextField(
                          controller: yearController,
                          keyboardType: const TextInputType.numberWithOptions(signed: true),
                          decoration: InputDecoration(
                            errorText: yearError,
                            hintText: AppLocalizations.of(context)!.carYearHint,
                            labelText: AppLocalizations.of(context)!.carYear,
                            suffixIcon: const Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                ]
            ),
          ),
        ));
  }

}