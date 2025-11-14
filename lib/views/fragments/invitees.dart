
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
  @override
  Widget build(BuildContext context) {
    return Consumer<CarUserInvitationManager>(
      builder: (context, invitationManager, _) {
        final invitations = invitationManager.local.where(
          (invitation) => invitation.carId == CarManager().watchingCar!.id
        ).toList();

        return RefreshIndicator(
          onRefresh: () => _refreshInvitations(),
          child: ListView.builder(
            itemCount: invitations.length,
            itemBuilder: (context, index) {
              final invitation = invitations[index];
              return ListTile(
                title: Text(invitation.recipientUsername),
                subtitle: Text(invitation.isAccepted ? translate('accepted') : translate('pending')),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _refreshInvitations() async {
    await CarUserInvitationManager().index();

  }
}
