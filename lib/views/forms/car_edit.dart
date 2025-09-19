import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/shared/buttons/persistent_add_or_edit_button.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../shared/notification.dart';

class EditCar extends StatefulWidget {
  const EditCar({super.key});

  @override
  State<StatefulWidget> createState() => _EditCarState();
}

class _EditCarState extends State<EditCar> {

  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  String? manufacturerError, modelError, yearError;
  bool isLoading = false;

  _sendCarEditPayload() async {
    manufacturerError = manufacturerController.text.isEmpty?
    translate('cannotBeEmpty') :
    null;

    modelError = modelController.text.isEmpty?
    translate('cannotBeEmpty') :
    null;

    yearError = yearController.text.isEmpty?
    translate('cannotBeEmpty') :
    null;

    yearError ??= int.parse(yearController.text) < 1886 ?
    translate('carsNotExistingBackThen') :
    null;

    if (manufacturerError != null || modelError != null || yearError != null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    var car = CarManager().car!;
    car.manufacturer = manufacturerController.text;
    car.model = modelController.text;
    car.year = int.parse(yearController.text);

    await CarManager().update(car);

    setState(() {
      isLoading = false;
    });

    SnackbarNotification.show(MessageType.success, translate('successfullyUpdatedCar'));
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    manufacturerController.text = CarManager().car!.manufacturer;
    modelController.text = CarManager().car!.model;
    yearController.text = CarManager().car!.year.toString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(translate('editCar')), // TODO: Translate
    ),
    persistentFooterAlignment: AlignmentDirectional.center,
    persistentFooterButtons: [
      PersistentAddOrEditButton(
          onPressed: _sendCarEditPayload,
          isEditing: true,
          isLoading: isLoading,
      )
    ],
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            DividerWithText(
              text: translate('carDetails'),
              textColor: Theme.of(context).colorScheme.primary,
              textSize: 17,
              barThickness: 3,
              lineColor: Colors.grey,
            ),

            const SizedBox(height: 10),

            TextField(
              controller: manufacturerController,
              keyboardType: TextInputType.text,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                errorText: manufacturerError,
                hintText: translate('carManufacturerHint'),
                labelText: translate('carManufacturer'),
                prefixIcon: const Icon(Icons.car_rental),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Password TextField

            Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: modelController,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      errorText: modelError,
                      hintText: translate('carModelHint'),
                      labelText: translate('carModel'),
                      prefixIcon: const Icon(Icons.car_rental_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 7.5),

                Expanded(
                  child: TextField(
                    controller: yearController,
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      errorText: yearError,
                      hintText: translate('carYearHint'),
                      labelText: translate('carYear'),
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                )

              ],
            ),
          ],
        ),
      ),
    ),
  );

}