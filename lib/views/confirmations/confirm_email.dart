import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:benzinapp/views/use_case_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../services/managers/user_manager.dart';
import '../shared/notification.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key, this.fromRegister = false});

  final bool fromRegister;

  @override
  State<StatefulWidget> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {

  static const int totalSeconds = 120; // wait 1 minute
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
    if (!widget.fromRegister) {
      defineSeconds();
    }
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

  onComplete(code) {
    setState(() {
      this.code = code;
    });
  }

  defineSeconds() async {
    setState(() {
      isLoading = true;
    });

    final result = await UserManager().getConfirmationDateSent();

    if (result == null) {
      requestNewToken();
    }
    else {
      final remainingSeconds = result.difference(DateTime.now()).inSeconds;
      if (remainingSeconds == 600) {
        requestNewToken();
      }
      else {
        setState(() {
          this.remainingSeconds = remainingSeconds < 0 ? 0 : remainingSeconds;
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void requestNewToken() async {
    setState(() {
      isSendingNewToken = true;
    });
    final result = await UserManager().resendConfirmationToken();
    setState(() {
      isSendingNewToken = false;
    });

    switch (result) {
      case UserPayloadStatus.confirmTokenSent:
        setState(() {
          remainingSeconds = totalSeconds;
        });
        break;
      case UserPayloadStatus.confirmTokenEarly:
        SnackbarNotification.show(MessageType.alert, translate('confirmAccountPleaseWait'));
        break;
      case UserPayloadStatus.confirmedAlready:
        SnackbarNotification.show(MessageType.success, translate('confirmAccountAlreadyConfirmed'));
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const Dashboard()
        ));
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
    final result = await UserManager().confirmUser(code!);
    setState(() {
      isLoading = false;
    });

    switch (result) {
      case UserPayloadStatus.confirmedOk:
        SnackbarNotification.show(MessageType.success, translate('confirmAccountOkay'));
        Widget redirectScreen = widget.fromRegister ? const UseCaseRegister() : const Dashboard();

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => redirectScreen
        ));
        break;
      case UserPayloadStatus.confirmTokenWrong:
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
      title: Text(translate('confirmAccount')),
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
                translate('confirmAccountTitle'),
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
              length: 6,
              appContext: context,

              keyboardType: TextInputType.text,
              animationType: AnimationType.fade,
              textCapitalization: TextCapitalization.characters,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 45,
                fieldWidth: 45,
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

            const SizedBox(height: 75),

            Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => const Dashboard()
                    ));
                  },
                  child: Text(
                    translate('skipVerification'),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue
                    ),
                  ),
                )
            ),

            const SizedBox(height: 55),

            Center(
              child: ListTile(
                onTap: skipModal,
                leading: const Icon(Icons.question_mark_rounded),
                title: AutoSizeText(
                  translate('skipConsequences'),
                ),
                trailing: const Icon(Icons.keyboard_arrow_down),
              )
            ),

          ],
        ),
      ),
    )
  );

  skipModal() => showModalBottomSheet(
    context: context,
    builder: (buildContext) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  translate("skipConsequencesTitle1"),
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              const SizedBox(height: 20),
              Text(
                translate("skipConsequencesText1"),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 15),
              Text(
                translate("skipConsequencesText2"),
                style: Theme.of(context).textTheme.bodyMedium,
              )
            ],
          ),
        ),
      ),
    )
  );

  bool canResendTokenButtonBePressed() => !(isLoading || isSendingNewToken || remainingSeconds > 0);
  bool canFinishButtonBePressed() => !(isLoading || isSendingNewToken || codeLength != 6);

}