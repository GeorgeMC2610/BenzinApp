import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {

  late GoogleMapController _googleMapController;
  bool _hasSelectedMarker = false;
  Set<Marker> markers = {};

  Future<void> _setCameraToCurrentPosition() async {
    var currentPosition = await Geolocator.getCurrentPosition();
    var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 18.3)
    );
  }

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
          DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  labelColor: Theme.of(context).appBarTheme.backgroundColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).appBarTheme.backgroundColor,
                  tabs: [
                    Tab(text: 'Origin'),
                    Tab(text: 'Destination'),
                  ],
                ),
                SizedBox( // 🔥 FIX: Define a height
                  height: 100, // Adjust as needed
                  child: TabBarView(
                    children: [
                      Center(child: Text("Here's the origin")),
                      Center(child: Text("Here's the destination")),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded( // Google Map should remain Expanded
            child: GoogleMap(
              onMapCreated: _onGoogleMapCreated,
              onLongPress: _onLongPress,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              markers: markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 0,
              ),
            ),
          ),
        ],
      )


    );
  }

  void _onGoogleMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    if (!_hasSelectedMarker) _setCameraToCurrentPosition();
  }

  void _onLongPress(LatLng place) async {
    setState(() {
      _hasSelectedMarker = true;
      var marker = Marker(
          markerId: MarkerId('origin'),
          position: place,
          flat: true,
          visible: true,
          infoWindow: InfoWindow(title: 'maravosa', ),
      );
      markers.add(marker);

    });

    await Future.delayed(Duration(milliseconds: 50)); // Small delay to ensure UI updates
    await _googleMapController.showMarkerInfoWindow(MarkerId('origin'));
  }

}