import 'package:flutter/material.dart';

class MaintenanceFragment extends StatefulWidget {
  const MaintenanceFragment({super.key});

  @override
  State<MaintenanceFragment> createState() => _MaintenanceFragmentState();
}

class _MaintenanceFragmentState extends State<MaintenanceFragment> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  labelColor: Theme.of(context).appBarTheme.backgroundColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).appBarTheme.backgroundColor,
                  tabs: [
                    const Tab(text: 'Malfunctions'),
                    const Tab(text: 'Services')
                  ],
                )
              ],
            )
          )
        )
    );
  }

}