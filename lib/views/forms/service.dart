import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/maps/select_location.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
                onEditingComplete: () {
                  setState(() {
                    descError = _numValidator(descriptionController.text);
                  });
                },
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        setState(() {
                          kmError = _validator(kmController.text);
                        });
                      },
                      enabled: !_isLoading,
                      controller: kmController,
                      decoration: InputDecoration(
                        errorText: kmError,
                        hintText: translate('serviceMileageHint'),
                        errorMaxLines: 4,
                        labelText: '${translate('serviceMileage2')} *',
                        prefixIcon: const Icon(Icons.speed),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: TextField(
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: costController,
                      onEditingComplete: () {
                        setState(() {
                          costError = _validator(costController.text);
                        });
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        errorText: costError,
                        hintText: translate('costHint'),
                        errorMaxLines: 4,
                        labelText: '${translate('cost2')} *',
                        prefixIcon: const Icon(Icons.euro),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ],
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

              // === FIX INFO === //
              const SizedBox(height: 20),

              DividerWithText(
                  text: translate('nextServiceInfo'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              TextField(
                onTapOutside: (value) {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  setState(() {
                    nextKmError = _numValidator(nextKmController.text);
                  });
                },
                enabled: !_isLoading,
                controller: nextKmController,
                decoration: InputDecoration(
                  errorText: nextKmError,
                  errorMaxLines: 4,
                  hintText: translate('nextServiceMileageHint'),
                  labelText: translate('nextServiceMileage'),
                  prefixIcon: const Icon(Icons.next_plan_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
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
                          lastDate: DateTime.parse('2100-01-01'),
                          firstDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
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
                      onPressed: _isLoading || _selectedNextDate == null ? null : () {
                        setState(() {
                          _selectedNextDate = null;
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

    var isParsed = double.tryParse(field);
    if (isParsed == null) {
      return translate('invalidNumber');
    }

    if (isParsed < 0) {
      return translate('cannotBeNegative');
    }

    return null;
  }

  String? _numValidator(String field) {
    if (field == '' || field.isEmpty) {
      return null;
    }

    else if (double.tryParse(field) == null) {
      return translate('invalidNumber');
    }

    else if (double.parse(field) < 0) {
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