import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class MeetupShimmerWidget extends StatelessWidget {
  final bool isMyMeetup;

  const MeetupShimmerWidget({
    super.key,
    this.isMyMeetup = true,
  });

  @override
  Widget build(BuildContext context) {
    // Fixed header height to match MeetupHeader
    final headerHeight = 390.36.h;

    return Container(
      constraints: BoxConstraints(
        minHeight: isMyMeetup ? 580.h : 680.h,
      ),
      color: black,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[900]!,
        highlightColor: Colors.grey[700]!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header shimmer
            Container(
              height: headerHeight,
              width: double.infinity,
              color: Colors.white,
            ),

            // Content section shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Description text shimmer
                  Container(
                    height: 15.h,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 16.h),
                    color: Colors.white,
                  ),
                  Container(
                    height: 15.h,
                    width: 250.w,
                    margin: EdgeInsets.only(top: 8.h),
                    color: Colors.white,
                  ),
                  16.verticalSpace,

                  // User info shimmer
                  Row(
                    children: [
                      // User avatar shimmer
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.white,
                      ),
                      10.horizontalSpace,

                      // User name shimmer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15.h,
                            width: 100.w,
                            color: Colors.white,
                          ),
                          5.verticalSpace,
                          Container(
                            height: 12.h,
                            width: 80.w,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ],
                  ),
                  16.verticalSpace,

                  // Location info shimmer
                  Container(
                    height: 15.h,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  8.verticalSpace,
                  Container(
                    height: 15.h,
                    width: 200.w,
                    color: Colors.white,
                  ),
                  16.verticalSpace,

                  // Interested users shimmer
                  Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: CircleAvatar(
                            radius: 18.r,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      10.horizontalSpace,
                      Container(
                        height: 15.h,
                        width: 80.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // Action buttons shimmer
                  if (isMyMeetup) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 40.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Group chat button shimmer
                    Container(
                      height: 45.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ],
                  20.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
