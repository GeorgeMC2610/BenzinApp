import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    required this.text,
    required this.lineColor, required this.textColor, required this.textSize,
    this.barThickness
  });

  final String text;
  final double textSize;
  final Color lineColor;
  final Color textColor;
  final double? barThickness;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 5, right: 10),
                child: Divider(
                  color: lineColor,
                  height: 36,
                  thickness: barThickness,
                )),
          ),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: textSize
            ),
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                child: Divider(
                  color: lineColor,
                  height: 36,
                  thickness: barThickness,
                )),
          ),
    ]);
  }
}