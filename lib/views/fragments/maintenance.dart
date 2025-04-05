import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/views/shared/cards/malfunction_card.dart';
import 'package:benzinapp/views/shared/cards/service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';


class MaintenanceFragment extends StatefulWidget {
  const MaintenanceFragment({super.key});

  @override
  State<MaintenanceFragment> createState() => _MaintenanceFragmentState();
}

class _MaintenanceFragmentState extends State<MaintenanceFragment> {

  bool _isLoadingServices = false;
  bool _isLoadingMalfunctions = false;

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

                      Consumer<DataHolder>(
                        builder: (context, dataHolder, child) {
                          if (DataHolder.getServices() == null) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Center(
                                  child: CircularProgressIndicator(
                                    value: null,
                                  )
                              ),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return
                                DataHolder.getMalfunctions()!.isEmpty ?
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'lib/assets/svg/no_malfunctions.svg',
                                          semanticsLabel: 'No Malfunctions!',
                                          width: 200,
                                        ),

                                        const SizedBox(height: 40),

                                        Text(
                                          AppLocalizations.of(context)!.noMalfunctions,
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
                                      _isLoadingMalfunctions = true;
                                    });

                                    DataHolder.refreshMalfunctions().whenComplete(() {
                                      setState(() {
                                        _isLoadingMalfunctions = false;
                                      });
                                    });
                                  },
                                  child: SingleChildScrollView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _isLoadingMalfunctions ? const LinearProgressIndicator(
                                              value: null,
                                            ) : const SizedBox(),

                                            ...DataHolder.getMalfunctions()!.map((malfunction) {
                                              return DataHolder.getMalfunctions()!.last != malfunction ?
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
                                  ),
                                );
                            },
                          );
                        }
                      ),
                      
                      Consumer<DataHolder>(
                       builder: (context, dataHolder, child) {
                         if (DataHolder.getServices() == null) {
                           return const Padding(
                             padding: EdgeInsets.symmetric(horizontal: 15),
                             child: Center(
                                 child: CircularProgressIndicator(
                                   value: null,
                                 )
                             ),
                           );
                         }

                         return LayoutBuilder(
                           builder: (context, constraints) {
                             return
                               DataHolder.getServices()!.isEmpty ?
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 15),
                                 child: Center(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       SvgPicture.asset(
                                         'lib/assets/svg/no_services.svg',
                                         semanticsLabel: 'No Services!',
                                         width: 200,
                                       ),

                                       const SizedBox(height: 40),

                                       AutoSizeText(
                                         AppLocalizations.of(context)!.noServices,
                                         maxLines: 1,
                                         style: const TextStyle(
                                             fontSize: 29,
                                             fontWeight: FontWeight.bold
                                         ),
                                       )
                                     ],
                                   ),
                                 ) ,
                               )
                               :
                               RefreshIndicator(
                                 onRefresh: () async {
                                   setState(() {
                                     _isLoadingServices = true;
                                   });

                                   DataHolder.refreshServices().whenComplete(() {
                                     setState(() {
                                       _isLoadingServices = false;
                                     });
                                   });
                                 },
                                 child: SingleChildScrollView(
                                   physics: const AlwaysScrollableScrollPhysics(),
                                   child: Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         _isLoadingServices ? const LinearProgressIndicator(
                                           value: null,
                                         ) : const SizedBox(),

                                         ...DataHolder.getServices()!.map((service) {
                                           return DataHolder.getServices()!.last != service ?
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
                                 ),
                               );
                           },
                         );
                       }
                      )


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