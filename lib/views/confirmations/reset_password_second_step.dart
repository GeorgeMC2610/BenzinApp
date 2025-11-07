import 'dart:async';

import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordSecondStep extends StatefulWidget {
  const ResetPasswordSecondStep({super.key, required this.email});

  final String email;

  @override
  State<StatefulWidget> createState() => _ResetPasswordFirstStep();
}

class _ResetPasswordFirstStep extends State<ResetPasswordSecondStep> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmController = TextEditingController();

  static const int totalSeconds = 120; // wait 1 minute
  int remainingSeconds = totalSeconds;

  Timer? _timer;

  String? passwordError;
  String? passwordConfirmError;
  String? codeError;

  String? code;

  bool isLoading = false;
  bool isSendingNewToken = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    remainingSeconds = totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get progress => 1 - (remainingSeconds / totalSeconds);

  requestNewToken() async {
    setState(() {
      isLoading = true;
    });
    final result = await UserManager().sendResetPasswordToken(widget.email);
    setState(() {
      isLoading = false;
    });

    switch (result) {
      case UserPayloadStatus.resetTokenSent:
        setState(() {
          remainingSeconds = totalSeconds;
        });
        break;
      default:
        SnackbarNotification.show(MessageType.danger, 'REQUEST TOO EARLY!');
        break;
    }
  }

  sendNewPassword() async {
    // all errors begin as ok.
    setState(() {
      passwordError = null;
      passwordConfirmError = null;
      codeError = null;
    });

    // null checks etc.
    if (code == null) {
      setState(() {
        codeError = translate('emptyCode');
      });
    }

    if (newPasswordController.text.isEmpty) {
      setState(() {
        passwordError = translate('cannotBeEmpty');
      });
    }

    if (newPasswordConfirmController.text.isEmpty) {
      setState(() {
        passwordConfirmError = translate('cannotBeEmpty');
      });
    }

    if (newPasswordConfirmController.text != newPasswordController.text) {
      setState(() {
        passwordConfirmError = translate('confirmPasswordCorrectly');
      });
    }

    // every error must be null in order to proceed.
    if (![codeError, passwordError, passwordConfirmError].every((e) => e == null)) return;

    // send the request and set as loading.
    setState(() {
      isLoading = true;
    });
    final result = await UserManager().resetPassword(
        widget.email,
        code!,
        newPasswordController.text,
        newPasswordConfirmController.text
    );
    setState(() {
      isLoading = false;
    });

    switch (result) {
      case UserPayloadStatus.passwordResetOk:
        SnackbarNotification.show(MessageType.success, translate('forgotPasswordSuccessfullyReset'));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const LoginPage()
            )
        );
        break;
      case UserPayloadStatus.resetTokenWrong:
        setState(() {
          codeError = translate('wrongCode');
        });
        break;
      default:
        SnackbarNotification.show(MessageType.danger, translate('forgotPasswordErrorSomethingElse', args: { 'code': 500 }));
        break;
    }
  }

  onComplete(code) {
    setState(() {
      this.code = code;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(translate('resetPasswordMenu')),

        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: canFinishButtonBePressed() ? sendNewPassword : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                label: Text(
                  translate('forgotPasswordFinishButton'),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                ),
                icon: isLoading? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 5,
                    strokeCap: StrokeCap.square,
                  ),
                ) : const Icon(Icons.check, color: Colors.black),
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    translate('forgotPasswordSecondStepTitle'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Center(
                  child: Text(
                      translate('checkYourEmail')
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    translate('enterCode'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                PinCodeTextField(
                  length: 10,
                  appContext: context,
                  keyboardType: TextInputType.text,
                  animationType: AnimationType.fade,
                  textCapitalization: TextCapitalization.characters,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 45,
                    fieldWidth: 35,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Colors.grey.shade400,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onCompleted: onComplete,
                  onChanged: (_) {},
                ),

                const SizedBox(height: 10),

                if (codeError != null)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.clear,
                          color: Theme.of(context).colorScheme.error,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          translate('wrongCode'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // RESEND TOKEN ROW
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // CIRCLE PROGRESS WITH TIME
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: Colors.grey.shade300,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      remainingSeconds.toString(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(width: 15),

                // RESEND TOKEN BUTTON
                Expanded(
                  child: FilledButton.icon(
                      onPressed: canResendTokenButtonBePressed() ? requestNewToken : null,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Resend"),
                  ),
                )
              ],
            ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    translate('forgotPasswordSecondStepEnterPassword'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  enabled: !isLoading,
                  controller: newPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    errorText: passwordError,
                    hintText: translate('forgotPasswordSecondStepPasswordHint'),
                    labelText: translate('forgotPasswordSecondStepPasswordLabel'),
                    prefixIcon: const Icon(Icons.enhanced_encryption),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  enabled: !isLoading,
                  controller: newPasswordConfirmController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: passwordConfirmError,
                    hintText: translate('forgotPasswordSecondStepPasswordConfirmHint'),
                    labelText: translate('forgotPasswordSecondStepPasswordConfirmLabel'),
                    prefixIcon: const Icon(Icons.enhanced_encryption_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  bool canResendTokenButtonBePressed() => !(isLoading || isSendingNewToken || remainingSeconds > 0);
  bool canFinishButtonBePressed() => !(isLoading || isSendingNewToken);
}
