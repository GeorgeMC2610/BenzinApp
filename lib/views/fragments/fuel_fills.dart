import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/year_month_fuel_fill_groups.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FuelFillsFragment extends StatefulWidget {
  const FuelFillsFragment({super.key});

  @override
  State<FuelFillsFragment> createState() => _FuelFillsFragmentState();
}

class _FuelFillsFragmentState extends State<FuelFillsFragment> {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataHolder>(
      builder: (context, dataHolder, child) {
        return DataHolder.getFuelFillRecords().isEmpty?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    AppLocalizations.of(context)!.noFuelFillRecords,
                    style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
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
                        label: Text(AppLocalizations.of(context)!.filters),
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
                              hintText: AppLocalizations.of(context)!.searchInFuelFills,
                              fillColor: Theme.of(context).colorScheme.onSecondary
                          ),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 5),

                  // TOTAL RECORDS
                  Text(
                    DataHolder.getFuelFillRecords().length == 1 ?
                    AppLocalizations.of(context)!.oneRecord :
                    AppLocalizations.of(context)!.totalRecords(DataHolder.getFuelFillRecords().length)
                  ),

                  const SizedBox(height: 10),

                  const YearMonthFuelFillGroups(),

                  const SizedBox(height: 75)

                ],
              ),
            )
        );
      }
    );
  }

}