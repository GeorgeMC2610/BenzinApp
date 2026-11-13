import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:benzinapp/i18n/strings.g.dart';
import 'package:benzinapp/services/data_holder.dart';
import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/views/shared/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// Lets the user pick an origin and a destination (by search, long-press, dragging
/// a marker or their current location), choose one of the suggested routes and
/// return it to the caller.
///
/// Pops with a map containing: originAddress, originCoordinates, destinationAddress,
/// destinationCoordinates, polyline (encoded) and totalKm.
class CreateTrip extends StatefulWidget {
  const CreateTrip({
    super.key,
    this.originAddress,
    this.destinationAddress,
    this.originCoordinates,
    this.destinationCoordinates,
    this.totalKm,
    this.polyline,
  });

  final String? originAddress, destinationAddress, polyline;
  final LatLng? originCoordinates, destinationCoordinates;
  final double? totalKm;

  @override
  State<StatefulWidget> createState() => _CreateTripState();
}

/// One route suggested by the Directions API (or restored from an existing trip).
class _RouteOption {
  _RouteOption({
    required this.encodedPolyline,
    required this.points,
    required this.distanceKm,
    this.durationText,
    this.summary,
  });

  final String encodedPolyline;
  final List<LatLng> points;
  final double distanceKm;
  final String? durationText;
  final String? summary;
}

enum _Point { origin, destination }

class _CreateTripState extends State<CreateTrip> {
  // Used until we know where the user is (Athens, city level).
  static const _fallbackCamera = CameraPosition(target: LatLng(37.9838, 23.7275), zoom: 11);
  static const double _pointZoom = 16;

  GoogleMapController? _mapController;

  LatLng? _origin, _destination;
  String? _originAddress, _destinationAddress;

  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _originFocus = FocusNode();
  final _destinationFocus = FocusNode();

  /// Which point a long-press on the map (or "use my location") will set.
  _Point _active = _Point.origin;

  List<_RouteOption> _routes = [];
  int _selectedRoute = 0;

  bool _isBusy = false;
  bool _hasLocationPermission = false;

  /// Increases with every route request so a slow, outdated response can't
  /// overwrite the routes of a newer one.
  int _routeRequestId = 0;

  @override
  void initState() {
    super.initState();

    _originFocus.addListener(() {
      if (_originFocus.hasFocus) setState(() => _active = _Point.origin);
    });
    _destinationFocus.addListener(() {
      if (_destinationFocus.hasFocus) setState(() => _active = _Point.destination);
    });

    // Editing an existing trip: restore its points and its chosen route, without
    // asking Google again (that could silently change the route the user picked).
    if (widget.originCoordinates != null && widget.destinationCoordinates != null) {
      _origin = widget.originCoordinates;
      _destination = widget.destinationCoordinates;
      _originAddress = widget.originAddress;
      _destinationAddress = widget.destinationAddress;
      _originController.text = _originAddress ?? '';
      _destinationController.text = _destinationAddress ?? '';

      if (widget.polyline != null) {
        _routes = [
          _RouteOption(
            encodedPolyline: widget.polyline!,
            points: _decode(widget.polyline!),
            distanceKm: widget.totalKm ?? 0,
          ),
        ];
      }
    }

    _checkLocationPermission();
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _originFocus.dispose();
    _destinationFocus.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t.createTrip),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onLongPress: (place) => _setPoint(_active, place),
            onTap: (_) => FocusScope.of(context).unfocus(),
            initialCameraPosition: _origin != null
                ? CameraPosition(target: _origin!, zoom: _pointZoom)
                : _fallbackCamera,
            myLocationEnabled: _hasLocationPermission,
            // "Use my location" lives in the search card instead.
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            // Keep Google's logo and the camera framing clear of the floating
            // search card and route panel (the map itself never resizes).
            padding: EdgeInsets.only(
              top: _searchCardHeight,
              bottom: _bottomPanelHeight + MediaQuery.paddingOf(context).bottom,
            ),
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
          ),

          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: _buildSearchCard(context),
          ),

          if (_routes.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomPanel(context),
            ),

          if (_isBusy)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  // Space the floating panels cover, used as map padding so routes are framed
  // in the visible part of the map.
  // Kept compact: on a typical phone the map is only ~400dp tall.
  static const double _searchCardHeight = 120;
  static const double _routeCardsHeight = 60;
  static const double _confirmButtonHeight = 48;
  static const double _panelSpacing = 8;

  double get _bottomPanelHeight {
    if (_routes.isEmpty) return 0;
    final cards = _routes.length > 1 ? _routeCardsHeight + _panelSpacing : 0;
    return cards + _confirmButtonHeight + 2 * _panelSpacing;
  }

  Widget _buildSearchCard(BuildContext context) {
    final bothSet = _origin != null && _destination != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildPointField(
                        point: _Point.origin,
                        controller: _originController,
                        focusNode: _originFocus,
                        hint: t.origin,
                        dotColor: Colors.green,
                        trailing: IconButton(
                          tooltip: t.useMyLocation,
                          icon: const Icon(Icons.my_location),
                          onPressed: _isBusy ? null : _useMyLocation,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _buildPointField(
                        point: _Point.destination,
                        controller: _destinationController,
                        focusNode: _destinationFocus,
                        hint: t.destination,
                        dotColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: t.swapOriginDestination,
                  icon: const Icon(Icons.swap_vert),
                  onPressed: (_origin == null && _destination == null) || _isBusy ? null : _swap,
                ),
              ],
            ),
          ),
        ),

        if (!bothSet)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  _active == _Point.origin ? t.longPressToSetOrigin : t.longPressToSetDestination,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPointField({
    required _Point point,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required Color dotColor,
    Widget? trailing,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = _active == point;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primaryContainer.withValues(alpha: 0.5) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: !_isBusy,
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => _searchAddress(point, value),
        onTapOutside: (_) => focusNode.unfocus(),
        decoration: InputDecoration(
          // No floating label: the coloured dot already says which point this is,
          // and the label would make each row taller.
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          hintText: hint,
          prefixIcon: GestureDetector(
            // Tapping the dot selects the point for long-press without opening the keyboard.
            onTap: () => setState(() => _active = point),
            child: Icon(Icons.circle, size: 14, color: dotColor),
          ),
          suffixIcon: trailing,
        ),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    final distanceProvider = Provider.of<DistanceMetricProvider>(context);
    final selected = _routes[_selectedRoute];
    final selectedDistance =
        '${distanceProvider.convert(selected.distanceKm).toStringAsFixed(1)} ${distanceProvider.label}';

    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      // The panel's background runs to the screen edge; its contents stay
      // above the home indicator / system navigation buttons.
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, _panelSpacing, 12, _panelSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_routes.length > 1) ...[
                SizedBox(
                  height: _routeCardsHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _routes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => _buildRouteCard(context, i, distanceProvider),
                  ),
                ),
                const SizedBox(height: _panelSpacing),
              ],
              FilledButton.icon(
                onPressed: _isBusy ? null : _confirm,
                icon: const Icon(Icons.check),
                label: Text('${t.confirmTrip} · $selectedDistance'),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(_confirmButtonHeight)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteCard(BuildContext context, int index, DistanceMetricProvider distanceProvider) {
    final route = _routes[index];
    final isSelected = index == _selectedRoute;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final details = [
      '${distanceProvider.convert(route.distanceKm).toStringAsFixed(1)} ${distanceProvider.label}',
      if (route.durationText != null) route.durationText!,
    ].join(' · ');

    return SizedBox(
      width: 180,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () => _selectRoute(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  details,
                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (route.summary != null && route.summary!.isNotEmpty)
                  Text(
                    t.viaRoad(road: route.summary!),
                    style: textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() => {
        if (_origin != null) _marker(_Point.origin, _origin!, _originAddress),
        if (_destination != null) _marker(_Point.destination, _destination!, _destinationAddress),
      };

  Marker _marker(_Point point, LatLng position, String? address) {
    final isOrigin = point == _Point.origin;
    return Marker(
      markerId: MarkerId(isOrigin ? 'origin' : 'destination'),
      position: position,
      draggable: true,
      onDragEnd: (newPosition) => _setPoint(point, newPosition, moveCamera: false),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        isOrigin ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
      ),
      infoWindow: InfoWindow(
        title: isOrigin ? t.origin : t.destination,
        snippet: address,
      ),
    );
  }

  Set<Polyline> _buildPolylines() {
    final colorScheme = Theme.of(context).colorScheme;
    return {
      for (var i = 0; i < _routes.length; i++)
        Polyline(
          polylineId: PolylineId('route_$i'),
          points: _routes[i].points,
          color: i == _selectedRoute ? Colors.blue : colorScheme.outline,
          width: i == _selectedRoute ? 6 : 5,
          // Selected route is drawn on top of the alternatives.
          zIndex: i == _selectedRoute ? 1 : 0,
          consumeTapEvents: true,
          onTap: () => _selectRoute(i),
        ),
    };
  }

  // ---------------------------------------------------------------------------
  // Map & location
  // ---------------------------------------------------------------------------

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    if (_routes.isNotEmpty) {
      _fitCameraAfterLayout();
    } else if (_origin == null) {
      final here = await _currentLatLng(silent: true);
      if (here != null && mounted && _origin == null) {
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(here, 14));
      }
    }
  }

  Future<void> _checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (!mounted) return;
    setState(() {
      _hasLocationPermission =
          permission == LocationPermission.always || permission == LocationPermission.whileInUse;
    });
  }

  /// Returns the device location, asking for permission if needed. Returns null
  /// (and, unless [silent], tells the user why) when it isn't available.
  Future<LatLng?> _currentLatLng({bool silent = false}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!silent) SnackbarNotification.show(MessageType.alert, t.locationUnavailable);
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (!silent) SnackbarNotification.show(MessageType.alert, t.locationUnavailable);
        return null;
      }

      if (mounted && !_hasLocationPermission) setState(() => _hasLocationPermission = true);

      // Without a time limit this can wait forever when no fresh fix arrives
      // (indoors, tunnels), leaving the screen stuck in its loading state.
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(timeLimit: Duration(seconds: 8)),
        );
      } on TimeoutException {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        if (!silent) SnackbarNotification.show(MessageType.alert, t.locationUnavailable);
        return null;
      }
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Could not get current location: $e');
      if (!silent) SnackbarNotification.show(MessageType.alert, t.locationUnavailable);
      return null;
    }
  }

  Future<void> _useMyLocation() async {
    FocusScope.of(context).unfocus();
    setState(() => _isBusy = true);
    final here = await _currentLatLng();
    if (!mounted) return;
    setState(() => _isBusy = false);

    if (here != null) await _setPoint(_Point.origin, here);
  }

  /// Fits the camera after the next build. The plugin applies a changed map
  /// padding (e.g. the route panel just appeared) asynchronously, so a camera
  /// move sent in the same frame could still be framed with the old padding.
  void _fitCameraAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _fitCamera();
      });
    });
  }

  /// Zooms to show the selected route (or both points), or onto the single point set.
  void _fitCamera() {
    final controller = _mapController;
    if (controller == null) return;

    final points = <LatLng>[
      if (_routes.isNotEmpty) ..._routes[_selectedRoute].points,
      if (_origin != null) _origin!,
      if (_destination != null) _destination!,
    ];
    if (points.isEmpty) return;

    if (points.length == 1) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(points.first, _pointZoom));
      return;
    }

    var south = points.first.latitude, north = south;
    var west = points.first.longitude, east = west;
    for (final p in points) {
      south = math.min(south, p.latitude);
      north = math.max(north, p.latitude);
      west = math.min(west, p.longitude);
      east = math.max(east, p.longitude);
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east)),
        // Room for the marker pins, which stick out above their points.
        32,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Points
  // ---------------------------------------------------------------------------

  Future<void> _searchAddress(_Point point, String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isBusy = true);
    try {
      final locations = await locationFromAddress(query);
      if (!mounted) return;

      if (locations.isEmpty) {
        SnackbarNotification.show(MessageType.alert, t.noPlacesFoundWithThisAddress);
        return;
      }

      await _setPoint(point, LatLng(locations.first.latitude, locations.first.longitude));
    } catch (e) {
      debugPrint('Address search failed: $e');
      SnackbarNotification.show(MessageType.alert, t.noPlacesFoundWithThisAddress);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  /// Sets [point] to [position], looks up its address, then refreshes the routes.
  Future<void> _setPoint(_Point point, LatLng position, {bool moveCamera = true}) async {
    FocusScope.of(context).unfocus();

    final isOrigin = point == _Point.origin;
    setState(() {
      if (isOrigin) {
        _origin = position;
      } else {
        _destination = position;
      }
      // The old routes no longer match the points.
      _routes = [];
      _selectedRoute = 0;

      // Guide the user to the other point if it's still missing.
      if (isOrigin && _destination == null) _active = _Point.destination;
      if (!isOrigin && _origin == null) _active = _Point.origin;
    });

    final address = await _addressOf(position);
    if (!mounted) return;
    setState(() {
      if (isOrigin) {
        _originAddress = address;
        _originController.text = address;
      } else {
        _destinationAddress = address;
        _destinationController.text = address;
      }
    });

    if (_origin != null && _destination != null) {
      await _loadRoutes();
    } else if (moveCamera) {
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, _pointZoom));
    }
  }

  void _swap() {
    setState(() {
      final point = _origin;
      _origin = _destination;
      _destination = point;

      final address = _originAddress;
      _originAddress = _destinationAddress;
      _destinationAddress = address;

      _originController.text = _originAddress ?? '';
      _destinationController.text = _destinationAddress ?? '';
      _routes = [];
      _selectedRoute = 0;
    });

    // The way back isn't always the same road (one-way streets, highway exits).
    if (_origin != null && _destination != null) _loadRoutes();
  }

  Future<String> _addressOf(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final street = [p.street, p.name].firstWhere(
          (s) => s != null && s.trim().isNotEmpty,
          orElse: () => null,
        );
        final city = [p.postalCode, p.locality]
            .where((s) => s != null && s.trim().isNotEmpty)
            .join(' ');
        final address = [street, city].where((s) => s != null && s.trim().isNotEmpty).join(', ');
        if (address.isNotEmpty) return address;
      }
    } catch (e) {
      debugPrint('Reverse geocoding failed: $e');
    }
    // Better than "null, null null".
    return '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
  }

  // ---------------------------------------------------------------------------
  // Routes
  // ---------------------------------------------------------------------------

  Future<void> _loadRoutes() async {
    final origin = _origin, destination = _destination;
    if (origin == null || destination == null) return;

    final requestId = ++_routeRequestId;
    setState(() => _isBusy = true);

    try {
      // Plain http on purpose: RequestHandler would attach the user's BenzinApp
      // Authorization header, which must never be sent to Google.
      final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'alternatives': 'true',
        'language': LocaleSettings.currentLocale.languageCode,
        'key': DataHolder().getPlacesApiKey(),
      });
      final response = await http.get(uri).timeout(const Duration(seconds: 15));
      if (!mounted || requestId != _routeRequestId) return;

      final body = json.decode(response.body) as Map<String, dynamic>;
      final routes = (body['routes'] as List?) ?? const [];

      if (routes.isEmpty) {
        SnackbarNotification.show(MessageType.alert, t.noTripsFound);
        setState(() => _routes = []);
        return;
      }

      final options = routes.map((route) {
        final leg = route['legs'][0];
        final encoded = route['overview_polyline']['points'] as String;
        return _RouteOption(
          encodedPolyline: encoded,
          points: _decode(encoded),
          distanceKm: (leg['distance']['value'] as num) / 1000,
          durationText: leg['duration']?['text'] as String?,
          summary: route['summary'] as String?,
        );
      }).toList();

      setState(() {
        _routes = options;
        _selectedRoute = 0;
      });
      // The route panel appearing makes the map shorter, so frame the route
      // only once the map has been resized.
      _fitCameraAfterLayout();
    } catch (e) {
      debugPrint('Route request failed: $e');
      if (mounted && requestId == _routeRequestId) {
        SnackbarNotification.show(MessageType.danger, t.routeRequestFailed);
      }
    } finally {
      if (mounted && requestId == _routeRequestId) setState(() => _isBusy = false);
    }
  }

  void _selectRoute(int index) {
    if (index == _selectedRoute) return;
    setState(() => _selectedRoute = index);
    _fitCameraAfterLayout();
  }

  List<LatLng> _decode(String encoded) => PolylinePoints()
      .decodePolyline(encoded)
      .map((p) => LatLng(p.latitude, p.longitude))
      .toList();

  void _confirm() {
    final route = _routes[_selectedRoute];
    Navigator.pop<Map<String, dynamic>>(context, {
      'originAddress': _originAddress!,
      'originCoordinates': _origin!,
      'destinationAddress': _destinationAddress!,
      'destinationCoordinates': _destination!,
      'polyline': route.encodedPolyline,
      'totalKm': route.distanceKm,
    });
  }
}
