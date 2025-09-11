import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/maps/select_location.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  String? _costValidator, _kmValidator, _nextKmValidator, _descValidator;

  bool _validateAll() {
    String? dateValidator;

    setState(() {
      _descValidator = _emptyValidator(descriptionController.text);
      _kmValidator = _validator(kmController.text);
      _costValidator = _validator(costController.text);
      _nextKmValidator = _numValidator(nextKmController.text);
      dateValidator = _selectedDate == null ? AppLocalizations.of(context)!.noDateSelected : null;
    });

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dateValidator!),
          )
      );
    }

    List<String?> mandatoryFields = [dateValidator, _kmValidator, _costValidator, _descValidator, _nextKmValidator];

    return mandatoryFields.every((validation) => validation == null);
  }

  void _buttonSubmit() async {
    // add field checks
    bool isValidated = _validateAll();
    if (!isValidated) return;

    // all validations have passed here
    setState(() {
      _isLoading  = true;
    });

    // add-service form
    if (widget.service == null) {
      final service = Service(
          id: -1, kilometersDone: int.parse(kmController.text),
          description: descriptionController.text.trim(), dateHappened: _selectedDate!,
          cost: double.parse(costController.text), nextServiceKilometers: int.tryParse(nextKmController.text),
          nextServiceDate: _selectedNextDate
      );

      await ServiceManager().create(service);
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

      await ServiceManager().update(widget.service!);
      if (widget.isViewing) {
        Navigator.pop(context, widget.service!);
      }
      else {
        Navigator.pop(context);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: widget.service != null ? Text(AppLocalizations.of(context)!.editService) :
          Text(AppLocalizations.of(context)!.addService),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _buttonSubmit,
          icon: _isLoading ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 5,
                strokeCap: StrokeCap.square,
              )
          ) : Icon(
              widget.service == null ?
              Icons.add : Icons.check
          ),
          label: widget.service == null ?
          Text(AppLocalizations.of(context)!.confirmAdd) : Text(AppLocalizations.of(context)!.confirmEdit),
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
              minimumSize: const WidgetStatePropertyAll(Size(200, 55),
              )
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              DividerWithText(
                  text: AppLocalizations.of(context)!.serviceInfo,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                onEditingComplete: () {
                  setState(() {
                    _descValidator = _numValidator(descriptionController.text);
                  });
                },
                enabled: !_isLoading,
                minLines: 2,
                maxLines: 10,
                decoration: InputDecoration(
                  errorText: _descValidator,
                  hintText: AppLocalizations.of(context)!.descriptionHint,
                  labelText: '${AppLocalizations.of(context)!.description2} *',
                  prefixIcon: const Icon(FontAwesomeIcons.wrench),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        setState(() {
                          _kmValidator = _validator(kmController.text);
                        });
                      },
                      enabled: !_isLoading,
                      controller: kmController,
                      decoration: InputDecoration(
                        errorText: _kmValidator,
                        hintText: AppLocalizations.of(context)!.serviceMileageHint,
                        labelText: '${AppLocalizations.of(context)!.serviceMileage2} *',
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
                      controller: costController,
                      onEditingComplete: () {
                        setState(() {
                          _costValidator = _validator(costController.text);
                        });
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        errorText: _costValidator,
                        hintText: AppLocalizations.of(context)!.costHint,
                        labelText: '${AppLocalizations.of(context)!.cost2} *',
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
                '${AppLocalizations.of(context)!.selectADate} *' :
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
                      label: Text(AppLocalizations.of(context)!.pickADate),
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
                      label: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.todayDate, minFontSize: 10),
                      icon: const Icon(Icons.more_time_rounded),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).buttonTheme.colorScheme!.primaryFixedDim
                          )
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
                AppLocalizations.of(context)!.selectLocation :
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
                      label: Text(AppLocalizations.of(context)!.pickAPlace),
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
                      label: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.removeLocation, minFontSize: 10),
                      icon: const Icon(Icons.cancel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary
                      ),
                    ),
                  )
                ],
              ),

              // === FIX INFO === //
              const SizedBox(height: 20),

              DividerWithText(
                  text: AppLocalizations.of(context)!.nextServiceInfo,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  setState(() {
                    _nextKmValidator = _numValidator(nextKmController.text);
                  });
                },
                enabled: !_isLoading,
                controller: nextKmController,
                decoration: InputDecoration(
                  errorText: _nextKmValidator,
                  hintText: AppLocalizations.of(context)!.nextServiceMileageHint,
                  labelText: AppLocalizations.of(context)!.nextServiceMileage,
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
                AppLocalizations.of(context)!.selectNextServiceDate :
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
                      label: Text(AppLocalizations.of(context)!.pickADate),
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
                      label: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.removeLocation, minFontSize: 10),
                      icon: const Icon(Icons.cancel),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary
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
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    var isParsed = double.tryParse(field);
    if (isParsed == null) {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    if (isParsed < 0) {
      return AppLocalizations.of(context)!.cannotBeNegative;
    }

    return null;
  }

  String? _numValidator(String field) {
    if (field == '' || field.isEmpty) {
      return null;
    }
    else if (double.parse(field) < 0) {
      return AppLocalizations.of(context)!.cannotBeNegative;
    }

    return null;
  }

  String? _emptyValidator(String field) {
    if (field.isEmpty || field == '') {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    return null;
  }

}