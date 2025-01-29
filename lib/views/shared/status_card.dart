import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.icon,
    required this.text,
    required this.status
  });

  final String text;
  final Icon icon;
  final StatusCardIndex status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      dense: true,
      minTileHeight: 25,
      title: Text(text, style: const TextStyle(
          letterSpacing: 0
      )
      ),
      leading: icon,
      trailing: _getStatusChip()
    );
  }

  Material _getStatusChip() {
    switch (status) {

      case StatusCardIndex.bad:
        return Material(
                color: Colors.red, // Set exact background color
                borderRadius: BorderRadius.circular(20), // Keep shape consistent
                elevation: 0, // No shadow
                child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: SizedBox(
                width: 50,
                child: const Icon(Icons.warning, color: Colors.white)
                )

                ));

      case StatusCardIndex.warning:
        return Material(
            color: Colors.amber, // Set exact background color
            borderRadius: BorderRadius.circular(20), // Keep shape consistent
            elevation: 0, // No shadow
            child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: SizedBox(
                    width: 50,
                    child: Icon(Icons.access_time_rounded, color: Colors.black)
                )

            ));
      case StatusCardIndex.good:
        return Material(
            color: Color.fromARGB(255, 0, 150, 0), // Set exact background color
            borderRadius: BorderRadius.circular(20), // Keep shape consistent
            elevation: 0, // No shadow
            child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text("OK", style: TextStyle(color: Colors.white),),
            ));
    }
  }

}

enum StatusCardIndex {
  bad,
  good,
  warning
}