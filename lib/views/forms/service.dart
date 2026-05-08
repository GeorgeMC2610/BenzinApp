import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:benzinapp/views/shared/dual_numeric_up_down_form.dart';
import 'package:benzinapp/views/shared/numeric_up_down_form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../maps/select_location.dart';
import '../shared/buttons/persistent_add_or_edit_button.dart';
import '../shared/notification.dart';

class ServiceForm extends StatefulWidget {
  const ServiceForm({super.key, this.service, this.isViewing = false});

  final Service? service;
  final bool isViewing;

  @override
  State<StatefulWidget> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {

  DateTime? _selectedDate, _selectedNextDate;
  String? _selectedAddress;
  LatLng? _selectedCoordinates;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController nextKmController = TextEditingController();

  bool _isLoading = false;
  String? costError, kmError, nextKmError, descError;

  @override
  void initState() {
    super.initState();

    if (widget.service != null) {
      kmController.text = widget.service!.kilometersDone.toString();
      nextKmController.text = widget.service!.nextServiceKilometers?.toString() ?? '';
      costController.text = widget.service!.cost?.toString() ?? '';
      descriptionController.text = widget.service!.description;
      _selectedNextDate = widget.service!.nextServiceDate;
      _selectedDate = widget.service!.dateHappened;
      _selectedAddress = widget.service!.getAddress();
      _selectedCoordinates = widget.service!.getCoordinates();
    }
    else {
      final previousFuelFill = FuelFillRecordManager().local?.firstOrNull;
      kmController.text = previousFuelFill?.totalKilometers?.toString() ?? '';
      nextKmController.text = previousFuelFill?.totalKilometers?.toString() ?? '';
      _selectedDate = DateTime.now();
    }
  }

  bool _validateAll() {
    String? dateValidator;

    setState(() {
      descError = _emptyValidator(descriptionController.text);
      kmError = _validator(kmController.text);
      costError = _validator(costController.text);
      nextKmError = _numValidator(nextKmController.text);
      dateValidator = _selectedDate == null ? translate('noDateSelected') : null;
    });

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // TODO: Convert to new notification.
          SnackBar(
            content: Text(dateValidator!),
          )
      );
    }

    List<String?> mandatoryFields = [dateValidator, kmError, costError, descError, nextKmError];

    return mandatoryFields.every((validation) => validation == null);
  }

  void _buttonSubmit() async {
    setState(() {
      descError = null;
      kmError = null;
      costError = null;
      nextKmError = null;
    });

    bool isValidated = _validateAll();
    if (!isValidated) return;

    // all validations have passed here
    // add-service form
    final manager = ServiceManager();
    if (widget.service == null) {
      final service = Service(
          id: -1, kilometersDone: int.parse(kmController.text),
          description: descriptionController.text.trim(), dateHappened: _selectedDate!,
          cost: double.parse(costController.text), nextServiceKilometers: int.tryParse(nextKmController.text),
          nextServiceDate: _selectedNextDate
      );

      setState(() {
        _isLoading  = true;
      });
      await manager.create(service);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      // server errors from back-end
      if (manager.errors.isNotEmpty) {
        _handleErrors(manager);
        return;
      }

      SnackbarNotification.show(
        MessageType.success,
        translate('successfullyAddedService'),
      );

      Navigator.pop(context);
      Navigator.pop(context);
    }
    // edit-service form
    else {
      widget.service!.kilometersDone = int.parse(kmController.text);
      widget.service!.description = descriptionController.text.trim();
      widget.service!.dateHappened = _selectedDate!;
      widget.service!.cost = double.parse(costController.text);
      widget.service!.nextServiceKilometers = int.tryParse(nextKmController.text);
      widget.service!.nextServiceDate = _selectedNextDate;

      setState(() {
        _isLoading  = true;
      });
      await manager.update(widget.service!);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      // server errors from back-end
      if (manager.errors.isNotEmpty) {
        _handleErrors(manager);
        return;
      }

      SnackbarNotification.show(
        MessageType.success,
        translate('successfullyUpdatedService'),
      );

      if (widget.isViewing) {
        Navigator.pop(context, widget.service!);
      }
      else {
        Navigator.pop(context);
      }
    }
  }

  _handleErrors(ServiceManager manager) {
    setState(() {
      kmError = manager.errors['at_km']?.join(', ');
      descError = manager.errors['description']?.join(', ');
      costError = manager.errors['cost_eur']?.join(', ');
    });

    if (manager.errors.containsKey('base')) {
      SnackbarNotification.show(
        MessageType.danger,
        manager.errors['base']!.join(', '),
      );
    }
    else if (manager.errors.containsKey('error')) {
      SnackbarNotification.show(
        MessageType.danger,
        manager.errors['error']!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: widget.service != null ? Text(translate('editService')) :
          Text(translate('addService')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        PersistentAddOrEditButton(
          onPressed: _buttonSubmit,
          isEditing: widget.service != null,
          isLoading: _isLoading,
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              DividerWithText(
                  text: translate('serviceInfo'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              TextField(
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                enabled: !_isLoading,
                minLines: 2,
                maxLines: 10,
                maxLength: 1024,
                decoration: InputDecoration(
                  errorText: descError,
                  errorMaxLines: 4,
                  hintText: translate('descriptionHint'),
                  labelText: '${translate('description2')} *',
                  prefixIcon: const Icon(FontAwesomeIcons.wrench),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              DualNumericUpDownForm(
                controller1: kmController,
                controller2: costController,
                title: translate('serviceInfo'),
                fieldTitle1: '${translate('serviceMileage2')} *',
                fieldTitle2: '${translate('cost2')} *',
                error1: kmError,
                error2: costError,
                icon: const Icon(Icons.build_circle_outlined, size: 40),
                quickValues: const [-10, -1, 1, 10, 100, 500],
                showUpDownButtons: false,
              ),

              const SizedBox(height: 25),

              AutoSizeText(
                maxLines: 1,
                _selectedDate == null ?
                '${translate('selectADate')} *' :
                LocaleStringConverter.dateShortDayMonthYearString(context, _selectedDate!),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          lastDate: DateTime.now(),
                          firstDate: DateTime.parse('1886-29-01'),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      label: Text(translate('pickADate')),
                      icon: const Icon(Icons.date_range),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _selectedDate = DateTime.now();
                        });
                      },
                      label: AutoSizeText(maxLines: 1, translate('todayDate'), minFontSize: 10),
                      icon: const Icon(Icons.more_time_rounded),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
                          foregroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant
                      ),
                    ),
                  )
                ],
              ),

              // === SELECT LOCATION === //
              const SizedBox(height: 25),

              AutoSizeText(
                maxLines: 1,
                _selectedAddress == null ?
                translate('selectLocation') :
                _selectedAddress!,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () async {
                        var data = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SelectLocationOnMaps(
                              address: _selectedAddress,
                              coordinates: _selectedCoordinates,
                            )
                          )
                        );

                        if (data == null) {
                          return;
                        }

                        setState(() {
                          _selectedAddress = data["address"]!;
                          _selectedCoordinates = data["coordinates"]!;
                        });
                      },
                      label: Text(translate('pickAPlace')),
                      icon: const Icon(Icons.map),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading || _selectedAddress == null ? null : () {
                        setState(() {
                          _selectedAddress = null;
                          _selectedCoordinates = null;
                        });
                      },
                      label: AutoSizeText(maxLines: 1, translate('removeLocation'), minFontSize: 10),
                      icon: const Icon(Icons.cancel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              DividerWithText(
                  text: translate('nextServiceInfo'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              NumericUpDownForm(
                controller: nextKmController,
                showUpDownButtons: true,
                hint: null,
                bigTitle: false,
                error: nextKmError,
                quickValues: const [-1000, -100, -10, 10, 100, 500, 1000, 10000],
                title: translate('nextServiceMileage'),
                metric: translate('km'),
                icon: const Icon(Icons.speed, size: 40),
              ),

              const SizedBox(height: 15),

              AutoSizeText(
                maxLines: 1,
                _selectedNextDate == null ?
                translate('selectNextServiceDate') :
                LocaleStringConverter.dateShortDayMonthYearString(context, _selectedNextDate!),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          lastDate: DateTime.parse('2100-29-01'),
                          firstDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedNextDate = pickedDate;
                          });
                        }
                      },
                      label: Text(translate('pickADate')),
                      icon: const Icon(Icons.date_range),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _selectedNextDate = null;
                        });
                      },
                      label: AutoSizeText(maxLines: 1, translate('discard'), minFontSize: 10),
                      icon: const Icon(Icons.delete_forever),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.errorContainer,
                          foregroundColor: Theme.of(context).colorScheme.onErrorContainer
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }

  String? _validator(String field) {
    if (field.isEmpty || field == '') {
      return translate('cannotBeEmpty');
    }

    if (double.tryParse(field) == null) {
      return translate('invalidNumber');
    }

    if (double.parse(field) < 0) {
      return translate('cannotBeNegative');
    }

    return null;
  }

  String? _numValidator(String field) {
    if (field.isEmpty || field == '') {
      return null;
    }

    if (double.tryParse(field) == null) {
      return translate('invalidNumber');
    }

    if (double.parse(field) < 0) {
      return translate('cannotBeNegative');
    }

    return null;
  }

  String? _emptyValidator(String field) {
    if (field.isEmpty || field == '') {
      return translate('cannotBeEmpty');
    }

    return null;
  }

}
