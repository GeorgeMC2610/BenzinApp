import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/cards/malfunction_card.dart';
import 'package:benzinapp/views/shared/cards/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MaintenanceFragment extends StatefulWidget {
  const MaintenanceFragment({super.key});

  @override
  State<MaintenanceFragment> createState() => _MaintenanceFragmentState();
}

class _MaintenanceFragmentState extends State<MaintenanceFragment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTabController(
          length: 2,
          child: Expanded(
            child: Column(
              children: [

                TabBar(
                  labelColor: Theme.of(context).appBarTheme.backgroundColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).appBarTheme.backgroundColor,
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.malfunctions),
                    Tab(text: AppLocalizations.of(context)!.services),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [

                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...DataHolder.getMalfunctions().map((malfunction) {
                                    return DataHolder.getMalfunctions().last != malfunction ?
                                    Column(
                                      children: [
                                        MalfunctionCard(malfunction: malfunction),
                                        const Divider()
                                      ],
                                    ) : MalfunctionCard(malfunction: malfunction);
                                  }),

                                  const SizedBox(height: 65)
                                ]
                              ),
                            ),
                          );
                        },
                      ),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...DataHolder.getServices().map((service) {
                                    return DataHolder.getServices().last != service ?
                                    Column(
                                      children: [
                                        ServiceCard(service: service),
                                        const Divider()
                                      ],
                                    ) : ServiceCard(service: service);
                                  }),

                                  const SizedBox(height: 65)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}