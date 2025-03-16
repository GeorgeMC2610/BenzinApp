import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/forms/malfunction.dart';
import 'package:benzinapp/views/forms/service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MaintenanceGuidanceMenu extends StatelessWidget {

  const MaintenanceGuidanceMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.maintenanceCategory),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              AutoSizeText(
                maxLines: 1,
                maxFontSize: 30,
                minFontSize: 12,
                AppLocalizations.of(context)!.selectMaintenanceType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Expanded(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.malfunction),

                        const SizedBox(height: 10),

                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddMalfunction()
                                  )
                              );
                            },
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(FontAwesomeIcons.carBurst, size: 45),
                          ),
                        ),
                      ],
                    )
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.service),

                        const SizedBox(height: 10),

                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddService()
                                  )
                              );
                            },
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(FontAwesomeIcons.wrench, size: 40),
                          ),
                        ),
                      ],
                    )
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.comingSoon),

                        const SizedBox(height: 10),

                        Container(
                          width: 100, // Set square dimensions
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: FloatingActionButton(
                            heroTag: null,
                            backgroundColor: Colors.white24,
                            onPressed: null,
                            elevation: 0.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(FontAwesomeIcons.question, size: 40),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}