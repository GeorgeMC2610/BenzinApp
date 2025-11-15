import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import '../../services/classes/car_user_invitation.dart';
import '../fragments/settings.dart';
import '../shared/divider_with_text.dart';

class GeneralInvitations extends StatefulWidget {
  const GeneralInvitations({super.key});

  @override
  State<GeneralInvitations> createState() => _GeneralInvitationsState();
}

class _GeneralInvitationsState extends State<GeneralInvitations>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> refresh() async {
    await CarUserInvitationManager().index();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarUserInvitationManager>(
      builder: (context, manager, child) {
        final invitations = CarUserInvitationManager().local;
        final currentUser = UserManager().currentUser;

        final incoming = invitations.where((i) => i.recipientUsername == currentUser!.username).toList();
        final outgoing = invitations.where((i) => i.senderUsername == currentUser!.username).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(translate('general_invitations')),
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
                  icon: const Icon(Icons.settings)),
            ],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: translate('incoming')),
                Tab(text: translate('outgoing')),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildInvitationList(incoming, true),
              _buildInvitationList(outgoing, false),
            ],
          ),
        );
      }
    );
  }

  Widget _buildInvitationList(List<CarUserInvitation> invitations, bool isIncoming) {
    final accepted = invitations.where((i) => i.isAccepted).toList();
    final unaccepted = invitations.where((i) => !i.isAccepted).toList();

    return RefreshIndicator(
      onRefresh: refresh,
      child: invitations.isEmpty
          ? Stack(
              children: <Widget>[
                ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                ),
                Center(child: Text(translate('no_invitations'))),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (unaccepted.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: DividerWithText(
                        text: translate('pending_invitations'),
                        lineColor: Colors.grey,
                        textColor: Theme.of(context).colorScheme.primary,
                        textSize: 16
                    ),
                  ),
                ...unaccepted.map((invitation) => _buildInvitationListTile(invitation, isIncoming)),
                if (accepted.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: DividerWithText(
                        text: translate('accepted_invitations'),
                        lineColor: Colors.grey,
                        textColor: Theme.of(context).colorScheme.primary,
                        textSize: 16
                    ),
                  ),
                ...accepted.map((invitation) => _buildInvitationListTile(invitation, isIncoming)),
              ],
            ),
    );
  }

  ListTile _buildInvitationListTile(CarUserInvitation invitation, bool isIncoming) {
    if (isIncoming) {
      return ListTile(
          leading: Icon(
            invitation.isAccepted ? Icons.check_circle : Icons.call_received,
            color: invitation.isAccepted ? Theme.of(context).colorScheme.primary : null,
          ),
          trailing: invitation.isAccepted
              ? TextButton.icon(
                  onPressed: () async {
                    await CarUserInvitationManager().delete(invitation);
                    SnackbarNotification.show(MessageType.info, translate('invitation_canceled'));
                  },
                  label: Text(translate("leave")),
                  icon: const Icon(Icons.logout),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () async {
                        await CarUserInvitationManager().accept(invitation.id);
                        SnackbarNotification.show(MessageType.info, translate('invitation_accepted'));
                      },
                      icon: const Icon(Icons.check),
                      style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer),
                    ),
                    IconButton.filledTonal(
                      onPressed: () async {
                        await CarUserInvitationManager().delete(invitation);
                        SnackbarNotification.show(MessageType.info, translate('invitation_rejected'));
                      },
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          foregroundColor: Theme.of(context).colorScheme.onErrorContainer),
                    ),
                  ],
                ),
          title: Text(invitation.senderUsername),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_car),
                  const SizedBox(width: 5),
                  Text(invitation.carUsername)
                ],
              ),
              Text(
                  '''${translate('sent_at')} ${invitation.createdAt.toIso8601String().substring(0, 10)}''')
            ],
          ));
    } else {
      return ListTile(
          leading: Icon(
            invitation.isAccepted ? Icons.check_circle : Icons.call_made,
            color: invitation.isAccepted ? Theme.of(context).colorScheme.primary : null,
          ),
        title: Text(invitation.recipientUsername),
        subtitle: Row(
          children: [
            const Icon(Icons.directions_car),
            const SizedBox(width: 5),
            Text(invitation.carUsername)
          ],
        ),
        trailing: TextButton.icon(
          onPressed: () async {
            // TODO: Confirm dialog
            await CarUserInvitationManager().delete(invitation);
            SnackbarNotification.show(MessageType.info, translate('invitation_canceled'));
          },
          label: Text(invitation.isAccepted ? translate("revoke") : translate("cancel")),
          icon: Icon(invitation.isAccepted ? Icons.person_off_outlined : Icons.close),
          iconAlignment: IconAlignment.start,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        )
      );
    }
  }
}
