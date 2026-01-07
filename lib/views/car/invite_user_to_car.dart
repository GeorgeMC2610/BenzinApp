import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car_user_invitation.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../services/classes/car.dart';
import '../fragments/settings.dart';

class InviteUserToCar extends StatefulWidget {
  const InviteUserToCar({super.key, required this.car});

  final Car car;

  @override
  State<StatefulWidget> createState() => _InviteUserToCarState();
}

class _InviteUserToCarState extends State<InviteUserToCar> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isSending = false;
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
              icon: const Icon(Icons.settings)
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
                child: Text(
                  translate('inviteUserToCarSubtitle'),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  translate('enterUsernameToInvite'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              Consumer<CarUserInvitationManager>(
                builder: (context, manager, child) => TextField(
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
                    errorText: manager.errors["recipient"]?.join(', '),
                    hintText: translate('sharedUsernameHint'),
                    labelText: translate('sharedUsername'),
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        translate('accessContributorDesc'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    )
                  ],
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
    // if (_usernameController.text == UserManager().currentUser!.username) {
    //   setState(() {
    //     _usernameError = '🤯';
    //   });
    //   return;
    // }

    setState(() {
      _isSending = true;
    });

    try {
      final invitation = CarUserInvitation(
          recipientUsername: _usernameController.text, access: 1,
          carId: widget.car.id, carUsername: '', id: -1, senderUsername: '',
          isAccepted: false, createdAt: DateTime.now(),
          updatedAt: DateTime.now()
      );
      await CarUserInvitationManager().create(invitation);
      if (CarUserInvitationManager().errors.keys.isEmpty) {
        // TODO: Translate!
        SnackbarNotification.show(MessageType.success, 'Invitation sent to ${_usernameController.text}');
        setState(() {
          _usernameController.clear();
          _usernameEmpty = true;
        });
      }
      else if (CarUserInvitationManager().errors.containsKey('base')) {
        SnackbarNotification.show(MessageType.danger, CarUserInvitationManager().errors["base"].join(', '));
      }
    }
    catch (e, stack) {
      print(e);
      print(stack);
    }
    finally {
      setState(() {
        _isSending = false;
      });
    }
  }
}
