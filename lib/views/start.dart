import 'dart:io';

import 'package:benzinapp/views/home.dart';
import 'package:flutter/material.dart';

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

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) { // Ensures widget is still in the tree before navigation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });

  }
}