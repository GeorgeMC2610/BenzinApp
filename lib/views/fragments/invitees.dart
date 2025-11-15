
import 'package:benzinapp/services/classes/car_user_invitation.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class InviteesFragment extends StatefulWidget {
  const InviteesFragment({super.key});

  @override
  State<InviteesFragment> createState() => _InviteesFragmentState();
}

class _InviteesFragmentState extends State<InviteesFragment> {

  Future<void> _refreshInvitations() async {
    await CarUserInvitationManager().index();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarUserInvitationManager>(
      builder: (context, invitationManager, _) {
        final invitations = invitationManager.local.where(
          (invitation) => invitation.carId == CarManager().watchingCar!.id
        ).toList();

        return RefreshIndicator(
          onRefresh: _refreshInvitations,
          child: invitations.isEmpty ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mail_outlined),
                const Text("Nooooo!")
              ],
            )
          )
              :
          ListView.builder(
            itemCount: invitations.length,
            itemBuilder: (context, index) {
              final invitation = invitations[index];
              return _buildListTile(invitation);
            },
          ),
        );
      },
    );
  }

  ListTile _buildListTile(CarUserInvitation invitation) =>  ListTile(
    title: Text(invitation.recipientUsername),
    leading: Icon(invitation.isAccepted ? Icons.person : Icons.access_time_outlined),
    subtitle: Text("${invitation.createdAt}"),
    trailing: TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.error
      ),
      icon: const Icon(Icons.close),
      label: Text(invitation.isAccepted ? translate('revoke') : translate('cancel')),
      onPressed: () async {
        await CarUserInvitationManager().delete(invitation);
      },
    ),
  );

}
