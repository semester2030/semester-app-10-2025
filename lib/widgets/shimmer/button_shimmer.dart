import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

/// A small shimmer widget for loading states inside components
class ButtonShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const ButtonShimmer({
    super.key,
    this.height = 45,
    this.width = 100,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
