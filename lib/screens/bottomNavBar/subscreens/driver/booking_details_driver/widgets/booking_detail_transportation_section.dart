import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingDetailTransportationSection extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingDetailTransportationSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Service Type',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                l10n.city,
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ),
          ],
        ),
        4.verticalSpace,
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                booking.formattedServiceType,
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                booking.city ?? l10n.dubai,
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ),
          ],
        ),
        16.verticalSpace,

        // Service-specific details
        if (booking.serviceType == TransportationServiceType.student) ...[
          // Vehicle Type
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Vehicle Type',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Transport Type',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  booking.selectedVehicleType ?? 'Not specified',
                  style: montserrat(14, grey36, FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _getFirstWord(booking.selectedServiceType) ?? 'Not specified',
                  style: montserrat(14, grey36, FontWeight.w500),
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Trip Type
          Row(
            children: [
              Expanded(
                child: Text(
                  'Trip Type',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.selectedTripType ?? 'Not specified',
                  style: montserrat(14, grey36, FontWeight.w500),
                ),
              ),
            ],
          ),
          16.verticalSpace,
        ],

        if (booking.serviceType == TransportationServiceType.teacher ||
            booking.serviceType == TransportationServiceType.employee) ...[
          // Driver Gender Preference
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Driver Gender',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Subscription',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  booking.selectedDriverGender ?? 'Not specified',
                  style: montserrat(14, grey36, FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  booking.selectedSubscriptionPlan ?? 'Not specified',
                  style: montserrat(14, grey36, FontWeight.w500),
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Work Schedule
          Row(
            children: [
              Expanded(
                child: Text(
                  'Work Schedule',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ),
            ],
          ),
          4.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.selectedWorkSchedule ?? 'Not specified',
                  style: montserrat(14, grey36, FontWeight.w500),
                ),
              ),
            ],
          ),
          16.verticalSpace,
        ],
        16.verticalSpace,
        Text(
          l10n.pickupLocation,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        4.verticalSpace,
        Text(
          booking.pickupAddress?.address ?? 'Pickup Location',
          style: montserrat(14, grey36, FontWeight.w500),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        16.verticalSpace,
        Text(
          l10n.destination,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        4.verticalSpace,
        Text(
          booking.dropOffAddress?.address ?? 'Destination',
          style: montserrat(14, grey36, FontWeight.w500),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        20.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: containerbackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: iconPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: iconPurple,
                  size: 24.sp,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.selectedVehicleType ?? 'Vehicle',
                      style: montserrat(14, grey36, FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    4.verticalSpace,
                    Text(
                      'License Plate: XXX-0000', // Placeholder
                      style: montserrat(12, grey5F63, FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${booking.finalPrice?.toStringAsFixed(0) ?? '0'} ${booking.priceUnit ?? 'AED'}',
                    style: montserrat(16, grey36, FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    AppLocalizations.of(context)!.fare,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _getFirstWord(String? text) {
    if (text == null || text.isEmpty) return null;
    return text.split(' ').first;
  }
}
