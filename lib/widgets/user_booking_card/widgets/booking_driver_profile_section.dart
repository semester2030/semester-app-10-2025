import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/providers/driver_details_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';
import 'package:semester_student_ride_app/utils/extensions.dart';

class BookingDriverProfileSection extends ConsumerWidget {
  final RequestBookingModel booking;

  const BookingDriverProfileSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (booking.driverId == null || booking.driverId!.isEmpty) {
      return _buildNoDriverAssigned();
    }

    final driverAsyncValue =
        ref.watch(driverDetailsProvider(booking.driverId!));

    return driverAsyncValue.when(
      data: (driver) {
        if (driver == null) {
          return _buildDriverNotFound();
        }

        final statsMap = ref.watch(driverReviewStatsProvider(driver.email));

        return Row(
          children: [
            // Driver Avatar
            CircleAvatar(
              radius: 25.r,
              backgroundColor: Colors.grey[300],
              backgroundImage: driver.profilePicture != null &&
                      driver.profilePicture!.isNotEmpty
                  ? NetworkImage(driver.profilePicture!)
                  : null,
              child: driver.profilePicture == null ||
                      driver.profilePicture!.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[600], size: 30.sp)
                  : null,
            ),
            12.horizontalSpace,

            // Driver Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name,
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  2.verticalSpace,
                  Text(
                    booking.formattedServiceType,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                ],
              ),
            ),

            // Price and Vehicle Info with Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (booking.finalPrice != null)
                  Row(
                    children: [
                      Text(
                        booking.finalPrice!.toStringAsFixed(0),
                        style: montserrat(16, grey36, FontWeight.w600),
                      ),
                      2.horizontalSpace,
                      Icon(Icons.currency_exchange, size: 16.sp, color: grey36),
                      2.horizontalSpace,
                      statsMap.when(
                        data: (stats) => Text(
                          (stats['averageRating'] as double).toStringAsFixed(1),
                          style: montserrat(16, grey36, FontWeight.w600),
                        ),
                        loading: () => Text(
                          '0.0',
                          style: montserrat(16, grey36, FontWeight.w600),
                        ),
                        error: (_, __) => Text(
                          '0.0',
                          style: montserrat(16, grey36, FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                4.verticalSpace,
                Text(
                  driver.fullVehicleName,
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, _) => _buildErrorState(),
    );
  }

  Widget _buildNoDriverAssigned() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.grey[600], size: 30.sp),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver not assigned',
                style: montserrat(16, grey36, FontWeight.w600),
              ),
              2.verticalSpace,
              Text(
                'Waiting for driver...',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (booking.finalPrice != null)
              Row(
                children: [
                  Text(
                    booking.finalPrice!.toStringAsFixed(0),
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  2.horizontalSpace,
                  Icon(Icons.currency_exchange, size: 16.sp, color: grey36),
                ],
              ),
            4.verticalSpace,
            Text(
              _getVehicleType(booking),
              style: montserrat(12, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDriverNotFound() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.grey[600], size: 30.sp),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver not found',
                style: montserrat(16, grey36, FontWeight.w600),
              ),
              2.verticalSpace,
              Text(
                'Driver information unavailable',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (booking.finalPrice != null)
              Row(
                children: [
                  Text(
                    booking.finalPrice!.toStringAsFixed(0),
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  2.horizontalSpace,
                  Icon(Icons.currency_exchange, size: 16.sp, color: grey36),
                ],
              ),
            4.verticalSpace,
            Text(
              _getVehicleType(booking),
              style: montserrat(12, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.grey[300],
          child: SizedBox(
            width: 30.sp,
            height: 30.sp,
            child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(accentPurple)),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loading driver...',
                style: montserrat(16, grey36, FontWeight.w600),
              ),
              2.verticalSpace,
              Text(
                'Fetching information...',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (booking.finalPrice != null)
              Row(
                children: [
                  Text(
                    booking.finalPrice!.toStringAsFixed(0),
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  2.horizontalSpace,
                  Icon(Icons.currency_exchange, size: 16.sp, color: grey36),
                ],
              ),
            4.verticalSpace,
            Text(
              _getVehicleType(booking),
              style: montserrat(12, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.red,
          child: Icon(Icons.error, color: Colors.white, size: 30.sp),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Error loading driver',
                style: montserrat(16, grey36, FontWeight.w600),
              ),
              2.verticalSpace,
              Text(
                'Failed to fetch driver info',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (booking.finalPrice != null)
              Row(
                children: [
                  Text(
                    booking.finalPrice!.toStringAsFixed(0),
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  2.horizontalSpace,
                  Icon(Icons.currency_exchange, size: 16.sp, color: grey36),
                ],
              ),
            4.verticalSpace,
            Text(
              _getVehicleType(booking),
              style: montserrat(12, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  String _getVehicleType(RequestBookingModel booking) {
    if (booking.selectedVehicleType != null &&
        booking.selectedVehicleType!.isNotEmpty) {
      return booking.selectedVehicleType!;
    }

    switch (booking.serviceType) {
      case TransportationServiceType.student:
        return 'Student Vehicle';
      case TransportationServiceType.teacher:
        return 'Teacher Vehicle';
      case TransportationServiceType.employee:
        return 'Employee Vehicle';
      case TransportationServiceType.daily:
        return 'Daily Transport';
    }
  }
}
