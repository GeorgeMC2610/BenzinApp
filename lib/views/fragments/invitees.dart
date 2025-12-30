
import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car_user_invitation.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
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

  _emptyBody() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.mail_outlined, size: 150,),
          AutoSizeText(
            maxLines: 1,
            translate('noInvitations'),
            style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      )
  );

  _normalBody(List<CarUserInvitation> invitations) => ListView.builder(
    itemCount: invitations.length,
    itemBuilder: (context, index) {
      final invitation = invitations[index];
      return _buildListTile(invitation);
    },
  );

  _loadingBody() => const LinearProgressIndicator(
    value: null,
  );

  _decideBody(List<CarUserInvitation>? invitations) {
    if (invitations == null) return _loadingBody();
    if (invitations.isEmpty) return _emptyBody();
    return _normalBody(invitations);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarUserInvitationManager>(
      builder: (context, invitationManager, _) {
        final invitations = invitationManager.local?.where(
          (invitation) => invitation.carId == CarManager().watchingCar!.id
        ).toList();

        return RefreshIndicator(
          onRefresh: _refreshInvitations,
          child: _decideBody(invitations)
        );
      },
    );
  }

  ListTile _buildListTile(CarUserInvitation invitation) =>  ListTile(
    title: Text(invitation.recipientUsername),
    leading: Icon(invitation.isAccepted ? Icons.person : Icons.access_time_outlined),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(translate('sentAt', args: { 'date': DateFormat.yMMMd().add_Hm().format(invitation.createdAt)} )),
        Text(invitation.isAccepted ? translate('accepted') : translate('pending')),
      ],
    ),
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
