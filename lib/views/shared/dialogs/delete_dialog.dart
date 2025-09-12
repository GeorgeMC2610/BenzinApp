import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';


class DeleteDialog {

  static void show(BuildContext context, String title, Function(Function(bool)) onDeleteButtonPressed) {
    showDialog<void>(
        context: context,
        builder: (BuildContext buildContext) {

          bool isLoading = false;

          return StatefulBuilder(
            builder: (buildContext, setState) {
              return AlertDialog(
                title: Text(title),
                content: Text(
                    translate('confirmDeleteGenericBody')),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(width: 1.0, color: Colors.red),
                    ),
                    child: Text(translate('cancel')),
                  ),

                  ElevatedButton.icon(
                    icon: isLoading ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.delete),
                    onPressed: isLoading
                        ? null : () {
                          setState(() => isLoading = true);
                          onDeleteButtonPressed((bool success) {
                            if (success) {
                              Navigator.pop(context); // Close dialog
                            } else {
                              setState(() => isLoading = false);
                            }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white
                    ),
                    label: Text(translate('delete')),
                  ),
                ],
              );
            }
          );
        }
    );
  }

}