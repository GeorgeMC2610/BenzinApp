import 'package:benzinapp/filters/malfunction_filter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/views/shared/cards/malfunction_card.dart';
import 'package:benzinapp/views/shared/cards/service_card.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
          translate('noMalfunctions'),
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
          translate('noServices'),
          maxLines: 1,
          style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    ),
  );

  Widget malfunctionListBody() {
    final manager = MalfunctionManager();
    final records = manager.localOrFiltered!;
    final filter = manager.filter;

    if (filter == null || filter.groupBy == MalfunctionGroupBy.none) {
      return RefreshIndicator(
        onRefresh: () => refreshMalfunctions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: _ungroupedMalfunctions(records),
          ),
        ),
      );
    } else if (filter.groupBy == MalfunctionGroupBy.status) {
      return RefreshIndicator(
        onRefresh: () => refreshMalfunctions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: _groupedByStatusMalfunctions(records),
          ),
        ),
      );
    } else if (filter.groupBy == MalfunctionGroupBy.severity) {
      return RefreshIndicator(
        onRefresh: () => refreshMalfunctions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: _groupedBySeverityMalfunctions(records),
          ),
        ),
      );
    }
    return _ungroupedMalfunctions(records);
  }

  Widget _ungroupedMalfunctions(List<Malfunction> records) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...records.map((malfunction) {
        return records.last != malfunction ?
        Column(
          children: [
            MalfunctionCard(malfunction: malfunction),
            const Divider()
          ],
        ) : MalfunctionCard(malfunction: malfunction);
      }),

      const SizedBox(height: 65)
    ]
  );

  Widget _groupedByStatusMalfunctions(List<Malfunction> records) {
    final fixed = records.where((m) => m.isFixed()).toList();
    final ongoing = records.where((m) => !m.isFixed()).toList();

    return Column(
      children: [
        if (ongoing.isNotEmpty) ...[
          _groupHeader(translate('onlyUnfixed')),
          ...ongoing.map((m) => MalfunctionCard(malfunction: m)),
        ],
        if (fixed.isNotEmpty) ...[
          _groupHeader(translate('onlyFixed')),
          ...fixed.map((m) => MalfunctionCard(malfunction: m)),
        ],
        const SizedBox(height: 65)
      ],
    );
  }

  Widget _groupedBySeverityMalfunctions(List<Malfunction> records) {
    Map<int, List<Malfunction>> groups = {};
    for (var r in records) {
      groups.putIfAbsent(r.severity, () => []).add(r);
    }
    var sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return Column(
      children: [
        for (var key in sortedKeys) ...[
          _groupHeader("${translate('severityFilter')}: $key"),
          ...groups[key]!.map((m) => MalfunctionCard(malfunction: m)),
        ],
        const SizedBox(height: 65)
      ],
    );
  }

  Widget _groupHeader(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: DividerWithText(
        text: text,
        lineColor: Colors.grey,
        textColor: Theme.of(context).colorScheme.primary,
        textSize: 16
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
                text: translate('lastService'),
                lineColor: Colors.grey,
                textColor: Theme.of(context).colorScheme.primary,
                textSize: 16
            ),

            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ServiceCard(service: ServiceManager().localOrFiltered!.first)
                    )
                )
            ),

            DividerWithText(
                text: translate('previousServices'),
                lineColor: Colors.grey,
                textColor: Theme.of(context).colorScheme.primary,
                textSize: 16
            ),

            ServiceManager().localOrFiltered!.skip(1).isEmpty ? Text(translate('nothingToShowHere')) :
            Column(
              children: ServiceManager().localOrFiltered!.skip(1).map((service) {
                return ServiceManager().localOrFiltered!.skip(1).last != service ?
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
    builder: (context, manager, _) {
      if (manager.localOrFiltered == null) return loadingBody();
      if (manager.localOrFiltered!.isEmpty) return noServicesBody();
      return serviceListBody();
    }
  );

  Widget getMalfunctions() => Consumer<MalfunctionManager>(
    builder: (context, manager, _) {
      if (manager.localOrFiltered == null) return loadingBody();
      if (manager.localOrFiltered!.isEmpty) return noMalfunctionsBody();
      return malfunctionListBody();
    }
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

              Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: TabBar(
                tabs: [
                  Tab(text: translate('malfunctions')),
                  Tab(text: translate('services')),
                  ],
                )
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