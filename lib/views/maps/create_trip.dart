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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Test"),

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
      )
    );
  }

  void _onGoogleMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
  }

}