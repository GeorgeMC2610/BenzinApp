import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFuelFillRecord extends StatefulWidget {
  const AddFuelFillRecord({super.key});

  @override
  State<AddFuelFillRecord> createState() => _AddFuelFillRecordState();
}

class _AddFuelFillRecordState extends State<AddFuelFillRecord> {

  DateTime? _selectedDate;
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _literController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _mileageValidator, _costValidator, _literValidator;

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

          if (_mileageValidator != null || _costValidator != null || _literValidator != null) {
            return;
          }

          // when the field checks pass, send the request.

          FuelFillRecord record = FuelFillRecord(
              id: 19,
              dateTime: _selectedDate!,
              liters: double.parse(_literController.text),
              cost: double.parse(_costController.text),
              kilometers: double.parse(_mileageController.text),
              fuelType: _fuelTypeController.text,
              gasStation: _stationController.text,
              comments: _commentsController.text,
          );

          setState(() {
            DataHolder.addFuelFill(record);
          });

          Navigator.of(context).pop();

        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.confirmAdd),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
            minimumSize: const WidgetStatePropertyAll(Size(200, 55),
        )
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.addFuelFillRecord),
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
                _selectedDate == null ? AppLocalizations.of(context)!.selectADate : _selectedDate.toString().substring(0, 10),
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