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
              // Use Expanded to give TabBarView proper constraints
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust height as needed
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Malfunctions')
                          ],
                        ),
                      )
                    ),

                    SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Services')
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}