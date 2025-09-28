import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:intl/intl.dart';

class DriverRequestBookingCard extends StatelessWidget {
  final RequestBookingModel booking;
  final VoidCallback? onTap;

  const DriverRequestBookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Format date
    String formattedDate = '';
    if (booking.createdAt != null) {
      formattedDate =
          DateFormat('MMM dd, yyyy • hh:mm a').format(booking.createdAt!);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Booking ID
                  Text(
                    'ID: ${booking.id?.substring(0, 8) ?? "N/A"}',
                    style: montserrat(12, grey5F63, FontWeight.w500),
                  ),
                  // Status
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(booking.status ?? BookingStatus.draft)
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _getStatusText(
                          booking.status ?? BookingStatus.draft, l10n),
                      style: montserrat(
                        12,
                        _getStatusColor(booking.status ?? BookingStatus.draft),
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,

              // Pickup and Destination
              Row(
                children: [
                  // Location Icons with vertical line
                  Column(
                    children: [
                      Icon(
                        Icons.circle,
                        color: accentPurple,
                        size: 16.sp,
                      ),
                      Container(
                        width: 2.w,
                        height: 24.h,
                        color: Colors.grey[300],
                      ),
                      Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 16.sp,
                      ),
                    ],
                  ),
                  12.horizontalSpace,
                  // Location Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.pickupAddress?.address ?? "Pickup Location",
                          style: montserrat(14, grey36, FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        12.verticalSpace,
                        Text(
                          booking.dropOffAddress?.address ??
                              "Drop-off Location",
                          style: montserrat(14, grey36, FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              16.verticalSpace,
              Divider(),
              16.verticalSpace,

              // Date and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date and Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16.sp,
                        color: grey5F63,
                      ),
                      6.horizontalSpace,
                      Text(
                        formattedDate,
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                  // Price
                  Text(
                    '${booking.finalPrice?.toStringAsFixed(2) ?? "0.00"} ${booking.priceUnit ?? "SAR"}',
                    style: montserrat(16, accentPurple, FontWeight.w600),
                  ),
                ],
              ),

              16.verticalSpace,

              // Action Buttons
              Row(
                children: [
                  // View Details Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                      child: Text(
                        "View Details",
                        style: montserrat(14, whiteColor, FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus? status) {
    if (status == null) return Colors.grey;

    switch (status) {
      case BookingStatus.draft:
        return Colors.grey;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.active:
        return Colors.green;
      case BookingStatus.driverComing:
        return Colors.orange;
      case BookingStatus.tripStarted:
        return accentPurple;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(BookingStatus? status, AppLocalizations l10n) {
    if (status == null) return l10n.draft;

    switch (status) {
      case BookingStatus.draft:
        return l10n.draft;
      case BookingStatus.pending:
        return l10n.pending;
      case BookingStatus.active:
        return l10n.active;
      case BookingStatus.driverComing:
        return 'Driver Coming';
      case BookingStatus.tripStarted:
        return 'Trip Started';
      case BookingStatus.completed:
        return l10n.completed;
      case BookingStatus.cancelled:
        return l10n.cancelled;
    }
  }
}
