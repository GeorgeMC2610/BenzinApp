import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:BenzinApp/services/classes/malfunction.dart';
import 'package:BenzinApp/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/data_holder.dart';
import '../../services/locale_string_converter.dart';
import '../maps/select_location.dart';
import '../shared/divider_with_text.dart';
import 'package:http/http.dart' as http;

class MalfunctionForm extends StatefulWidget {
  const MalfunctionForm({super.key, this.malfunction, this.isViewing});

  final Malfunction? malfunction;
  final bool? isViewing;

  @override
  State<StatefulWidget> createState() => _MalfunctionFormState();
}

class _MalfunctionFormState extends State<MalfunctionForm> {

  DateTime? _selectedDate, _selectedDateEnded;
  String? _selectedAddress;
  LatLng? _selectedCoordinates;
  final TextEditingController kmController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  String? _kmValidator, _titleValidator, _descriptionValidator, _costValidator;
  bool _isLoading = false;
  bool _markAsFixed = false;

  @override
  void initState() {
    super.initState();

    if (widget.malfunction != null) {
      kmController.text = widget.malfunction!.kilometersDiscovered.toString();
      titleController.text = widget.malfunction!.title;
      descriptionController.text = widget.malfunction!.description;
      _selectedDate = widget.malfunction!.dateStarted;

      if (widget.malfunction!.isFixed()) {
        _markAsFixed = true;
        costController.text = widget.malfunction!.cost!.toString();
        _selectedDateEnded = widget.malfunction!.dateEnded!;
        _selectedAddress = widget.malfunction!.getAddress();
        _selectedCoordinates = widget.malfunction!.getCoordinates();
      }
    }
  }

  Future<void> _whenPostRequestIsComplete(http.Response response) async {
    var jsonResponse = jsonDecode(response.body);
    var malfunction = Malfunction.fromJson(jsonResponse["malfunction"]);
    DataHolder.addMalfunction(malfunction);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<void> _whenPatchRequestIsComplete(http.Response response) async {
    var jsonObject = jsonDecode(response.body);
    var malfunction = Malfunction.fromJson(jsonObject["malfunction"]);
    DataHolder.setMalfunction(malfunction);

    if (widget.isViewing == null) {
      Navigator.pop(context);
    }
    else if (widget.isViewing!) {
      Navigator.pop<Malfunction>(context, malfunction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.addMalfunction), // TODO: Change to be edit.
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : () {
            // TODO: For Donald Knuth's sake, please refactor this...
            // when adding a malfunction
            if (widget.malfunction == null) {
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

              var uriString = '${DataHolder.destination}/malfunction';
              var body = {
                'at_km': kmController.text,
                'title': titleController.text.trim(),
                'started': _selectedDate!.toIso8601String().substring(0, 10),
                'description': descriptionController.text.trim(),
              };

              RequestHandler.sendPostRequest(uriString, true, body,
                      () {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  _whenPostRequestIsComplete
              );
            }
            // when editing a malfunction
            else {
              setState(() {
                _titleValidator = _emptyValidator(titleController.text);
                _kmValidator = _numberValidator(kmController.text);
                _descriptionValidator = _emptyValidator(descriptionController.text);
              });

              if (_markAsFixed) {
                setState(() {
                  _costValidator = _numberValidator(costController.text);
                });
              }

              if (_selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.noDateSelected),
                    )
                );
              }

              if (_markAsFixed) {
                if (_selectedDateEnded == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.pleaseSelectAnEndDate),
                      )
                  );
                }

                if (_kmValidator != null ||
                    _titleValidator != null ||
                    _descriptionValidator != null ||
                    _selectedDate == null ||
                    _selectedDateEnded == null ||
                    _costValidator != null
                ) {
                  return;
                }
              }
              else {
                if (_kmValidator != null ||
                    _titleValidator != null ||
                    _descriptionValidator != null ||
                    _selectedDate == null
                ) {
                  return;
                }
              }

              setState(() {
                _isLoading = true;
              });

              var uriString = '${DataHolder.destination}/malfunction/${widget.malfunction!.id}';
              var body = {
                'at_km': kmController.text,
                'title': titleController.text.trim(),
                'started': _selectedDate!.toIso8601String().substring(0, 10),
                'description': descriptionController.text.trim(),
              };

              if (_markAsFixed) {
                body = {
                  ...body,
                  'ended': _selectedDateEnded!.toIso8601String().substring(0, 10),
                  'cost_eur': costController.text,
                  'location': _selectedCoordinates == null ? '' : '$_selectedAddress|${_selectedCoordinates!.latitude}, ${_selectedCoordinates!.longitude}'
                };
              }

              RequestHandler.sendPatchRequest(uriString, body,
                      () {
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  _whenPatchRequestIsComplete
              );
            }
          },
          icon: _isLoading ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 5,
                strokeCap: StrokeCap.square,
              )
          ) : Icon(
              widget.malfunction == null ?
              Icons.add : Icons.check
          ),
          label: widget.malfunction == null ?
          Text(AppLocalizations.of(context)!.confirmAdd) : Text(AppLocalizations.of(context)!.confirmEdit),
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondaryFixed),
              minimumSize: const WidgetStatePropertyAll(Size(200, 55),
              )
          ),
        ),
      ],
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
                      onEditingComplete: () async {
                        setState(() {
                          _titleValidator = _emptyValidator(titleController.text);
                        });
                      },
                      textInputAction: TextInputAction.next,
                      controller: kmController,
                      enabled: !_isLoading,
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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () async {
                        setState(() {
                          _kmValidator = _numberValidator(kmController.text);
                        });
                      },
                      enabled: !_isLoading,
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
                onEditingComplete: () async {
                  setState(() {
                    _descriptionValidator = _emptyValidator(descriptionController.text);
                  });
                },
                minLines: 2,
                maxLines: 10,
                enabled: !_isLoading,
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
                      onPressed: _isLoading ? null : () async {
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
                      onPressed: _isLoading ? null : () {
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
                  ),
                ],
              ),

              // Checkbox only appears when the malfunction is not being edited
              // TODO: Localize all of the below
              widget.malfunction != null ? Row(
                children: [
                  Checkbox(
                      value: _markAsFixed,
                      onChanged: (value) {
                        setState(() {
                          _markAsFixed = value!;
                        });
                      }
                  ),
                  Text(AppLocalizations.of(context)!.iFixedThisMalfunction)
                ],
              ) : const SizedBox(),

              !_markAsFixed && _getMalfunctionStatus() ? Text(
                AppLocalizations.of(context)!.uncheckingTheBox,
                style: Theme.of(context).textTheme.labelLarge
              ) : const SizedBox(),

              _markAsFixed ? _editForm() : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  bool _getMalfunctionStatus() {
    if (widget.malfunction == null) {
      return false;
    }

    return widget.malfunction!.isFixed();
  }

  Widget _editForm() {
    return Column(
      children: [
        const SizedBox(height: 10),

        DividerWithText(
            text: AppLocalizations.of(context)!.repairData,
            lineColor: Colors.black,
            textColor: Colors.black,
            textSize: 16
        ),

        const SizedBox(height: 20),


        TextField(
          keyboardType: TextInputType.number,
          controller: costController,
          onEditingComplete: () async {
            setState(() {
              _costValidator = _numberValidator(costController.text);
            });
          },
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.repairCostHint,
            errorText: _costValidator,
            labelText: AppLocalizations.of(context)!.repairCost,
            prefixIcon: const Icon(Icons.euro),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // DATE ENDED
        AutoSizeText(
          maxLines: 1,
          _selectedDateEnded == null ?
          AppLocalizations.of(context)!.selectADate :
          LocaleStringConverter.dateShortDayMonthYearString(context, _selectedDateEnded!),
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),

        // DATE ENDED PICKER
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).buttonTheme.colorScheme!.primaryContainer
                ),
                onPressed: _isLoading ? null : () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    lastDate: DateTime.now(),
                    firstDate: DateTime.parse('1886-29-01'),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDateEnded = pickedDate;
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
                onPressed: _isLoading ? null : () {
                  setState(() {
                    _selectedDateEnded = DateTime.now();
                  });
                },
                label: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.todayDate, minFontSize: 10),
                icon: const Icon(Icons.more_time_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).buttonTheme.colorScheme!.inversePrimary

                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),

        AutoSizeText(
          maxLines: 1,
          _selectedAddress == null ?
          AppLocalizations.of(context)!.selectLocation :
          _selectedAddress!,
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
                onPressed: _isLoading ? null : () async {
                  var data = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SelectLocationOnMaps(
                            address: _selectedAddress,
                            coordinates: _selectedCoordinates,
                          )
                      )
                  );

                  if (data == null) {
                    return;
                  }

                  setState(() {
                    _selectedAddress = data["address"]!;
                    _selectedCoordinates = data["coordinates"]!;
                  });
                },
                label: Text(AppLocalizations.of(context)!.pickAPlace),
                icon: const Icon(Icons.map),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoading || _selectedAddress == null ? null : () {
                  setState(() {
                    _selectedAddress = null;
                    _selectedCoordinates = null;
                  });
                },
                label: AutoSizeText(maxLines: 1, AppLocalizations.of(context)!.removeLocation, minFontSize: 10),
                icon: const Icon(Icons.cancel),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary
                ),
              ),
            )
          ],
        ),
      ],
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