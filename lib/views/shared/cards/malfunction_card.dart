import 'package:benzinapp/services/distance_metric_provider.dart';
import 'package:benzinapp/services/classes/malfunction.dart';
import 'package:benzinapp/views/details/malfunction.dart';
import 'package:benzinapp/views/forms/malfunction.dart';
import 'package:benzinapp/views/shared/buttons/card_edit_delete_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/language_provider.dart';
import '../../../services/managers/malfunction_manager.dart';
import '../../../services/managers/user_manager.dart';
import '../dialogs/delete_dialog.dart';
import '../malfunction_severity.dart';
import '../notification.dart';

class MalfunctionCard extends StatefulWidget {
  const MalfunctionCard({super.key, required this.malfunction});

  final Malfunction malfunction;

  @override
  State<StatefulWidget> createState() => _MalfunctionCardState();
}

class _MalfunctionCardState extends State<MalfunctionCard> {

  @override
  Widget build(BuildContext context) {
    final distanceProvider = Provider.of<DistanceMetricProvider>(context);
    final locale = Provider.of<LanguageProvider>(context).currentLocale.toLanguageTag();
    final NumberFormat format = NumberFormat('#,###', locale);
    final theme = Theme.of(context);
    final isFixed = widget.malfunction.isFixed();
    final metaStyle = theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final showCreator = widget.malfunction.createdByUsername != null
        && widget.malfunction.createdByUsername != UserManager().currentUser!.username;

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewMalfunction(malfunction: widget.malfunction)
            )
        );
      },
      leading: Opacity(
        opacity: isFixed ? 0.5 : 1,
        child: _getSeverity(),
      ),
      title: Text(
        widget.malfunction.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: isFixed ? theme.colorScheme.onSurfaceVariant : null,
        ),
      ),
      trailing: CardEditDeleteButtons(
        onEditButtonPressed: edit,
        onDeleteButtonPressed: delete,
      ),

      // MALFUNCTION DATA
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              Icon(Icons.calendar_today, size: 13, color: metaStyle?.color),
              Text(DateFormat.yMMMd(locale).format(widget.malfunction.dateStarted), style: metaStyle),
              Text('·', style: metaStyle),
              Icon(Icons.speed, size: 14, color: metaStyle?.color),
              Text(
                "${format.format(distanceProvider.convert(widget.malfunction.kilometersDiscovered.toDouble()).toInt())} ${distanceProvider.label}",
                style: metaStyle,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              _getStatus(),
              if (showCreator)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 14, color: metaStyle?.color),
                    const SizedBox(width: 2),
                    Text(widget.malfunction.createdByUsername!, style: metaStyle),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  edit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MalfunctionForm(malfunction: widget.malfunction)
        )
    );
  }

  delete() {
    DeleteDialog.show(
        context,
        translate('confirmDeleteMalfunction'),
            (Function(bool) setLoadingState) async {

          await MalfunctionManager().delete(widget.malfunction);
          SnackbarNotification.show(
            MessageType.info,
            translate('successfullyDeletedMalfunction'),
          );
          setLoadingState(true);
        }
    );
  }

  Widget _getStatus() {
    final colorScheme = Theme.of(context).colorScheme;
    final isFixed = widget.malfunction.isFixed();
    final background = isFixed ? colorScheme.surfaceContainerHighest : colorScheme.errorContainer;
    final foreground = isFixed ? colorScheme.onSurfaceVariant : colorScheme.onErrorContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isFixed ? Icons.check : Icons.error_outline, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            isFixed ? translate('fixedMalfunction') : translate('ongoingMalfunction'),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }

  Widget _getSeverity() {
    final severity = widget.malfunction.severity;
    final color = MalfunctionSeverity.color(severity);

    return Tooltip(
      message: MalfunctionSeverity.label(severity),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color.withOpacity(0.15),
        child: Icon(
          MalfunctionSeverity.icon(severity),
          color: color,
          semanticLabel: MalfunctionSeverity.label(severity),
        ),
      ),
    );
  }

}
