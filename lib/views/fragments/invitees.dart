
import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car_user_invitation.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/views/shared/dialogs/confirmation_dialog.dart';
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
    padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildListTile(CarUserInvitation invitation) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accepted = invitation.isAccepted;
    final username = invitation.recipientUsername;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0,
      color: scheme.surfaceContainerHighest.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: accepted ? scheme.primaryContainer : scheme.secondaryContainer,
              foregroundColor: accepted ? scheme.onPrimaryContainer : scheme.onSecondaryContainer,
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: textTheme.titleLarge?.copyWith(color: accepted ? scheme.onPrimaryContainer : scheme.onSecondaryContainer),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          translate('sentAt', args: { 'date': DateFormat.yMMMd().add_Hm().format(invitation.createdAt)} ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _statusChip(accepted),
                ],
              ),
            ),
            IconButton(
              tooltip: accepted ? translate('revoke') : translate('cancel'),
              color: scheme.error,
              icon: Icon(accepted ? Icons.person_remove_outlined : Icons.close),
              onPressed: () => _confirmRemoval(invitation),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(bool accepted) {
    final scheme = Theme.of(context).colorScheme;
    final color = accepted ? scheme.primary : scheme.tertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(accepted ? Icons.check_circle_outline : Icons.hourglass_empty, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            accepted ? translate('accepted') : translate('pending'),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _confirmRemoval(CarUserInvitation invitation) {
    ConfirmationDialog.show(
      context,
      invitation.isAccepted ? translate('revokeInvitation') : translate('cancelInvitation'),
      invitation.isAccepted
          ? translate('areYouSureYouWantToRevokeAccess', args: {'car': invitation.carUsername, 'user': invitation.recipientUsername})
          : translate('areYouSureYouWantToCancelInvitationForThisUser', args: {'car': invitation.carUsername, 'user': invitation.recipientUsername}),
      (confirmed) async {
        if (confirmed) {
          await CarUserInvitationManager().delete(invitation);
        }
      },
    );
  }

}
