import 'package:benzinapp/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

    await GeocodingPlatform.instance?.placemarkFromCoordinates(place.latitude, place.longitude).then((onValue) async{

      Placemark? address;
      if (onValue.isEmpty) {
        address = null;
      }
      else {
        address = onValue[0];
      }

      setState(() {
        _hasSelectedMarker = true;
        String fullAddress = address == null ? '' : '${address.name},\n${address.locality} ${address.postalCode}';

        if (_selectedTab == 0) {
          originAddress = fullAddress;
        } else {
          destinationAddress = fullAddress;
        }

        _googleMapController.animateCamera(
            CameraUpdate.newLatLngZoom(place, 18.3)
        );
        var marker = Marker(
          markerId: MarkerId(_selectedTab == 0 ? 'origin' : 'destination'),
          position: place,
          flat: true,
          visible: true,
          infoWindow: InfoWindow(title: _selectedTab == 0 ? 'Origin' : 'Destination', snippet: fullAddress),
        );
        markers.add(marker);
    });

    });

    await Future.delayed(Duration(milliseconds: 50)); // Small delay to ensure UI updates
    await _googleMapController.showMarkerInfoWindow(MarkerId(_selectedTab == 0 ? 'origin' : 'destination'));

    _checkForPolyLine();
    _checkIfCanProceed();
  }

  void _addMarkerFromAddress(String value, bool isOrigin) async {
    await GeocodingPlatform.instance?.locationFromAddress(value).then((onValue) async {
      if (onValue.isEmpty) {
        return;
      }

      var place = LatLng(onValue[0].latitude, onValue[0].longitude);
      var addresses = await GeocodingPlatform.instance?.placemarkFromCoordinates(onValue[0].latitude, onValue[0].longitude);

      setState(() {
        _hasSelectedMarker = true;
        String fullAddress = '${addresses?[0].name},\n${addresses?[0].locality} ${addresses?[0].postalCode}';

        if (_selectedTab == 0) {
          originAddress = fullAddress;
        } else {
          destinationAddress = fullAddress;
        }

        _googleMapController.animateCamera(
            CameraUpdate.newLatLngZoom(place, 18.3)
        );
        var marker = Marker(
          markerId: MarkerId(isOrigin ? 'origin' : 'destination'),
          position: place,
          flat: true,
          visible: true,
          infoWindow: InfoWindow(title: isOrigin ? 'Origin' : 'Destination', snippet: fullAddress),
        );
        markers.add(marker);
      });

      await Future.delayed(Duration(milliseconds: 50)); // Small delay to ensure UI updates
      await _googleMapController.showMarkerInfoWindow(MarkerId(isOrigin ? 'origin' : 'destination'));
      }
    ).onError((error, stack) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No places found with this address."),
          )
      );
    });

    _checkForPolyLine();
    _checkIfCanProceed();
  }

  void _checkIfCanProceed() {
    setState(() {
      _canProceed = originAddress != null && destinationAddress != null && polyLine != null && markers.length == 2;
    });
  }

  void _checkForPolyLine() {
    if (markers.length != 2) {
      return;
    }

    RequestHandler.sendGetRequest(
        '',
        () {},
        (response) {
          var body = response.body;
        }
    );
  }

}