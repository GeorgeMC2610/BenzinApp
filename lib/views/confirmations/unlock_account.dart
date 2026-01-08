import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../services/managers/user_manager.dart';
import '../shared/notification.dart';

class UnlockAccountScreen extends StatefulWidget {
  const UnlockAccountScreen({super.key, required this.email});

  final String email;

  @override
  State<StatefulWidget> createState() => _UnlockAccountScreenState();
}

class _UnlockAccountScreenState extends State<UnlockAccountScreen> {

  static const int totalSeconds = 120; // wait 2 minutes
  int remainingSeconds = totalSeconds;
  double get progress => 1 - (remainingSeconds / totalSeconds);

  Timer? _timer;
  bool isLoading = false;
  bool isSendingNewToken = false;
  bool wrongCode = false;

  String? code;
  String? codeError;

  int codeLength = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer({int? startValue}) {
    remainingSeconds = startValue ?? totalSeconds;
    _timer?.cancel();
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

  onComplete(code) {
    setState(() {
      this.code = code;
    });
  }

  void requestNewToken() async {
    setState(() {
      isSendingNewToken = true;
    });
    final result = await UserManager().resendUnlockAccountToken(widget.email);
    setState(() {
      isSendingNewToken = false;
    });

    switch (result) {
      case UserPayloadStatus.unlockTokenSent:
        _startTimer();
        break;
      case UserPayloadStatus.unlockTokenEarly:
        SnackbarNotification.show(MessageType.alert, translate('confirmAccountPleaseWait'));
        break;
      default:
        SnackbarNotification.show(MessageType.danger, translate('confirmAccountSomethingElseWentWrong'));
        break;
    }
  }

  void verify() async {
    // first verify that the code is not blank
    setState(() {
      codeError = null;
    });

    // notify the user if this is the case
    if (code == null && code!.isEmpty) {
      setState(() {
        codeError = 'CANNOT BE BLANK!';
      });
    }

    // if it is
    if (codeError != null) return;

    setState(() {
      wrongCode = false;
      isLoading = true;
    });
    final result = await UserManager().unlockAccount(widget.email, code!);
    setState(() {
      isLoading = false;
    });

    switch (result) {
      case UserPayloadStatus.unlockSuccess:
        SnackbarNotification.show(MessageType.success, translate('unlockAccountSuccess'));
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const LoginPage()
        ));
        break;
      case UserPayloadStatus.unlockTokenWrong:
        setState(() {
          wrongCode = true;
        });
        break;
      default:
        SnackbarNotification.show(MessageType.danger, translate('forgotPasswordErrorSomethingElse', args: { 'code': 500 }));
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(translate('unlockAccount')),
    ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: canFinishButtonBePressed() ? verify : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: Text(
                translate('confirmButton'),
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
          children: [
            Center(
              child: AutoSizeText(
                translate('unlockAccountTitle'),
                maxLines: 1,
                minFontSize: 20,
                maxFontSize: 35,
                style: TextStyle(
                    fontSize: 35,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
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
              length: 8,
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
              onChanged: (code) {
                setState(() {
                  codeLength = code.length;
                });
              },
            ),

            const SizedBox(height: 10),

            if (wrongCode)
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
                    label: Text(translate('resendButton')),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    )
  );

  bool canResendTokenButtonBePressed() => !(isLoading || isSendingNewToken || remainingSeconds > 0);
  bool canFinishButtonBePressed() => !(isLoading || isSendingNewToken || codeLength != 8);

}
