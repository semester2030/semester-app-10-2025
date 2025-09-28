import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[700]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          50.verticalSpace,

          // Profile picture
          Center(
            child: CircleAvatar(
              radius: 60.r,
              backgroundColor: Colors.white,
            ),
          ),
          16.verticalSpace,

          // Name
          Container(
            height: 24.h,
            width: 180.w,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: Colors.white,
          ),
          8.verticalSpace,

          // Username
          Container(
            height: 16.h,
            width: 120.w,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            color: Colors.white,
          ),
          24.verticalSpace,

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < 3; i++)
                Column(
                  children: [
                    Container(
                      height: 18.h,
                      width: 60.w,
                      color: Colors.white,
                    ),
                    8.verticalSpace,
                    Container(
                      height: 14.h,
                      width: 40.w,
                      color: Colors.white,
                    ),
                  ],
                ),
            ],
          ),
          30.verticalSpace,

          // Setting items
          for (int i = 0; i < 5; i++) ...[
            Container(
              height: 60.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            16.verticalSpace,
          ],
        ],
      ),
    );
  }
}
