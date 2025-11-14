import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../services/classes/car.dart';

class InviteUserToCar extends StatefulWidget {
  const InviteUserToCar({super.key, required this.car});

  final Car car;

  @override
  State<StatefulWidget> createState() => _InviteUserToCarState();
}

class _InviteUserToCarState extends State<InviteUserToCar> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isSending = false;
  String? _usernameError;
  bool _usernameEmpty = true;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('inviteUserToCarAppBar')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: buttonLocked() ? null : _sendInvitation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: Text(
                translate('sendInvitationButton'),
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              iconAlignment: IconAlignment.end,
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
                  : const Icon(Icons.send, color: Colors.black),
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
                  translate('inviteUserToCarTitle'),
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
                child: Text(translate('inviteUserToCarSubtitle')),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  translate('enterUsernameToInvite'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                enabled: !_isSending,
                controller: _usernameController,
                onChanged: (value) {
                  setState(() {
                    _usernameEmpty = value.isEmpty;
                  });
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  errorText: _usernameError,
                  hintText: translate('usernameHint'),
                  labelText: translate('username'),
                  prefixIcon: const Icon(Icons.person),
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

  bool buttonLocked() => _usernameEmpty || _isSending;

  void _sendInvitation() async {
    setState(() {
      _isSending = true;
      _usernameError = null;
    });

    final result = await CarManager().inviteUserToCar(_usernameController.text);

    setState(() {
      _isSending = false;
    });

    if (success) {
      SnackbarNotification.show(MessageType.success, 'Invitation sent to ${_usernameController.text}');
      setState(() {
        _usernameController.clear();
        _usernameEmpty = true;
      });
    } else {
      setState(() {
        _usernameError = 'User not found'; // Example error message
      });
    }
  }
}
