import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/shimmer/meetup_shimmer_widget.dart';

class MeetupListShimmer extends StatelessWidget {
  final bool isMyMeetup;
  final int itemCount;

  const MeetupListShimmer({
    super.key,
    this.isMyMeetup = true,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.only(top: 15.h, bottom: 100.h),
      itemBuilder: (context, index) {
        return Column(
          children: [
            MeetupShimmerWidget(isMyMeetup: isMyMeetup),
            20.verticalSpace,
          ],
        );
      },
    );
  }
}
