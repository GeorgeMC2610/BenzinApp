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

              Text('x Total Records'),

              const SizedBox(height: 10),

              const Text(
                'January 2025',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),

              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        ListTile(
                          title: const Text(
                            "Thursday 22",
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
                                backgroundColor: Colors.blue,
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
                              Text("€39,29", style: TextStyle(fontSize: 16)),
                              Text("FuelSave 95, Shell", style: TextStyle(fontSize: 12)),
                              Text("4.929 lt./100km", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),

                        const Divider(),

                        const ListTile(
                          title: Text(
                              "Wednesday 01",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                          subtitle: Column(
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