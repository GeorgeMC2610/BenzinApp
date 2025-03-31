import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {

  late GoogleMapController _googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Create Trip"),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop<Map<String, dynamic>>(context);
          },
          icon: Icon(Icons.check),
          label: Text('Confirm Trip'),
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
              minimumSize: const WidgetStatePropertyAll(Size(200, 55),
              )
          ),
        ),
      ],
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                const Text("Hi!")
              ],
            ),
          ),

          Expanded(
            child: GoogleMap(
              onMapCreated: _onGoogleMapCreated,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onGoogleMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

}