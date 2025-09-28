import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';
import 'package:semester_student_ride_app/utils/extensions.dart';
import 'package:semester_student_ride_app/config/app_images.dart';

class BookingLocationRow extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingLocationRow({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom location icons with dotted line
        Column(
          children: [
            // Start location icon
            SvgPicture.asset(AppIcons.locationAddress),
            // Dotted line
            SizedBox(
              width: 2.w,
              height: 35.h,
              child: Column(
                children: List.generate(
                  8,
                  (index) => Container(
                    width: 2.w,
                    height: 2.h,
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: grey5F63,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            // End location icon
            SvgPicture.asset(AppIcons.locationAddress),
          ],
        ),
        16.horizontalSpace,
        // Location text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
                child: Text(
                  booking.pickupAddress?.address ?? 'Pickup Location',
                  style: montserrat(12, grey36, FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              15.verticalSpace,
              SizedBox(
                height: 40.h,
                child: Text(
                  booking.dropOffAddress?.address ?? 'Drop-off Location',
                  style: montserrat(12, grey36, FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
