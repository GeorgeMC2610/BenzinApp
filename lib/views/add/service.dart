import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/data_holder.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<StatefulWidget> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {

  DateTime? _selectedDate;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController kmController = TextEditingController();
  final TextEditingController nextKmController = TextEditingController();

  String? _costValidator, _kmValidator, _nextKmValidator, _descValidator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.addService),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // temporary code so it runs

          // add field checks
          setState(() {
            _costValidator = _numValidator(costController.text);
            _kmValidator = _validator(kmController.text);
            _nextKmValidator = _numValidator(nextKmController.text);
            _descValidator = _emptyValidator(descriptionController.text);
          });

          if (_selectedDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.noDateSelected),
                )
            );
          }

          if (_kmValidator != null ||
              _costValidator != null ||
              _nextKmValidator != null ||
              _descValidator != null ||
              _selectedDate == null
          ) {
            return;
          }

          // when the field checks pass, send the request.

          Service service = Service(
            id: 19,
            dateHappened: _selectedDate!,
            description: descriptionController.text,
            cost: double.parse(costController.text),
            kilometersDone: int.parse(kmController.text),
            nextServiceKilometers: int.parse(nextKmController.text)
          );

          DataHolder.addService(service);
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              DividerWithText(
                  text: AppLocalizations.of(context)!.serviceInfo,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 16
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 10,
                      decoration: InputDecoration(
                        errorText: _descValidator,
                        hintText: AppLocalizations.of(context)!.descriptionHint,
                        labelText: AppLocalizations.of(context)!.description2,
                        prefixIcon: const Icon(FontAwesomeIcons.wrench),
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
                      controller: costController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorText: _costValidator,
                        hintText: AppLocalizations.of(context)!.costHint,
                        labelText: AppLocalizations.of(context)!.cost2,
                        prefixIcon: const Icon(Icons.euro),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: kmController,
                      decoration: InputDecoration(
                        errorText: _kmValidator,
                        hintText: AppLocalizations.of(context)!.serviceMileageHint,
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
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: nextKmController,
                      decoration: InputDecoration(
                        errorText: _nextKmValidator,
                        hintText: AppLocalizations.of(context)!.nextServiceMileageHint,
                        labelText: AppLocalizations.of(context)!.nextServiceMileage,
                        prefixIcon: const Icon(Icons.next_plan_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 25),

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

  String? _validator(String field) {

    if (field.isEmpty || field == '') {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    if (double.parse(field) < 0) {
      return AppLocalizations.of(context)!.cannotBeNegative;
    }

    return null;
  }

  String? _numValidator(String field) {
    if (field == '' || field.isEmpty) {
      return null;
    }
    else if (double.parse(field) < 0) {
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