import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:benzinapp/views/confirmations/confirm_email.dart';
import 'package:benzinapp/views/confirmations/reset_password_first_step.dart';
import 'package:benzinapp/views/confirmations/unlock_account.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/register.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:benzinapp/views/use_case_register.dart';
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
  bool showUnlockButton = false;

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

    switch (result) {
      case SessionStatus.success:
        // show the message that the user is authorized successfully.
        SnackbarNotification.show(MessageType.success, translate('successfullyLoggedIn'));
        DataHolder().initializeValues();

        Widget screen = const Dashboard();

        if (!UserManager().currentUser!.isConfirmed()) {
          screen = const ConfirmEmail();
        }

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => screen
        ));

        break;
      case SessionStatus.locked:
        SnackbarNotification.show(MessageType.danger, translate('accountLockedNotification'));
        setState(() {
          showUnlockButton = true;
        });
      case SessionStatus.wrongCredentials:
        setState(() {
          emailError = translate('wrongCredentials');
          passwordError = translate('wrongCredentials');
        });
        break;
      case SessionStatus.serverError:
        SnackbarNotification.show(MessageType.danger, "SERVER ERROR"); // TODO: Localize
        break;
      default:
        break;
    }

    setState(() {
      isLoggingIn = false;
    });
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
                    builder: (context) => const SettingsScreen()
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

          }, icon: const Icon(Icons.person_add_rounded)
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

              const SizedBox(height: 40),

              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()
                    )
                  );
                },
                leading: const Icon(Icons.person_add_rounded),
                title: Text(translate('dontHaveAnAccount')),
                subtitle: Text(translate('registerToBenzinApp')),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),

              const SizedBox(height: 60),

              // E-mail text field
              TextField(
                enabled: !isLoggingIn,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    showUnlockButton = false;
                  });
                },
                decoration: InputDecoration(
                  errorText: emailError,
                  hintText: translate('emailHint'),
                  labelText: translate('email'),
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

              const SizedBox(height: 25),

              if (showUnlockButton)
              Center(
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.lock_reset),
                  label: Text(translate('unlockAccountButton')),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnlockAccountScreen(email: emailController.text)
                        )
                    );
                  },
                ),
              ),

              if (showUnlockButton)
              const SizedBox(height: 15),

              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.password),
                  label: Text(translate('forgotPassword')),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPasswordFirstStep()
                        )
                    );
                  },
                ),
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
