import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extensions for spacing and common UI utilities
extension SpacingExtensions on int {
  /// Creates vertical spacing using SizedBox
  Widget get verticalSpace => SizedBox(height: toDouble().h);
  
  /// Creates horizontal spacing using SizedBox  
  Widget get horizontalSpace => SizedBox(width: toDouble().w);
}

extension DoubleSpacingExtensions on double {
  /// Creates vertical spacing using SizedBox
  Widget get verticalSpace => SizedBox(height: h);
  
  /// Creates horizontal spacing using SizedBox
  Widget get horizontalSpace => SizedBox(width: w);
}
