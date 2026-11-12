import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/about/privacy_policy.dart';
import 'package:benzinapp/views/confirmations/confirm_email.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:benzinapp/views/shared/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:benzinapp/i18n/strings.g.dart';
import 'about/terms_and_conditions.dart';

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
  bool _termsAccepted = false;


  final _formKey = GlobalKey<FormState>();

  void _sendRegisterPayload() async {
    // empty checks
    setState(() {
      usernameError = usernameController.text.trim().isEmpty
          ? t.cannotBeEmpty
          : null;

      passwordError =
        passwordController.text.isEmpty ? t.cannotBeEmpty : null;

      passwordError =
        passwordController.text.length < 6 ? t.passwordTooShort : null;

      passwordConfirmError = passwordConfirmController.text.isEmpty
          ? t.cannotBeEmpty
          : null;

      emailError =
          emailController.text.isEmpty ? t.cannotBeEmpty : null;

      if (passwordConfirmError == null && passwordError == null) {
        passwordConfirmError =
            passwordConfirmController.text != passwordController.text
                ? t.confirmPasswordCorrectly
                : null;
      }
    });

    if (usernameError != null ||
        passwordError != null ||
        passwordConfirmError != null ||
        emailError != null) {
      return;
    }

    setState(() {
      isRegistering = true;
    });

    try {
      var result = await SessionManager().signup(
        emailController.text,
        usernameController.text,
        passwordController.text,
        passwordConfirmController.text,
      );

      switch (result) {
        case SessionStatus.success:
          SnackbarNotification.show(
              MessageType.success, t.successfullyCreatedAccount);

          await UserManager().getCurrentUser();

          if (mounted) {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfirmEmail(fromRegister: true)));
          }
          break;
        case SessionStatus.usernameTaken:
          setState(() {
            usernameError = t.usernameAlreadyTaken;
          });
          break;
        case SessionStatus.usernameBad:
          setState(() {
            usernameError = t.usernameBad;
          });
          break;
        case SessionStatus.emailTaken:
          setState(() {
            emailError = t.emailAlreadyTaken;
          });
          break;
        case SessionStatus.serverError:
          SnackbarNotification.show(MessageType.danger, t.serverError);
          break;
        default:
          break;
      }
    }
    catch (e) {
      showDialog(context: context, builder: (buildContext) => AlertDialog(
        title: Text(t.serverErrorTitle),
        content: Text(t.serverErrorBody),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text(t.ok))
        ],
      ));
      SnackbarNotification.show(MessageType.danger, t.serverError);
    }
    finally {
      setState(() {
        isRegistering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(t.registerToBenzinApp),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: (isRegistering || !_termsAccepted) ? null : _sendRegisterPayload,
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary),
                label: Text(
                  t.register,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                icon: isRegistering
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3,
                          strokeCap: StrokeCap.square,
                        ),
                      )
                    : const Icon(Icons.app_registration),
              ),
            ),
          ),
        ],
        persistentFooterAlignment: AlignmentDirectional.center,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                  child: AutoSizeText(
                t.welcome,
                maxLines: 1,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  "lib/assets/images/benzinapp_logo_round.png",
                  height: 150,
                  width: 150,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        maxLength: 256,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          errorText: emailError,
                          hintText: t.emailHint,
                          counterText: '',
                          labelText: t.email,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        autofillHints: const [AutofillHints.newUsername],
                        maxLength: 16,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          errorText: usernameError,
                          hintText: t.usernameRegisterHint,
                          errorMaxLines: 4,
                          labelText: t.username,
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PasswordField(
                              controller: passwordController,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              maxLength: 128,
                              errorText: passwordError,
                              errorMaxLines: 4,
                              hintText: t.passwordHint,
                              labelText: t.password,
                            ),
                          ),
                          const SizedBox(width: 7.5),
                          Expanded(
                            child: PasswordField(
                              controller: passwordConfirmController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _sendRegisterPayload(),
                              autofillHints: const [AutofillHints.newPassword],
                              maxLength: 128,
                              errorText: passwordConfirmError,
                              hintText: t.passwordConfirmationHint,
                              labelText: t.passwordConfirmation,
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: t.termsPart1,
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <TextSpan>[
                          TextSpan(
                              text: t.termsPart2,
                              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsAndConditions()));
                                }),
                          TextSpan(text: t.termsPart3),
                          TextSpan(
                              text: t.termsPart4,
                              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PrivacyPolicy()));
                                }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
