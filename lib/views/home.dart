import 'package:benzinapp/views/add/fuel_fill_record.dart';
import 'package:benzinapp/views/add/maintenance_guidance_menu.dart';
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

  void _floatingActionButtonPressed() {
    Widget page;

    switch (_selectedTabIndex) {
      case 1:
        page = const AddFuelFillRecord();
        break;
      case 2:
        page = const MaintenanceGuidanceMenu();
        break;
      case 3:
        page = const RegisterPage();
        break;
      default:
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
        backgroundColor: Theme.of(this.context).colorScheme.primaryFixedDim,
        currentIndex: _selectedTabIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
          label:  AppLocalizations.of(context)!.home,
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