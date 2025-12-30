import 'package:flutter/material.dart';

class LoadingDataCard extends StatelessWidget {
  const LoadingDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 24.0,
              color: Colors.grey[300],
              margin: const EdgeInsets.only(bottom: 8.0),
            ),
            const SizedBox(height: 16.0),

            const LinearProgressIndicator(),
            const SizedBox(height: 12.0),
            const LinearProgressIndicator(),
            const SizedBox(height: 12.0),
            const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

}