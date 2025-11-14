
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/services/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../services/classes/car_user_invitation.dart';

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

  @override
  Widget build(BuildContext context) {
    final invitations = CarUserInvitationManager().local;
    final currentUser = UserManager().currentUser;

    final incoming = invitations.where((i) => i.recipientUsername == currentUser!.username).toList();
    final outgoing = invitations.where((i) => i.senderUsername == currentUser!.username).toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: translate('incoming')),
            Tab(text: translate('outgoing')),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildInvitationList(incoming, true),
              _buildInvitationList(outgoing, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationList(List<CarUserInvitation> invitations, bool isIncoming) {
    if (invitations.isEmpty) {
      return Center(child: Text(translate('no_invitations')));
    }

    return ListView.builder(
      itemCount: invitations.length,
      itemBuilder: (context, index) {
        final invitation = invitations[index];
        return ListTile(
          title: Text(isIncoming ? invitation.senderUsername : invitation.recipientUsername),
          subtitle: Text(invitation.carId.toString()),
          // TODO: Add actions to accept or decline invitations.
        );
      },
    );
  }
}

