import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PersistentAddOrEditButton extends StatelessWidget {
  const PersistentAddOrEditButton({
    super.key,
    required this.onPressed,
    required this.isEditing,
    required this.isLoading
  });

  final bool isEditing;
  final bool isLoading;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width * 0.9,
    child: ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            value: null,
            strokeWidth: 5,
            strokeCap: StrokeCap.square,
          )
      ) : Icon(
          !isEditing ?
          Icons.add : Icons.check
      ),
      label: Text(
          !isEditing ?
          translate('confirmAdd') :
          translate('confirmEdit')
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    ),
  );

}