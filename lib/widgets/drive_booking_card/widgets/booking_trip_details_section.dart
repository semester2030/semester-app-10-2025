import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingTripDetailsSection extends StatelessWidget {
  final RequestBookingModel booking;
  final AppLocalizations l10n;

  const BookingTripDetailsSection({
    super.key,
    required this.booking,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row - Trip Way and Start Time
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                label: l10n.tripWay,
                value: booking.selectedTripType ??
                    booking.transportStartDate ??
                    "One-way",
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                label: l10n.startTime,
                value: booking.startTime ??
                    booking.transportStartTime ??
                    "09:00 AM",
              ),
            ),
          ],
        ),
        8.verticalSpace,
        // Second row - Start Date and Return Time
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                label: l10n.startDate,
                value: booking.selectedDate ??
                    booking.transportStartDate ??
                    "Today",
              ),
            ),
            Expanded(
              child: _buildDetailItem(
                label: l10n.returnTime,
                value:
                    booking.endTime ?? booking.transportEndTime ?? "05:00 PM",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label – ',
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        2.verticalSpace,
        Text(
          value,
          style: montserrat(12, grey36, FontWeight.w500),
        ),
      ],
    );
  }
}
