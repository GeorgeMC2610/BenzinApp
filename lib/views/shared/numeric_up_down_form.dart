import 'package:flutter/material.dart';

class NumericUpDownForm extends StatefulWidget {
  const NumericUpDownForm({
    super.key,
    required this.controller,
    this.title = '',
    this.icon,
    this.startingValue,
    this.canBeNegative = false,
    this.quickValues = const [5, 10, 15, 20],
    this.metric,
    this.showUpDownButtons = true,
    this.bigTitle = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final Widget? icon;
  final String title;
  final double? startingValue;
  final bool canBeNegative;
  final bool showUpDownButtons;
  final bool bigTitle;
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
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              ),
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
                      counterText: '',
                      icon: widget.icon,
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 42,
                        minHeight: 42,
                        maxHeight: 42,
                        maxWidth: 42,
                      ),
                      // MINUS BUTTON
                      prefixIcon:
                      widget.showUpDownButtons ? null :
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
                          onPressed: () => _decrement(1),
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
                      widget.showUpDownButtons ? null :
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
                          onPressed: () => _increment(1),
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
                    visualDensity: VisualDensity.standard,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  onPressed: () => _increment(value),
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
