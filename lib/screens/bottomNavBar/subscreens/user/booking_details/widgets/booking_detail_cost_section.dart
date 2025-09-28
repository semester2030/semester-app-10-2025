import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class BookingDetailCostSection extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingDetailCostSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.cost,
          style: montserrat(16, grey36, FontWeight.w600),
        ),
        20.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Base fare
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getBaseFareLabel(booking),
                    style: montserrat(14, grey36, FontWeight.w400),
                  ),
                  Text(
                    _getFormattedPrice(booking.basePrice ?? 0.0),
                    style: montserrat(14, grey36, FontWeight.w400),
                  ),
                ],
              ),

              // Additional charges based on service type
              if (_hasAdditionalCharges(booking)) ...[
                12.verticalSpace,
                ..._buildAdditionalCharges(booking),
              ],

              // Total with separator line
              16.verticalSpace,
              Divider(color: Colors.grey.shade300),
              8.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .totalEstimate
                        .replaceAll(':', ''),
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  Text(
                    _getFormattedPrice(
                        booking.finalPrice ?? booking.basePrice ?? 0.0),
                    style: montserrat(16, colorPrimary, FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getBaseFareLabel(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return 'Hourly Rate';
      case TransportationServiceType.student:
        return booking.selectedTripType == 'Round Trip'
            ? 'Round Trip Fare'
            : 'One Way Fare';
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return 'Transport Fee';
    }
  }

  bool _hasAdditionalCharges(RequestBookingModel booking) {
    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        return booking.numberOfHours != null && booking.numberOfHours! > 1;
      case TransportationServiceType.student:
        return booking.pricePerHour != null && booking.pricePerHour! > 0;
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return false; // Simple pricing for these types
    }
  }

  List<Widget> _buildAdditionalCharges(RequestBookingModel booking) {
    List<Widget> charges = [];

    switch (booking.serviceType) {
      case TransportationServiceType.daily:
        if (booking.numberOfHours != null && booking.numberOfHours! > 1) {
          charges.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Additional Hours (${(booking.numberOfHours! - 1).toStringAsFixed(1)})',
                  style: montserrat(14, grey36, FontWeight.w400),
                ),
                Text(
                  _getFormattedPrice(
                      (booking.pricePerHour ?? booking.basePrice ?? 0.0) *
                          (booking.numberOfHours! - 1)),
                  style: montserrat(14, grey36, FontWeight.w400),
                ),
              ],
            ),
          );
        }
        break;

      case TransportationServiceType.student:
        if (booking.pricePerHour != null && booking.pricePerHour! > 0) {
          charges.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hourly Rate',
                  style: montserrat(14, grey36, FontWeight.w400),
                ),
                Text(
                  _getFormattedPrice(booking.pricePerHour!),
                  style: montserrat(14, grey36, FontWeight.w400),
                ),
              ],
            ),
          );
        }
        break;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        // No additional charges for these service types
        break;
    }

    // Add spacing between charges
    List<Widget> spacedCharges = [];
    for (int i = 0; i < charges.length; i++) {
      spacedCharges.add(charges[i]);
      if (i < charges.length - 1) {
        spacedCharges.add(8.verticalSpace);
      }
    }

    return spacedCharges;
  }

  String _getFormattedPrice(double price) {
    return '${price.toStringAsFixed(0)} ${_getPriceUnit()}';
  }

  String _getPriceUnit() {
    return booking.priceUnit ?? 'SAR';
  }
}
