import 'package:flutter/material.dart';

class FuelFillsFragment extends StatefulWidget {
  const FuelFillsFragment({super.key});

  @override
  State<FuelFillsFragment> createState() => _FuelFillsFragmentState();
}

class _FuelFillsFragmentState extends State<FuelFillsFragment> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // BUTTON FILTERS AND SEARCH
              Row(
                children: [

                  FilledButton.icon (
                    onPressed: () {},
                    label: const Text("Filters"),
                    icon: const Icon(Icons.filter_list),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                      child: TextField(
                        style: TextStyle(
                          height: 1
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          hintStyle: const TextStyle(color: Colors.grey),
                          hintText: "Search in fuel fills...",
                          fillColor: Theme.of(context).colorScheme.onSecondary
                        ),
                      ),
                  )

                ],
              ),

              const SizedBox(height: 5),

              // TOTAL RECORDS
              Text('x Total Records'),

              const SizedBox(height: 10),

              // YEAR-MONTH
              const Padding(
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  'January 2025',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              // CARD WITH THE RECORDS
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  elevation: 3,

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: Theme.of(context).highlightColor)
                  ),

                  // THIS IS THE INNARDS OF THE CARD
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // A SINGULAR FUEL-FILL RECORD
                        ListTile(
                          title: const Text(
                            "Thursday 22",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              // EDIT BUTTON
                              FloatingActionButton.small(
                                onPressed: () {},
                                child: const Icon(Icons.edit),
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),

                              // DELETE BUTTON
                              FloatingActionButton.small(
                                onPressed: () {},
                                child: const Icon(Icons.delete),
                                elevation: 0,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ],
                          ),

                          // FUEL-FILL RECORD DATA
                          subtitle: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("€39,29", style: TextStyle(fontSize: 16)),
                              Text("FuelSave 95, Shell", style: TextStyle(fontSize: 12)),
                              Text("4.929 lt./100km", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),

                        // DIVIDER FOR THE NEXT RECORD
                        const Divider(),

                        ListTile(
                          title: const Text(
                              "Wednesday 01",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              FloatingActionButton.small(
                                onPressed: () {},
                                child: const Icon(Icons.edit),
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                              ),

                              FloatingActionButton.small(
                                onPressed: () {},
                                child: const Icon(Icons.delete),
                                elevation: 0,
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ],
                          ),
                          subtitle: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("€80,00", style: TextStyle(fontSize: 16)),
                              Text("FuelSave 95, Shell", style: TextStyle(fontSize: 12)),
                              Text("2.459 lt./100km", style: TextStyle(fontSize: 12)),
                            ],
                          ),


                        )
                      ],
                  ),
                ),
              )
            )],
          ),
        )
    );
  }

}