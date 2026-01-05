import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../shared/notification.dart';

class ClaimOldCar extends StatefulWidget {
  const ClaimOldCar({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  State<StatefulWidget> createState() => _ClaimOldCarState();
}

class _ClaimOldCarState extends State<ClaimOldCar> {

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('claimCarAppBar')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: buttonLocked() ? null : claimCar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              label: Text(
                translate('claimCarButton'),
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black
                ),
              ),
              icon: isSearching? const SizedBox(
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
                        widget.fromSettings ? translate('claimCarTitleAlt') : translate('claimCarTitle'),
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
                          widget.fromSettings ? translate('claimCarSubtitleAlt') : translate('claimCarSubtitle')
                      ),
                    ),

                    const SizedBox(height: 30),

                    Center(
                      child: Text(
                        translate('enterExistingCarData'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      enabled: !isSearching,
                      controller: carUsername,
                      onChanged: (value) {
                        setState(() {
                          usernameEmpty = value.isEmpty;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorText: usernameError,
                        hintText: translate('usernameHint'),
                        labelText: translate('username'),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password TextField
                    TextField(
                      enabled: !isSearching,
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          passwordEmpty = value.isEmpty;
                        });
                      },
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

                    const SizedBox(height: 60),

                    if (!widget.fromSettings)
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Dashboard(),
                            ),
                          );
                        },
                        title: Text(translate('claimCarBackToDashboard')),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        leading: const Icon(Icons.dashboard),
                      )
                  ]
              )
          )
      )
  );

  bool isSearching = false;
  bool usernameEmpty = true;
  bool passwordEmpty = true;

  buttonLocked() => passwordEmpty || usernameEmpty || isSearching;

  TextEditingController carUsername = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? usernameError, passwordError;

  claimCar() async {
    setState(() {
      isSearching = true;
    });

    final result = await CarManager().claimCar(carUsername.text, passwordController.text);

    setState(() {
      isSearching = false;
    });

    if (result != null) {
      setState(() {
        usernameError = translate('wrongCredentials');
        passwordError = translate('wrongCredentials');
      });
    }
    else {
      SnackbarNotification.show(MessageType.success, translate('claimCarSuccess'));
      setState(() {
        carUsername.text = '';
        passwordController.text = '';
        usernameError = null;
        passwordError = null;
      });
    }
  }
}