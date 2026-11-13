import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/forms/fuel_fill_record.dart';
import 'package:benzinapp/i18n/strings.g.dart';
import 'package:flutter/material.dart';

class InsufficientDataCard extends StatelessWidget {
  const InsufficientDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Center(
                child: AutoSizeText(
                  maxLines: 1,
                  t.insufficientDataTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                t.insufficientDataText,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FuelFillRecordForm()
                        )
                    );
                  },
                  label: Text(t.addFuelFillRecord),
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryFixed,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryFixed
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}