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

  Future<void> refresh() async {
    await CarUserInvitationManager().index();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final invitations = CarUserInvitationManager().local;
    final currentUser = UserManager().currentUser;

    final incoming = invitations.where((i) => i.recipientUsername == currentUser!.username).toList();
    final outgoing = invitations.where((i) => i.senderUsername == currentUser!.username).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('general_invitations')),
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

  Widget _buildInvitationList(List<CarUserInvitation> invitations, bool isIncoming) {
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
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];
                return _buildInvitationListTile(invitation, isIncoming);
              },
            ),
    );
  }

  ListTile _buildInvitationListTile(CarUserInvitation invitation, bool isIncoming) {
    if (isIncoming) {
      return ListTile(
        leading: const Icon(Icons.call_received),
        trailing: invitation.isAccepted ?
        TextButton.icon(
          onPressed: () {},
          label: Text("Leave"),
          icon: const Icon(Icons.logout),
          iconAlignment: IconAlignment.end,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        )
            :
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              onPressed: () {}, icon: const Icon(Icons.check),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer
              ),
            ),

            IconButton.filledTonal(
              onPressed: () {}, icon: const Icon(Icons.close),
              style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer
              ),
            ),
          ],
        ),
        title: Text(invitation.senderUsername),
        subtitle: Row(
          children: [
            const Icon(Icons.directions_car),
            const SizedBox(width: 5),
            Text(invitation.carId.toString())
          ],
        ),
      );
    }
    else {
      return ListTile(
        leading: const Icon(Icons.call_made),
        title: Text(invitation.recipientUsername),
        subtitle: Row(
          children: [
            const Icon(Icons.directions_car),
            const SizedBox(width: 5),
            Text(invitation.carId.toString())
          ],
        ),
      );
    }

  }
}
