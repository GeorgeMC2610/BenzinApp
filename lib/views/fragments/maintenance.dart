import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/shared/cards/malfunction_card.dart';
import 'package:benzinapp/views/shared/cards/service_card.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Widget loadingBody() => const Center(
      child: CircularProgressIndicator(
        value: null,
      )
  );

  Widget noMalfunctionsBody() => Center(
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
  );

  Widget noServicesBody() => Center(
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
  );

  Widget malfunctionListBody() => RefreshIndicator(
    onRefresh: () => refreshMalfunctions(),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...MalfunctionManager().local.map((malfunction) {
                return MalfunctionManager().local.last != malfunction ?
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

  Widget serviceListBody() => RefreshIndicator(
    onRefresh: () => refreshServices(),
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            DividerWithText(
                text: AppLocalizations.of(context)!.lastService,
                lineColor: Colors.black,
                textColor: Colors.black,
                textSize: 16
            ),

            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ServiceCard(service: ServiceManager().local.first)
                    )
                )
            ),

            DividerWithText(
                text: AppLocalizations.of(context)!.previousServices,
                lineColor: Colors.black,
                textColor: Colors.black,
                textSize: 16
            ),

            ServiceManager().local.skip(1).isEmpty ? Text(AppLocalizations.of(context)!.nothingToShowHere) :
            Column(
              children: ServiceManager().local.skip(1).map((service) {
                return ServiceManager().local.skip(1).last != service ?
                Column(
                  children: [
                    ServiceCard(service: service),
                    const Divider()
                  ],
                ) : ServiceCard(service: service);
              }).toList(),
            ),

            const SizedBox(height: 65)
          ],
        ),
      ),
    ),
  );

  Widget getServices() => Consumer<ServiceManager>(
    builder: (context, manager, _) =>
    manager.local.isEmpty ? noServicesBody() : serviceListBody(),
  );

  Widget getMalfunctions() => Consumer<MalfunctionManager>(
    builder: (context, manager, _) =>
    manager.local.isEmpty ? noMalfunctionsBody() : malfunctionListBody(),
  );

  @override
  Widget build(BuildContext context) => Column(
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
                  children: <Widget>[
                    getMalfunctions(),
                    getServices(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  refreshMalfunctions() async {
    await MalfunctionManager().index();
  }

  refreshServices() async {
    await ServiceManager().index();
  }
}