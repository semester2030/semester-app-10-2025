import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/providers/trip_tracking_provider.dart';
import 'package:semester_student_ride_app/providers/user_provider.dart';
import 'package:semester_student_ride_app/services/trip_tracking_service.dart';
import 'package:semester_student_ride_app/utils/chat_utils.dart';
import 'package:semester_student_ride_app/utils/distance_utils.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/utils/directions_test.dart';
import 'package:semester_student_ride_app/services/driver_location_service.dart';

// Helper function to test and start driver location tracking
Future<void> testDriverLocationTracking() async {
  try {
    log('🧪 Testing driver location tracking...', name: 'DriverLocationTest');

    // Check if already tracking
    final isCurrentlyTracking = DriverLocationService.isTracking;
    log('📍 Current tracking status: $isCurrentlyTracking',
        name: 'DriverLocationTest');

    // Check permissions
    final hasPermission = await DriverLocationService.hasLocationPermission();
    log('🔒 Has location permission: $hasPermission',
        name: 'DriverLocationTest');

    // Check if location service is enabled
    final serviceEnabled =
        await DriverLocationService.isLocationServiceEnabled();
    log('🛰️ Location service enabled: $serviceEnabled',
        name: 'DriverLocationTest');

    // If not tracking, try to start it
    if (!isCurrentlyTracking) {
      log('🚀 Starting driver location tracking...',
          name: 'DriverLocationTest');
      final started = await DriverLocationService.startLocationTracking();
      log('✅ Location tracking started: $started', name: 'DriverLocationTest');

      // Test immediate update
      await Future.delayed(Duration(seconds: 2));
      await DriverLocationService.updateLocationNow();
      log('🔄 Forced location update triggered', name: 'DriverLocationTest');
    } else {
      log('✅ Location tracking already active', name: 'DriverLocationTest');
    }
  } catch (e) {
    log('❌ Error testing driver location: $e', name: 'DriverLocationTest');
  }
}

// Helper function to create car marker icon
Future<BitmapDescriptor> createCarMarkerIcon() async {
  try {
    final ByteData data = await rootBundle.load('assets/images/car.png');
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 120,
      targetHeight: 120,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData != null) {
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    }
  } catch (e) {
    log('Error creating car marker icon: $e');
  }
  return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
}

// Helper function to create circular user profile marker
Future<BitmapDescriptor> createUserProfileMarker(
    String? profileImageUrl) async {
  try {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 100.0;
    const radius = size / 2;

    // Draw outer circle (purple border)
    final borderPaint = Paint()
      ..color = accentPurple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(radius, radius), radius, borderPaint);

    // Draw inner circle (white background)
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        const Offset(radius, radius), radius - 3, backgroundPaint);

    // Draw user icon in the center
    final iconPaint = Paint()
      ..color = accentPurple
      ..style = PaintingStyle.fill;

    // Draw head (upper circle)
    canvas.drawCircle(const Offset(radius, radius - 8), 12, iconPaint);

    // Draw body (lower arc/circle)
    final bodyRect =
        Rect.fromCircle(center: const Offset(radius, radius + 15), radius: 18);
    canvas.drawArc(bodyRect, -0.5, 1.0, true, iconPaint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    }
  } catch (e) {
    log('Error creating user profile marker: $e');
  }
  return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
}

class LiveDriverTrackingScreen extends HookConsumerWidget {
  final RequestBookingModel booking;

  const LiveDriverTrackingScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = useState<GoogleMapController?>(null);
    final markers = useState<Set<Marker>>({});
    final polylines = useState<Set<Polyline>>({});
    final isCardMinimized = useState<bool>(false);
    final hasUserInteractedWithMap = useState<bool>(false);

    final tripTrackingState = ref.watch(tripTrackingProvider);
    final tripTrackingNotifier = ref.read(tripTrackingProvider.notifier);

    // Initialize tracking when screen loads
    useEffect(() {
      if (booking.id != null && booking.pickupAddress?.coordinates != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Pass destination location if available for trip tracking
          final destinationLocation = booking.dropOffAddress?.coordinates;
          tripTrackingNotifier.startTracking(
            booking.driverId!,
            booking.pickupAddress!.coordinates,
            booking.id!,
            destinationLocation: destinationLocation,
          );
        });
      }

      // Test Directions API
      DirectionsTest.testDirections();

      // Test driver location tracking
      testDriverLocationTracking();

      return () {
        // Delay the stopTracking call to avoid modifying provider during widget disposal
        Future.microtask(() {
          tripTrackingNotifier.stopTracking();
        });
      };
    }, [booking.id]);

    // Listen for trip completion and auto-pop screen
    useEffect(() {
      if (tripTrackingState.bookingStatus == BookingStatus.completed) {
        // Delay to allow any UI updates to complete before navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            log('🎯 Trip completed - auto-popping screen',
                name: 'LiveDriverTracking');
            context.pop();
          }
        });
      }
      ref.invalidate(userBookingsProvider);
      return null;
    }, [tripTrackingState.bookingStatus]);

    // Update markers and polylines when driver location changes
    useEffect(() {
      if (tripTrackingState.driverLocation != null &&
          booking.pickupAddress?.coordinates != null) {
        // Call async function to update map elements
        Future.microtask(() async {
          // Determine target location based on booking status
          LatLng targetLocation;
          String targetTitle;
          String targetSnippet;

          if (tripTrackingState.bookingStatus == BookingStatus.tripStarted &&
              booking.dropOffAddress?.coordinates != null) {
            // Trip started - show destination
            targetLocation = booking.dropOffAddress!.coordinates;
            targetTitle = 'Destination';
            targetSnippet = 'Your ride destination';
          } else {
            // Default to pickup location
            targetLocation = booking.pickupAddress!.coordinates;
            targetTitle = 'Pickup Location';
            targetSnippet = 'Your ride will pick you up here';
          }

          log('🗺️ Updating map elements - Driver: ${tripTrackingState.driverLocation}, Target: $targetTitle, Route points: ${tripTrackingState.routePolyline.length}',
              name: 'LiveDriverTracking');

          await _updateMapElements(
            markers,
            polylines,
            tripTrackingState.driverLocation!,
            targetLocation,
            targetTitle,
            targetSnippet,
            tripTrackingState.routePolyline,
            tripTrackingState.driverData,
          );

          // Only update camera if user hasn't interacted with the map
          if (mapController.value != null && !hasUserInteractedWithMap.value) {
            _updateCameraToShowBothPoints(
              mapController.value!,
              tripTrackingState.driverLocation!,
              targetLocation,
            );
          }
        });
      }
      return null;
    }, [
      tripTrackingState.driverLocation,
      tripTrackingState.routePolyline.length, // Monitor route length changes
      tripTrackingState.driverData,
      tripTrackingState.bookingStatus, // Monitor booking status changes
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: booking.pickupAddress?.coordinates ??
                  const LatLng(25.2048, 55.2708),
              zoom: 14,
            ),
            markers: markers.value,
            polylines: polylines.value,
            onMapCreated: (GoogleMapController controller) {
              mapController.value = controller;
              _applyMapStyle(controller, context);
            },
            // Track user interaction with map
            onCameraMove: (CameraPosition position) {
              hasUserInteractedWithMap.value = true;
            },
            onTap: (LatLng position) {
              hasUserInteractedWithMap.value = true;
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
            trafficEnabled: false,
            buildingsEnabled: true,
            indoorViewEnabled: false,
          ),
          Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: accentPurple),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  const Spacer(),
                  // Center on route button
                  Container(
                    height: 40.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: accentPurple),
                    child: IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.white),
                      onPressed: () {
                        // Reset user interaction flag and center the map
                        hasUserInteractedWithMap.value = false;
                        if (mapController.value != null &&
                            tripTrackingState.driverLocation != null &&
                            booking.pickupAddress?.coordinates != null) {
                          LatLng targetLocation;
                          if (tripTrackingState.bookingStatus ==
                                  BookingStatus.tripStarted &&
                              booking.dropOffAddress?.coordinates != null) {
                            targetLocation =
                                booking.dropOffAddress!.coordinates;
                          } else {
                            targetLocation = booking.pickupAddress!.coordinates;
                          }
                          _updateCameraToShowBothPoints(
                            mapController.value!,
                            tripTrackingState.driverLocation!,
                            targetLocation,
                          );
                        }
                      },
                    ),
                  ),
                ],
              )),

          // Loading overlay
          if (tripTrackingState.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: accentPurple),
              ),
            ),

          // Driver info card
          // if (tripTrackingState.driverData != null)
          //   Positioned(
          //     top: 100,
          //     left: 16,
          //     right: 16,
          //     child: _buildDriverInfoCard(
          //       context,
          //       tripTrackingState.driverData!,
          //       ref,
          //     ),
          //   ),

          // Trip status card
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: _buildTripStatusCard(
              context,
              tripTrackingState,
              booking,
              isCardMinimized,
            ),
          ),

          // Action buttons
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildActionButtons(
              context,
              tripTrackingState.driverData,
              ref,
            ),
          ),

          // Error message
          if (tripTrackingState.error != null)
            Positioned(
              top: 100,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        tripTrackingState.error!,
                        style: montserrat(14, Colors.red, FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => tripTrackingNotifier.clearError(),
                    ),
                  ],
                ),
              ),
            ),

          // Driver proximity warning (only when driver is coming, not when trip has started)
          if (tripTrackingState.isDriverNearby &&
              tripTrackingState.driverData != null &&
              tripTrackingState.bookingStatus == BookingStatus.driverComing)
            Positioned(
              top: tripTrackingState.error != null ? 180 : 100,
              left: 16,
              right: 16,
              child: _buildProximityWarningContainer(
                context,
                tripTrackingState.driverData!,
                tripTrackingState.routeInfo,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTripStatusCard(
    BuildContext context,
    TripTrackingState state,
    RequestBookingModel booking,
    ValueNotifier<bool> isCardMinimized,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with status and minimize/expand button
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(state.bookingStatus),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  _getStatusText(state.bookingStatus, state.isTripActive, l10n),
                  style: montserrat(12, Colors.white, FontWeight.w500),
                ),
              ),
              const Spacer(),
              // Minimize/Expand button
              GestureDetector(
                onTap: () {
                  isCardMinimized.value = !isCardMinimized.value;
                },
                child: Icon(
                  isCardMinimized.value ? Icons.expand_less : Icons.expand_more,
                  color: accentPurple,
                  size: 20.sp,
                ),
              ),
              8.horizontalSpace,
            ],
          ),

          // Expandable content
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isCardMinimized.value
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: _buildExpandedContent(context, state, booking, l10n),
            secondChild: _buildMinimizedContent(context, state, booking),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    TripTrackingState state,
    RequestBookingModel booking,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        _buildLocationInfo(
          'Pickup Location',
          booking.pickupAddress?.address ?? 'Not specified',
          Icons.location_on,
          accentPurple,
        ),
        12.verticalSpace,
        if (booking.dropOffAddress != null)
          _buildLocationInfo(
            'Drop-off Location',
            booking.dropOffAddress!.address,
            Icons.flag,
            Colors.red,
          ),

        // Route information
        if (state.routeInfo != null) ...[
          12.verticalSpace,
          Divider(color: grey5F63.withOpacity(0.3)),
          8.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildRouteInfoItem(
                  'Distance',
                  state.routeInfo!['distance'] ?? 'N/A',
                  Icons.straighten,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: _buildRouteInfoItem(
                  'Duration',
                  state.routeInfo!['duration'] ?? 'N/A',
                  Icons.access_time,
                ),
              ),
            ],
          ),
        ],

        // Show proximity status when driver is nearby (only when driver is coming, not when trip has started)
        if (state.isDriverNearby &&
            state.driverLocation != null &&
            state.bookingStatus == BookingStatus.driverComing) ...[
          12.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: accentPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: accentPurple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.near_me, size: 16.sp, color: accentPurple),
                8.horizontalSpace,
                Expanded(
                  child: Text(
                    'Driver is very close! Distance: ${DistanceUtils.formatDistance(
                      DistanceUtils.calculateDistance(
                        state.driverLocation!,
                        booking.pickupAddress!.coordinates,
                      ),
                    )}',
                    style: montserrat(12, accentPurple, FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMinimizedContent(
    BuildContext context,
    TripTrackingState state,
    RequestBookingModel booking,
  ) {
    return Column(
      children: [
        8.verticalSpace,
        Row(
          children: [
            Icon(Icons.location_on, size: 16.sp, color: accentPurple),
            8.horizontalSpace,
            Expanded(
              child: Text(
                booking.pickupAddress?.address ?? 'Not specified',
                style: montserrat(12, grey36, FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.routeInfo != null) ...[
              8.horizontalSpace,
              Text(
                state.routeInfo!['duration'] ?? 'N/A',
                style: montserrat(10, accentPurple, FontWeight.w600),
              ),
            ],
          ],
        ),
        if (state.isDriverNearby &&
            state.bookingStatus == BookingStatus.driverComing) ...[
          4.verticalSpace,
          Row(
            children: [
              Icon(Icons.near_me, size: 14.sp, color: Colors.orange),
              4.horizontalSpace,
              Text(
                'Driver is nearby!',
                style: montserrat(10, Colors.orange, FontWeight.w600),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLocationInfo(
      String label, String address, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: color),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
              2.verticalSpace,
              Text(
                address,
                style: montserrat(14, grey36, FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: accentPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: accentPurple),
          6.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: montserrat(10, grey5F63, FontWeight.w400),
                ),
                Text(
                  value,
                  style: montserrat(12, accentPurple, FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    Map<String, dynamic>? driverData,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        Expanded(
          child: NormalCustomButton(
            height: 48,
            label: 'Chat with Driver',
            titleStyle: montserrat(14, whiteColor, FontWeight.w500),
            syncCallback: () async {
              if (driverData != null) {
                // Create a UserSignupModel from driver data for chat
                final driverUser = UserSignupModel(
                  id: driverData['driverId'],
                  name: driverData['driverName'] ?? 'Unknown Driver',
                  email: 'driver@example.com', // Placeholder
                  password: '', // Not needed for chat
                  phoneNumber: driverData['phoneNumber'],
                  profilePicture: driverData['driverPhoto'],
                  isDriver: true,
                );

                ChatUtils.startChat(
                  context: context,
                  otherUser: driverUser,
                  ref: ref,
                );
              }
            },
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: NormalCustomButton(
            height: 48,
            label: 'Call Driver',
            buttonColor: containerbackground,
            titleStyle: montserrat(14, grey56, FontWeight.w500),
            syncCallback: () async {
              // In a real app, you would implement phone call functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Call driver functionality would be implemented here'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _updateMapElements(
    ValueNotifier<Set<Marker>> markers,
    ValueNotifier<Set<Polyline>> polylines,
    LatLng driverLocation,
    LatLng targetLocation,
    String targetTitle,
    String targetSnippet,
    List<LatLng> routePoints,
    Map<String, dynamic>? driverData,
  ) async {
    log('🎯 _updateMapElements called - Route points: ${routePoints.length}',
        name: 'LiveDriverTracking');

    // Get current user for profile picture
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    String? currentUserProfilePicture;

    if (currentUserId != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          currentUserProfilePicture = userData?['profilePicture'];
        }
      } catch (e) {
        log('Error fetching current user profile: $e');
      }
    }

    // Create custom markers
    final carIcon = await createCarMarkerIcon();
    final userProfileIcon =
        await createUserProfileMarker(currentUserProfilePicture);

    // Update markers
    final newMarkers = <Marker>{
      // Target location marker with user profile picture
      Marker(
        markerId: const MarkerId('target'),
        position: targetLocation,
        infoWindow: InfoWindow(
          title: targetTitle,
          snippet: targetSnippet,
        ),
        icon: userProfileIcon,
      ),
      // Driver location marker with car icon
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLocation,
        infoWindow: InfoWindow(
          title: driverData?['driverName'] ?? 'Driver',
          snippet: 'En route to pickup',
        ),
        icon: carIcon,
      ),
    };

    // Update polyline with solid styling - ensure it's always created
    final newPolylines = <Polyline>{};

    if (routePoints.isNotEmpty) {
      log('✅ Creating polyline with ${routePoints.length} points',
          name: 'LiveDriverTracking');
      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: accentPurple,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        geodesic: true,
        // Solid line - no patterns
      );
      newPolylines.add(polyline);
    } else {
      // Create a fallback straight line if no route points available
      log('⚠️ No route points available, creating fallback straight line',
          name: 'LiveDriverTracking');
      final fallbackPolyline = Polyline(
        polylineId: const PolylineId('route'),
        points: [driverLocation, targetLocation],
        color: accentPurple.withOpacity(0.7),
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        geodesic: true,
        patterns: [
          PatternItem.dash(10),
          PatternItem.gap(5)
        ], // Dashed for fallback
      );
      newPolylines.add(fallbackPolyline);
    }

    log('🔄 Setting markers: ${newMarkers.length}, polylines: ${newPolylines.length}',
        name: 'LiveDriverTracking');

    markers.value = newMarkers;
    polylines.value = newPolylines;
  }

  Future<void> _updateCameraToShowBothPoints(
    GoogleMapController controller,
    LatLng driverLocation,
    LatLng targetLocation,
  ) async {
    final bounds = LatLngBounds(
      southwest: LatLng(
        [driverLocation.latitude, targetLocation.latitude]
            .reduce((a, b) => a < b ? a : b),
        [driverLocation.longitude, targetLocation.longitude]
            .reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        [driverLocation.latitude, targetLocation.latitude]
            .reduce((a, b) => a > b ? a : b),
        [driverLocation.longitude, targetLocation.longitude]
            .reduce((a, b) => a > b ? a : b),
      ),
    );

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );
  }

  Future<void> _applyMapStyle(
      GoogleMapController controller, BuildContext context) async {
    try {
      final mapStyle = await DefaultAssetBundle.of(context)
          .loadString('assets/map_style.json');
      await controller.setMapStyle(mapStyle);
    } catch (e) {
      log('Error loading map style: $e');
    }
  }

  Widget _buildProximityWarningContainer(
    BuildContext context,
    Map<String, dynamic> driverData,
    Map<String, dynamic>? routeInfo,
  ) {
    final driverName = driverData['driverName'] ?? 'Your driver';
    final estimatedArrival = routeInfo?['duration'] ?? '1-2 minutes';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentPurple,
            accentPurple.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: accentPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Warning icon with animation
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          16.horizontalSpace,
          // Warning text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Driver Approaching!',
                  style: montserrat(16, Colors.white, FontWeight.bold),
                ),
                4.verticalSpace,
                Text(
                  '$driverName is nearby and will arrive in $estimatedArrival.\nGet ready for pickup!',
                  style: montserrat(12, Colors.white, FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Pulse animation indicator
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus? status) {
    if (status == null) return Colors.grey;

    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
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
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(
      BookingStatus? status, bool isTripActive, AppLocalizations l10n) {
    if (status == null) return l10n.pending;

    switch (status) {
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
      default:
        return l10n.pending;
    }
  }
}
