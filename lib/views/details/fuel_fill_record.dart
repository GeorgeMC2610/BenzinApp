import 'package:flutter/material.dart';

class ViewFuelFillRecord extends StatelessWidget {
  const ViewFuelFillRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fuel Fill Record Data"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      persistentFooterAlignment: AlignmentDirectional.centerStart,
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.primary),
              foregroundColor: WidgetStatePropertyAll(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.edit),
            label: const Text("Edit")
        ),
        ElevatedButton.icon(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.error),
              foregroundColor: WidgetStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.onPrimary),
            ),
            icon: const Icon(Icons.delete),
            label: const Text("Delete")
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // singular card with initial data
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 30,),
                            const SizedBox(width: 15),
                            const Text("January 15th 2026", style: TextStyle(fontSize: 18),),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(Icons.local_gas_station_outlined, size: 30,),
                            const SizedBox(width: 15),
                            const Text("FuelSave 95, Shell", style: TextStyle(fontSize: 18),),
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
              ),

            ],
          )
        )
      ),
    );
  }

}