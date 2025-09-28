import 'package:flutter/material.dart';

/// RTL Helper utility class for handling right-to-left text direction
class RTLHelper {
  /// Check if the current context has RTL text direction
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Get appropriate EdgeInsets for RTL/LTR layouts
  static EdgeInsets paddingOnly({
    required BuildContext context,
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    final bool rtl = isRTL(context);
    return EdgeInsets.only(
      left: rtl ? right : left,
      top: top,
      right: rtl ? left : right,
      bottom: bottom,
    );
  }

  /// Get appropriate EdgeInsets for symmetric RTL/LTR layouts
  static EdgeInsets paddingSymmetric({
    required BuildContext context,
    double vertical = 0.0,
    double horizontal = 0.0,
  }) {
    return EdgeInsets.symmetric(
      vertical: vertical,
      horizontal: horizontal,
    );
  }

  /// Get appropriate alignment for RTL/LTR layouts
  static Alignment getAlignment({
    required BuildContext context,
    Alignment ltrAlignment = Alignment.centerLeft,
    Alignment? rtlAlignment,
  }) {
    final bool rtl = isRTL(context);
    if (rtl) {
      return rtlAlignment ?? _getOppositeAlignment(ltrAlignment);
    }
    return ltrAlignment;
  }

  /// Get appropriate CrossAxisAlignment for RTL/LTR layouts
  static CrossAxisAlignment getCrossAxisAlignment({
    required BuildContext context,
    CrossAxisAlignment ltrAlignment = CrossAxisAlignment.start,
    CrossAxisAlignment? rtlAlignment,
  }) {
    final bool rtl = isRTL(context);
    if (rtl) {
      return rtlAlignment ?? _getOppositeCrossAxisAlignment(ltrAlignment);
    }
    return ltrAlignment;
  }

  /// Get appropriate TextAlign for RTL/LTR layouts
  static TextAlign getTextAlign({
    required BuildContext context,
    TextAlign ltrAlign = TextAlign.left,
    TextAlign? rtlAlign,
  }) {
    final bool rtl = isRTL(context);
    if (rtl) {
      return rtlAlign ?? _getOppositeTextAlign(ltrAlign);
    }
    return ltrAlign;
  }

  /// Get appropriate MainAxisAlignment for RTL/LTR layouts
  static MainAxisAlignment getMainAxisAlignment({
    required BuildContext context,
    MainAxisAlignment ltrAlignment = MainAxisAlignment.start,
    MainAxisAlignment? rtlAlignment,
  }) {
    final bool rtl = isRTL(context);
    if (rtl) {
      return rtlAlignment ?? _getOppositeMainAxisAlignment(ltrAlignment);
    }
    return ltrAlignment;
  }

  // Private helper methods
  static Alignment _getOppositeAlignment(Alignment alignment) {
    if (alignment == Alignment.centerLeft) return Alignment.centerRight;
    if (alignment == Alignment.centerRight) return Alignment.centerLeft;
    if (alignment == Alignment.topLeft) return Alignment.topRight;
    if (alignment == Alignment.topRight) return Alignment.topLeft;
    if (alignment == Alignment.bottomLeft) return Alignment.bottomRight;
    if (alignment == Alignment.bottomRight) return Alignment.bottomLeft;
    return alignment;
  }

  static CrossAxisAlignment _getOppositeCrossAxisAlignment(
      CrossAxisAlignment alignment) {
    if (alignment == CrossAxisAlignment.start) return CrossAxisAlignment.end;
    if (alignment == CrossAxisAlignment.end) return CrossAxisAlignment.start;
    return alignment;
  }

  static TextAlign _getOppositeTextAlign(TextAlign align) {
    if (align == TextAlign.left) return TextAlign.right;
    if (align == TextAlign.right) return TextAlign.left;
    if (align == TextAlign.start) return TextAlign.end;
    if (align == TextAlign.end) return TextAlign.start;
    return align;
  }

  static MainAxisAlignment _getOppositeMainAxisAlignment(
      MainAxisAlignment alignment) {
    if (alignment == MainAxisAlignment.start) return MainAxisAlignment.end;
    if (alignment == MainAxisAlignment.end) return MainAxisAlignment.start;
    return alignment;
  }
}

/// Extension on BuildContext for easier access to RTL utilities
extension RTLExtension on BuildContext {
  /// Check if current context has RTL text direction
  bool get isRTL => RTLHelper.isRTL(this);

  /// Get appropriate EdgeInsets for RTL/LTR layouts
  EdgeInsets paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      RTLHelper.paddingOnly(
        context: this,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      );

  /// Get appropriate alignment for RTL/LTR layouts
  Alignment getAlignment({
    Alignment ltrAlignment = Alignment.centerLeft,
    Alignment? rtlAlignment,
  }) =>
      RTLHelper.getAlignment(
        context: this,
        ltrAlignment: ltrAlignment,
        rtlAlignment: rtlAlignment,
      );

  /// Get appropriate CrossAxisAlignment for RTL/LTR layouts
  CrossAxisAlignment getCrossAxisAlignment({
    CrossAxisAlignment ltrAlignment = CrossAxisAlignment.start,
    CrossAxisAlignment? rtlAlignment,
  }) =>
      RTLHelper.getCrossAxisAlignment(
        context: this,
        ltrAlignment: ltrAlignment,
        rtlAlignment: rtlAlignment,
      );

  /// Get appropriate TextAlign for RTL/LTR layouts
  TextAlign getTextAlign({
    TextAlign ltrAlign = TextAlign.left,
    TextAlign? rtlAlign,
  }) =>
      RTLHelper.getTextAlign(
        context: this,
        ltrAlign: ltrAlign,
        rtlAlign: rtlAlign,
      );

  /// Get appropriate MainAxisAlignment for RTL/LTR layouts
  MainAxisAlignment getMainAxisAlignment({
    MainAxisAlignment ltrAlignment = MainAxisAlignment.start,
    MainAxisAlignment? rtlAlignment,
  }) =>
      RTLHelper.getMainAxisAlignment(
        context: this,
        ltrAlignment: ltrAlignment,
        rtlAlignment: rtlAlignment,
      );
}
