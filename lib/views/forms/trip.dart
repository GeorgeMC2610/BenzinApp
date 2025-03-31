import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/views/shared/divider_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/classes/trip.dart';

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

  late String originAddress;
  late String destinationAddress;

  late double originLatitude;
  late double originLongitude;
  late double destinationLatitude;
  late double destinationLongitude;

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
      polyline = widget.trip!.polyline;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.trip != null ? 'Edit Trip' : 'Add Trip'),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton.icon(
          onPressed: _isLoading ? null : () {

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
            children: [
              DividerWithText(
                  text: 'Trip Info',
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
                  hintText: AppLocalizations.of(context)!.commentsHint,
                  labelText: AppLocalizations.of(context)!.malfunctionTitle,
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
                        hintText: AppLocalizations.of(context)!.descriptionHint,
                        labelText: AppLocalizations.of(context)!.description2,
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

                        AutoSizeText("Doesn't repeat", maxLines: 1, maxFontSize: 19,)
                      ],
                    )
                  ),
                ],
              ),

              const SizedBox(height: 20),

              AutoSizeText(
                maxLines: 1,
                polyline == null ? 'Make Trip...' : getTripString(),
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

                        // open the selecting view for maps.

                      },
                      label: Text('Make on Maps'),
                      icon: const Icon(Icons.pin_drop),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          polyline = null;
                        });
                      },
                      label: AutoSizeText('Delete Trip', minFontSize: 10),
                      icon: const Icon(Icons.cancel_outlined),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).buttonTheme.colorScheme!.error
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).buttonTheme.colorScheme!.onError
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  String getTripString() {
    return 'FROM: $originAddress\n\n TO: $destinationAddress';
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
}

