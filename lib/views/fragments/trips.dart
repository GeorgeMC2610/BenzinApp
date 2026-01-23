import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/trip_manager.dart';
import 'package:benzinapp/views/shared/cards/trip_card.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../services/classes/trip.dart';

class TripsFragment extends StatefulWidget {
  const TripsFragment({super.key});

  @override
  State<TripsFragment> createState() => _TripsFragmentState();
}

class _TripsFragmentState extends State<TripsFragment> {

  getRepeatingTrips() => TripManager().local!.where((trip) => trip.timesRepeating != 1).toList();
  getOneTimeTrips() => TripManager().local!.where((trip) => trip.timesRepeating == 1).toList();

  Widget noTripsBody() => Center(
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
            Center(
              child: AutoSizeText(
                translate('noTrips'),
                maxLines: 3,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );

  Widget notEnoughFuelFillsBody() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.gas_meter_outlined, size: 150,),
          AutoSizeText(
            maxLines: 2,
            textAlign: TextAlign.center,
            translate('pleaseEnterFuelFills'),
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
          ),
          AutoSizeText(
            translate('atlEastThreeFuelFills'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
            ),
          )
        ],
      )
    ),
  );

  Widget tripsBody() => RefreshIndicator(
    onRefresh: () => refreshTrips(),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TripSection(
              title: translate('repeatingTrips'),
              trips: getRepeatingTrips(),
              cardColor:
              Theme.of(context).colorScheme.secondaryContainer,
            ),
            const SizedBox(height: 20),
            TripSection(
              title: translate('oneTimeTrips'),
              trips: getOneTimeTrips(),
              cardColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    ),
  );

  Widget loadingBody() => const LinearProgressIndicator(
    value: null,
  );

  Widget buildBody() {
    return Consumer2<TripManager, FuelFillRecordManager>(
      builder: (context, tripManager, fuelManager, _) {
        if (tripManager.local == null || fuelManager.local == null) {
          return loadingBody();
        }

        if (tripManager.local!.isEmpty) {
          return noTripsBody();
        }

        if (fuelManager.local!.length < 2) {
          return notEnoughFuelFillsBody();
        }

        return tripsBody();
      },
    );
  }

  @override
  Widget build(BuildContext context) => buildBody();

  refreshTrips() async {
    await TripManager().index();
  }
}

class TripSection extends StatelessWidget {
  final String title;
  final List<Trip> trips;
  final Color cardColor;

  const TripSection({
    super.key,
    required this.title,
    required this.trips,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DividerWithText(
          text: title,
          lineColor: Colors.blueGrey,
          textColor: Colors.blueGrey,
          textSize: 22,
        ),
        trips.isNotEmpty
            ? SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  for (int i = 0; i < trips.length; i++) ...[
                    TripCard(trip: trips[i]),
                    if (i < trips.length - 1)
                      Divider(
                          color:
                          Theme.of(context).colorScheme.primary),
                  ]
                ],
              ),
            ),
          ),
        )
            : Text(translate('nothingToShowHere')),
      ],
    );
  }
}

