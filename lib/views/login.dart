import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/confirmations/confirm_email.dart';
import 'package:benzinapp/views/confirmations/reset_password_first_step.dart';
import 'package:benzinapp/views/home.dart';
import 'package:benzinapp/views/register.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.message});

  final String? message;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  bool isLoggingIn = false;

  void sendLoginPayload() async {

    setState(() {
      emailError = emailController.text.trim().isEmpty?
      translate('cannotBeEmpty') :
      null;

      passwordError = passwordController.text.isEmpty?
      translate('cannotBeEmpty') :
      null;
    });

    if (emailError != null || passwordError != null) {
      return;
    }

    setState(() {
      isLoggingIn = true;
    });

    final result = await SessionManager().login(emailController.text, passwordController.text);

    setState(() {
      isLoggingIn = false;
    });

    switch (result) {
      case SessionStatus.success:
        // show the message that the user is authorized successfully.
        SnackbarNotification.show(MessageType.success, translate('successfullyLoggedIn'));
        await DataHolder().initializeValues();

        Widget screen = const HomePage();

        if (!UserManager().currentUser!.isConfirmed()) {
          screen = const ConfirmEmail();
        }

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => screen
        ));

        break;
      case SessionStatus.wrongCredentials:
        setState(() {
          emailError = translate('wrongCredentials');
          passwordError = translate('wrongCredentials');
        });
        break;
      case SessionStatus.serverError:
        SnackbarNotification.show(MessageType.danger, "SERVER ERROR");
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.message != null) {
        SnackbarNotification.show(MessageType.info, widget.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('loginToBenzinApp')),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterPage()
                )
            );

            }, icon: const Icon(Icons.settings)
          ),

          IconButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterPage()
                )
            );

          }, icon: const Icon(Icons.add_box_outlined)
          ),

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
                translate('login'),
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
                    translate('welcomeBack'),
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  errorText: emailError,
                  hintText: translate('usernameHint'),
                  labelText: translate('username'),
                  prefixIcon: const Icon(Icons.email),
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
                  hintText: translate('passwordHint'),
                  labelText: translate('password'),
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 75),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordFirstStep()
                        )
                    );
                  },
                  child: Text(
                    translate('forgotPassword'),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue
                    ),
                  ),
                )
              ),

              const SizedBox(height: 30),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()
                        )
                    );
                  },
                  child: Text(
                    translate("dontHaveAnAccount"),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue
                    ),
                  ),
                )
              ),


              // const SizedBox(height: 5),
              // Row(
              //   children: [
              //     Expanded(
              //       child: AutoSizeText( maxLines: 1, "• ${translate('forgotPassword')}"),
              //     ),
              //     const SizedBox(width: 5),
              //     const Icon(Icons.key_off, size: 18,)
              //   ],
              // ),
            ]
          ),
        ),
      ));
  }
}
