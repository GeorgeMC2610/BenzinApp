import 'package:flutter/material.dart';

class CardEditDeleteButtons extends StatelessWidget {
  const CardEditDeleteButtons({
    super.key,
    required this.onEditButtonPressed,
    required this.onDeleteButtonPressed
  });

  final Function() onEditButtonPressed;
  final Function() onDeleteButtonPressed;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [

      // EDIT BUTTON
      FloatingActionButton.small(
        heroTag: null,
        onPressed: onEditButtonPressed,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.edit),
      ),

      // DELETE BUTTON
      FloatingActionButton.small(
        heroTag: null,
        onPressed: onDeleteButtonPressed,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
        child: const Icon(Icons.delete),
      ),
    ],
  );
}