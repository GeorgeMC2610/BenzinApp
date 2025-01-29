import 'package:benzinapp/views/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.loginToBenzinApp),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                    AppLocalizations.of(context)!.welcomeBack,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35
                    ),
                  )
              ),

              const SizedBox(height: 80),

              Center(
                child: Image.asset(
                  "lib/assets/images/benzinapp_logo_round.png",
                  height: 150,
                  width: 150,
                ),
              ),

              const SizedBox(height: 80),

              // BenzinApp Logo
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.usernameHint,
                  labelText: AppLocalizations.of(context)!.username,
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),

              // Password TextField
              TextField(
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

              const SizedBox(height: 50),

              Center(
                child: TapRegion(
                  child: Text(
                    AppLocalizations.of(context)!.dontHaveAnAccount,
                  ),
                  onTapInside: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()
                      )
                    );
                  },
                )
              ),

              const SizedBox(height: 50),

              // Login Button
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
                    AppLocalizations.of(context)!.login,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                    ),
                  ),
                  icon: const Icon(Icons.login, color: Colors.black),
                ),
              )
            ]
          ),
        ),
      ));
  }
}
