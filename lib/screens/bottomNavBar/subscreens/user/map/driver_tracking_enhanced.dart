import 'dart:developer';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverTrackingEnhancedScreen extends HookConsumerWidget {
  final Map<String, dynamic> driver;
  final Map<String, dynamic> booking;
  
  const DriverTrackingEnhancedScreen({
    super.key,
    required this.driver,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final mapController = useState<GoogleMapController?>(null);
    final driverPosition = useState<LatLng?>(null);
    final estimatedArrival = useState<String>('5 minutes');
    final tripProgress = useState<double>(0.3);
    final isTracking = useState<bool>(true);

    // Mock driver position updates
    useEffect(() {
      if (isTracking.value) {
        // Simulate driver movement
        final subscription = Stream.periodic(Duration(seconds: 5), (i) {
          // Update driver position
          driverPosition.value = LatLng(
            24.7136 + (i * 0.001), // Simulate movement
            46.6753 + (i * 0.001),
          );
          
          // Update estimated arrival
          final remainingTime = 5 - (i * 0.5);
          if (remainingTime > 0) {
            estimatedArrival.value = '${remainingTime.toStringAsFixed(0)} minutes';
          } else {
            estimatedArrival.value = 'Arriving now';
          }
          
          // Update trip progress
          tripProgress.value = (i * 0.1).clamp(0.0, 1.0);
        }).listen((_) {});
        
        return () => subscription.cancel();
      }
      return null;
    }, [isTracking.value]);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.driver),
            Text(
              driver['name'],
              style: montserrat(12, Colors.white70, FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Call driver
            },
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Message driver
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Driver Info Card
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.grey[50],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: NetworkImage(driver['image']),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver['name'],
                        style: montserrat(16, grey36, FontWeight.w600),
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Icon(Icons.star, size: 14.sp, color: Colors.amber),
                          4.horizontalSpace,
                          Text(
                            '${driver['rating']}',
                            style: montserrat(14, grey5F63, FontWeight.w500),
                          ),
                          16.horizontalSpace,
                          Icon(Icons.local_shipping, size: 14.sp, color: grey5F63),
                          4.horizontalSpace,
                          Text(
                            driver['vehicleModel'],
                            style: montserrat(14, grey5F63, FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    l10n.driver,
                    style: montserrat(12, Colors.green, FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(24.7136, 46.6753),
                zoom: 15.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController.value = controller;
              },
              markers: {
                if (driverPosition.value != null)
                  Marker(
                    markerId: MarkerId('driver'),
                    position: driverPosition.value!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    infoWindow: InfoWindow(
                      title: driver['name'],
                      snippet: l10n.driver,
                    ),
                  ),
                Marker(
                  markerId: MarkerId('pickup'),
                  position: LatLng(24.7100, 46.6700),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  infoWindow: InfoWindow(
                    title: l10n.address,
                    snippet: booking['pickupAddress'],
                  ),
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: LatLng(24.7200, 46.6800),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  infoWindow: InfoWindow(
                    title: l10n.address,
                    snippet: booking['destinationAddress'],
                  ),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),

          // Trip Progress Card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Trip Progress
                Row(
                  children: [
                    Text(
                      l10n.chooseAccountType,
                      style: montserrat(16, grey36, FontWeight.w600),
                    ),
                    Spacer(),
                    Text(
                      '${(tripProgress.value * 100).toInt()}%',
                      style: montserrat(16, accentPurple, FontWeight.w700),
                    ),
                  ],
                ),
                12.verticalSpace,
                LinearProgressIndicator(
                  value: tripProgress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(accentPurple),
                ),
                20.verticalSpace,

                // Estimated Arrival
                Row(
                  children: [
                    Icon(Icons.access_time, color: accentPurple, size: 20.sp),
                    12.horizontalSpace,
                    Text(
                      l10n.chooseAccountType,
                      style: montserrat(14, grey5F63, FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      estimatedArrival.value,
                      style: montserrat(16, grey36, FontWeight.w700),
                    ),
                  ],
                ),
                16.verticalSpace,

                // Trip Details
                Row(
                  children: [
                    Expanded(
                      child: _buildTripDetail(
                        icon: Icons.location_on,
                        label: l10n.address,
                        value: booking['pickupAddress'],
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: _buildTripDetail(
                        icon: Icons.flag,
                        label: l10n.address,
                        value: booking['destinationAddress'],
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Cancel trip
                        },
                        icon: Icon(Icons.cancel, size: 18.sp),
                        label: Text(l10n.cancel),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Contact driver
                        },
                        icon: Icon(Icons.phone, size: 18.sp),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: grey5F63),
            8.horizontalSpace,
            Text(
              label,
              style: montserrat(12, grey5F63, FontWeight.w500),
            ),
          ],
        ),
        4.verticalSpace,
        Text(
          value,
          style: montserrat(14, grey36, FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
