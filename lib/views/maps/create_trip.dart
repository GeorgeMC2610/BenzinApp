import 'dart:convert';
import 'package:benzinapp/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {

  late GoogleMapController _googleMapController;
  int _selectedTab = 0;
  bool _hasSelectedMarker = false;
  bool _canProceed = false;
  String? originAddress, destinationAddress, polyLine;
  Set<Marker> markers = {};
  int _selectedPolylineIndex = 0;
  Set<Polyline> polylines = {};

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
          onPressed: !_canProceed ? null : () {
            Navigator.pop<Map<String, dynamic>>(context);
          },
          icon: Icon(Icons.check),
          label: Text('Confirm Trip'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
            minimumSize: Size(200, 55),
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
                  onTap: (tab) {
                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                  tabs: const [
                    Tab(text: 'Origin'),
                    Tab(text: 'Destination'),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 60,
                  child: TabBarView(
                    children: [

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            onSubmitted: (value) {
                              _addMarkerFromAddress(value, true);
                            },
                            autofillHints: const [
                              AutofillHints.addressCity
                            ],
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Type an address for the origin...',
                              labelText: 'Search Address',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          )
                        ),
                      ),

                      Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                _addMarkerFromAddress(value, false);
                              },
                              decoration: InputDecoration(
                                hintText: 'Type an address for the destination...',
                                labelText: 'Search Address',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            )
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text("Type an address, or long-press on the map."),
          ),

          Expanded( // Google Map should remain Expanded
            child: GoogleMap(
              onMapCreated: _onGoogleMapCreated,
              onLongPress: _onLongPress,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              markers: markers,
              polylines: polylines,
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

  Future<void> _onLongPress(LatLng place) async {
    try {
      List<Placemark> placemarks =
          await GeocodingPlatform.instance?.placemarkFromCoordinates(
              place.latitude, place.longitude) ?? [];

      String fullAddress = placemarks.isNotEmpty
          ? '${placemarks[0].street}, ${placemarks[0].locality} ${placemarks[0].postalCode}'
          : '';

      setState(() {
        _hasSelectedMarker = true;
        _selectedTab == 0 ? originAddress = fullAddress : destinationAddress = fullAddress;
        markers.removeWhere((marker) => marker.markerId.value == (_selectedTab == 0 ? 'origin' : 'destination'));
        markers.add(_createMarker(place, fullAddress, _selectedTab == 0));
      });

      await _googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(place, 18.3));
      await Future.delayed(Duration(milliseconds: 50));
      await _googleMapController.showMarkerInfoWindow(MarkerId(_selectedTab == 0 ? 'origin' : 'destination'));

      _checkForPolyLine();
      _checkIfCanProceed();
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
  }

  Future<void> _addMarkerFromAddress(String value, bool isOrigin) async {
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
        _hasSelectedMarker = true;
        isOrigin ? originAddress = fullAddress : destinationAddress = fullAddress;
        markers.removeWhere((marker) => marker.markerId.value == (isOrigin ? 'origin' : 'destination'));
        markers.add(_createMarker(place, fullAddress, isOrigin));
      });

      await _googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(place, 18.3));
      await Future.delayed(Duration(milliseconds: 50));
      await _googleMapController.showMarkerInfoWindow(MarkerId(isOrigin ? 'origin' : 'destination'));

      _checkForPolyLine();
      _checkIfCanProceed();
    } catch (e) {
      debugPrint("Error fetching address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No places found with this address.")));
    }
  }

  Marker _createMarker(LatLng position, String address, bool isOrigin) {
    return Marker(
      markerId: MarkerId(isOrigin ? 'origin' : 'destination'),
      position: position,
      flat: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          isOrigin ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
      visible: true,
      infoWindow: InfoWindow(title: isOrigin ? 'Origin' : 'Destination', snippet: address),
    );
  }


  void _checkIfCanProceed() {
    setState(() {
      _canProceed = originAddress != null && destinationAddress != null && polyLine != null && markers.length == 2;
    });
  }

  void _checkForPolyLine() {
    debugPrint("Trying to make trip...");

    if (markers.toList().where((marker) => marker.markerId.value == 'origin' || marker.markerId.value == 'destination').length != 2) {
      debugPrint("Not enough markers. Can't proceed. Current length: ${markers.length}");
      return;
    }

    RequestHandler.sendGetRequest(
        'https://maps.googleapis.com/maps/api/directions/json?alternatives=true'
            '&destination=${markers.last.position.latitude},${markers.last.position.longitude}'
            '&origin=${markers.first.position.latitude},${markers.first.position.longitude}'
        () {},
        (response) {
          var body = response.body;
          final decodedBody = json.decode(body);

          if (decodedBody['routes'].isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("There is no route available for the current positions.")
              )
            );
            return;
          }

          Set<Polyline> newPolylines = {};

          for (int i = 0; i < decodedBody['routes'].length; i++) {
            var route = decodedBody['routes'][i];
            var encodedPolyline = route['overview_polyline']['points']; // Encoded points

            List<LatLng> polylineCoordinates = PolylinePoints().decodePolyline(encodedPolyline)
                .map((point) => LatLng(point.latitude, point.longitude)).toList();

            // First polyline is blue (selected), others are gray
            bool isSelected = (i == 0);

            if (isSelected) {
              polyLine = encodedPolyline;
            }

            Polyline polyline = Polyline(
              polylineId: PolylineId('route_$i'),
              points: polylineCoordinates,
              color: isSelected ? Colors.blue : Colors.grey,
              width: isSelected ? 15 : 10,
              consumeTapEvents: true,
              onTap: () async {
                setState(() {
                  _selectedPolylineIndex = i;
                  polyLine = encodedPolyline;
                  _updatePolylineColors();
                  _checkIfCanProceed();
                });
              },
            );

            newPolylines.add(polyline);
          }

          setState(() {
            polylines = newPolylines;
            _selectedPolylineIndex = 0;
          });

          _checkIfCanProceed();
        }
    );
  }

  void _updatePolylineColors() {
    setState(() {
      polylines = polylines.map((polyline) {
        return polyline.copyWith(
          colorParam: (polyline.polylineId.value == 'route_$_selectedPolylineIndex')
              ? Colors.blue
              : Colors.grey,
          widthParam: (polyline.polylineId.value == 'route_$_selectedPolylineIndex') ? 6 : 4,
        );
      }).toSet();
    });
  }

}