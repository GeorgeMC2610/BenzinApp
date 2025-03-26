import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class FuelFillRecordForm extends StatefulWidget {
  const FuelFillRecordForm({super.key, this.fuelFillRecord, this.viewingRecord});

  final FuelFillRecord? fuelFillRecord;
  final bool? viewingRecord;

  @override
  State<FuelFillRecordForm> createState() => _FuelFillRecordFormState();
}

class _FuelFillRecordFormState extends State<FuelFillRecordForm> {

  DateTime? _selectedDate;
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _literController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _mileageValidator, _costValidator, _literValidator;

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

      _stationController.text = record.gasStation ?? '';
      _fuelTypeController.text = record.fuelType ?? '';
      _commentsController.text = record.comments ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // temporary code so it runs
          // add field checks
          setState(() {
            _mileageValidator = _validator(_mileageController.text);
            _costValidator = _validator(_costController.text);
            _literValidator = _validator(_literController.text);
          });

          if (_selectedDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.noDateSelected),
              )
            );
          }

          if (_mileageValidator != null || _costValidator != null || _literValidator != null || _selectedDate == null) {
            return;
          }

          setState(() {
            _isLoading = true;
          });

          var client = http.Client();
          var uriString = '${DataHolder.destination}/fuel_fill_record';

          if (widget.fuelFillRecord == null) {
            var uri = Uri.parse(uriString);
            client.post(
              uri,
              headers: {
                'Authorization': TokenManager().token!,
              },
              body: {
                  'lt': _literController.text,
                  'km': _mileageController.text,
                  'cost_eur': _costController.text,
                  'filled_at': _selectedDate!.toIso8601String().substring(0, 10),
                  'notes': _commentsController.text.trim().isEmpty ? '' : _commentsController.text.trim(),
                  'station': _stationController.text.trim().isEmpty ? '' : _stationController.text.trim(),
                  'fuel_type': _fuelTypeController.text.trim().isEmpty ? '' : _fuelTypeController.text.trim()
              }
            ).whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            }).then((response) {
              var jsonResponse = jsonDecode(response.body);
              var fuelFill = FuelFillRecord.fromJson(jsonResponse["fuel_fill"]);
              DataHolder.addFuelFill(fuelFill);
              Navigator.pop(context);
            });
          }
          else {
            var uri = Uri.parse('$uriString/${widget.fuelFillRecord!.id}');
            client.put(
                uri,
                headers: {
                  'Authorization': TokenManager().token!,
                },
                body: {
                  'lt': _literController.text,
                  'km': _mileageController.text,
                  'cost_eur': _costController.text,
                  'filled_at': _selectedDate!.toIso8601String().substring(0, 10),
                  'notes': _commentsController.text.trim().isEmpty ? '' : _commentsController.text.trim(),
                  'station': _stationController.text.trim().isEmpty ? '' : _stationController.text.trim(),
                  'fuel_type': _fuelTypeController.text.trim().isEmpty ? '' : _fuelTypeController.text.trim()
                }
            ).whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            }).then((response) {

              if (response.statusCode == 204) {
                client.get(
                  uri,
                  headers: {
                    'Authorization': TokenManager().token!,
                  },
                ).then((response) {
                  var jsonObject = jsonDecode(response.body);
                  var fuelFill = FuelFillRecord.fromJson(jsonObject);
                  DataHolder.setFuelFill(fuelFill);
                  Navigator.pop(context);

                  if (widget.viewingRecord == null) return;
                  if (widget.viewingRecord!) {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewFuelFillRecord(record: fuelFill),
                        )
                    );
                  }
                });
              }
            });
          }
        },
        icon: Icon(
          widget.fuelFillRecord == null ?
            Icons.add : Icons.check
        ),
        label: Text(
            widget.fuelFillRecord == null ?
            AppLocalizations.of(context)!.confirmAdd :
            AppLocalizations.of(context)!.confirmEdit
        ),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
            minimumSize: const WidgetStatePropertyAll(Size(200, 55),
        )
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.fuelFillRecord == null?
          AppLocalizations.of(context)!.addFuelFillRecord :
          AppLocalizations.of(context)!.editFuelFillRecord
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              DividerWithText(
                  text: AppLocalizations.of(context)!.requiredInfo,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 13
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mileageController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.inKmHint,
                        labelText: AppLocalizations.of(context)!.mileage,
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
                      controller: _costController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.costHint,
                        labelText: AppLocalizations.of(context)!.cost2,
                        errorText: _costValidator,
                        prefixIcon: const Icon(Icons.euro_symbol_sharp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: TextField(
                      controller: _literController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.litersHint,
                        labelText: AppLocalizations.of(context)!.liters2,
                        errorText: _literValidator,
                        prefixIcon: const Icon(Icons.water_drop),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30),

              AutoSizeText(
                maxLines: 1,
                _selectedDate == null ?
                    AppLocalizations.of(context)!.selectADate :
                    LocaleStringConverter.dateShortDayMonthYearString(context, _selectedDate!),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
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
                      onPressed: () {
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

              const SizedBox(height: 15),

              DividerWithText(
                  text: AppLocalizations.of(context)!.optionalInfo,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 13
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _fuelTypeController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.fuelTypeHint,
                        labelText: AppLocalizations.of(context)!.fuelType,
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
                      enabled: !_isLoading,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.stationHint,
                        labelText: AppLocalizations.of(context)!.station,
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
                  hintText: AppLocalizations.of(context)!.commentsHint,
                  labelText: AppLocalizations.of(context)!.comments2,
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

  String? _validator(String field) {

    if (field.isEmpty || field == '') {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    if (double.parse(field) < 0) {
      return AppLocalizations.of(context)!.cannotBeNegative;
    }

    return null;
  }

}