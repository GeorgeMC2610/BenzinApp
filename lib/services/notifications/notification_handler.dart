import 'dart:convert';
import 'package:benzinapp/main.dart';
import 'package:benzinapp/services/classes/fuel_fill_record.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/services/classes/service.dart';
import 'package:benzinapp/services/classes/trip.dart';
import 'package:benzinapp/services/managers/car_manager.dart';
import 'package:benzinapp/services/managers/fuel_fill_record_manager.dart';
import 'package:benzinapp/services/managers/malfunction_manager.dart';
import 'package:benzinapp/services/managers/service_manager.dart';
import 'package:benzinapp/services/managers/trip_manager.dart';
import 'package:benzinapp/views/car/general_invitations.dart';
import 'package:benzinapp/views/details/fuel_fill_record.dart';
import 'package:benzinapp/views/details/malfunction.dart';
import 'package:benzinapp/views/details/service.dart';
import 'package:benzinapp/views/details/trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class NotificationHandler {
  /// Parses raw argument object or JSON string into a Map<String, dynamic>.
  static Map<String, dynamic>? parseArgs(dynamic args) {
    if (args == null) return null;
    if (args is Map<String, dynamic>) return args;
    if (args is Map) return Map<String, dynamic>.from(args);
    try {
      final decoded = jsonDecode(args as String);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Resolves translated title and body from the message data payload,
  /// falling back to standard notification title and body if available.
  static (String? title, String? body) resolveTitleAndBody({
    required Map<String, dynamic> data,
    String? fallbackTitle,
    String? fallbackBody,
  }) {
    String? title;
    String? body;

    // 1. Check if the message is using translatable keys in data payload
    if (data.containsKey('title_key') && data['title_key'] != null) {
      title = translate(data['title_key'].toString(), args: parseArgs(data['title_args']));
    }

    if (data.containsKey('body_key') && data['body_key'] != null) {
      body = translate(data['body_key'].toString(), args: parseArgs(data['body_args']));
    }

    // 2. Fallback to standard notification values if keys weren't found or translated
    title ??= fallbackTitle;
    body ??= fallbackBody;

    return (title, body);
  }

  /// Parses screen_args and screen from raw payload (Map or String), sets the watching car,
  /// and creates/inserts the record locally in the appropriate Manager.
  static Future<void> processRecord(dynamic rawPayload) async {
    if (rawPayload == null) return;

    try {
      Map<String, dynamic> payload;
      if (rawPayload is String) {
        payload = Map<String, dynamic>.from(jsonDecode(rawPayload) as Map);
      } else if (rawPayload is Map) {
        payload = Map<String, dynamic>.from(rawPayload);
      } else {
        return;
      }

      Map<String, dynamic>? screenArgs;
      if (payload.containsKey('screen_args') && payload['screen_args'] != null) {
        dynamic rawArgs = payload['screen_args'];
        if (rawArgs is String) {
          rawArgs = jsonDecode(rawArgs);
        }
        if (rawArgs is Map) {
          screenArgs = Map<String, dynamic>.from(rawArgs);
        }
      }

      if (screenArgs != null && screenArgs.containsKey('car_id')) {
        final carId = screenArgs['car_id'];
        if (CarManager().local == null) {
          await CarManager().index();
        }
        final car = CarManager().local?.where((c) => c.id == carId).firstOrNull;
        if (car != null) {
          CarManager().watchingCar = car;
        }
      }

      if (payload.containsKey('screen') && screenArgs != null) {
        switch (payload['screen']) {
          case 'fuel_fill_record_screen':
            final FuelFillRecord newRecord = FuelFillRecord.fromJson(screenArgs);
            FuelFillRecordManager().manualInsert(newRecord);
            break;
          case 'malfunction_screen':
            final Malfunction newRecord = Malfunction.fromJson(screenArgs);
            MalfunctionManager().manualInsert(newRecord);
            break;
          case 'service_screen':
            final Service newRecord = Service.fromJson(screenArgs);
            ServiceManager().manualInsert(newRecord);
            break;
          case 'repeated_trip_screen':
            final Trip newRecord = Trip.fromJson(screenArgs);
            TripManager().manualInsert(newRecord);
            break;
          default:
            break;
        }
      }
    } catch (e, stackTrace) {
      print('Error creating record from notification payload: $e');
      print(stackTrace);
    }
  }

  /// Handles incoming notification payload (either Map or JSON String) and performs navigation.
  static Future<void> handlePayload(dynamic rawPayload) async {
    if (rawPayload == null) return;

    try {
      Map<String, dynamic> payload;
      if (rawPayload is String) {
        payload = Map<String, dynamic>.from(jsonDecode(rawPayload) as Map);
      } else if (rawPayload is Map) {
        payload = Map<String, dynamic>.from(rawPayload);
      } else {
        return;
      }

      print('Handling notification navigation with payload: $payload');

      // Create/insert record locally into appropriate manager
      await processRecord(payload);

      Map<String, dynamic>? screenArgs;
      if (payload.containsKey('screen_args') && payload['screen_args'] != null) {
        dynamic rawArgs = payload['screen_args'];
        if (rawArgs is String) {
          rawArgs = jsonDecode(rawArgs);
        }
        if (rawArgs is Map) {
          screenArgs = Map<String, dynamic>.from(rawArgs);
        }
      }

      // Navigate to target screen
      if (payload.containsKey('screen')) {
        switch (payload['screen']) {
          case 'fuel_fill_record_screen':
            if (screenArgs != null) {
              final FuelFillRecord newRecord = FuelFillRecord.fromJson(screenArgs);
              navigateNowOrLater(ViewFuelFillRecord(record: newRecord));
            }
            break;
          case 'malfunction_screen':
            if (screenArgs != null) {
              final Malfunction newRecord = Malfunction.fromJson(screenArgs);
              navigateNowOrLater(ViewMalfunction(malfunction: newRecord));
            }
            break;
          case 'service_screen':
            if (screenArgs != null) {
              final Service newRecord = Service.fromJson(screenArgs);
              navigateNowOrLater(ViewService(service: newRecord));
            }
            break;
          case 'repeated_trip_screen':
            if (screenArgs != null) {
              final Trip newRecord = Trip.fromJson(screenArgs);
              navigateNowOrLater(ViewTrip(trip: newRecord));
            }
            break;
          case 'invitation_screen':
            navigateNowOrLater(const GeneralInvitations());
            break;
          default:
            break;
        }
      }
    } catch (e, stackTrace) {
      print('Error handling notification payload: $e');
      print(stackTrace);
    }
  }

  /// Navigates to a screen immediately if NavigatorState is available,
  /// or schedules navigation after the current frame callback.
  static void navigateNowOrLater(Widget nextScreen) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (BuildContext context) => nextScreen,
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (BuildContext context) => nextScreen,
        ),
      ));
    }
  }
}
