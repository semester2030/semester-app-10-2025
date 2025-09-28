import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start from top left
    path.moveTo(0, 0);
    // Draw upward (reversed) circle curve
    path.quadraticBezierTo(
      size.width / 2,
      60.h, // control point below the top edge for upward curve
      size.width, 0, // end at top right
    );
    // Right side
    path.lineTo(size.width, size.height);
    // Bottom
    path.lineTo(0, size.height);
    // Left side
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
