import 'package:auto_size_text/auto_size_text.dart';
import 'package:BenzinApp/services/data_holder.dart';
import 'package:BenzinApp/views/shared/cards/trip_card.dart';
import 'package:BenzinApp/views/shared/divider_with_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TripsFragment extends StatefulWidget {
  const TripsFragment({super.key});

  @override
  State<TripsFragment> createState() => _TripsFragmentState();
}

class _TripsFragmentState extends State<TripsFragment> {

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Consumer<DataHolder>(
        builder: (context, dataHolder, child)
    {
      if (DataHolder.getTrips() == null) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Center(
              child: CircularProgressIndicator(
                value: null,
              )
          ),
        );
      }

      return DataHolder.getTrips()!.isEmpty ?
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
      RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true;
            });

            DataHolder.refreshTrips().whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DividerWithText(
                            text: AppLocalizations.of(context)!.repeatingTrips,
                            lineColor: Colors.blueGrey,
                            textColor: Colors.blueGrey,
                            textSize: 22
                        ),

                        DataHolder.getRepeatingTrips()!.isNotEmpty ?

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Column(
                                children: DataHolder.getRepeatingTrips()!.map((trip) {
                                  return DataHolder.getRepeatingTrips()!.last != trip ?
                                  Column(
                                    children: [
                                      TripCard(trip: trip),
                                      Divider(color: Theme.of(context).colorScheme.primary)
                                    ],
                                  ) : TripCard(trip: trip);
                                }).toList(),
                              ),
                            ) ,
                          ),
                        ) : Text(AppLocalizations.of(context)!.nothingToShowHere),

                        const SizedBox(height: 20),

                        DividerWithText(
                            text: AppLocalizations.of(context)!.oneTimeTrips,
                            lineColor: Colors.blueGrey,
                            textColor: Colors.blueGrey,
                            textSize: 22
                        ),

                        DataHolder.getOneTimeTrips()!.isNotEmpty ?

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            color: Theme.of(context).colorScheme.surfaceContainer,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Column(
                                children: DataHolder.getOneTimeTrips()!.map((trip) {
                                  return DataHolder.getOneTimeTrips()!.last != trip ?
                                  Column(
                                    children: [
                                      TripCard(trip: trip),
                                      Divider(color: Theme.of(context).colorScheme.primary)
                                    ],
                                  ) : TripCard(trip: trip);
                                }).toList(),
                              ),
                            )

                          ),
                        ) : Text(AppLocalizations.of(context)!.nothingToShowHere),

                        const SizedBox(height: 100)
                      ]
                  )
              )
          )
      );
      }
    );
  }
}