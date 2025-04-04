import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewTripOnMaps extends StatefulWidget {
  const ViewTripOnMaps({super.key, required this.positions, required this.addresses, this.polyline});

  final String? polyline;
  final List<LatLng> positions;
  final List<String> addresses;

  @override
  State<StatefulWidget> createState() => _ViewTripsOnMapsState();
}

class _ViewTripsOnMapsState extends State<ViewTripOnMaps> {
  late GoogleMapController _googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  void _onGoogleMapCreated(GoogleMapController controller) {
    _googleMapController = controller;

    if (widget.positions.length == 2) {
      List<LatLng> polylineCoordinates = PolylinePoints()
          .decodePolyline(widget.polyline!)
          .map((point) => LatLng(point.latitude, point.longitude)).toList();

      setState(() {
        polylines.add(Polyline(
            polylineId: const PolylineId('trip'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
            consumeTapEvents: false
        ));
      });

      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('Origin'),
          position: widget.positions[0],
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          visible: true,
          infoWindow: InfoWindow(title: 'Origin', snippet: widget.addresses[0]),
        ));

        markers.add(Marker(
          markerId: const MarkerId('Destination'),
          position: widget.positions[1],
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          visible: true,
          infoWindow: InfoWindow(title: 'Destination', snippet: widget.addresses[1]),
        ));
      });
    } else {
      setState(() {
        markers.add(Marker(
          markerId: const MarkerId('Origin'),
          position: widget.positions[0],
          flat: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          visible: true,
          infoWindow: InfoWindow(title: 'Location', snippet: widget.addresses[0]),
        ));
      });
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      _googleMapController.showMarkerInfoWindow(markers.last.markerId);
    });

    _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(widget.positions.last, 18)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Location"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: GoogleMap(
          onMapCreated: _onGoogleMapCreated,
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
    );
  }


}