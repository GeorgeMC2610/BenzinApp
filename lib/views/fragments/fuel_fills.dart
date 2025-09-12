import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/views/shared/year_month_fuel_fill_groups.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FuelFillsFragment extends StatefulWidget {
  const FuelFillsFragment({super.key});

  @override
  State<FuelFillsFragment> createState() => _FuelFillsFragmentState();
}

class _FuelFillsFragmentState extends State<FuelFillsFragment> {

  Widget emptyRecordsBody() => RefreshIndicator(
    onRefresh: refreshFuelFills,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/svg/no_petrol.svg',
                semanticsLabel: 'No Records!',
                width: 200,
              ),

              const SizedBox(height: 40),

              AutoSizeText(
                maxLines: 1,
                translate('noFuelFillRecords'),
                style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    )
  );

  Widget normalBody() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: RefreshIndicator(
      onRefresh: refreshFuelFills,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // BUTTON FILTERS AND SEARCH
            Row(
              children: [

                FilledButton.icon (
                  onPressed: () {},
                  label: Text(translate('filters')),
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
                        hintText: translate('searchInFuelFills'),
                        fillColor: Theme.of(context).colorScheme.onSecondary
                    ),
                  ),
                )

              ],
            ),

            const SizedBox(height: 5),

            // TOTAL RECORDS
            Text(
                fuelFillRecordCount() == 1 ?
                translate('oneRecord') :
                translate('totalRecords', args: {'totalRecords': FuelFillRecordManager().local.length})
            ),

            const SizedBox(height: 10),

            YearMonthFuelFillGroups(records: FuelFillRecordManager().local),

            const SizedBox(height: 75)

          ],
        ),
      ),
    ),
  );

  Future<void> refreshFuelFills() async {
    await FuelFillRecordManager().index();
  }

  int fuelFillRecordCount() => FuelFillRecordManager().local.length;

  @override
  Widget build(BuildContext context) => Consumer<FuelFillRecordManager>(
     builder: (context, manager, _) =>
     manager.local.isNotEmpty ? normalBody() : emptyRecordsBody(),
   );
}