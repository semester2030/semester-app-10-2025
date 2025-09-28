import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int currentIndex; // 0-based index of current step

  const OnboardingProgressIndicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        bool isActive = index == currentIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 24.w : 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: !isActive
              ? null // Active indicator doesn't need child
              : Center(
                  child: Container(
                    width: 16.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: accentPurple,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
