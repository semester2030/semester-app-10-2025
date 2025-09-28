import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingDetailCostSection extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingDetailCostSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cost,
          style: montserrat(16, colorPrimary, FontWeight.w600),
        ),
        16.verticalSpace,

        // Base price
        _buildCostRow(
          label: _getBasePriceLabel(booking),
          amount: _getBasePriceAmount(booking),
        ),

        // Additional details based on service type
        if (_shouldShowAdditionalDetails(booking)) ...[
          8.verticalSpace,
          _buildCostRow(
            label: _getAdditionalDetailsLabel(booking),
            amount: '',
          ),
        ],

        // Divider
        12.verticalSpace,
        Divider(
          color: borderGrey,
          thickness: 1,
        ),
        12.verticalSpace,

        // Total amount
        _buildCostRow(
          label: l10n.totalEstimate,
          amount: _getTotalAmount(booking),
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildCostRow({
    required String label,
    required String amount,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: montserrat(
            isTotal ? 16 : 14,
            grey36,
            isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        if (amount.isNotEmpty)
          Text(
            amount,
            style: montserrat(
              isTotal ? 16 : 14,
              isTotal ? colorPrimary : grey36,
              isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
      ],
    );
  }

  String _getBasePriceLabel(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return 'Daily Rate';
      case TransportationServiceType.student:
        return booking.selectedTripType == 'Round Trip'
            ? 'Round Trip Fare'
            : 'One Way Fare';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return 'Base Fare';
    }
  }

  String _getBasePriceAmount(RequestBookingModel booking) {
    double amount = booking.basePrice ?? booking.finalPrice ?? 0.0;
    return 'Rs. ${amount.toStringAsFixed(0)}';
  }

  bool _shouldShowAdditionalDetails(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return booking.numberOfHours != null && booking.numberOfHours! > 0;
      case TransportationServiceType.student:
        return booking.selectedTripType != null;
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return booking.selectedSubscriptionPlan != null ||
            booking.selectedWorkSchedule != null;
    }
  }

  String _getAdditionalDetailsLabel(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return 'Duration: ${booking.numberOfHours?.toStringAsFixed(1) ?? '0'} hours';
      case TransportationServiceType.student:
        return 'Trip Type: ${booking.selectedTripType ?? 'Not specified'}';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        if (booking.selectedSubscriptionPlan != null) {
          return 'Plan: ${booking.selectedSubscriptionPlan}';
        } else if (booking.selectedWorkSchedule != null) {
          return 'Schedule: ${booking.selectedWorkSchedule}';
        }
        return '';
    }
  }

  String _getTotalAmount(RequestBookingModel booking) {
    double total = booking.finalPrice ?? booking.basePrice ?? 0.0;
    return 'Rs. ${total.toStringAsFixed(0)}';
  }
}
