import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'about/terms_and_conditions.dart';

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
      translate('cannotBeEmpty') :
      null;

      passwordError = passwordController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;

      passwordConfirmError = passwordConfirmController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;

      manufacturerError = manufacturerController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;

      modelError = modelController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;

      yearError = yearController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;

      // other checks
      yearError ??= int.parse(yearController.text) < 1886 ?
      translate('carsNotExistingBackThen') :
        null;

      if (passwordConfirmError == null && passwordError == null) {
        passwordConfirmError = passwordConfirmController.text != passwordController.text ?
        translate('confirmPasswordCorrectly') :
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
    );

    setState(() {
      isRegistering = false;
    });

    switch (result) {
      case SessionStatus.success:
        SnackbarNotification.show(MessageType.success, translate('successfullyCreatedAccount'));

        await DataHolder().initializeValues();

        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomePage()
        ));
        break;
      case SessionStatus.usernameTaken:
        setState(() {
          usernameError = translate('usernameAlreadyTaken');
        });
        break;
      case SessionStatus.emailTaken:
        setState(() {
          usernameError = translate('EMAIL ALREADY TAKEN');
        });
        break;
      case SessionStatus.serverError:
        SnackbarNotification.show(MessageType.success, translate('SERVER ERROR!!!'));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(translate('registerToBenzinApp')),
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
                  translate('register'),
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
                        translate('welcome'),
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

                  Text(translate('agreeToTheTandC')),

                  const SizedBox(height: 20),

                  DividerWithText(
                    text: translate('accountDetails'),
                    textSize: 17,
                    lineColor: Colors.grey,
                    textColor: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 10),

                  // BenzinApp Logo
                  TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorText: usernameError,
                      hintText: translate('usernameRegisterHint'),
                      labelText: translate('username'),
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
                            hintText: translate('passwordHint'),
                            labelText: translate('password'),
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
                            hintText: translate('passwordConfirmationHint'),
                            labelText: translate('passwordConfirmation'),
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
                    text: translate('carDetails'),
                    textSize: 17,
                    lineColor: Colors.grey,
                    textColor: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(height: 10),

                  // BenzinApp Logo
                  TextField(
                    controller: manufacturerController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorText: manufacturerError,
                      hintText: translate('carManufacturerHint'),
                      labelText: translate('carManufacturer'),
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
                            hintText: translate('carModelHint'),
                            labelText: translate('carModel'),
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
                            hintText: translate('carYearHint'),
                            labelText: translate('carYear'),
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