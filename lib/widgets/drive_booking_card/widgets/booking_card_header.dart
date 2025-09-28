import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingCardHeader extends StatelessWidget {
  final RequestBookingModel booking;
  final AppLocalizations l10n;

  const BookingCardHeader({
    super.key,
    required this.booking,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _formatTimeAgo(booking.createdAt, l10n),
          style: montserrat(12, grey36, FontWeight.w400),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _getStatusColor(booking.status),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            _formatStatus(booking.status, l10n),
            style: montserrat(9, Colors.white, FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(BookingStatus? status) {
    if (status == null) return Colors.grey;

    switch (status) {
      case BookingStatus.draft:
        return Colors.grey;
      case BookingStatus.active:
      case BookingStatus.driverComing:
      case BookingStatus.tripStarted:
        return accentPurple;
      case BookingStatus.pending:
        return accentPurple;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.orange;
    }
  }

  String _formatStatus(BookingStatus? status, AppLocalizations l10n) {
    if (status == null) return l10n.draft;

    switch (status) {
      case BookingStatus.draft:
        return l10n.draft;
      case BookingStatus.driverComing:
        return 'Driver Coming';
      case BookingStatus.tripStarted:
        return 'Trip Started';
      case BookingStatus.active:
        return l10n.active;
      case BookingStatus.pending:
        return l10n.pending;
      case BookingStatus.completed:
        return l10n.completed;
      case BookingStatus.cancelled:
        return l10n.cancelled;
    }
  }

  String _formatTimeAgo(DateTime? dateTime, AppLocalizations l10n) {
    if (dateTime == null) {
      return l10n.postedMinutesAgo; // Fallback to default text if no date
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      // More than a week ago
      final weeks = (difference.inDays / 7).floor();
      return 'Posted $weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      // Days ago
      return 'Posted ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      // Hours ago
      return 'Posted ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      // Minutes ago
      return 'Posted ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      // Just now
      return 'Posted just now';
    }
  }
}
