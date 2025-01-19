import 'package:flutter/material.dart';

class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<SettingsFragment> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {

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

                const ListTile(
                  title: Text("Dark Mode"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: Icon(Icons.dark_mode),
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

                const ListTile(
                  title: Text("Fast Login"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: Icon(Icons.fast_forward),
                ),
                const ListTile(
                  title: Text("Logout"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: Icon(Icons.logout),
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

                const ListTile(
                  title: Text("Privacy Policy"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: Icon(Icons.security_outlined),
                ),
                const ListTile(
                  title: Text("Terms and Conditions"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  leading: Icon(Icons.newspaper),
                ),
                ListTile(
                  title: const Text("Technical Information"),
                  onTap: () {
                  },
                  trailing: const Icon(Icons.arrow_forward_ios),
                  leading: const Icon(Icons.developer_mode),
                ),
              ])
      ),
    );


  }

}