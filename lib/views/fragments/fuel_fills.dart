import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/cards/fuel_fill_card.dart';
import 'package:benzinapp/views/shared/year_month_fuel_fill_groups.dart';
import 'package:flutter/material.dart';

class FuelFillsFragment extends StatefulWidget {
  const FuelFillsFragment({super.key});

  @override
  State<FuelFillsFragment> createState() => _FuelFillsFragmentState();
}

class _FuelFillsFragmentState extends State<FuelFillsFragment> {

  @override
  Widget build(BuildContext context) {
    return DataHolder.getFuelFillRecords().isEmpty?
    Center(
      // TODO: Fill this with an icon later.
    )
    :
    SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // BUTTON FILTERS AND SEARCH
              Row(
                children: [

                  FilledButton.icon (
                    onPressed: () {},
                    label: const Text("Filters"),
                    icon: const Icon(Icons.filter_list),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                      child: TextField(
                        style: const TextStyle(
                          height: 1
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          hintStyle: const TextStyle(color: Colors.grey),
                          hintText: "Search in fuel fills...",
                          fillColor: Theme.of(context).colorScheme.onSecondary
                        ),
                      ),
                  )

                ],
              ),

              const SizedBox(height: 5),

              // TOTAL RECORDS
              Text('${DataHolder.getFuelFillRecords().length} Total Records'),

              const SizedBox(height: 10),

              const YearMonthFuelFillGroups(),

              const SizedBox(height: 75)

            ],
          ),
        )
    );
  }

}