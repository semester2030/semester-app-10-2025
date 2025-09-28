import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';

class BookingConfirmationScreen extends HookConsumerWidget {
  final Map<String, dynamic> bookingDetails;
  
  const BookingConfirmationScreen({
    super.key,
    required this.bookingDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final bookingStatus = useState<String>('pending');
    final estimatedArrival = useState<String>('5-10 minutes');
    final driverInfo = useState<Map<String, dynamic>?>(null);

    // Mock driver assignment
    useEffect(() {
      Future.delayed(Duration(seconds: 2), () {
        driverInfo.value = {
          'id': '1',
          'name': 'Ahmed Al-Rashid',
          'rating': 4.8,
          'image': 'https://randomuser.me/api/portraits/men/1.jpg',
          'vehicleModel': 'Toyota Camry 2023',
          'vehicleColor': 'White',
          'licensePlate': 'ABC-1234',
          'phone': '+966501234567',
          'estimatedArrival': '5-10 minutes',
        };
        bookingStatus.value = 'confirmed';
      });
      return null;
    }, []);

    Future<void> onCancelBooking() async {
      // TODO: Implement booking cancellation
      context.pop();
    }

    Future<void> onContactDriver() async {}

    Future<void> onTrackDriver() async { context.go('/booking_map', extra: TransportationServiceType.student); }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setting),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Header
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: bookingStatus.value == 'confirmed' 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: bookingStatus.value == 'confirmed' 
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      bookingStatus.value == 'confirmed' 
                          ? Icons.check_circle
                          : Icons.access_time,
                      color: bookingStatus.value == 'confirmed' 
                          ? Colors.green
                          : Colors.orange,
                      size: 32.sp,
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookingStatus.value == 'confirmed' 
                                ? l10n.continueButton
                                : l10n.chooseAccountType,
                            style: montserrat(18, grey36, FontWeight.w700),
                          ),
                          4.verticalSpace,
                          Text(
                            bookingStatus.value == 'confirmed' 
                                ? l10n.chooseAccountType
                                : l10n.chooseAccountType,
                            style: montserrat(14, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              32.verticalSpace,

              // Booking Details
              Text(
                l10n.personalInformation,
                style: montserrat(20, grey36, FontWeight.w700),
              ),
              16.verticalSpace,

              _buildDetailCard(
                icon: Icons.location_on,
                title: l10n.address,
                value: bookingDetails['pickupAddress'] ?? '',
                color: Colors.blue,
              ),
              12.verticalSpace,

              _buildDetailCard(
                icon: Icons.flag,
                title: l10n.address,
                value: bookingDetails['destinationAddress'] ?? '',
                color: Colors.red,
              ),
              12.verticalSpace,

              _buildDetailCard(
                icon: Icons.local_shipping,
                title: l10n.personalInformation,
                value: bookingDetails['serviceType'] ?? '',
                color: Colors.green,
              ),
              12.verticalSpace,

              _buildDetailCard(
                icon: Icons.directions_car,
                title: l10n.personalInformation,
                value: bookingDetails['vehicleType'] ?? '',
                color: Colors.orange,
              ),
              12.verticalSpace,

              _buildDetailCard(
                icon: Icons.access_time,
                title: l10n.personalInformation,
                value: bookingDetails['scheduledTime'] ?? '',
                color: Colors.purple,
              ),
              12.verticalSpace,

              _buildDetailCard(
                icon: Icons.attach_money,
                title: l10n.personalInformation,
                value: bookingDetails['estimatedFare'] ?? '',
                color: Colors.green,
              ),

              32.verticalSpace,

              // Driver Information
              if (driverInfo.value != null) ...[
                Text(
                  l10n.driver,
                  style: montserrat(20, grey36, FontWeight.w700),
                ),
                16.verticalSpace,

                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundImage: NetworkImage(driverInfo.value!['image']),
                          ),
                          16.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driverInfo.value!['name'],
                                  style: montserrat(18, grey36, FontWeight.w700),
                                ),
                                4.verticalSpace,
                                Row(
                                  children: [
                                    Icon(Icons.star, size: 16.sp, color: Colors.amber),
                                    4.horizontalSpace,
                                    Text(
                                      '${driverInfo.value!['rating']}',
                                      style: montserrat(14, grey5F63, FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              l10n.driver,
                              style: montserrat(12, Colors.green, FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      20.verticalSpace,

                      // Vehicle Information
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.directions_car, color: accentPurple, size: 20.sp),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${driverInfo.value!['vehicleModel']}',
                                    style: montserrat(16, grey36, FontWeight.w600),
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    '${driverInfo.value!['vehicleColor']} • ${driverInfo.value!['licensePlate']}',
                                    style: montserrat(14, grey5F63, FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,

                      // Estimated Arrival
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.orange, size: 20.sp),
                          12.horizontalSpace,
                          Text(
                            l10n.chooseAccountType,
                            style: montserrat(14, grey5F63, FontWeight.w500),
                          ),
                          Text(
                            estimatedArrival.value,
                            style: montserrat(14, grey36, FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                32.verticalSpace,

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onContactDriver,
                        icon: Icon(Icons.phone, size: 18.sp),
                        label: Text(l10n.driver),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accentPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onTrackDriver,
                        icon: Icon(Icons.location_on, size: 18.sp),
                        label: Text(l10n.driver),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Loading State
                Container(
                  padding: EdgeInsets.all(40.w),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: accentPurple,
                        strokeWidth: 3,
                      ),
                      24.verticalSpace,
                      Text(
                        l10n.chooseAccountType,
                        style: montserrat(16, grey5F63, FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      8.verticalSpace,
                      Text(
                        l10n.chooseAccountType,
                        style: montserrat(14, grey5F63, FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],

              32.verticalSpace,

              // Cancel Booking Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancelBooking,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child: Text(
                    l10n.continueButton,
                    style: montserrat(16, Colors.red, FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.sp),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: montserrat(12, grey5F63, FontWeight.w500),
                ),
                4.verticalSpace,
                Text(
                  value,
                  style: montserrat(14, grey36, FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
