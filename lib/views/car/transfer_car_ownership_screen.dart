import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/car.dart';
import 'package:benzinapp/services/classes/car_user_invitation.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/car_user_invitation_manager.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TransferCarOwnershipScreen extends StatefulWidget {
  const TransferCarOwnershipScreen({super.key, required this.car});

  final Car car;

  @override
  State<TransferCarOwnershipScreen> createState() =>
      _TransferCarOwnershipScreenState();
}

class _TransferCarOwnershipScreenState extends State<TransferCarOwnershipScreen> {

  final TextEditingController _carNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _isSending = false;
  CarUserInvitation? _selectedInvitation;

  @override
  void dispose() {
    _carNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('transferCarOwnershipAppBar')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: buttonLocked() ? null : _transferOwnership,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
              label: Text(
                translate('transferCarOwnershipButton'),
                style: TextStyle(
                    fontSize: 18,
                    color: buttonLocked()
                        ? null
                        : Theme.of(context).colorScheme.onErrorContainer),
              ),
              iconAlignment: IconAlignment.start,
              icon: _isSending
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        value: null,
                        strokeWidth: 5,
                        strokeCap: StrokeCap.square,
                      ),
                    )
                  : Icon(Icons.swap_horiz, color: buttonLocked() ? null : Theme.of(context).colorScheme.onErrorContainer),
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              Center(
                child: AutoSizeText(
                  translate('transferCarOwnershipTitle'),
                  minFontSize: 20,
                  maxLines: 1,
                  maxFontSize: 35,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  translate('transferCarOwnershipSubtitle'),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        translate('transferCarOwnershipWarning'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  translate('transferCarOwnershipSelectUserTitle'),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<CarUserInvitation>(
                decoration: InputDecoration(
                  labelText: translate('transferCarOwnershipSelectUser'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                value: _selectedInvitation,
                onChanged: (CarUserInvitation? newValue) {
                  setState(() {
                    _selectedInvitation = newValue;
                  });
                },
                dropdownColor: Theme.of(context).colorScheme.surfaceContainerLow,
                icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface),

                borderRadius: BorderRadius.circular(15), // Rounded corners
                isExpanded: true,
                items: CarUserInvitationManager().local?.where((invitation) => invitation.carId == widget.car.id && invitation.isAccepted).toList().map<DropdownMenuItem<CarUserInvitation>>(
                        (CarUserInvitation invitation) {
                      return DropdownMenuItem<CarUserInvitation>(
                        value: invitation,
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 10),
                            Text(invitation.recipientUsername),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              if (_selectedInvitation != null)
                Column(
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: AutoSizeText(
                        translate('transferCarOwnershipDangerZone'),
                        minFontSize: 20,
                        maxLines: 1,
                        maxFontSize: 25,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        translate('transferCarOwnershipRetypeUsernameTitle', args: { 'username': _selectedInvitation!.recipientUsername }),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enabled: !_isSending,
                      controller: _userNameController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: _selectedInvitation!.recipientUsername,
                        labelText: translate('transferCarOwnershipRetypeUsername'),
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Text(
                        translate('transferCarOwnershipRetypeCarNameTitle', args: { 'carName': _selectedInvitation!.carUsername }),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      enabled: !_isSending,
                      controller: _carNameController,
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: widget.car.username,
                        labelText: translate('transferCarOwnershipRetypeCarName'),
                        prefixIcon: const Icon(Icons.directions_car),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool buttonLocked() =>
      _isSending ||
      _selectedInvitation == null ||
      _userNameController.text != _selectedInvitation!.recipientUsername ||
      _carNameController.text != widget.car.username;

  void _transferOwnership() async {
    setState(() {
      _isSending = true;
    });

    try {
      await CarManager().transferOwnership(widget.car, _userNameController.text, _carNameController.text);
      if (mounted) {
        if (CarManager().errors.isEmpty) {
          SnackbarNotification.show(MessageType.success,
              translate('carTransferredSuccessfully'));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Dashboard()),
                  (Route<dynamic> route) => false);
        }
        else {
          if (CarManager().errors.containsKey('base')) {
            SnackbarNotification.show(
                MessageType.danger, CarManager().errors["base"]!.join(', '));
          }
          else if (CarManager().errors.containsKey('error')) {
            SnackbarNotification.show(
                MessageType.danger, CarManager().errors['error']);
          }
        }
      }
    } catch (e) {
      SnackbarNotification.show(
          MessageType.danger, translate('carTransferFailed'));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}
