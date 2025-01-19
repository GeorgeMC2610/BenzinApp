import 'package:flutter/material.dart';

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
                  tabs: const [
                    Tab(text: 'Malfunctions'),
                    Tab(text: 'Services'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [

                      LayoutBuilder(
                        builder: (context, constraints) {
                          return const SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Malfunctions'),
                                ]
                              ),
                            ),
                          );
                        },
                      ),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          return const SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Services'),
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