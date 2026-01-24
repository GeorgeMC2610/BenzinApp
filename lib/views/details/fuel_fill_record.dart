import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/language_provider.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/views/shared/dialogs/delete_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:benzinapp/views/shared/shared_font_styles.dart';
import '../../services/managers/fuel_fill_record_manager.dart';
import '../forms/fuel_fill_record.dart';

class ViewFuelFillRecord extends StatefulWidget {
  const ViewFuelFillRecord({super.key, required this.record});

  final FuelFillRecord record;

  @override
  State<StatefulWidget> createState() => _ViewFuelFillRecordState();
}

class _ViewFuelFillRecordState extends State<ViewFuelFillRecord> {
  late FuelFillRecord fuelFillRecord;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fuelFillRecord = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate('fuelFillRecordData')),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        persistentFooterAlignment: AlignmentDirectional.centerStart,
        // EDIT AND DELETE BUTTONS
        persistentFooterButtons: [


          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                    onPressed: () async {
                      var fuelFillRecord = await Navigator.push<FuelFillRecord>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FuelFillRecordForm(fuelFillRecord: this.fuelFillRecord, viewingRecord: true)
                          )
                      );

                      if (fuelFillRecord != null) {
                        setState(() {
                          this.fuelFillRecord = fuelFillRecord;
                        });
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                    icon: const Icon(Icons.edit),
                    label: Text(translate('edit'))
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: FilledButton.tonalIcon(
                      onPressed: () {
                        DeleteDialog.show(
                            context,
                            translate('confirmDeleteFuelFill'),
                                (Function(bool) setLoadingState) async {
                              setState(() => isLoading = true);

                              await FuelFillRecordManager().delete(widget.record);
                              setState(() {
                                isLoading = false;
                              });
                              setLoadingState(true);
                              Navigator.pop(context);
                            }
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      icon: const Icon(Icons.delete),
                      label: Text(translate('delete'))
                  )
              )
            ],
          )
        ],
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // fuelFillRecord.getNext() == null?
                    // ListTile(
                    //     leading: const Icon(Icons.info),
                    //     title: Text(translate('statsCannotBeCalculated'))
                    // ) : const SizedBox(),

                    // singular card with initial data
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  const Icon(Icons.access_time_outlined, size: 30,),
                                  const SizedBox(width: 15),
                                  AutoSizeText(
                                    _getFullDateTimeString(context),
                                    maxLines: 1,
                                    maxFontSize: 19,
                                    style: const TextStyle(
                                        fontSize: 18
                                    ),

                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(Icons.local_gas_station_outlined, size: 30),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: AutoSizeText(
                                      _getFuelString(context),
                                      maxLines: 1,
                                      maxFontSize: 19,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _getFuelString(context) == translate('unspecified') ? Colors.grey : Theme.of(context).colorScheme.onSurface,
                                        fontStyle: _getFuelString(context) == translate('unspecified') ? FontStyle.italic : FontStyle.normal,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              fuelFillRecord.totalKilometers == null ?
                              const SizedBox() :
                              const SizedBox(height: 10),

                              fuelFillRecord.totalKilometers == null ?
                              const SizedBox() :
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.carSide, size: 25),
                                  const SizedBox(width: 20),
                                  AutoSizeText(
                                    maxLines: 1,
                                    maxFontSize: 19,
                                    '${LocaleStringConverter.formattedBigInt(context, fuelFillRecord.totalKilometers!)} km',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // TWO CARDS WITH THE DATA AND THE STATS
                    Row(
                      children: [

                        Expanded(
                          flex: 2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(translate('liters'), style: SharedFontStyles.legendTextStyle),
                                  Text("${fuelFillRecord.liters} lt", style: SharedFontStyles.descriptiveTextStyle),

                                  const SizedBox(height: 20),

                                  Text(translate('kilometers'), style: SharedFontStyles.legendTextStyle),
                                  Text("${fuelFillRecord.kilometers} km", style: SharedFontStyles.descriptiveTextStyle),

                                  const SizedBox(height: 20),

                                  Text(translate('cost'), style: SharedFontStyles.legendTextStyle),
                                  Text(CarManager().watchingCar!.toCurrency(fuelFillRecord.cost.toString()), style: SharedFontStyles.descriptiveTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // fuelFillRecord.getNext() == null ? const SizedBox() :
                        Expanded(
                          flex: 3,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(translate('consumption'), style: SharedFontStyles.legendTextStyle),
                                  Text("${fuelFillRecord.getConsumption().toStringAsFixed(3)} lt/100km", style: SharedFontStyles.mainTextStyle),

                                  const SizedBox(height: 20),

                                  Text(translate('efficiency'), style: SharedFontStyles.legendTextStyle),
                                  Text("${fuelFillRecord.getEfficiency().toStringAsFixed(3)} km/lt", style: SharedFontStyles.mainTextStyle),

                                  const SizedBox(height: 20),

                                  Text(translate('travel_cost'), style: SharedFontStyles.legendTextStyle),
                                  Text("${CarManager().watchingCar!.toCurrency(fuelFillRecord.getTravelCost().toStringAsFixed(2))}/km", style: SharedFontStyles.mainTextStyle),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // singular card with initial data
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  const Icon(Icons.comment_outlined, size: 15, color: CupertinoColors.systemGrey,),
                                  const SizedBox(width: 5),
                                  Text(translate('comments'), style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey)),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                fuelFillRecord.comments == null ? translate('nothingToShowHere') : fuelFillRecord.comments!,
                                style: TextStyle(
                                    color: fuelFillRecord.comments == null ? Colors.grey : Theme.of(context).colorScheme.onSurface,
                                    fontStyle: fuelFillRecord.comments == null ? FontStyle.italic : FontStyle.normal
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  String _getFullDateTimeString(BuildContext context) {
    return DateFormat.yMMMMEEEEd(Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag()).format(fuelFillRecord.dateTime);
  }

  String _getFuelString(BuildContext context) {

    if (fuelFillRecord.fuelType == null) {

      if (fuelFillRecord.gasStation == null) {
        return translate('unspecified');
      }

      return fuelFillRecord.gasStation!;
    }

    return fuelFillRecord.gasStation == null? fuelFillRecord.fuelType! : "${fuelFillRecord.fuelType}, ${fuelFillRecord.gasStation}";
  }
}