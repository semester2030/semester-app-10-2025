import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.isDark = false});

  final String title;
  final bool? isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark == true ? accentPurple : null,
        gradient: isDark == true
            ? null
            : LinearGradient(
                colors: [
                  accentPurple.withOpacity(0.1),
                  accentPurple.withOpacity(0.05)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accentPurple.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: isDark == true ? whiteColor : accentPurple,
              gradient: isDark == true
                  ? null
                  : LinearGradient(
                      colors: [accentPurple, accentPurple.withOpacity(0.7)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          12.horizontalSpace,
          Text(
            title,
            style: montserrat(16, isDark == true ? whiteColor : accentPurple,
                FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
