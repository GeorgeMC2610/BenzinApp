import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(AppLocalizations.of(context)!.registerToBenzinApp),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                        AppLocalizations.of(context)!.welcome,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      )
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Image.asset(
                      "lib/assets/images/benzinapp_logo_round.png",
                      height: 150,
                      width: 150,
                    ),
                  ),

                  const SizedBox(height: 20),

                  DividerWithText(
                    text: AppLocalizations.of(context)!.accountDetails,
                    textSize: 17,
                    lineColor: Colors.black, textColor: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  // BenzinApp Logo
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.usernameRegisterHint,
                      labelText: AppLocalizations.of(context)!.username,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // ACCOUNT DETAILS REGION
                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.passwordHint,
                            labelText: AppLocalizations.of(context)!.password,
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 7.5),

                      Expanded(
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.passwordConfirmationHint,
                            labelText: AppLocalizations.of(context)!.passwordConfirmation,
                            suffixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),

                  // CAR DETAILS REGION
                  const SizedBox(height: 50),

                  DividerWithText(
                    text: AppLocalizations.of(context)!.carDetails,
                    textSize: 17,
                    lineColor: Colors.black, textColor: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  // BenzinApp Logo
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.carManufacturerHint,
                      labelText: AppLocalizations.of(context)!.carManufacturer,
                      prefixIcon: const Icon(Icons.car_rental),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Password TextField

                  Row(
                    children: [

                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.carModelHint,
                            labelText: AppLocalizations.of(context)!.carModel,
                            prefixIcon: const Icon(Icons.car_rental_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 7.5),

                      Expanded(
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(signed: true),
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.carYearHint,
                            labelText: AppLocalizations.of(context)!.carYear,
                            suffixIcon: const Icon(Icons.calendar_month),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 50),

                  // Register Button
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(4),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 184, 134, 59)
                          )
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.register,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black
                        ),
                      ),
                      icon: const Icon(Icons.app_registration, color: Colors.black),
                    ),
                  )
                ]
            ),
          ),
        ));
  }

}