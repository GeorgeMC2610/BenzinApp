import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../services/classes/car.dart';

class DeleteCarScreen extends StatefulWidget {
  const DeleteCarScreen({super.key, required this.car});

  final Car car;

  @override
  State<StatefulWidget> createState() => _DeleteCarScreenState();
}

class _DeleteCarScreenState extends State<DeleteCarScreen> {
  final TextEditingController _carNameController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _carNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('deleteCarAppBar')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: buttonLocked() ? null : _deleteCar,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
              ),
              label: Text(
                translate('deleteButton'),
                style: TextStyle(fontSize: 18, color: buttonLocked() ? null : Theme.of(context).colorScheme.onErrorContainer),
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
                  : Icon(Icons.delete, color: buttonLocked() ? null : Theme.of(context).colorScheme.onErrorContainer),
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
                  translate('deleteCarTitle'),
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
                  translate('deleteCarSubtitle'),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  translate('enterCarNameToDelete'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                enabled: !_isSending,
                controller: _carNameController,
                onChanged: (value) {
                  setState(() {});
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: widget.car.username,
                  labelText: translate('carName'),
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
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
                    Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        translate('deleteCarWarning'),
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.error,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool buttonLocked() =>
      _isSending || _carNameController.text != widget.car.username;

  void _deleteCar() async {
    setState(() {
      _isSending = true;
    });

    try {
      final carManager = CarManager();
      await carManager.delete(widget.car, body: { 'username': _carNameController.text });
      if (mounted) {
        SnackbarNotification.show(MessageType.success, translate('carDeletedSuccessfully'));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Dashboard()),
            (Route<dynamic> route) => false);
      }
    }
    catch (e) {
      SnackbarNotification.show(
          MessageType.danger, translate('carDeletionFailed'));
    }
    finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}
