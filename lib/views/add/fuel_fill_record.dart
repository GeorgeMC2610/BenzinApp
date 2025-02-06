import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // temporary code so it runs

          // add field checks

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

        },
        icon: const Icon(Icons.add),
        label: const Text("Confirm Add"),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
            minimumSize: const WidgetStatePropertyAll(Size(200, 55),
        )
      ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add Fuel Fill Record"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              const DividerWithText(
                  text: "Required Info",
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
                        hintText: 'in km...',
                        labelText: 'Mileage',
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
                        hintText: 'Cost',
                        labelText: 'Cost',
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
                        hintText: 'lt',
                        labelText: 'Liters',
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

              Text(
                _selectedDate == null ? 'Select a date...' : _selectedDate.toString().substring(0, 10),
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
                            locale: const Locale('ja', 'EN'),
                            lastDate: DateTime.now(),
                            firstDate: DateTime.parse('1897-01-01'),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      label: const Text("Pick a date"),
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
                      label: const Text("Today's date"),
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

              const DividerWithText(
                  text: "Optional Info",
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
                        hintText: 'E.g. "FuelSave 95"',
                        labelText: 'Fuel Type',
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
                        hintText: 'E.g. "Shell" or "bp"',
                        labelText: 'Station',
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
                  hintText: 'Anything useful about this fuel fill...',
                  labelText: 'Comments',
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

}