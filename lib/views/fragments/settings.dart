import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/about/app_information.dart';
import 'package:benzinapp/views/about/terms_and_conditions.dart';
import 'package:benzinapp/views/car/delete_car_screen.dart';
import 'package:benzinapp/views/car/general_invitations.dart';
import 'package:benzinapp/views/car/invite_user_to_car.dart';
import 'package:benzinapp/views/car/transfer_car_ownership_screen.dart';
import 'package:benzinapp/views/forms/car_form.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/about/privacy_policy.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:benzinapp/services/language_provider.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../services/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final bool loggedIn = UserManager().currentUser != null;
  final bool isWatchingCar = CarManager().watchingCar != null;

  void _performLogout() {
    SessionManager().logout();
    SnackbarNotification.show(MessageType.info, translate('successfullyLoggedOut'));

    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginPage()
        )
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(translate('settings')),
    ),
    body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    translate('applicationAppearance'),
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500
                    )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: Text(translate('darkMode')),
                  trailing: Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return Switch.adaptive(
                        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Icon(Icons.dark_mode, color: Colors.black);
                          }
                          return const Icon(Icons.light_mode, color: Colors.white);
                        }),
                        value: themeProvider.themeMode == ThemeMode.dark,
                        onChanged: (bool isDarkMode) {
                          themeProvider.toggleTheme(isDarkMode);
                        },
                      );
                    },
                  ),
                  leading: const Icon(Icons.dark_mode),
                ),
                ListTile(
                  title: Text(translate('language')),
                  onTap: _showLanguageModal,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.language_outlined),
                ),

                if (isWatchingCar)
                  ...getCarOptions(),

                if (loggedIn)
                  ...getUserOptions(),

                const SizedBox(height: 30),

                Text(translate('aboutTheApp'),
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500
                    )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: Text(translate('privacyPolicy')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy()
                        )
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.security_outlined),
                ),
                ListTile(
                  title: Text(translate('termsAndConditions')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsAndConditions()
                        )
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.newspaper),
                ),
                ListTile(
                  title: Text(translate('appInformation')),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppInformation()
                        )
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.developer_mode),
                ),
              ])
      ),
    ),
  );

  List<Widget> getCarOptions() => [
    const SizedBox(height: 30),

    Text(
        translate('carOptions'),
        style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500
        )
    ),

    const SizedBox(height: 12),

    ListTile(
      title: Text(translate('inviteUserToCar')),
      enabled: true,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InviteUserToCar(car: CarManager().watchingCar!)
            )
        );
      },
      trailing: const Icon(Icons.arrow_forward_ios),
      leading: const Icon(Icons.outgoing_mail),
    ),

    ListTile(
      title: Text(translate('transferOwnership'), style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
      enabled: true,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransferCarOwnershipScreen(car: CarManager().watchingCar!)
            )
        );
      },
      trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
      leading: const Icon(Icons.compare_arrows, color: Color.fromARGB(255, 200, 0, 0)),
    ),

    ListTile(
      title: Text(translate('deleteCar'), style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
      leading: const Icon(Icons.car_crash, color: Color.fromARGB(255, 200, 0, 0)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeleteCarScreen(car: CarManager().watchingCar!)
            )
        );
      },
    ),
  ];

  List<Widget> getUserOptions() => [
    const SizedBox(height: 30),

    Text(
        translate('accountSettings'),
        style: TextStyle(
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w500
        )
    ),

    const SizedBox(height: 12),

    ListTile(
      title: Text(translate('editAccount')),
      enabled: true,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CarForm()
            )
        );
      },
      trailing: const Icon(Icons.arrow_forward_ios),
      leading: const Icon(Icons.person),
    ),

    ListTile(
      title: Text(translate('invitations')),
      enabled: true,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GeneralInvitations()
            )
        );
      },
      trailing: const Icon(Icons.arrow_forward_ios),
      leading: const Icon(Icons.mail_outlined),
    ),

    ListTile(
      title: Text(translate('logout'), style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
      trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
      leading: const Icon(Icons.logout, color: Color.fromARGB(255, 200, 0, 0)),
      onTap: _performLogout,
    ),
  ];

  void _showLanguageModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Language"),
          content: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min, // Prevent excessive height
                children: [
                  _buildLanguageOption(context, 'English', const Locale('en', 'US')),
                  _buildLanguageOption(context, 'Ελληνικά', const Locale('el', 'GR')),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String title, Locale locale) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return RadioListTile<Locale>(
      title: Text(title),
      value: locale,
      groupValue: languageProvider.currentLocale,
      onChanged: (Locale? value) async {
        if (value != null) {
          languageProvider.changeLocale(value);
          await changeLocale(context, value.languageCode);
          Navigator.pop(context); // Close modal after selection
        }
      },
    );
  }

}