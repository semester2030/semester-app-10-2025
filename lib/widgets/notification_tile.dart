import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String time;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.isRead,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
        decoration: BoxDecoration(
          color: isRead ? black : accentPurple,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 9,
              offset: const Offset(0, -2), // Shadow positioned above the widget
            ),
          ],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            CircularProfileImage(imageUrl: imageUrl, radius: 30),
            10.horizontalSpace,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.verticalSpace,
                SizedBox(
                  width: 230.w,
                  child: Text(title,
                      style: montserrat(
                          12, isRead ? accentPurple : black, FontWeight.w600)),
                ),
                6.verticalSpace,
                SizedBox(
                    width: 220.w,
                    child: Text(
                      description,
                      style: montserrat(
                          11, isRead ? accentPurple : black, FontWeight.w400),
                    )),
                10.verticalSpace,
                SizedBox(
                    width: 230.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style: montserrat(10, isRead ? accentPurple : black,
                              FontWeight.w400),
                        ),
                      ],
                    )),
                10.verticalSpace,
              ],
            )
          ],
        ),
      ),
    );
  }
}
