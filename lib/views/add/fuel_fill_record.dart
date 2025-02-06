import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {},
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

              const SizedBox(height: 25),

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
                            lastDate: DateTime.now(),
                            firstDate: DateTime.parse('1897-01-01')
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


              const DividerWithText(
                  text: "Optional Info",
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 13
              ),
              
              const SizedBox(height: 70)

            ],
          ),
        ),
      ),
    );
  }

}