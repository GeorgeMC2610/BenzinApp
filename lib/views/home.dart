import 'package:benzinapp/views/fragments/fuel_fills.dart';
import 'package:benzinapp/views/fragments/maintenance.dart';
import 'package:benzinapp/views/fragments/overview.dart';
import 'package:benzinapp/views/fragments/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  final String title = 'BenzinApp';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Widget _buildBody(int index, BuildContext context) {

    switch (index) {
      case 0:
        return const OverviewFragment();
      case 1:
        return const FuelFillsFragment();
      case 2:
        return const MaintenanceFragment();
      case 3:
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
        title: Text(widget.title),
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
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ]),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

}