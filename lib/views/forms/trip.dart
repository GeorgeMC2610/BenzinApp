import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/maps/create_trip.dart';
import 'package:benzinapp/views/shared/dialogs/delete_dialog.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/classes/trip.dart';
import '../../services/data_holder.dart';
import '../../services/request_handler.dart';

class TripForm extends StatefulWidget {
  const TripForm({super.key, this.trip, this.isViewing});

  final Trip? trip;
  final bool? isViewing;

  @override
  State<StatefulWidget> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timesRepeatingController = TextEditingController();

  String? _titleValidator, _timesRepeatingValidator;

  bool _isLoading = false;
  bool _isRepeating = false;

  String? originAddress;
  String? destinationAddress;

  double? originLatitude;
  double? originLongitude;
  double? destinationLatitude;
  double? destinationLongitude;

  double? totalKm;
  String? polyline;

  @override
  void initState() {
    super.initState();

    if (widget.trip != null) {
      _titleController.text = widget.trip!.title;
      _timesRepeatingController.text = widget.trip!.timesRepeating.toString();
      _isRepeating = widget.trip!.timesRepeating == 1;
      originAddress = widget.trip!.originAddress;
      destinationAddress = widget.trip!.destinationAddress;
      originLatitude = widget.trip!.originLatitude;
      originLongitude = widget.trip!.originLongitude;
      destinationLatitude = widget.trip!.destinationLatitude;
      destinationLongitude = widget.trip!.destinationLongitude;
      totalKm = widget.trip!.totalKm;
      polyline = widget.trip!.polyline;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.trip != null ? AppLocalizations.of(context)!.editTrip : AppLocalizations.of(context)!.addTrip),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : () {
            setState(() {
              _titleValidator = _emptyValidator(_titleController.text);
              _timesRepeatingValidator = _validator(_timesRepeatingController.text);
            });

            if (polyline == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.pleaseMakeATrip),
                  )
              );
            }

            if (_timesRepeatingValidator != null || _titleValidator != null || polyline == null) {
              return;
            }

            setState(() {
              _isLoading = true;
            });

            var uriString = '${DataHolder.destination}/repeated_trip';
            var body = {
              'title': _titleController.text,
              'times_repeating': _timesRepeatingController.text,
              'total_km': totalKm!.toString(),
              'origin_latitude': originLatitude!.toString(),
              'origin_longitude': originLongitude!.toString(),
              'destination_latitude': destinationLatitude!.toString(),
              'destination_longitude': destinationLongitude!.toString(),
              'origin_address': originAddress!,
              'destination_address': destinationAddress!,
              'polyline': polyline!,
            };

            if (widget.trip == null) {
              RequestHandler.sendPostRequest(
                  uriString,
                  true, body,
                  _whenCompleteRequest,
                  (response) {
                    var jsonResponse = jsonDecode(response.body);
                    var trip = Trip.fromJson(jsonResponse["repeated_trip"]);
                    DataHolder.addTrip(trip);
                    Navigator.pop(context);
                  }
              );
            }
            else {
              uriString = '${DataHolder.destination}/repeated_trip/${widget.trip!.id}';
              RequestHandler.sendPatchRequest(
                  uriString,
                  body,
                  _whenCompleteRequest,
                  (response) {
                    var jsonObject = jsonDecode(response.body);
                    var trip = Trip.fromJson(jsonObject["repeated_trip"]);
                    DataHolder.setTrip(trip);

                    if (widget.isViewing == null) {
                      Navigator.pop(context);
                    }
                    else if (widget.isViewing!) {
                      Navigator.pop<Trip>(context, trip);
                    }
                  }
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
              widget.trip == null ?
              Icons.add : Icons.check
          ),
          label: widget.trip == null ?
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DividerWithText(
                  text: AppLocalizations.of(context)!.tripInfo,
                  lineColor: Colors.black,
                  textColor: Colors.black,
                  textSize: 16
              ),

              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  setState(() {
                    _titleValidator = _emptyValidator(_titleController.text);
                  });
                },
                enabled: !_isLoading,
                decoration: InputDecoration(
                  errorText: _titleValidator,
                  hintText: AppLocalizations.of(context)!.tripNameHint,
                  labelText: AppLocalizations.of(context)!.tripName2,
                  prefixIcon: const Icon(FontAwesomeIcons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _timesRepeatingController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        setState(() {
                          _timesRepeatingValidator = _validator(_timesRepeatingController.text);
                        });
                      },
                      enabled: !_isLoading && !_isRepeating,
                      decoration: InputDecoration(
                        errorText: _timesRepeatingValidator,
                        hintText: AppLocalizations.of(context)!.timesRepeatingHint,
                        labelText: AppLocalizations.of(context)!.timesRepeating,
                        prefixIcon: const Icon(FontAwesomeIcons.repeat),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Checkbox(
                            value: _isRepeating,
                            onChanged: (value) {
                              setState(() {
                                _isRepeating = value!;

                                if (_isRepeating) {
                                  _timesRepeatingController.text = '1';
                                }
                              });
                            }
                        ),

                        AutoSizeText(AppLocalizations.of(context)!.noRepeat, maxLines: 1, maxFontSize: 19,)
                      ],
                    )
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  polyline == null ? AppLocalizations.of(context)!.makeTrip : getTripString(),
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
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
                                builder: (context) => polyline == null ? const CreateTrip() :
                                    CreateTrip(
                                      polyline: polyline!,
                                      originAddress: originAddress!,
                                      destinationAddress: destinationAddress!,
                                      originCoordinates: LatLng(originLatitude!, originLongitude!),
                                      destinationCoordinates: LatLng(destinationLatitude!, destinationLongitude!),
                                      totalKm: totalKm!,
                                    )
                            )
                        );

                        if (data == null) {
                          return;
                        }

                        setState(() {
                          originAddress = data["originAddress"];
                          destinationAddress = data["destinationAddress"];
                          polyline = data["polyline"];
                          originLatitude = data["originCoordinates"].latitude;
                          originLongitude = data["originCoordinates"].longitude;
                          destinationLatitude = data["destinationCoordinates"].latitude;
                          destinationLongitude = data["destinationCoordinates"].longitude;
                          totalKm = data['totalKm'];
                        });

                      },
                      label: Text(AppLocalizations.of(context)!.makeOnMaps),
                      icon: const Icon(Icons.pin_drop),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : polyline == null ? null : () {

                        DeleteDialog.show(
                          context, AppLocalizations.of(context)!.deleteTrip,
                          (value) {
                            setState(() {
                              originAddress = null;
                              destinationAddress = null;
                              polyline = null;
                              originLatitude = null;
                              originLongitude = null;
                              destinationLatitude = null;
                              destinationLongitude = null;
                              totalKm = null;
                            });

                            value(true);
                          }
                        );

                      },
                      label: AutoSizeText(AppLocalizations.of(context)!.deleteTrip, minFontSize: 10),
                      icon: const Icon(Icons.cancel_outlined),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).buttonTheme.colorScheme!.error,
                        foregroundColor: Theme.of(context).buttonTheme.colorScheme!.onError
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              totalKm == null ? const SizedBox() :
              Text(
                "${AppLocalizations.of(context)!.tripDistance} $totalKm km",
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
        ),
      ),
    );

  }

  String getTripString() {
    return '${AppLocalizations.of(context)!.from}: $originAddress\n\n ${AppLocalizations.of(context)!.to}: $destinationAddress';
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

  String? _emptyValidator(String field) {
    if (field.isEmpty || field == '') {
      return AppLocalizations.of(context)!.cannotBeEmpty;
    }

    return null;
  }

  void _whenCompleteRequest() {
    setState(() {
      _isLoading = false;
    });
  }
}

