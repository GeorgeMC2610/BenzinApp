import 'package:benzinapp/services/classes/service.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          "${service.kilometersDone.toString()} km",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [

          // EDIT BUTTON
          FloatingActionButton.small(
            onPressed: () {},
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),

          // DELETE BUTTON
          FloatingActionButton.small(
            onPressed: () {},
            elevation: 0,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: const Icon(Icons.delete),
          ),
        ],
      ),

      // FUEL-FILL RECORD DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(service.cost == null ? '-' : "${service.cost}", style: const TextStyle(fontSize: 16)),
          Text(service.dateHappened.toString().substring(0, 10), style: const TextStyle(fontSize: 12)),
          Text("Next at: ${service.nextServiceKilometers?? '-'} km", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

}