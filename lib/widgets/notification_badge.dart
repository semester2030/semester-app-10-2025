import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final double size;
  final Color backgroundColor;
  final Color textColor;

  const NotificationBadge({
    super.key,
    required this.count,
    this.size = 20,
    this.backgroundColor = accentPurple,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show badge if count is 0
    if (count == 0) return const SizedBox.shrink();

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
            // Show '9+' if count is greater than 9
            count > 9 ? '9+' : count.toString(),
            style: montserrat(10, black, FontWeight.w500)),
      ),
    );
  }
}
