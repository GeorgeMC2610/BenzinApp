import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/car/claim_old_car.dart';
import 'package:benzinapp/views/car/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class UseCaseRegister extends StatelessWidget {
  const UseCaseRegister({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(translate('welcomeUseCaseAppBar')),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  Center(
                    child: AutoSizeText(
                      translate('welcomeUseCase'),
                      minFontSize: 20,
                      maxLines: 1,
                      maxFontSize: 35,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Center(
                    child: Text(
                      translate('welcomeUseCaseSubtitle')
                    ),
                  ),

                  const SizedBox(height: 165),

                  SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClaimOldCar()
                            )
                        );
                      },
                      label: AutoSizeText(
                        maxLines: 2,
                        translate('welcomeUseCaseYesButton'),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      icon: const Icon(Icons.history, size: 35),
                      iconAlignment: IconAlignment.start,
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                          foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()
                            )
                        );
                      },
                      label: AutoSizeText(
                          maxLines: 1,
                          translate('welcomeUseCaseNoButton'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                      icon: const Icon(Icons.person_off_sharp, size: 35),
                      iconAlignment: IconAlignment.start,
                    ),
                  ),

                ],
              ),
          )
      )
  );

}