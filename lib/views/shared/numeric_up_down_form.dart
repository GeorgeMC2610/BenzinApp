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
  });

  final TextEditingController controller;
  final Widget? icon;
  final String title;
  final double? startingValue;
  final bool canBeNegative;
  final List<double> quickValues;
  final String? metric;

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

  String _formatValue(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  void _setValue(double value) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      labelText: widget.title,
                      labelStyle: const TextStyle(fontSize: 18),
                      errorMaxLines: 4,
                      counterText: '',
                      icon: widget.icon,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          iconSize: 18,
                          icon: const Icon(Icons.remove),
                          color: Theme.of(context).colorScheme.onError,
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.error,
                            minimumSize: const Size(30, 30),
                            maximumSize: const Size(30, 30),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => _decrement(1),
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          iconSize: 18,
                          icon: const Icon(Icons.add),
                          color: Theme.of(context).colorScheme.onTertiary,
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            minimumSize: const Size(30, 30),
                            maximumSize: const Size(30, 30),
                            padding: EdgeInsets.zero,
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
                  child: Text('${value > 0 ? '+' : ''} ${_formatValue(value)}'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
