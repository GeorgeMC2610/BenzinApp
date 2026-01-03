import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/managers/trip_manager.dart';
import 'package:benzinapp/views/maps/create_trip.dart';
import 'package:benzinapp/views/shared/dialogs/delete_dialog.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/classes/trip.dart';
import '../shared/buttons/persistent_add_or_edit_button.dart';
import '../shared/notification.dart';

class TripForm extends StatefulWidget {
  const TripForm({super.key, this.trip, this.isViewing = false});

  final Trip? trip;
  final bool isViewing;

  @override
  State<StatefulWidget> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _timesRepeatingController = TextEditingController();

  String? titleError, timesRepeatingError;

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

  submit() async {
    setState(() {
      titleError = _emptyValidator(_titleController.text);
      timesRepeatingError = _validator(_timesRepeatingController.text);
    });

    if (polyline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        // TODO: Convert to new notification.
          SnackBar(
            content: Text(translate('pleaseMakeATrip')),
          )
      );
    }

    if (timesRepeatingError != null || titleError != null || polyline == null) {
      return;
    }

    TripManager manager = TripManager();

    if (widget.trip == null) {
      var newTrip = Trip(
          id: -1, title: _titleController.text,
          timesRepeating: int.parse(_titleController.text),
          totalKm: totalKm!, created: DateTime.now(), updated: DateTime.now(),
          originLatitude: originLatitude!, originLongitude: originLongitude!,
          destinationLatitude: destinationLatitude!, destinationLongitude: destinationLongitude!,
          originAddress: originAddress!, destinationAddress: destinationAddress!, polyline: polyline!
      );

      setState(() {
        _isLoading = true;
      });
      await manager.create(newTrip);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    }
    else {
      widget.trip!.title = _titleController.text;
      widget.trip!.timesRepeating = int.parse(_titleController.text);
      widget.trip!.totalKm = totalKm!;
      widget.trip!.originLatitude = originLatitude!;
      widget.trip!.originLongitude = originLongitude!;
      widget.trip!.originAddress = originAddress!;
      widget.trip!.destinationLongitude = destinationLongitude!;
      widget.trip!.destinationLatitude = destinationLatitude!;
      widget.trip!.polyline = polyline!;

      setState(() {
        _isLoading = true;
      });
      await manager.update(widget.trip!);
      setState(() {
        _isLoading = false;
      });

      // server errors from back-end
      if (manager.errors.isNotEmpty) {
        _handleErrors(manager);
        return;
      }

      if (widget.isViewing) {
        Navigator.pop(context, widget.trip);
      }
      else {
        Navigator.pop(context);
      }
    }
  }

  _handleErrors(TripManager manager) {
    setState(() {
      titleError = manager.errors["title"]?.join(', ');
      timesRepeatingError = manager.errors["times_repeating"]?.join(', ');
    });

    if (manager.errors.containsKey('base')) {
      SnackbarNotification.show(
        MessageType.danger,
        manager.errors['base']!.join(', '),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.trip != null ? translate('editTrip') : translate('addTrip')),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        PersistentAddOrEditButton(
          onPressed: submit,
          isEditing: widget.trip != null,
          isLoading: _isLoading,
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DividerWithText(
                  text: translate('tripInfo'),
                  lineColor: Colors.grey,
                  textColor: Theme.of(context).colorScheme.primary,
                  textSize: 16
              ),

              TextField(
                controller: _titleController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  setState(() {
                    titleError = _emptyValidator(_titleController.text);
                  });
                },
                enabled: !_isLoading,
                maxLength: 127,
                decoration: InputDecoration(
                  errorText: titleError,
                  errorMaxLines: 4,
                  counterText: '',
                  hintText: translate('tripNameHint'),
                  labelText: translate('tripName2'),
                  prefixIcon: const Icon(FontAwesomeIcons.tag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _timesRepeatingController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        setState(() {
                          timesRepeatingError = _validator(_timesRepeatingController.text);
                        });
                      },
                      enabled: !_isLoading && !_isRepeating,
                      decoration: InputDecoration(
                        errorText: timesRepeatingError,
                        errorMaxLines: 4,
                        hintText: translate('timesRepeatingHint'),
                        labelText: translate('timesRepeating'),
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

                        AutoSizeText(translate('noRepeat'), maxLines: 1, maxFontSize: 19,)
                      ],
                    )
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  polyline == null ? translate('makeTrip') : getTripString(),
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
                      label: Text(translate('makeOnMaps')),
                      icon: const Icon(Icons.pin_drop),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : polyline == null ? null : () {

                        DeleteDialog.show(
                          context, translate('deleteTrip'),
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
                      label: AutoSizeText(translate('deleteTrip'), minFontSize: 10),
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
                "${translate('tripDistance')} $totalKm km",
                style: Theme.of(context).textTheme.labelLarge,
              )
            ],
          ),
        ),
      ),
    );

  }

  String getTripString() {
    return '${translate('from')}: $originAddress\n\n ${translate('to')}: $destinationAddress';
  }

  String? _validator(String field) {

    if (field.isEmpty || field == '') {
      return translate('cannotBeEmpty');
    }

    if (double.tryParse(field) == null) {
      return translate('invalidNumber');
    }

    if (double.parse(field) < 0) {
      return translate('cannotBeNegative');
    }

    return null;
  }

  String? _emptyValidator(String field) {
    if (field.isEmpty || field == '') {
      return translate('cannotBeEmpty');
    }

    return null;
  }
}

