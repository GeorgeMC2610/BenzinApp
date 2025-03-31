import 'package:benzinapp/views/forms/fuel_fill_record.dart';
import 'package:benzinapp/views/forms/maintenance_guidance_menu.dart';
import 'package:benzinapp/views/forms/trip.dart';
import 'package:benzinapp/views/fragments/fuel_fills.dart';
import 'package:benzinapp/views/fragments/maintenance.dart';
import 'package:benzinapp/views/fragments/overview.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/fragments/trips.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

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
          _title = AppLocalizations.of(context)!.home;
          break;
        case 1:
          _title = AppLocalizations.of(context)!.fuelFills;
          break;
        case 2:
          _title = AppLocalizations.of(context)!.maintenance;
          break;
        case 3:
          _title = AppLocalizations.of(context)!.trips;
          break;
        case 4:
          _title = AppLocalizations.of(context)!.settings;
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

      // CHECK FOR PERMISSION, OTHERWISE DON'T CONTINUE.
      //var permissionResult = await

      return;
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
            label: AppLocalizations.of(context)!.home,
            icon: const Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.fuelFills,
              icon: const Icon(Icons.local_gas_station)
          ),
          BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.maintenance,
              icon: const Icon(Icons.car_repair)
          ),
          BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.trips,
              icon: const Icon(Icons.pin_drop)
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.settings,
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