import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

/// A small circular shimmer widget for loading states
class CircleShimmer extends StatelessWidget {
  final double radius;

  const CircleShimmer({
    super.key,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: CircleAvatar(
        radius: radius.r,
        backgroundColor: Colors.white,
      ),
    );
  }
}
