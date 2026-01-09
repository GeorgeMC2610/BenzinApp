import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/locale_string_converter.dart';
import '../maps/select_location.dart';
import '../shared/buttons/persistent_add_or_edit_button.dart';
import '../shared/divider_with_text.dart';
import '../shared/notification.dart';

class MalfunctionForm extends StatefulWidget {
  const MalfunctionForm({super.key, this.malfunction, this.isViewing = false});

  final Malfunction? malfunction;
  final bool isViewing;

  @override
  State<StatefulWidget> createState() => _MalfunctionFormState();
}

class _MalfunctionFormState extends State<MalfunctionForm> {

  DateTime? _selectedDate, _selectedDateEnded;
  String? _selectedAddress;
  LatLng? _selectedCoordinates;
  double _severity = 3;

  final TextEditingController kmController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  String? kmError, titleError, descriptionError, costError;
  bool _isLoading = false;
  bool _markAsFixed = false;

  @override
  void initState() {
    super.initState();

    if (widget.malfunction != null) {
      kmController.text = widget.malfunction!.kilometersDiscovered.toString();
      titleController.text = widget.malfunction!.title;
      descriptionController.text = widget.malfunction!.description;
      _selectedDate = widget.malfunction!.dateStarted;
      _severity = widget.malfunction!.severity.toDouble();

      if (widget.malfunction!.isFixed()) {
        _markAsFixed = true;
        costController.text = widget.malfunction!.cost!.toString();
        _selectedDateEnded = widget.malfunction!.dateEnded!;
        _selectedAddress = widget.malfunction!.getAddress();
        _selectedCoordinates = widget.malfunction!.getCoordinates();
      }
    }
  }

  void _buttonSubmit() async {
    // validate the fields.
    setState(() {
      kmError = null;
      titleError = null;
      descriptionError = null;
      costError = null;
    });

    bool isValidated = _markAsFixed ? _validateForFixed() : _validateForOngoing();
    if (!isValidated) return;

    final manager = MalfunctionManager();
    if (widget.malfunction == null) {
      final malfunction = Malfunction(
          id: -1, dateStarted: _selectedDate!, description: descriptionController.text.trim(),
          title: titleController.text.trim(), severity: _severity.toInt(),
          kilometersDiscovered: int.parse(kmController.text), dateEnded: _markAsFixed ? _selectedDateEnded : null,
          cost: _markAsFixed ? double.tryParse(costController.text) : null,
          location: _selectedCoordinates == null || !_markAsFixed  ? null : '$_selectedAddress|${_selectedCoordinates!.latitude}, ${_selectedCoordinates!.longitude}'
      );

      setState(() {
        _isLoading = true;
      });
      await manager.create(malfunction);
      setState(() {
        _isLoading = false;
      });

      if (manager.errors.isNotEmpty) {
        _handleErrors(manager);
        return;
      }

      Navigator.pop(context);
      Navigator.pop(context);
    }
    // patch request for new malfunction
    else {
      widget.malfunction!
        ..dateStarted = _selectedDate!
        ..description = descriptionController.text.trim()
        ..title = titleController.text.trim()
        ..severity = _severity.toInt()
        ..kilometersDiscovered = int.parse(kmController.text);

      if (_markAsFixed) {
        widget.malfunction!
            ..dateEnded = _selectedDateEnded
            ..cost = double.tryParse(costController.text)
            ..location = _selectedCoordinates == null ? null : '$_selectedAddress|${_selectedCoordinates!.latitude}, ${_selectedCoordinates!.longitude}';
      }
      else {
        widget.malfunction!
          ..dateEnded = null
          ..cost = null
          ..location = null;
      }

      setState(() {
        _isLoading = true;
      });
      await manager.update(widget.malfunction!);
      setState(() {
        _isLoading = false;
      });

      if (manager.errors.isNotEmpty) {
        _handleErrors(manager);
        return;
      }

      if (widget.isViewing) {
        Navigator.pop(context, widget.malfunction!);
      } else {
        Navigator.pop(context);
      }
    }
  }

  bool _validateForOngoing() {
    String? dateValidator;

    setState(() {
      kmError = _numberValidator(kmController.text);
      titleError = _emptyValidator(titleController.text);
      descriptionError = _emptyValidator(descriptionController.text);
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

    List<String?> mandatoryFields = [dateValidator, kmError, titleError, descriptionError];

    return mandatoryFields.every((validation) => validation == null);
  }

  _handleErrors(MalfunctionManager manager) {
    setState(() {
      kmError = manager.errors['at_km']?.join(', ');
      titleError = manager.errors['title']?.join(', ');
      descriptionError = manager.errors['description']?.join(', ');
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

  bool _validateForFixed() {
    String? dateValidator, endedDateValidator;

    setState(() {
      kmError = _numberValidator(kmController.text);
      titleError = _emptyValidator(titleController.text);
      descriptionError = _emptyValidator(descriptionController.text);
      costError = _numberValidator(costController.text);
      dateValidator = _selectedDate == null ? translate('noDateSelected') : null;
      endedDateValidator = _selectedDateEnded == null ? translate('pleaseSelectAnEndDate') : null;
    });

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // TODO: Convert to new notification.
        SnackBar(
          content: Text(dateValidator!),
        )
      );
    }

    if (_selectedDateEnded == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // TODO: Convert to new notification.
        SnackBar(
          content: Text(endedDateValidator!),
        )
      );
    }

    List<String?> mandatoryFields = [endedDateValidator, kmError, titleError, descriptionError, dateValidator];

    return mandatoryFields.every((validation) => validation == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('addMalfunction')), // TODO: Change to be edit.
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        PersistentAddOrEditButton(
          onPressed: _buttonSubmit,
          isEditing: widget.malfunction != null,
          isLoading: _isLoading,
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              DividerWithText(
                  text: translate('malfunctionData'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onEditingComplete: () async {
                        setState(() {
                          titleError = _emptyValidator(titleController.text);
                        });
                      },
                      textInputAction: TextInputAction.next,
                      controller: kmController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: translate('inKmHint'),
                        errorText: kmError,
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
                    flex: 3,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () async {
                        setState(() {
                          kmError = _numberValidator(kmController.text);
                        });
                      },
                      enabled: !_isLoading,
                      controller: titleController,
                      maxLength: 30,
                      decoration: InputDecoration(
                        hintText: translate('malfunctionTitleHint'),
                        errorText: titleError,
                        errorMaxLines: 4,
                        counterText: '',
                        labelText: '${translate('malfunctionTitle')} *',
                        prefixIcon: const Icon(Icons.next_plan_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              TextField(
                keyboardType: TextInputType.multiline,
                onEditingComplete: () async {
                  setState(() {
                    descriptionError = _emptyValidator(descriptionController.text);
                  });
                },
                minLines: 2,
                maxLines: 10,
                maxLength: 2048,
                enabled: !_isLoading,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: translate('descriptionHintMalfunction'),
                  labelText: '${translate('description2')} *',
                  errorText: descriptionError,
                  errorMaxLines: 4,
                  prefixIcon: const Icon(Icons.comment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '${translate('malfunctionSeverity')}*:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: _severity,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _severity.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _severity = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(translate('severityLowest'), style: const TextStyle(fontSize: 12)),
                        Text(translate('severityHighest'), style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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
                  ),
                ],
              ),

              // Checkbox only appears when the malfunction is not being edited
              Row(
                children: [
                  Checkbox(
                      value: _markAsFixed,
                      onChanged: (value) {
                        setState(() {
                          _markAsFixed = value!;
                        });
                      }
                  ),
                  Text(translate('iFixedThisMalfunction'))
                ],
              ),

              !_markAsFixed && _getMalfunctionStatus() ? Text(
                translate('uncheckingTheBox'),
                style: Theme.of(context).textTheme.labelLarge
              ) : const SizedBox(),

              _markAsFixed ? _editForm() : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  bool _getMalfunctionStatus() {
    if (widget.malfunction == null) {
      return false;
    }

    return widget.malfunction!.isFixed();
  }

  Widget _editForm() {
    return Column(
      children: [
        const SizedBox(height: 10),

        DividerWithText(
            text: translate('repairData'),
            lineColor: Colors.grey,
            textColor: Theme.of(context).colorScheme.primary,
            textSize: 16
        ),

        const SizedBox(height: 20),


        TextField(
          keyboardType: TextInputType.number,
          controller: costController,
          onEditingComplete: () async {
            setState(() {
              costError = _numberValidator(costController.text);
            });
          },
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: translate('repairCostHint'),
            errorText: costError,
            errorMaxLines: 4,
            labelText: '${translate('repairCost')} *',
            prefixIcon: const Icon(Icons.euro),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // DATE ENDED
        AutoSizeText(
          maxLines: 1,
          _selectedDateEnded == null ?
          '${translate('malfunctionEnded')} *' :
          LocaleStringConverter.dateShortDayMonthYearString(context, _selectedDateEnded!),
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),

        // DATE ENDED PICKER
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer
                ),
                onPressed: _isLoading ? null : () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    lastDate: DateTime.now(),
                    firstDate: DateTime.parse('1886-29-01'),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDateEnded = pickedDate;
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
                    _selectedDateEnded = DateTime.now();
                  });
                },
                label: AutoSizeText(maxLines: 1, translate('todayDate'), minFontSize: 10),
                icon: const Icon(Icons.more_time_rounded),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryFixedVariant
                ),
              ),
            ),
          ],
        ),

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
      ],
    );
  }

  String? _numberValidator(String field) {
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

  String? _emptyValidator(String field) {
    if (field.isEmpty || field == '') {
      return translate('cannotBeEmpty');
    }

    return null;
  }
}