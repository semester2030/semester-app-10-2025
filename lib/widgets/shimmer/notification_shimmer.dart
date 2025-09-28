import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: Colors.white,
                ),
                12.horizontalSpace,
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 250.w,
                        color: Colors.white,
                      ),
                      8.verticalSpace,
                      Container(
                        height: 12.h,
                        width: 200.w,
                        color: Colors.white,
                      ),
                      8.verticalSpace,
                      Container(
                        height: 10.h,
                        width: 80.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                // Indicator dot
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
