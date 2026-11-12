import 'package:benzinapp/views/drawer/malfunction_drawer.dart';
import 'package:benzinapp/views/drawer/service_drawer.dart';
import 'package:flutter/material.dart';
import 'package:benzinapp/i18n/strings.g.dart';

class MaintenanceDrawer extends StatelessWidget {
  const MaintenanceDrawer({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialIndex,
      child: Drawer(
        child: Column(
          children: [
            Material(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: SafeArea(
                bottom: false,
                child: TabBar(
                  tabs: [
                    Tab(text: t.malfunctions),
                    Tab(text: t.services),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  MalfunctionDrawerContent(),
                  ServiceDrawerContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
