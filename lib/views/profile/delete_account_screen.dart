import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('deleteAccountAppBar')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: buttonLocked() ? null : _deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
              label: Text(
                translate('deleteAccountButton'),
                style: TextStyle(
                    fontSize: 18,
                    color: buttonLocked()
                        ? null
                        : Theme.of(context).colorScheme.onErrorContainer),
              ),
              iconAlignment: IconAlignment.start,
              icon: _isSending
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 5,
                        strokeCap: StrokeCap.square,
                      ),
                    )
                  : Icon(Icons.delete_forever, color: buttonLocked() ? null : Theme.of(context).colorScheme.onErrorContainer),
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
                  translate('deleteAccountTitle'),
                  minFontSize: 20,
                  maxLines: 1,
                  maxFontSize: 35,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  translate('deleteAccountSubtitle'),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        translate('deleteAccountWarning'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: AutoSizeText(
                  translate('deleteAccountDangerZone'),
                  minFontSize: 20,
                  maxLines: 1,
                  maxFontSize: 25,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  translate('deleteAccountRetypeUsernameTitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                enabled: !_isSending,
                controller: _userNameController,
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: translate('deleteAccountRetypeUsername'),
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text(
                  translate('deleteAccountRetypePasswordTitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                enabled: !_isSending,
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: translate('deleteAccountRetypePassword'),
                  prefixIcon: const Icon(Icons.password),
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

  bool buttonLocked() =>
      _isSending ||
      _userNameController.text.isEmpty ||
      _passwordController.text.isEmpty;

  void _deleteAccount() async {
    setState(() {
      _isSending = true;
    });

    try {
      final result = await UserManager().deleteAccount(_userNameController.text, _passwordController.text);
      if (result && mounted) {
        SnackbarNotification.show(MessageType.success,
            translate('accountDeletedSuccessfully'));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        SnackbarNotification.show(
          MessageType.danger, translate('accountDeletionFailed'));
      }
    } catch (e) {
      SnackbarNotification.show(
          MessageType.danger, translate('accountDeletionFailed'));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}
