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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  String? usernameError, passwordError, passwordConfirmError, emailError;
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

      emailError = emailController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;

      if (passwordConfirmError == null && passwordError == null) {
        passwordConfirmError = passwordConfirmController.text != passwordController.text ?
        translate('confirmPasswordCorrectly') :
        null;
      }
    });

    if (
    usernameError != null || passwordError != null || passwordConfirmError != null ||
    emailError != null
    ) {
      return;
    }

    setState(() {
      isRegistering = true;
    });

    var result = await SessionManager().signup(
        emailController.text, usernameController.text,
        passwordController.text, passwordConfirmController.text,
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

                  const SizedBox(height: 40),

                  // BenzinApp Logo
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorText: emailError,
                      hintText: translate('carManufacturerHint'),
                      labelText: translate('carManufacturer'),
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
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

                  const SizedBox(height: 10),

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

                  // Password TextField
                ]
            ),
          ),
        ));
  }

}