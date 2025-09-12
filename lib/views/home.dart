import 'package:benzinapp/views/forms/fuel_fill_record.dart';
import 'package:benzinapp/views/forms/maintenance_guidance_menu.dart';
import 'package:benzinapp/views/forms/trip.dart';
import 'package:benzinapp/views/fragments/fuel_fills.dart';
import 'package:benzinapp/views/fragments/maintenance.dart';
import 'package:benzinapp/views/fragments/overview.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/fragments/trips.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _title = '';
  int _selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    _setTitle(context);
  }

  final List<Widget> pages = const [
    OverviewFragment(),
    FuelFillsFragment(),
    MaintenanceFragment(),
    TripsFragment(),
    SettingsFragment()
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setTitle(context);
  }

  void _setTitle(BuildContext context) {
    setState(() {
      switch (_selectedTabIndex) {
        case 0:
          _title = translate('home');
          break;
        case 1:
          _title = translate('fuelFills');
          break;
        case 2:
          _title = translate('maintenance');
          break;
        case 3:
          _title = translate('trips');
          break;
        case 4:
          _title = translate('settings');
          break;
      }
    });
  }

  Widget _buildBody(int index, BuildContext context) {
    return pages[index];
  }

  void _floatingActionButtonPressed() async {
    Widget page;

    switch (_selectedTabIndex) {
      case 1:
        page = const FuelFillRecordForm();
        break;
      case 2:
        page = const MaintenanceGuidanceMenu();
        break;
      case 3:
        page = const TripForm();
        break;
      default:
        return;
    }

    if (_selectedTabIndex == 3) {

      bool serviceEnabled;
      LocationPermission initialPermission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(translate('enableLocationSetting')))
        );
        return;
      }

      initialPermission = await Geolocator.checkPermission();
      var requestedPermission;
      switch (initialPermission) {
        case LocationPermission.denied:
          requestedPermission = await Geolocator.requestPermission();
          break;
        case LocationPermission.deniedForever:
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(translate('permissionDeniedForever')))
          );
          break;
        case LocationPermission.whileInUse:
          break;
        case LocationPermission.always:
          break;
        case LocationPermission.unableToDetermine:
          requestedPermission = await Geolocator.requestPermission();
          break;
      }

      if (requestedPermission != null) {
        switch (requestedPermission) {
          case LocationPermission.denied:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translate('mustGrantPermissionToUseThis')))
            );
            return;
          case LocationPermission.deniedForever:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translate('permissionDeniedForever')))
            );
            return;
          case LocationPermission.unableToDetermine:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(translate('unableToDeterminePermissionStatus')))
            );
            return;
          default:
            break;
        }
      }
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => page
        )
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
      ),
      body: _buildBody(_selectedTabIndex, context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(this.context).colorScheme.inversePrimary,
        currentIndex: _selectedTabIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: translate('home'),
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              label: translate('fuelFills'),
              icon: const Icon(Icons.local_gas_station)
          ),
          BottomNavigationBarItem(
              label: translate('maintenance'),
              icon: const Icon(Icons.car_repair)
          ),
          BottomNavigationBarItem(
              label: translate('trips'),
              icon: const Icon(Icons.pin_drop)
          ),
          BottomNavigationBarItem(
            label: translate('settings'),
            icon: const Icon(Icons.settings),
          ),
        ]),
      floatingActionButton: _selectedTabIndex == 0 || _selectedTabIndex == 4 ? null : FloatingActionButton(
        heroTag: null,
        onPressed: _floatingActionButtonPressed,
        tooltip: 'Add',
        elevation: 3,
        child: const Icon(Icons.add),
      ),
    );
  }

}