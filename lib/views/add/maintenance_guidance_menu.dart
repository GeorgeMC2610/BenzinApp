import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MaintenanceGuidanceMenu extends StatelessWidget {

  const MaintenanceGuidanceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                height: 110,
                width: 110,
                child: FloatingActionButton(
                  onPressed: () {

                  },
                  elevation: 0.5,
                  child: const Icon(FontAwesomeIcons.carBurst, size: 50,),
                ),
              ),

              const SizedBox(width: 15),

              SizedBox(
                height: 110,
                width: 110,
                child: FloatingActionButton(
                  onPressed: () {

                  },
                  elevation: 0.5,
                  child: const Icon(FontAwesomeIcons.car, size: 50,),
                ),
              ),

              const SizedBox(width: 15),

              const SizedBox(
                height: 110,
                width: 110,
                child: FloatingActionButton(
                  backgroundColor: Colors.white24,
                  onPressed: null,
                  elevation: 0.5,
                  child: Icon(FontAwesomeIcons.wrench, size: 50,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}