import 'package:benzinapp/views/fragments/fuel_fills.dart';
import 'package:benzinapp/views/fragments/maintenance.dart';
import 'package:benzinapp/views/fragments/overview.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:benzinapp/views/fragments/trips.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _title = 'Home';
  int _selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {

      // sets the current index to the corresponding fragment.
      _selectedTabIndex = index;

      // this is to ensure the title changes dynamically, apart from the body.
      switch (index) {
        case 0:
          _title = 'Home';
        case 1:
          _title = 'Fuel Fills';
        case 2:
          _title = 'Maintenance';
        case 3:
          _title = 'Trips';
        case 4:
          _title = 'Settings';
        default:
          _title = 'BenzinApp';
      }
    });
  }

  Widget _buildBody(int index, BuildContext context) {

    // you might see the same thing happening in the `_onItemTapped`
    // if the code is migrated here, the strings will not update correctly.
    switch (index) {
      case 0:
        return const OverviewFragment();
      case 1:
        return const FuelFillsFragment();
      case 2:
        return const MaintenanceFragment();
      case 3:
        return const TripsFragment();
      case 4:
        return const SettingsFragment();
      default:
        throw UnimplementedError();
    }
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
        backgroundColor: Theme.of(this.context).colorScheme.primaryFixedDim,
        currentIndex: _selectedTabIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
              label: 'Fuel Fills',
              icon: Icon(Icons.local_gas_station)
          ),
          BottomNavigationBarItem(
              label: 'Maintenance',
              icon: Icon(Icons.car_repair)
          ),
          BottomNavigationBarItem(
              label: 'Trips',
              icon: Icon(Icons.pin_drop)
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ]),
      floatingActionButton: _selectedTabIndex == 0 || _selectedTabIndex == 4 ? null : FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        elevation: 3,
        child: const Icon(Icons.add),
      ),
    );
  }

}