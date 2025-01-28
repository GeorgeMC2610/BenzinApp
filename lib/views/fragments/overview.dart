import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OverviewFragment extends StatefulWidget {
  const OverviewFragment({super.key});

  @override
  State<OverviewFragment> createState() => _OverviewFragmentState();
}

class _OverviewFragmentState extends State<OverviewFragment> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(AppLocalizations.of(context)!.loggedInAs('polo_despoina')),

            const SizedBox(height: 10),

            // car info container
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Volkswagen Polo',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text('2001',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),

            // graph with consumption container
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text('FUEL USAGE TREND',
                          style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            )
                          )
                        ),

                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         constraints: BoxConstraints(minHeight: 30, minWidth: 60),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10)
                         ),
                         child: DropdownButton(
                           items: [],
                           onChanged: (item) {}
                         )
                       )
                      ],
                    ),
                  )
              ),
            ),

            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('COMBINED COSTS',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),

                      ],
                    ),
                  )
              ),
            ),

            // car consumption container
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('AVERAGE CONSUMPTION',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                              )
                          )
                        ),

                        const SizedBox(height: 15),

                        Text('Liters per 100 km:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Something something better than the green limo',
                          style: TextStyle(
                              fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text('Kilometers per Liter:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Something something better than the green limo',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text('Cost per Kilometer:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text('Something something better than the green limo',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),

            // timely manner consumption
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text('TOTAL STATISTICS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          )
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text('Total Liters Filled:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('Something something better than the green limo',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text('Total Kilometers Travelled:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('Something something better than the green limo',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text('Total Costs:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text('Something something better than the green limo',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),

                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      )
    );
  }

}