import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class BookingStatusUtilities {
  /// Get the color for a booking status
  static Color getStatusColor(BookingStatus? status) {
    if (status == null) return Colors.grey;

    switch (status) {
      case BookingStatus.draft:
        return Colors.grey;
      case BookingStatus.pending:
        return Color(0xFFAE7461);
      case BookingStatus.active:
        return Colors.blue;
      case BookingStatus.driverComing:
        return Colors.orange;
      case BookingStatus.tripStarted:
        return accentPurple;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  /// Format booking status for display
  static String formatStatus(BuildContext context, BookingStatus? status) {
    final l10n = AppLocalizations.of(context)!;
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

  /// Format date for display
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'No Date';

    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String month = months[dateTime.month - 1];
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();

    // Convert to 12-hour format with AM/PM
    int hour = dateTime.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    String formattedTime =
        "${hour.toString()}:${dateTime.minute.toString().padLeft(2, '0')} $period";

    return "$month $day, $year   $formattedTime";
  }
}

class BookingStatusChip extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingStatusChip({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status ?? BookingStatus.draft;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: BookingStatusUtilities.getStatusColor(status),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        BookingStatusUtilities.formatStatus(context, status),
        style: montserrat(10, Colors.white, FontWeight.w500),
      ),
    );
  }
}
