import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TripsFragment extends StatefulWidget {
  const TripsFragment({super.key});

  @override
  State<TripsFragment> createState() => _TripsFragmentState();
}

class _TripsFragmentState extends State<TripsFragment> {

  @override
  Widget build(BuildContext context) {
    return const Column();

    return DataHolder.getServices()!.isEmpty?
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/svg/no_trips.svg',
              semanticsLabel: 'No Trips!',
              width: 200,
            ),

            const SizedBox(height: 40),

            AutoSizeText(
              AppLocalizations.of(context)!.noTrips,
              maxLines: 1,
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
    SingleChildScrollView(       // TODO : Implement consumer mode.
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DividerWithText(
                text: AppLocalizations.of(context)!.repeatingTrips,
                lineColor: Colors.blueGrey,
                textColor: Colors.blueGrey,
                textSize: 12.8
            ),

            Text(AppLocalizations.of(context)!.nothingToShowHere),

            DividerWithText(
                text: AppLocalizations.of(context)!.oneTimeTrips,
                lineColor: Colors.blueGrey,
                textColor: Colors.blueGrey,
                textSize: 12.8
            ),
            

          ]
        )
      )
    );
  }

}