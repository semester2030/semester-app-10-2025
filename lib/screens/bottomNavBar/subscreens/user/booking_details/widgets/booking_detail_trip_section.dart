import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class BookingDetailTripSection extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingDetailTripSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.status,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        4.verticalSpace,
        Text(
          _formatStatus(context, booking.status ?? BookingStatus.draft),
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        20.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTimeLabel(context, booking),
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    _getFormattedTime(booking),
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDurationLabel(context, booking),
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    _getFormattedDuration(booking),
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Show end time for round trips or daily transport
        if (_shouldShowEndTime(booking)) ...[
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getEndTimeLabel(context, booking),
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    4.verticalSpace,
                    Text(
                      _getFormattedEndTime(booking),
                      style: montserrat(14, grey36, FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()), // Empty space to maintain layout
            ],
          ),
        ],

        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    _getFormattedDate(booking),
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.paymentMethod,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    'Card', // Default payment method
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTimeLabel(BuildContext context, RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return 'Start Time';
      case TransportationServiceType.student:
        return 'Transport Start Time';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return 'Pickup Time';
    }
  }

  String _getFormattedTime(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return booking.startTime ?? 'Not specified';
      case TransportationServiceType.student:
        return booking.transportStartTime ?? 'Not specified';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return booking.startTime ??
            booking.transportStartTime ??
            'Not specified';
    }
  }

  String _getDurationLabel(BuildContext context, RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return 'Duration';
      case TransportationServiceType.student:
        return booking.selectedTripType == 'Round Trip'
            ? 'Trip Type'
            : 'Trip Type';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return 'Schedule';
    }
  }

  String _getFormattedDuration(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return booking.numberOfHours != null
            ? '${booking.numberOfHours!.toStringAsFixed(1)} hours'
            : 'Not specified';
      case TransportationServiceType.student:
        return booking.selectedTripType ?? 'Not specified';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return booking.selectedWorkSchedule ?? 'Not specified';
    }
  }

  bool _shouldShowEndTime(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return true; // Always show end time for daily transport
      case TransportationServiceType.student:
        return booking.selectedTripType == 'Round Trip';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return false; // Don't show separate end time
    }
  }

  String _getEndTimeLabel(BuildContext context, RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return 'End Time';
      case TransportationServiceType.student:
        return 'Return Time';
      default:
        return 'End Time';
    }
  }

  String _getFormattedEndTime(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return booking.endTime ?? 'Not specified';
      case TransportationServiceType.student:
        return booking.transportEndTime ?? 'Not specified';
      default:
        return 'Not specified';
    }
  }

  String _getFormattedDate(RequestBookingModel booking) {
    // Priority: transport-specific date, then general date, then created date
    String? dateStr = booking.transportStartDate ??
        booking.selectedDate ??
        (booking.createdAt != null ? _formatDate(booking.createdAt!) : null);
    return dateStr ?? 'Not specified';
  }

  String _formatStatus(BuildContext context, BookingStatus? status) {
    if (status == null) return AppLocalizations.of(context)!.draft;

    switch (status) {
      case BookingStatus.draft:
        return AppLocalizations.of(context)!.draft;
      case BookingStatus.active:
        return AppLocalizations.of(context)!.active;
      case BookingStatus.driverComing:
        return 'Driver Coming';
      case BookingStatus.tripStarted:
        return 'Trip Started';
      case BookingStatus.pending:
        return AppLocalizations.of(context)!.pending;
      case BookingStatus.completed:
        return AppLocalizations.of(context)!.completed;
      case BookingStatus.cancelled:
        return AppLocalizations.of(context)!.cancelled;
    }
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }
}
