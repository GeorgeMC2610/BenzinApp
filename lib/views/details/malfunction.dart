import 'package:auto_size_text/auto_size_text.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/locale_string_converter.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../services/data_holder.dart';
import '../../services/request_handler.dart';
import '../forms/malfunction.dart';
import '../maps/view_trip.dart';
import '../shared/dialogs/delete_dialog.dart';
import '../shared/shared_font_styles.dart';

class ViewMalfunction extends StatefulWidget {
  const ViewMalfunction({super.key, required this.malfunction});

  final Malfunction malfunction;

  @override
  State<StatefulWidget> createState() => _ViewMalfunctionState();
}

class _ViewMalfunctionState extends State<ViewMalfunction> {

  late Malfunction malfunction;

  @override
  void initState() {
    super.initState();
    malfunction = widget.malfunction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('malfunctionData')),
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
                    var malfunction = await Navigator.push<Malfunction>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MalfunctionForm(malfunction: this.malfunction, isViewing: true)
                        )
                    );

                    if (malfunction != null) {
                      setState(() {
                        this.malfunction = malfunction;
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
                        translate('confirmDeleteMalfunction'),
                            (Function(bool) setLoadingState) async {

                          await MalfunctionManager().delete(widget.malfunction);
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
              ),
            )
          ],
        )
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              // CARD WITH BASE DATA
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

                        // DATE DISCOVERED
                        Text(translate('dateDiscovered'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            LocaleStringConverter.dateDayMonthYearString(context, malfunction.dateStarted),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        // KM DISCOVERED
                        Text(translate('kilometersDiscovered'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            '${
                          LocaleStringConverter.formattedBigInt(
                              context, malfunction.kilometersDiscovered)
                        } km',
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        // STATUS (FIXED/UNFIXED)
                        Text(translate('status'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            malfunction.isFixed() ?
                            translate('fixedMalfunction') :
                            translate('ongoingMalfunction'),
                            style: TextStyle(
                              fontSize: 20.5,
                              fontWeight: FontWeight.bold,
                              color: malfunction.isFixed() ? Colors.green : Colors.red
                            ),
                        ),

                        const SizedBox(height: 20),

                        // SEVERITY
                        Text('Severity', style: SharedFontStyles.legendTextStyle),
                        _getSeverity()
                      ],
                    ),
                  ),
                ),
              ),

              // TITLE AND DESCRIPTION
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
                        Text(translate('title'), style: SharedFontStyles.legendTextStyle),
                        Text(malfunction.title, style: SharedFontStyles.descriptiveTextStyle),

                        const SizedBox(height: 20),

                        Text(translate('description'), style: SharedFontStyles.legendTextStyle),
                        Text(malfunction.description, style: SharedFontStyles.descriptiveTextStyle),
                      ],
                    ),
                  ),
                ),
              ),

              // CONDITIONAL DATA IF THE MALFUNCTION IS FIXED
              malfunction.isFixed() ?
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
                        Text(translate('dateFixed'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            LocaleStringConverter.dateDayMonthYearString(context, malfunction.dateEnded!),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),

                        const SizedBox(height: 20),

                        Text(translate('locationFixed'), style: SharedFontStyles.legendTextStyle),
                        Text(malfunction.getAddress() ?? '-', style: SharedFontStyles.descriptiveTextStyle),

                        malfunction.location == null ? const SizedBox() : ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => ViewTripOnMaps(
                                        positions: [malfunction.getCoordinates()!],
                                        addresses: [malfunction.getAddress()!]
                                    )
                                )
                            );
                          },
                          label: AutoSizeText(translate('seeOnMap'), maxLines: 1, minFontSize: 8),
                          icon: const Icon(Icons.pin_drop, size: 20.3,),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(translate('cost'), style: SharedFontStyles.legendTextStyle),
                        Text(
                            malfunction.cost == null ? '-' : CarManager().watchingCar!.toCurrency(LocaleStringConverter.formattedDouble(context, malfunction.cost!)),
                            style: SharedFontStyles.descriptiveTextStyle
                        ),
                      ],
                    ),
                  ),
                ),
              ) :  const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSeverity() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        severityIconIndex[malfunction.severity]!,
        const SizedBox(width: 5),
        Text(
          severityStringIndex(context)[malfunction.severity]!,
          style: TextStyle(
            fontSize: 20.5,
            fontWeight: FontWeight.bold,
            color: severityColorIndex[malfunction.severity]!,
          ),
        ),
      ],
    );
  }

  Map<int, String> severityStringIndex(context) {
    return {
      1: translate('severityLowest'),
      2: translate('severityLow'),
      3: translate('severityNormal'),
      4: translate('severityHigh'),
      5: translate('severityHighest')
    };
  }

  static const Map<int, Color> severityColorIndex = {
    1: Colors.blue,
    2: Colors.lightBlue,
    3: Colors.orange,
    4: Colors.red,
    5: Color.fromARGB(255, 128, 0, 0)
  };

  static const Map<int, Icon> severityIconIndex = {
    1: Icon(Icons.arrow_downward, color: Colors.blue, size: 20),
    2: Icon(Icons.keyboard_arrow_down, color: Colors.lightBlue, size: 20),
    3: Icon(Icons.horizontal_rule_sharp, color: Colors.orange, size: 20),
    4: Icon(Icons.keyboard_arrow_up, color: Colors.red, size: 20),
    5: Icon(Icons.arrow_upward, color:Color.fromARGB(255, 128, 0, 0), size: 20),
  };


}