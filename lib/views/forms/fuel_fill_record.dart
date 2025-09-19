import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/views/shared/buttons/persistent_add_or_edit_button.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FuelFillRecordForm extends StatefulWidget {
  const FuelFillRecordForm({super.key, this.fuelFillRecord, this.viewingRecord = false});

  final FuelFillRecord? fuelFillRecord;
  final bool viewingRecord;

  @override
  State<FuelFillRecordForm> createState() => _FuelFillRecordFormState();
}

class _FuelFillRecordFormState extends State<FuelFillRecordForm> {

  DateTime? _selectedDate;
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _totalMileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _literController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  final FocusNode _mileageFocusNode = FocusNode();
  final FocusNode _costFocusNode = FocusNode();
  final FocusNode _literFocusNode = FocusNode();
  final FocusNode _totalMileageFocusNode = FocusNode();

  String? _mileageValidator, _totalMileageValidator, _costValidator, _literValidator;

  bool _isLoading = false;

  // this function is applied when the user clicks "edit" instead of "add".
  // in that case, the fuel fill record is passed in the widget above.
  // and all its data are loaded in the fields.
  @override
  void initState() {
    super.initState();
    if (widget.fuelFillRecord != null) {
      FuelFillRecord record = widget.fuelFillRecord!;

      _mileageController.text = record.kilometers.toString();
      _costController.text = record.cost.toString();
      _literController.text = record.liters.toString();
      _selectedDate = record.dateTime;

      _totalMileageController.text = record.totalKilometers?.toString() ?? '';
      _stationController.text = record.gasStation ?? '';
      _fuelTypeController.text = record.fuelType ?? '';
      _commentsController.text = record.comments ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        PersistentAddOrEditButton(
          onPressed: onButtonPressed,
          isEditing: widget.fuelFillRecord != null,
          isLoading: _isLoading,
        )
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.fuelFillRecord == null?
          translate('addFuelFillRecord') :
          translate('editFuelFillRecord')
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DividerWithText(
                  text: translate('requiredInfo'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 13
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mileageController,
                      focusNode: _mileageFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () async {
                        if (_totalMileageController.text.isEmpty && _mileageController.text.isNotEmpty) {
                          var lastRecord = FuelFillRecordManager().local.firstOrNull;
                          if (lastRecord?.totalKilometers != null) {
                            var currentKilometers = double.tryParse(_mileageController.text);
                            if (currentKilometers != null) {
                              var newTotalKilometers = currentKilometers.round() + lastRecord!.totalKilometers!;
                              setState(() {
                                _totalMileageController.text = newTotalKilometers.toString();
                              });
                            }
                          }

                          FocusScope.of(context).requestFocus(_costFocusNode);
                        }
                        else {
                          FocusScope.of(context).requestFocus(_totalMileageFocusNode);
                        }

                        setState(() {
                          _mileageValidator = _validator(_mileageController.text);
                        });
                      },
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: translate('inKmHint'),
                        labelText: '${translate('mileage')} *',
                        errorText: _mileageValidator,
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
                      controller: _totalMileageController,
                      textInputAction: TextInputAction.next,
                      focusNode: _totalMileageFocusNode,
                      onEditingComplete: () async {
                        if (_mileageController.text.isEmpty && _totalMileageController.text.isNotEmpty) {
                          var lastRecord = FuelFillRecordManager().local.firstOrNull;
                          if (lastRecord?.totalKilometers != null) {
                            var currentKilometers = double.tryParse(_totalMileageController.text);
                            if (currentKilometers != null) {
                              var newKilometers = currentKilometers - lastRecord!.totalKilometers!;
                              setState(() {
                                _mileageController.text = newKilometers.toString();
                              });
                            }
                          }

                          FocusScope.of(context).requestFocus(_costFocusNode);
                        }
                        else {
                          FocusScope.of(context).requestFocus(_totalMileageFocusNode);
                        }

                        setState(() {
                          _mileageValidator = _validator(_mileageController.text);
                        });
                      },
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: translate('inKmHint'),
                        labelText: translate('totalMileage'),
                        errorText: _totalMileageValidator,
                        prefixIcon: const Icon(FontAwesomeIcons.carSide, size: 15,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.475,
                child: TextField(
                  controller: _costController,
                  focusNode: _costFocusNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_literFocusNode);
                    setState(() {
                      _costValidator = _validator(_costController.text);
                    });
                  },
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: translate('costHint'),
                    labelText: '${translate('cost2')} *',
                    errorText: _costValidator,
                    prefixIcon: const Icon(Icons.euro_symbol_sharp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.475,
                  child: TextField(
                  controller: _literController,
                  focusNode: _literFocusNode,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    setState(() {
                      _literValidator = _validator(_literController.text);
                    });
                  },
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: translate('litersHint'),
                    labelText: '${translate('liters2')} *',
                    errorText: _literValidator,
                    prefixIcon: const Icon(Icons.water_drop),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: AutoSizeText(
                  maxLines: 1,
                  _selectedDate == null ?
                  translate('selectADate') :
                  LocaleStringConverter.dateShortDayMonthYearString(context, _selectedDate!),
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

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

              const SizedBox(height: 15),

              DividerWithText(
                  text: translate('optionalInfo'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 13
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fuelTypeController,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: translate('fuelTypeHint'),
                        labelText: translate('fuelType'),
                        prefixIcon: const Icon(Icons.gas_meter),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: TextField(
                      controller: _stationController,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: translate('stationHint'),
                        labelText: translate('station'),
                        prefixIcon: const Icon(Icons.local_gas_station),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 15),

              TextField(
                keyboardType: TextInputType.multiline,
                enabled: !_isLoading,
                controller: _commentsController,
                minLines: 2,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: translate('commentsHint'),
                  labelText: translate('comments2'),
                  prefixIcon: const Icon(Icons.comment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 70)

            ],
          ),
        ),
      ),
    );
  }

  onButtonPressed() async {
    // add field checks
    // TODO: Add those check when the user exits the fields.
    setState(() {
      _mileageValidator = _validator(_mileageController.text);
      _costValidator = _validator(_costController.text);
      _literValidator = _validator(_literController.text);
    });

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // TODO: Convert to new notification.
          SnackBar(
            content: Text(translate('noDateSelected')),
          )
      );
    }

    if (_mileageValidator != null || _costValidator != null || _literValidator != null || _selectedDate == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    double liters = double.parse(_literController.text);
    double cost = double.parse(_costController.text);
    double kilometers = double.parse(_mileageController.text);

    String? comments = _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim();
    String? station = _stationController.text.trim().isEmpty ? null : _stationController.text.trim();
    String? fuelType = _fuelTypeController.text.trim().isEmpty ? null : _fuelTypeController.text.trim();
    int? totalKm = int.tryParse(_totalMileageController.text);

    // if the record is non-existent, then ADD is enabled
    if (widget.fuelFillRecord == null) {
      var newRecord = FuelFillRecord(
        id: -1, dateTime: _selectedDate!, liters: liters,
        cost: cost, kilometers: kilometers, comments: comments,
        gasStation: station, fuelType: fuelType, totalKilometers: totalKm,
      );

      await FuelFillRecordManager().create(newRecord);
      SnackbarNotification.show(MessageType.success, translate('successfullyAddedFuelFill'));
      Navigator.pop(context);
    }
    // otherwise EDIT is enabled.
    else {
      // when editing, we want the patch request to be sent, and then
      // checkout a new view with the new data.
      widget.fuelFillRecord!.liters = liters;
      widget.fuelFillRecord!.cost = cost;
      widget.fuelFillRecord!.kilometers = kilometers;
      widget.fuelFillRecord!.comments = comments;
      widget.fuelFillRecord!.gasStation = station;
      widget.fuelFillRecord!.fuelType = fuelType;
      widget.fuelFillRecord!.totalKilometers = totalKm;
      widget.fuelFillRecord!.dateTime = _selectedDate!;

      await FuelFillRecordManager().update(widget.fuelFillRecord!);
      SnackbarNotification.show(MessageType.success, translate('successfullyUpdatedFuelFill'));
      if (widget.viewingRecord) {
        Navigator.pop(context, widget.fuelFillRecord);
      }
      else {
        Navigator.pop(context);
      }
    }
  }

  String? _validator(String field) {

    if (field.isEmpty || field == '') {
      return translate('cannotBeEmpty');
    }

    if (double.parse(field) < 0) {
      return translate('cannotBeNegative');
    }

    return null;
  }

}