import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/shimmer/meetup_shimmer_widget.dart';

class HomeScreenShimmer extends StatelessWidget {
  final int itemCount;

  const HomeScreenShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[700]!,
              child: Row(
                children: [
                  for (int i = 0; i < 3; i++)
                    Container(
                      height: 32.h,
                      width: 80.w + (i * 10.w), // Varied widths
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Meetup shimmer items
          for (int i = 0; i < itemCount; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: MeetupShimmerWidget(isMyMeetup: false),
            ),
        ],
      ),
    );
  }
}
