import 'package:benzinapp/views/about/app_information.dart';
import 'package:benzinapp/views/about/terms_and_conditions.dart';
import 'package:benzinapp/views/login.dart';
import 'package:benzinapp/views/about/privacy_policy.dart';
import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {

  bool lightMode = false;
  bool fastLogin = false;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Application Appearance",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: const Text("Dark Mode"),
                  trailing: Switch.adaptive(
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.dark_mode, color: Colors.black);
                      }
                      return const Icon(Icons.light_mode, color: Colors.white);
                    }),
                    value: lightMode,
                    onChanged: (bool value) {

                      if (lightMode == false)
                      {
                        setState(() {
                          lightMode = true;
                        });
                      }
                      else
                      {
                        setState(() {
                          lightMode = false;
                        });
                      }
                    }),
                  leading: const Icon(Icons.dark_mode),
                ),
                ListTile(
                  title: const Text("Language"),
                  onTap: () {

                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.language_outlined),
                ),

                const SizedBox(height: 30),

                const Text("Account Settings",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: const Text("Fast Login"),
                  trailing: Switch.adaptive(
                    thumbIcon: WidgetStateProperty.resolveWith<Icon?>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const Icon(Icons.electric_bolt, color: Colors.black);
                      }
                      return null;
                    }),
                    value: fastLogin,
                      onChanged: (bool value) {

                        if (fastLogin == false)
                        {
                          setState(() {
                            fastLogin = true;
                          });
                        }
                        else
                        {
                          setState(() {
                            fastLogin = false;
                          });
                        }
                      },

                  ),
                  leading: const Icon(Icons.offline_bolt_outlined),
                ),
                ListTile(
                  title: const Text("Logout", style: TextStyle(color: Color.fromARGB(255, 200, 0, 0))),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 200, 0, 0)),
                  leading: const Icon(Icons.logout, color: Color.fromARGB(255, 200, 0, 0)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()
                      )
                    );
                  },
                ),
                const ListTile(
                  title: Text("Edit Account"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: Icon(Icons.edit),
                ),

                const SizedBox(height: 30),

                const Text("About the App",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  )
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: const Text("Privacy Policy"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyPolicy()
                        )
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.security_outlined),
                ),
                ListTile(
                  title: Text("Terms and Conditions"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TermsAndConditions()
                        )
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.newspaper),
                ),
                ListTile(
                  title: const Text("App Information"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AppInformation()
                        )
                    );
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.developer_mode),
                ),
              ])
      ),
    );


  }

}