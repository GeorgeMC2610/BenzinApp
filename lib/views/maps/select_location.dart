import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationOnMaps extends StatefulWidget {
  const SelectLocationOnMaps({super.key, this.address, this.coordinates});

  final String? address;
  final LatLng? coordinates;

  @override
  State<StatefulWidget> createState() => _SelectLocationOnMaps();
}

class _SelectLocationOnMaps extends State<SelectLocationOnMaps> {
  late GoogleMapController _googleMapController;
  Set<Marker> markers = {};
  String? selectedAddress;

  @override
  void initState() {
    super.initState();
    if (widget.coordinates != null) {
      setState(() {
        selectedAddress = widget.address;
        markers.removeWhere((marker) => marker.markerId.value == 'Location');
        var marker = Marker(
          markerId: const MarkerId('Location'),
          position: widget.coordinates!,
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          visible: true,
          infoWindow: InfoWindow(title: 'Location', snippet: selectedAddress),
        );

        markers.add(marker);
      });
    }
  }

  void _onGoogleMapCreated(GoogleMapController controller) async {
    _googleMapController = controller;

    // if there is no location selected, animate the camera to the user's
    // current position
    if (markers.isEmpty) {
      var currentPosition = await Geolocator.getCurrentPosition();
      var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
      await _googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 18.3)
      );
    } else {
      await _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(markers.first.position, 18));
      await _googleMapController.showMarkerInfoWindow(const MarkerId('Location'));
    }
  }

  Future<void> _addMarkerFromAddress(String value) async {
    try {
      List<Location> locations =
          await GeocodingPlatform.instance?.locationFromAddress(value) ?? [];

      if (locations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No places found with this address.")));
        return;
      }

      LatLng place = LatLng(locations[0].latitude, locations[0].longitude);
      List<Placemark> placemarks =
          await GeocodingPlatform.instance?.placemarkFromCoordinates(
              place.latitude, place.longitude) ?? [];

      String fullAddress = placemarks.isNotEmpty
          ? '${placemarks[0].street}, ${placemarks[0].locality} ${placemarks[0].postalCode}'
          : '';

      setState(() {
        selectedAddress = fullAddress;
        markers.removeWhere((marker) => marker.markerId.value == 'Location');
        markers.add(Marker(
          markerId: const MarkerId('Location'),
          position: place,
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          visible: true,
          infoWindow: InfoWindow(title: 'Location', snippet: fullAddress),
        ));
      });

      await _googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(place, 18));
      await Future.delayed(const Duration(milliseconds: 50));
      await _googleMapController.showMarkerInfoWindow(MarkerId('Location'));
    } catch (e) {
      debugPrint("Error fetching address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No places found with this address.")));
    }
  }

  void _onMapLongPress(LatLng latLng) async {
    var placemarks = await GeocodingPlatform.instance?.placemarkFromCoordinates(
        latLng.latitude, latLng.longitude) ?? [];

    var fullAddress = placemarks.isEmpty ? '' :
        '${placemarks.first.street}, ${placemarks.first.locality} ${placemarks.first.postalCode}';

    setState(() {
      selectedAddress = fullAddress;
      markers.removeWhere((marker) => marker.markerId.value == 'Location');

      var marker = Marker(
        markerId: MarkerId('Location'),
        position: latLng,
        flat: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        visible: true,
        infoWindow: InfoWindow(title: 'Location', snippet: selectedAddress),
      );

      markers.add(marker);
      _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 18));
    });

    await Future.delayed(const Duration(milliseconds: 50));
    await _googleMapController.showMarkerInfoWindow(const MarkerId('Location'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: selectedAddress == null ? null : () {
            var data = {
              'address': selectedAddress,
              'coordinates': markers.first.position,
            };

            Navigator.pop<Map<String, dynamic>>(context, data);
          },
          icon: const Icon(Icons.check),
          label: Text('Confirm Location'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
            minimumSize: const Size(200, 55),
          ),
        ),
      ],
      persistentFooterAlignment: AlignmentDirectional.center,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 10),

          Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    _addMarkerFromAddress(value);
                  },
                  autofillHints: const [
                    AutofillHints.addressCity
                  ],
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Type an address for the location...',
                    labelText: 'Search Address',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                )
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text("Type an address, or long-press on the map."),
          ),

          // google maps
          Expanded(
            child: GoogleMap(
              onMapCreated: _onGoogleMapCreated,
              onLongPress: _onMapLongPress,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              markers: markers,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 0,
              ),
            ),
          )
        ],
      ),
    );
  }


}