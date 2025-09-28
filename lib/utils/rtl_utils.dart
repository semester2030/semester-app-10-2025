import 'package:flutter/material.dart';

extension RTLAwareExtensions on EdgeInsets {
  /// Creates EdgeInsets with start and end values that respect text direction
  static EdgeInsets symmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  /// Creates EdgeInsets with specific start and end values
  static EdgeInsets fromLTRB({
    required double left,
    required double top,
    required double right,
    required double bottom,
  }) {
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  /// Creates EdgeInsets that respect text direction
  static EdgeInsets only({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    double start = 0.0,
    double end = 0.0,
  }) {
    return EdgeInsets.only(
      left: left + start,
      top: top,
      right: right + end,
      bottom: bottom,
    );
  }
}

extension RTLAwareAlignment on Alignment {
  /// Returns appropriate alignment based on text direction
  static Alignment centerStart(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Alignment.centerRight
        : Alignment.centerLeft;
  }

  static Alignment centerEnd(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Alignment.centerLeft
        : Alignment.centerRight;
  }

  static Alignment topStart(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Alignment.topRight
        : Alignment.topLeft;
  }

  static Alignment topEnd(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Alignment.topLeft
        : Alignment.topRight;
  }

  static Alignment bottomStart(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Alignment.bottomRight
        : Alignment.bottomLeft;
  }

  static Alignment bottomEnd(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? Alignment.bottomLeft
        : Alignment.bottomRight;
  }
}

extension RTLAwareCrossAxisAlignment on CrossAxisAlignment {
  /// Returns appropriate cross axis alignment based on text direction
  static CrossAxisAlignment start(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
  }

  static CrossAxisAlignment end(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;
  }
}

extension RTLAwareMainAxisAlignment on MainAxisAlignment {
  /// Returns appropriate main axis alignment based on text direction for Row widgets
  static MainAxisAlignment start(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;
  }

  static MainAxisAlignment end(TextDirection textDirection) {
    return textDirection == TextDirection.rtl
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;
  }
}
