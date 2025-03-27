import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/token_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/data_holder.dart';
import '../../services/locale_string_converter.dart';
import '../shared/divider_with_text.dart';
import 'package:http/http.dart' as http;

class AddMalfunction extends StatefulWidget {
  const AddMalfunction({super.key, this.malfunction, this.isViewing});

  final Malfunction? malfunction;
  final bool? isViewing;

  @override
  State<StatefulWidget> createState() => _AddMalfunctionState();
}

class _AddMalfunctionState extends State<AddMalfunction> {

  DateTime? _selectedDate;
  final TextEditingController kmController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? _kmValidator, _titleValidator, _descriptionValidator;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.addMalfunction),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // add field checks
          setState(() {
            _titleValidator = _emptyValidator(titleController.text);
            _kmValidator = _numberValidator(kmController.text);
            _descriptionValidator = _emptyValidator(descriptionController.text);
          });

          if (_selectedDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.noDateSelected),
                )
            );
          }

          if (_kmValidator != null ||
              _titleValidator != null ||
              _descriptionValidator != null ||
              _selectedDate == null
          ) {
            return;
          }
          
          setState(() {
            _isLoading = true;
          });

          // when the field checks pass, send the request.
          var client = http.Client();
          var uriString = '${DataHolder.destination}/malfunction';
          var body = {
            'at_km': kmController.text,
            'title': titleController.text.trim(),
            'started': _selectedDate!.toIso8601String().substring(0, 10),
            'description': descriptionController.text.trim(),
          };

          if (widget.malfunction == null) {
            var uri = Uri.parse(uriString);
            client.post(
              uri,
              headers: {
                'Authorization': TokenManager().token!,
              },
              body: body
            ).whenComplete(() {
              setState(() {
                _isLoading = false;
              });
            }).then((response) {
              var jsonResponse = jsonDecode(response.body);
              var malfunction = Malfunction.fromJson(jsonResponse);
              DataHolder.addMalfunction(malfunction);
              Navigator.pop(context);
            });
          }
          else {
            
          }

          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.confirmAdd),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
            minimumSize: const WidgetStatePropertyAll(Size(200, 55),
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              DividerWithText(
                  text: AppLocalizations.of(context)!.malfunctionData,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: kmController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.serviceMileageHint,
                        errorText: _kmValidator,
                        labelText: AppLocalizations.of(context)!.serviceMileage2,
                        prefixIcon: const Icon(Icons.speed),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    flex: 3,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.malfunctionTitleHint,
                        errorText: _titleValidator,
                        labelText: AppLocalizations.of(context)!.malfunctionTitle,
                        prefixIcon: const Icon(Icons.next_plan_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              TextField(
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 10,
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.descriptionHintMalfunction,
                  labelText: AppLocalizations.of(context)!.description2,
                  errorText: _descriptionValidator,
                  prefixIcon: const Icon(Icons.comment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              AutoSizeText(
                maxLines: 1,
                _selectedDate == null ?
                AppLocalizations.of(context)!.selectADate :
                LocaleStringConverter.dateShortDayMonthYearString(context, _selectedDate!),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          lastDate: DateTime.now(),
                          firstDate: DateTime.parse('1886-29-01'),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      label: Text(AppLocalizations.of(context)!.pickADate),
                      icon: const Icon(Icons.date_range),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime.now();
                        });
                      },
                      label: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.todayDate, minFontSize: 10),
                      icon: const Icon(Icons.more_time_rounded),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).buttonTheme.colorScheme!.primaryFixedDim
                          )
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _numberValidator(String field) {

    if (field.isEmpty || field == '') {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    if (double.parse(field) < 0) {
      return AppLocalizations.of(context)!.cannotBeNegative;
    }

    return null;
  }

  String? _emptyValidator(String field) {
    if (field.isEmpty || field == '') {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    return null;
  }
}