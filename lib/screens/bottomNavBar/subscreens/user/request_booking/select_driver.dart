import 'dart:developer' as dev;
import 'dart:math';

import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/widgets/section_header.dart';
import 'package:semester_student_ride_app/widgets/address_stepper_widget.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

class SelectDriver extends HookConsumerWidget {
  final TransportationServiceType serviceType;

  const SelectDriver({
    super.key,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingState = ref.watch(bookingFlowProvider);
    final bookingNotifier = ref.read(bookingFlowProvider.notifier);

    // Local state for UI and map
    final searchDistance = useState<double>(bookingState.searchRadius);
    final isMapExpanded = useState<bool>(false);
    final mapController = useState<GoogleMapController?>(null);
    final currentPosition = useState<Position?>(null);
    final markers = useState<Set<Marker>>({});
    final isLoadingLocation = useState<bool>(true);

    // Function to calculate distance between two points
    double calculateDistance(
        double lat1, double lon1, double lat2, double lon2) {
      return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) /
          1000; // Convert to kilometers
    }

    // Generate driver position based on email hash (for consistent demo data)
    LatLng getDriverPosition(UserSignupModel driver) {
      final random = Random(driver.email.hashCode);
      final lat = 24.7136 +
          (random.nextDouble() - 0.5) * 0.1; // ±0.05 degrees around Riyadh
      final lng = 46.6753 + (random.nextDouble() - 0.5) * 0.1;
      return LatLng(lat, lng);
    }

    // Filter drivers based on distance radius
    final filteredDrivers = bookingState.availableDrivers.where((driver) {
      if (currentPosition.value == null) return true;

      final driverPos = getDriverPosition(driver);
      final distance = calculateDistance(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        driverPos.latitude,
        driverPos.longitude,
      );

      return distance <= searchDistance.value;
    }).toList();

    // Function to update markers
    void updateMarkers() {
      Set<Marker> newMarkers = {};

      // Add driver markers
      for (final driver in filteredDrivers) {
        final isSelected = bookingState.selectedDriver?.email == driver.email;
        final driverPos = getDriverPosition(driver);

        newMarkers.add(
          Marker(
            markerId: MarkerId('driver_${driver.email}'),
            position: driverPos,
            icon: isSelected
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: driver.name,
              snippet:
                  '${driver.role ?? 'Driver'} • ${currentPosition.value != null ? calculateDistance(currentPosition.value!.latitude, currentPosition.value!.longitude, driverPos.latitude, driverPos.longitude).toStringAsFixed(1) : '0.0'} km away',
            ),
            onTap: () {
              bookingNotifier.selectDriver(driver);
              updateMarkers(); // Update markers to reflect selection
            },
          ),
        );
      }

      markers.value = newMarkers;
    }

    // Function to get current location
    Future<void> getCurrentLocation() async {
      try {
        isLoadingLocation.value = true;

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception('Location permissions are denied');
          }
        }

        if (permission == LocationPermission.deniedForever) {
          throw Exception('Location permissions are permanently denied');
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        currentPosition.value = position;

        // Move camera to current location
        if (mapController.value != null) {
          await mapController.value!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        }

        isLoadingLocation.value = false;
        updateMarkers();
      } catch (e) {
        dev.log('Error getting location: $e');
        isLoadingLocation.value = false;
        // Use default location (Riyadh, Saudi Arabia) if location fails
        currentPosition.value = Position(
          latitude: 24.7136,
          longitude: 46.6753,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        updateMarkers();
      }
    }

    // Load drivers and get location on initial load
    useEffect(() {
      Future.microtask(() async {
        if (bookingState.availableDrivers.isEmpty) {
          await bookingNotifier.loadAvailableDrivers();
        }

        // If we're editing and have a previously selected driver ID, load it
        if (bookingState.selectedDriver == null &&
            bookingState.originalDriverID?.isNotEmpty == true) {
          dev.log(
              'Loading original driver with ID: ${bookingState.originalDriverID}');
          await bookingNotifier
              .selectDriverByID(bookingState.originalDriverID!);
        }

        // Get current location
        await getCurrentLocation();
      });
      return null;
    }, []);

    // Update markers when drivers change
    useEffect(() {
      updateMarkers();
      return null;
    }, [filteredDrivers.length, bookingState.selectedDriver]);

    return ScreenWithTopAppbar(
        title: serviceType.getLocalizedAppBarTitle(l10n),
        child: Column(
          children: [
            // Stepper widget with better spacing
            140.verticalSpace,
            AddressStepperWidget(currentStep: 2),
            24.verticalSpace,
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: accentPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.person,
                          color: accentPurple,
                          size: 20.w,
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.selectDriverOnMap,
                              style: montserrat(14, grey36, FontWeight.w600),
                            ),
                            4.verticalSpace,
                            Text(
                              l10n.selectDriverFromMap,
                              style:
                                  montserrat(12, grey5E5E5E, FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  32.verticalSpace,

                  // Map container
                  Container(
                    height: isMapExpanded.value ? 300.h : 200.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Stack(
                        children: [
                          // Google Map
                          if (currentPosition.value != null)
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  currentPosition.value!.latitude,
                                  currentPosition.value!.longitude,
                                ),
                                zoom: 14.0,
                              ),
                              markers: markers.value,
                              onMapCreated: (GoogleMapController controller) {
                                mapController.value = controller;
                                updateMarkers();
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              mapType: MapType.normal,
                              zoomControlsEnabled: false,
                              onTap: (LatLng position) {
                                // Handle map tap if needed
                              },
                            )
                          else
                            // Loading state
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: accentPurple,
                                    ),
                                    8.verticalSpace,
                                    Text(
                                      'Loading map...',
                                      style: montserrat(
                                          12, grey5E5E5E, FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // Expand/Collapse button
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: GestureDetector(
                              onTap: () =>
                                  isMapExpanded.value = !isMapExpanded.value,
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isMapExpanded.value
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  size: 20.sp,
                                  color: accentPurple,
                                ),
                              ),
                            ),
                          ),
                          // My location button
                          Positioned(
                            bottom: 8.h,
                            right: 8.w,
                            child: GestureDetector(
                              onTap: () async {
                                if (currentPosition.value != null &&
                                    mapController.value != null) {
                                  await mapController.value!.animateCamera(
                                    CameraUpdate.newLatLng(
                                      LatLng(
                                        currentPosition.value!.latitude,
                                        currentPosition.value!.longitude,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  size: 20.sp,
                                  color: accentPurple,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.verticalSpace,

                  // Search radius slider section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.search,
                            style: montserrat(14, grey36, FontWeight.w600),
                          ),
                          Text(
                            '${searchDistance.value.toStringAsFixed(1)} ${l10n.kmUnit}',
                            style:
                                montserrat(14, accentPurple, FontWeight.w600),
                          ),
                        ],
                      ),
                      8.verticalSpace,
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: accentPurple,
                          inactiveTrackColor: accentPurple.withOpacity(0.3),
                          thumbColor: accentPurple,
                          overlayColor: accentPurple.withOpacity(0.2),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8.r),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 16.r),
                        ),
                        child: Slider(
                          value: searchDistance.value,
                          min: 1.0,
                          max: 2000.0,
                          divisions: 199,
                          onChanged: (value) {
                            searchDistance.value = value;
                            // Update the provider's search radius
                            bookingNotifier.updateSearchRadius(value);
                            // Update markers with new filtered drivers
                            updateMarkers();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1.0 ${l10n.kmUnit}',
                            style: montserrat(12, grey5E5E5E, FontWeight.w400),
                          ),
                          Text(
                            '2000 ${l10n.kmUnit.toUpperCase()}',
                            style: montserrat(12, grey5E5E5E, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // Available drivers section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionHeader(
                        title: l10n.availableDrivers,
                        isDark: true,
                      ),
                      Text(
                        '${filteredDrivers.length.toString().padLeft(2, '0')} ${l10n.results}',
                        style: montserrat(14, grey5E5E5E, FontWeight.w400),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // Drivers list (now as column children instead of ListView)
                  ...filteredDrivers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final driver = entry.value;
                    final isSelected =
                        bookingState.selectedDriver?.email == driver.email;
                    final driverPos = getDriverPosition(driver);
                    final distance = currentPosition.value != null
                        ? calculateDistance(
                            currentPosition.value!.latitude,
                            currentPosition.value!.longitude,
                            driverPos.latitude,
                            driverPos.longitude,
                          )
                        : 0.0;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            bookingNotifier.selectDriver(driver);
                            updateMarkers(); // Update map markers
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accentPurple.withOpacity(0.1)
                                  : Color(0xffF3F8FE),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected ? accentPurple : whiteColor,
                                width: isSelected ? 1 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Driver photo
                                CircularProfileImage(
                                  imageUrl: driver.profilePicture ?? '',
                                  radius: 20,
                                ),

                                16.horizontalSpace,

                                // Driver info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.name,
                                        style: montserrat(
                                            14, grey36, FontWeight.w500),
                                      ),
                                      4.verticalSpace,
                                      Row(
                                        children: [
                                          Text(
                                            driver.role ?? 'Driver',
                                            style: montserrat(12, grey5E5E5E,
                                                FontWeight.w400),
                                          ),
                                          8.horizontalSpace,
                                          Icon(
                                            Icons.star,
                                            color: yellowE2A640,
                                            size: 14.sp,
                                          ),
                                          2.horizontalSpace,
                                          Text(
                                            (4.0 +
                                                    Random(driver
                                                            .email.hashCode)
                                                        .nextDouble())
                                                .toStringAsFixed(
                                                    1), // Random rating between 4.0-5.0
                                            style: montserrat(12, grey5E5E5E,
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Distance
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${distance.toStringAsFixed(1)} ${l10n.kmUnit}',
                                      style: montserrat(
                                          16, grey36, FontWeight.w600),
                                    ),
                                    if (isSelected)
                                      Container(
                                        margin: EdgeInsets.only(top: 4.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accentPurple,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          'Selected',
                                          style: montserrat(10, Colors.white,
                                              FontWeight.w500),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index < filteredDrivers.length - 1)
                          12.verticalSpace,
                      ],
                    );
                  }),

                  16.verticalSpace,
                ],
              ),
            ))),
            // Continue button
            Padding(
              padding: EdgeInsets.all(20.w),
              child: NormalCustomButton(
                label: l10n.continueButton,
                syncCallback: () {
                  // Validate driver selection
                  if (bookingState.selectedDriver == null) {
                    showErrorFlushBar(
                        message: 'Please select a driver to continue',
                        context: context);
                    return;
                  }

                  // Move to next step
                  bookingNotifier.nextStep();

                  // Navigate to next screen
                  context.push('/additional_booking_details',
                      extra: serviceType);
                },
              ),
            ),
          ],
        ));
  }
}
