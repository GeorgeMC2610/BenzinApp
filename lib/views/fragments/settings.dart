import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/about/app_information.dart';
import 'package:benzinapp/views/about/terms_and_conditions.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/about/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:benzinapp/services/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/theme_provider.dart';

class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {

  bool lightMode = false;
  bool fastLogin = false;

  void _performLogout() {
    TokenManager().removeToken().whenComplete(() {
      DataHolder().destroyValues();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out.'), // TODO: Localize
        )
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage()
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.applicationAppearance,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: Text(AppLocalizations.of(context)!.darkMode),
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
                  title: Text(AppLocalizations.of(context)!.language),
                  onTap: _showLanguageModal,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.language_outlined),
                ),

                const SizedBox(height: 30),

                Text(
                  AppLocalizations.of(context)!.accountSettings,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.fastLogin),
                  trailing: Switch.adaptive(
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.electric_bolt, color: Colors.black);
                      }
                      return null;
                    }),
                    value: fastLogin,
                      onChanged: (bool value) {

                        if (fastLogin == false)
                        {
                          setState(() {
                            fastLogin = true;
                          });
                        }
                        else
                        {
                          setState(() {
                            fastLogin = false;
                          });
                        }
                      },

                  ),
                  leading: const Icon(Icons.offline_bolt_outlined),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.editAccount),
                  onTap: () {},
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.edit),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.logout, style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
                  leading: const Icon(Icons.logout, color: Color.fromARGB(255, 200, 0, 0)),
                  onTap: _performLogout,
                ),

                const SizedBox(height: 30),

                Text(AppLocalizations.of(context)!.aboutTheApp,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: Text(AppLocalizations.of(context)!.privacyPolicy),
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
                  title: Text(AppLocalizations.of(context)!.termsAndConditions),
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
                  title: Text(AppLocalizations.of(context)!.appInformation),
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
    );

  }

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
      onChanged: (Locale? value) {
        if (value != null) {
          languageProvider.changeLocale(value);
          Navigator.pop(context); // Close modal after selection
        }
      },
    );
  }

}