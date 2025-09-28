import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/providers/driver_details_provider.dart';
import 'package:semester_student_ride_app/utils/chat_utils.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class BookingDetailDriverProfileSection extends ConsumerWidget {
  final RequestBookingModel booking;

  const BookingDetailDriverProfileSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverId = booking.driverId ?? '';

    if (driverId.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: containerbackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'No driver selected',
            style: montserrat(14, grey5F63, FontWeight.w400),
          ),
        ),
      );
    }

    final driverAsyncValue = ref.watch(driverDetailsProvider(driverId));

    return driverAsyncValue.when(
      loading: () => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: containerbackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(accentPurple),
            ),
            16.horizontalSpace,
            Text(
              'Loading driver details...',
              style: montserrat(14, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ),
      error: (error, stackTrace) => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: containerbackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 20.sp),
            16.horizontalSpace,
            Expanded(
              child: Text(
                'Error loading driver details',
                style: montserrat(14, Colors.red, FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
      data: (driver) {
        if (driver == null) {
          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                CircularProfileImage(
                  imageUrl: 'https://via.placeholder.com/150',
                  radius: 25,
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Driver not found',
                        style: montserrat(16, grey36, FontWeight.w600),
                      ),
                      4.verticalSpace,
                      Text(
                        driver?.email ?? 'No email',
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Get rating directly from driver's UserSignupModel
        final rating = driver.averageRating;
        final totalReviews = driver.totalReviews;
        final distance = 0.0; // You may want to calculate actual distance

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: containerbackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircularProfileImage(
                    imageUrl: driver.profilePicture ??
                        'https://via.placeholder.com/150',
                    radius: 25,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: montserrat(16, grey36, FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        4.verticalSpace,
                        Text(
                          driver.email,
                          style: montserrat(11, grey5F63, FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        4.verticalSpace,
                        Wrap(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: yellowE2A640,
                                  size: 14.sp,
                                ),
                                Text(
                                  '${rating.toStringAsFixed(1)} ($totalReviews ${AppLocalizations.of(context)!.reviews})',
                                  style:
                                      montserrat(12, grey5F63, FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  8.horizontalSpace,
                  Column(
                    children: [
                      Text(
                        '${distance.toStringAsFixed(1)} km',
                        style: montserrat(12, grey36, FontWeight.w600),
                      ),
                      // Add contact button here for active/driverComing/tripStarted bookings
                      if (booking.status == BookingStatus.active ||
                          booking.status == BookingStatus.driverComing ||
                          booking.status == BookingStatus.tripStarted) ...[
                        8.verticalSpace,
                        GestureDetector(
                          onTap: () => ChatUtils.startChat(
                            context: context,
                            otherUser: driver,
                            ref: ref,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: accentPurple,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: Colors.white,
                                  size: 12.sp,
                                ),
                                4.horizontalSpace,
                                Text(
                                  'Chat',
                                  style: montserrat(
                                      10, Colors.white, FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
