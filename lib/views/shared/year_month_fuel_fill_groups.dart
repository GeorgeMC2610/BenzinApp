import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:flutter/material.dart';

import 'cards/fuel_fill_card.dart';

class YearMonthFuelFillGroups extends StatelessWidget {

  const YearMonthFuelFillGroups({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    // YEAR-MONTH
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: DataHolder.getYearMonthFuelFills().entries.map((entry) {
        String yearMonth = entry.key;
        List<FuelFillRecord> records = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // YEAR-MONTH HEADER
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 25),
              child: Text(
                _formatYearMonth(yearMonth),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                "€${records.map((value) => value.cost).reduce((value, element) {
                  return value + element;
                }).toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 12),
              ),
            ),

            // CARD WITH RECORDS
            Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(color: Theme.of(context).highlightColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // List of FuelFillCards
                      ...records.map((record) => Column(
                        children: [
                          FuelFillCard(record: record),
                          if (record != records.last) const Divider(),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );

      }).toList()
    );
  }

  /// Formats "YYYY-MM" into "Month Year"
  String _formatYearMonth(String yearMonth) {
    List<String> parts = yearMonth.split("-");
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    return "${_monthName(month)} $year";
  }

  /// Converts month number to name
  String _monthName(int month) {
    const monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month - 1];
  }
}