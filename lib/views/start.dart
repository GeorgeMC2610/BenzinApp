import 'package:benzinapp/services/token_manager.dart';
import 'package:benzinapp/views/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../services/data_holder.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/images/benzinapp_logo_round.png",
              width: 250,
              height: 250,
            ),

            const SizedBox(height: 15.0),

            const LinearProgressIndicator(
                value: null
            )
          ],
        ),
      )

    );
  }

  void _load() {

    if (TokenManager().isTokenPresent) {
      _attemptLogin();
    }


  }

  void _attemptLogin() async {
    var client = http.Client();
    var uri = Uri.parse('${DataHolder.destination}/');

    client.get(uri,
      headers: 
    );
  }
}