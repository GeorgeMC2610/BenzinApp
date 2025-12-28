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

  Widget emptyRecordsBody() => ConstrainedBox(
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
  );

  Widget normalBody(FuelFillRecordManager manager) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TOTAL RECORDS
        Text(
            manager.local.length == 1 ?
            translate('oneRecord') :
            translate('totalRecords', args: {'totalRecords': manager.local.length})
        ),

        if (manager.filter != null)
          Text(
              manager.localOrFiltered.length == 1 ?
              translate('oneRecordWithFilters') :
              translate('totalFilteredRecords', args: {'totalRecords': manager.localOrFiltered.length})
          ),

        YearMonthFuelFillGroups(records: manager.localOrFiltered),

        const SizedBox(height: 75)

      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Consumer<FuelFillRecordManager>(
     builder: (context, manager, _) =>
      RefreshIndicator(
        onRefresh: manager.index,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: manager.local.isEmpty ? emptyRecordsBody() : normalBody(manager),
        ),
      ),
   );
}