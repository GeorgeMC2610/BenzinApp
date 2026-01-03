
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ConfirmationDialog {
  static Future<void> show(
      BuildContext context,
      String title,
      String content,
      Function(bool) onConfirm,
      ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(translate('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(false);
              },
            ),
            TextButton(
              child: Text(translate('confirm')),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(true);
              },
            ),
          ],
        );
      },
    );
  }
}
