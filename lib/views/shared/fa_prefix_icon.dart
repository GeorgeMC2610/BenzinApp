import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// A Font Awesome icon for [InputDecoration.prefixIcon] / [InputDecoration.suffixIcon].
///
/// Since font_awesome_flutter 11, [FaIcon] renders without the centering box that
/// Material's [Icon] has (FA glyphs aren't square). Inside the 48x48 prefix slot of
/// a text field that makes the glyph stick to the top-left corner. This centers it.
class FaPrefixIcon extends StatelessWidget {
  const FaPrefixIcon(this.icon, {super.key, this.size});

  final FaIconData icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: FaIcon(icon, size: size),
    );
  }
}
