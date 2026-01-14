import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/confirmations/reset_password_second_step.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ResetPasswordFirstStep extends StatefulWidget {
  const ResetPasswordFirstStep({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordFirstStep();
}

class _ResetPasswordFirstStep extends State<ResetPasswordFirstStep> {
  TextEditingController emailController = TextEditingController();

  String? emailError;
  bool isLoading = false;
  bool isEmail = false;

  sendEmailResetToken() async {
    setState(() {
      isLoading = true;
    });
    final result = await UserManager().sendResetPasswordToken(emailController.text);
    setState(() {
      isLoading = false;
    });

    switch (result) {
      case UserPayloadStatus.resetTokenSent:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResetPasswordSecondStep(email: emailController.text)
            )
        );
        break;
      default:
        SnackbarNotification.show(MessageType.danger, translate('forgotPasswordErrorSomethingElse', args: { 'code': 500 }));
        break;
    }
  }

  checkEmail(value) {
    setState(() {
      isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(translate('forgotPasswordMenu')),

        ),
        persistentFooterAlignment: AlignmentDirectional.center,
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: !isEmail ? null : sendEmailResetToken,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                label: Text(
                  translate('forgotPasswordNextStep'),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                ),
                iconAlignment: IconAlignment.end,
                icon: isLoading? const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 5,
                    strokeCap: StrokeCap.square,
                  ),
                ) : const Icon(Icons.arrow_right_alt_sharp, color: Colors.black),
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
                    translate('forgotPasswordTitle'),
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
                      translate('forgotPasswordSubtitle')
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    translate('forgotPasswordEmailPrompt'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  enabled: !isLoading,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: checkEmail,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: emailError,
                    hintText: translate('forgotPasswordEmailHint'),
                    labelText: translate('forgotPasswordEmailLabel'),
                    prefixIcon: const Icon(Icons.email),
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
}
