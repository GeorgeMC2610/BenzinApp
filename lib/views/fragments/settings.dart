import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/managers/fcm_manager.dart';
import 'package:benzinapp/services/volume_metric_provider.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/session_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/about/app_information.dart';
import 'package:benzinapp/views/about/terms_and_conditions.dart';
import 'package:benzinapp/views/car/delete_car_screen.dart';
import 'package:benzinapp/views/car/general_invitations.dart';
import 'package:benzinapp/views/car/invite_user_to_car.dart';
import 'package:benzinapp/views/car/transfer_car_ownership_screen.dart';
import 'package:benzinapp/views/confirmations/confirm_email.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/about/privacy_policy.dart';
import 'package:benzinapp/views/profile/delete_account_screen.dart';
import 'package:benzinapp/views/profile/edit_account_screen.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:benzinapp/services/language_provider.dart';
import 'package:benzinapp/services/translation_lookup.dart';
import 'package:benzinapp/i18n/strings.g.dart';
import 'package:provider/provider.dart';

import '../../services/theme_provider.dart';
import '../car/claim_old_car.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final bool loggedIn = UserManager().currentUser != null;
  final bool isWatchingCar = CarManager().watchingCar != null && (CarManager().watchingCar?.isOwned() ?? false);

  void _performLogout() {
    SessionManager().logout();
    SnackbarNotification.show(MessageType.info, t.successfullyLoggedOut);

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
      title: Text(t.settings),
    ),
    body: SafeArea(
      child:  SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child:
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      t.applicationAppearance,
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500
                      )
                  ),

                  const SizedBox(height: 12),

                  ListTile(
                    title: Text(t.darkMode),
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
                    title: Text(t.language),
                    subtitle: Text(
                        Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag()
                    ),
                    onTap: _showLanguageModal,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    leading: const Icon(Icons.language_outlined),
                  ),
                  ListTile(
                    title: Text(t.distanceMetric),
                    subtitle: Text(
                        TranslationLookup.byKey(Provider.of<DistanceMetricProvider>(context).translatableCode)!
                    ),
                    onTap: _showDistanceMetricModal,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    leading: const Icon(Icons.straighten),
                  ),
                  ListTile(
                    title: Text(t.volumeMetric),
                    subtitle: Text(
                        TranslationLookup.byKey(Provider.of<VolumeMetricProvider>(context).translatableCode)!
                    ),
                    onTap: _showVolumeMetricModal,
                    trailing: const Icon(Icons.arrow_forward_ios),
                    leading: const Icon(Icons.opacity),
                  ),

                  if (loggedIn)
                    const SizedBox(height: 30),

                  if (loggedIn)
                    ...getNotificationOptions(),

                  if (isWatchingCar)
                    ...getCarOptions(),

                  if (loggedIn)
                    ...getUserOptions(),

                  const SizedBox(height: 30),

                  Text(t.aboutTheApp,
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500
                      )
                  ),

                  const SizedBox(height: 12),

                  ListTile(
                    title: Text(t.privacyPolicy),
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
                    title: Text(t.termsAndConditions),
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
                    title: Text(t.appInformation),
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
    )
  );

  List<Widget> getNotificationOptions() => [
      Text(
          t.notificationSettings,
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500
          )
      ),

      const SizedBox(height: 12),

      ListTile(
        title: Text(t.receiveEmailNotifications),
        trailing: Consumer<FCMManager>(
          builder: (context, fcmManager, child) {
            return Switch.adaptive(
              value: fcmManager.receiveEmailNotifications,
              onChanged: (bool value) {
                fcmManager.toggleEmailNotifications(value);
              },
            );
          },
        ),
        leading: const Icon(Icons.email_outlined),
      ),

      ListTile(
        title: Text(t.receivePushNotifications),
        trailing: Consumer<FCMManager>(
          builder: (context, fcmManager, child) {
            return Switch.adaptive(
              value: fcmManager.receivePushNotifications,
              onChanged: (bool value) {
                fcmManager.togglePushNotifications(value);
              },
            );
          },
        ),
        leading: const Icon(Icons.notifications_active_outlined),
      ),
  ];

  List<Widget> getCarOptions() {
    final isConfirmed = UserManager().currentUser?.isConfirmed() ?? false;

    return [
      const SizedBox(height: 30),

      Text(
          t.carOptions,
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500
          )
      ),

      const SizedBox(height: 12),

      ListTile(
        title: Text(t.inviteUserToCar),
        enabled: UserManager().currentUser?.confirmedAt != null,
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
        title: Text(t.transferOwnership, style: TextStyle(
            color: !isConfirmed ? null : const Color.fromARGB(255, 200, 0, 0))
        ),
        enabled: UserManager().currentUser?.confirmedAt != null,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransferCarOwnershipScreen(car: CarManager().watchingCar!)
              )
          );
        },
        trailing: Icon(Icons.arrow_forward_ios, color: !isConfirmed ? null : const Color.fromARGB(255, 200, 0, 0)),
        leading: Icon(Icons.compare_arrows, color: !isConfirmed ? null : const Color.fromARGB(255, 200, 0, 0)),
      ),

      ListTile(
        title: Text(t.deleteCar, style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
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
  }

  List<Widget> getUserOptions() {
    final isConfirmed = UserManager().currentUser?.isConfirmed() ?? false;

    return [
      const SizedBox(height: 30),

      Text(
          t.accountSettings,
          style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500
          )
      ),

      const SizedBox(height: 12),

      ListTile(
        title: Text(t.editAccount),
        enabled: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditAccountScreen()
              )
          );
        },
        trailing: const Icon(Icons.arrow_forward_ios),
        leading: const Icon(Icons.person),
      ),

      if (isConfirmed)
        ListTile(
          title: Text(t.invitations),
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

      if (isConfirmed)
        ListTile(
          title: Text(t.claimCarSettings),
          enabled: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClaimOldCar(fromSettings: true)
                )
            );
          },
          trailing: const Icon(Icons.arrow_forward_ios),
          leading: const Icon(Icons.car_rental_outlined),
        ),

      if (!isConfirmed)
        ListTile(
          title: Text(t.confirmAccount),
          enabled: true,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConfirmEmail(fromSettings: true)
                )
            );
          },
          trailing: const Icon(Icons.arrow_forward_ios),
          leading: const Icon(Icons.verified_user_outlined),
        ),

      ListTile(
        title: Text(t.logout, style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
        leading: const Icon(Icons.logout, color: Color.fromARGB(255, 200, 0, 0)),
        onTap: _performLogout,
      ),

      ListTile(
        title: Text(t.deleteAccount, style: const TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
        leading: const Icon(Icons.person_remove, color: Color.fromARGB(255, 200, 0, 0)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const DeleteAccountScreen()
              )
          );
        },
      ),
    ];
  }

  void _showDistanceMetricModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.distanceMetric),
          content: Consumer<DistanceMetricProvider>(
            builder: (context, distanceMetricProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDistanceMetricOption(context, t.kilometersSetting, DistanceMetric.kilometers),
                  _buildDistanceMetricOption(context, t.milesSetting, DistanceMetric.miles),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDistanceMetricOption(BuildContext context, String title, DistanceMetric metric) {
    final distanceMetricProvider = Provider.of<DistanceMetricProvider>(context, listen: false);
    return RadioListTile<DistanceMetric>(
      title: Text(title),
      value: metric,
      groupValue: distanceMetricProvider.metric,
      onChanged: (DistanceMetric? value) {
        if (value != null) {
          distanceMetricProvider.setMetric(value);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showVolumeMetricModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.volumeMetric),
          content: Consumer<VolumeMetricProvider>(
            builder: (context, volumeMetricProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildVolumeMetricOption(context, t.litersSetting, VolumeMetric.liters),
                  _buildVolumeMetricOption(context, t.gallonsSetting, VolumeMetric.gallons),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.cancel),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVolumeMetricOption(BuildContext context, String title, VolumeMetric metric) {
    final volumeMetricProvider = Provider.of<VolumeMetricProvider>(context, listen: false);
    return RadioListTile<VolumeMetric>(
      title: Text(title),
      value: metric,
      groupValue: volumeMetricProvider.metric,
      onChanged: (VolumeMetric? value) {
        if (value != null) {
          volumeMetricProvider.setMetric(value);
          Navigator.pop(context);
        }
      },
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
