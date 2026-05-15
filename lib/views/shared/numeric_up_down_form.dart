import 'package:flutter/material.dart';

class NumericUpDownForm extends StatefulWidget {
  const NumericUpDownForm({
    super.key,
    required this.controller,
    this.title = '',
    this.icon,
    this.hint,
    this.startingValue,
    this.canBeNegative = false,
    this.quickValues = const [5, 10, 15, 20],
    this.metric,
    this.upAndDownButtonValue,
    this.showUpDownButtons = true,
    this.bigTitle = true,
    this.error,
    this.onChanged,
  });

  final TextEditingController controller;
  final Widget? icon;
  final String title;
  final double? startingValue;
  final bool canBeNegative;
  final Widget? hint;
  final bool showUpDownButtons;
  final double? upAndDownButtonValue;
  final bool bigTitle;
  final String? error;
  final List<double> quickValues;
  final String? metric;
  final void Function(String)? onChanged;

  @override
  State<NumericUpDownForm> createState() => _NumericUpDownFormState();
}

class _NumericUpDownFormState extends State<NumericUpDownForm> {
  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isEmpty) {
      _setValue(widget.startingValue ?? 0);
    } else {
      final parsed = double.tryParse(widget.controller.text);
      if (parsed != null) {
        _setValue(parsed);
      }
    }
  }

  double _currentValue() {
    return double.tryParse(widget.controller.text) ?? 0;
  }

  /// Formats the value to remove trailing zeros and fix floating point precision issues.
  String _formatValue(double value) {
    // Round to 10 decimal places to handle the "mantissa" problem (e.g. 0.30000000000000004)
    String s = value.toStringAsFixed(10);
    if (s.contains('.')) {
      // Remove trailing zeros and the decimal point if it's no longer needed
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }

  void _setValue(double value) {
    if (widget.onChanged != null) widget.onChanged!(value.toString());
    if (!widget.canBeNegative && value < 0) {
      value = 0;
    }
    widget.controller.text = _formatValue(value);
    setState(() {});
  }

  void _increment(double amount) {
    _setValue(_currentValue() + amount);
  }

  void _decrement(double amount) {
    _setValue(_currentValue() - amount);
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

  @override
  Widget build(BuildContext context) {
    return Card(
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

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    onTapOutside: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: widget.controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    decoration: InputDecoration(
                      labelText: widget.bigTitle ? null : widget.title,
                      labelStyle: const TextStyle(fontSize: 18),
                      errorMaxLines: 4,
                      errorText: widget.error,
                      counterText: '',
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 42,
                        minHeight: 42,
                        maxHeight: 42,
                        maxWidth: 42,
                      ),
                      // MINUS BUTTON
                      prefixIcon:
                      !widget.showUpDownButtons ? null :
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          iconSize: 18,
                          icon: const Icon(Icons.remove),
                          color: Theme.of(context).colorScheme.onError,
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.error,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () => _decrement(widget.upAndDownButtonValue ?? 1),
                        ),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 42,
                        minHeight: 42,
                        maxHeight: 42,
                        maxWidth: 42,
                      ),
                      // PLUS BUTTON
                      suffixIcon:
                      !widget.showUpDownButtons ? null :
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          iconSize: 18,
                          icon: const Icon(Icons.add),
                          color: Theme.of(context).colorScheme.onTertiary,
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () => _increment(widget.upAndDownButtonValue ?? 1),
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
                    onChanged: (value) {
                      if (widget.onChanged != null) widget.onChanged!(value);

                      final parsed = double.tryParse(value);
                      if (parsed != null && !widget.canBeNegative && parsed < 0) {
                        widget.controller.text = '0';
                        setState(() {});
                      }
                    },
                  ),
                ),
                if (widget.metric != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    widget.metric!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
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
                  onPressed: _currentValue() <= 0 && value < 0 && !widget.canBeNegative ? null : () => _increment(value),
                  child: Text('${value > 0 ? '+' : ''}${_formatValue(value)}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
