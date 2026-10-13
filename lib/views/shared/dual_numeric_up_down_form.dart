import 'package:flutter/material.dart';
import '../../services/localized_number_input.dart';

class DualNumericUpDownForm extends StatefulWidget {
  const DualNumericUpDownForm({
    super.key,
    required this.controller1,
    required this.controller2,
    required this.title,
    required this.fieldTitle1,
    required this.fieldTitle2,
    this.quickValues = const [5, 10, 15, 20],
    this.showUpDownButtons = true,
    this.canBeNegative = false,
    this.icon,
    this.metric,
    this.syncedControllers = false,
    this.onController1Changed,
    this.onController2Changed,
    this.error1,
    this.error2,
    this.hint,
  });

  final NumericTextController controller1;
  final NumericTextController controller2;
  final bool canBeNegative;
  final String title;
  final String fieldTitle1;
  final String fieldTitle2;
  final String? metric;
  final Widget? icon;
  final Widget? hint;
  final bool syncedControllers;
  final bool showUpDownButtons;
  final String? error1;
  final String? error2;
  final List<double> quickValues;
  final ValueChanged<double?>? onController1Changed;
  final ValueChanged<double?>? onController2Changed;

  @override
  State<DualNumericUpDownForm> createState() => _NumericUpDownFormState();
}

class _NumericUpDownFormState extends State<DualNumericUpDownForm> {
  @override
  void initState() {
    super.initState();
    _applySeparators(NumberSeparators.of(context, listen: false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // re-renders the values when the app language changes
    _applySeparators(NumberSeparators.of(context));
  }

  void _applySeparators(NumberSeparators separators) {
    widget.controller1.separators = separators;
    widget.controller2.separators = separators;
  }

  double _currentValue(NumericTextController controller) {
    return controller.numericValue ?? 0;
  }

  void _notifyChanged(NumericTextController controller) {
    if (controller == widget.controller1) {
      if (widget.onController1Changed != null) widget.onController1Changed!(controller.numericValue);
    }
    else {
      if (widget.onController2Changed != null) widget.onController2Changed!(controller.numericValue);
    }
  }

  void _setValue(double value, NumericTextController controller) {
    if (!widget.canBeNegative && value < 0) {
      value = 0;
    }

    controller.numericValue = value;
    _notifyChanged(controller);

    setState(() {});
  }

  void _increment(double amount, NumericTextController controller) {
    _setValue(_currentValue(controller) + amount, controller);
  }

  void _decrement(double amount, NumericTextController controller) {
    _setValue(_currentValue(controller) - amount, controller);
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 10),
              ],
              Expanded(child: Text(widget.title)),
            ],
          ),
          content: widget.hint ?? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Placeholder text for information regarding this section. You can describe what these fields represent or how they are calculated.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Pictures:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement image picking logic
                },
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Add Picture'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required NumericTextController controller,
    required String labelText,
    required String? errorText,
  }) {
    return Column(
      children: [
        TextField(
          onTapOutside: (value) {
            FocusScope.of(context).unfocus();
          },
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true, signed: widget.canBeNegative),
          inputFormatters: [
            LocalizedNumberInputFormatter(
              separators: controller.separators,
              allowNegative: widget.canBeNegative,
            ),
          ],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 18),
            errorMaxLines: 4,
            errorText: errorText,
            counterText: '',
            prefixIconConstraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
              maxHeight: 42,
              maxWidth: 42,
            ),
            // MINUS BUTTON
            prefixIcon: !widget.showUpDownButtons
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(Icons.remove),
                      color: Theme.of(context).colorScheme.onError,
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () => _decrement(1, controller),
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 42,
              minHeight: 42,
              maxHeight: 42,
              maxWidth: 42,
            ),
            // PLUS BUTTON
            suffixIcon: !widget.showUpDownButtons
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      iconSize: 18,
                      icon: const Icon(Icons.add),
                      color: Theme.of(context).colorScheme.onTertiary,
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () => _increment(1, controller),
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          // the formatter already rejects a minus sign when canBeNegative is false
          onChanged: (value) {
            _notifyChanged(controller);
            setState(() {});
          },
        ),

        if (!widget.syncedControllers)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.quickValues.map((value) {
              return FilledButton.tonal(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.standard,
                  backgroundColor: value < 0 ? Theme.of(context).colorScheme.errorContainer : null,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                onPressed: _currentValue(controller) <= 0 && value < 0 && !widget.canBeNegative ? null : () => _increment(value, controller),
                child:
                Text('${value > 0 ? '+' : ''}${LocalizedNumber.format(value, widget.controller1.separators)}'),
              );
            }).toList(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    widget.icon!,

                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (widget.hint != null)
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.grey, size: 30),
                    onPressed: () => _showInfoDialog(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FIRST FIELD
                  Expanded(
                    child: _buildTextField(
                      controller: widget.controller1,
                      labelText: widget.fieldTitle1,
                      errorText: widget.error1
                    ),
                  ),

                  const SizedBox(width: 10),

                  // SECOND FIELD
                  Expanded(
                    child: _buildTextField(
                      controller: widget.controller2,
                      labelText: widget.fieldTitle2,
                      errorText: widget.error2
                    ),
                  ),
                  if (widget.metric != null) ...[
                    const SizedBox(width: 12),
                    Text(
                      widget.metric!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
              if (widget.syncedControllers)
              const SizedBox(height: 10),

              if (widget.syncedControllers)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.quickValues.map((value) {
                  return FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      backgroundColor: value < 0 ? Theme.of(context).colorScheme.errorContainer : null,
                      visualDensity: VisualDensity.standard,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                    ),
                    onPressed: (_currentValue(widget.controller1) <= 0 || _currentValue(widget.controller2) <= 0) && value < 0 && !widget.canBeNegative ? null : () {
                      _increment(value, widget.controller1);
                      _increment(value, widget.controller2);
                    },
                    child:
                        Text('${value > 0 ? '+' : ''}${LocalizedNumber.format(value, widget.controller1.separators)}'),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
}
