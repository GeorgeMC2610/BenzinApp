import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/car/general_invitations.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/shared/car_list.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    refreshCars();
  }

  _normalBody() => RefreshIndicator(
        onRefresh: refreshCars,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!(UserManager().currentUser?.isConfirmed() ?? false))
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            translate('dashboardConfirmAccount'),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                DividerWithText(
                  text: translate('dashboardMyCars'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16,
                ),
                const SizedBox(height: 15),
                const CarList(owned: true),
                const SizedBox(height: 15),
                DividerWithText(
                  text: translate('dashboardSharedWithMe'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16,
                ),
                const SizedBox(height: 15),
                const CarList(owned: false),
              ],
            ),
          ),
        ),
      );

  _loadingBody() => const LinearProgressIndicator(
        value: null,
      );

  _bodyDecider(
      CarManager carManager, CarUserInvitationManager invitationManager) {
    if (carManager.local == null || invitationManager.local == null) {
      return _loadingBody();
    }
    return _normalBody();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CarManager, CarUserInvitationManager>(
      builder: (context, carManager, invitationManager, _) {
        final pendingInvitations = invitationManager.local
            ?.where((element) => !element.isAccepted && element.recipientUsername == UserManager().currentUser!.username)
            .length;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(translate('dashboardAppBar')),
            actions: [
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GeneralInvitations(),
                      ),
                    ).then((value) => refreshCars()),
                    icon: const Icon(Icons.mail_outlined),
                  ),
                  if (pendingInvitations != null && pendingInvitations > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$pendingInvitations',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: _bodyDecider(carManager, invitationManager),
        );
      },
    );
  }

  Future<void> refreshCars() async {
    await CarManager().index();
    await CarUserInvitationManager().index();
  }
}
