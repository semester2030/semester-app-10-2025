import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:semester_student_ride_app/providers/all_drivers_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

// Helper function to create custom marker icon
Future<BitmapDescriptor> createCustomMarkerIcon(
    String assetPath, int size) async {
  try {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: size,
      targetHeight: size,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData != null) {
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    }
  } catch (e) {
    log('Error creating custom marker icon: $e');
  }

  return BitmapDescriptor.defaultMarker;
}

class RidesMap extends HookConsumerWidget {
  const RidesMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State management
    final mapController = ref.watch(rideMapControllerProvider);
    final drivers = ref.watch(allDriversProvider);
    final focusedIndex = ref.watch(focusedBookingIndexProvider);

    // Local state
    final carouselController =
        useState<CarouselSliderController>(CarouselSliderController());
    final currentCarouselPage = useState<int>(0);
    final markers = useState<Set<Marker>>({});
    final carPositions = useState<Map<String, LatLng>>({});

    // Create markers for drivers
    useEffect(() {
      drivers.when(
        data: (driversList) async {
          final Set<Marker> newMarkers = {};
          final Map<String, LatLng> newCarPositions = {};

          // Add markers for all drivers with currentLocation
          for (int i = 0; i < driversList.length; i++) {
            final driver = driversList[i];

            // Skip if driver doesn't have current location
            if (driver.currentLocation == null) continue;

            final currentLocation = driver.currentLocation!;
            final latitude = currentLocation['latitude'] as double?;
            final longitude = currentLocation['longitude'] as double?;

            if (latitude == null || longitude == null) continue;

            final driverLocation = LatLng(latitude, longitude);

            // Store car position for overlay containers
            newCarPositions['driver_${driver.name}'] = driverLocation;

            // Create car marker icon
            BitmapDescriptor carIcon;
            try {
              carIcon =
                  await createCustomMarkerIcon('assets/images/car.png', 170);
            } catch (e) {
              log('Error loading car icon: $e');
              carIcon = BitmapDescriptor.defaultMarker;
            }

            // Add driver location marker
            newMarkers.add(
              Marker(
                markerId: MarkerId('driver_${driver.name}_$i'),
                position: driverLocation,
                icon: carIcon,
                onTap: () {
                  // Update focused index and animate carousel
                  ref.read(focusedBookingIndexProvider.notifier).state = i;
                  carouselController.value.animateToPage(i);
                  currentCarouselPage.value = i;

                  // Move camera to driver location
                  if (mapController != null) {
                    mapController.animateCamera(
                      CameraUpdate.newLatLngZoom(driverLocation, 15),
                    );
                  }
                },

                // Enable InfoWindow to show driver info
                infoWindow: InfoWindow(
                  title: driver.name,
                  snippet:
                      '${driver.fullVehicleName} • ${driver.isOnline ? "Online" : "Offline"}',
                  anchor: const Offset(0.5, 1.0),
                ),
              ),
            );
          }

          markers.value = newMarkers;
          carPositions.value = newCarPositions;
          log('Created ${newMarkers.length} markers for ${driversList.length} drivers');
        },
        loading: () {
          // Keep existing markers while loading
        },
        error: (error, stack) {
          log('Error loading drivers for markers: $error');
        },
      );

      return null;
    }, [drivers]);

    // Handle carousel page changes and move camera
    useEffect(() {
      drivers.whenData((driversList) {
        if (focusedIndex >= 0 && focusedIndex < driversList.length) {
          final driver = driversList[focusedIndex];

          // Get driver location
          if (driver.currentLocation != null) {
            final currentLocation = driver.currentLocation!;
            final latitude = currentLocation['latitude'] as double?;
            final longitude = currentLocation['longitude'] as double?;

            if (latitude != null &&
                longitude != null &&
                mapController != null) {
              final driverLocation = LatLng(latitude, longitude);
              mapController.animateCamera(
                CameraUpdate.newLatLngZoom(driverLocation, 15),
              );
            }
          }
        }
      });
      return null;
    }, [focusedIndex, drivers]);

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              ref.read(rideMapControllerProvider.notifier).state = controller;

              // Apply custom map style
              try {
                final mapStyle = await DefaultAssetBundle.of(context)
                    .loadString('assets/map_style.json');
                await controller.setMapStyle(mapStyle);
              } catch (e) {
                log('Error loading map style: $e');
              }

              // Set initial camera position to show first driver if available
              drivers.whenData((driversList) {
                if (driversList.isNotEmpty) {
                  final firstDriver = driversList.first;
                  if (firstDriver.currentLocation != null) {
                    final currentLocation = firstDriver.currentLocation!;
                    final latitude = currentLocation['latitude'] as double?;
                    final longitude = currentLocation['longitude'] as double?;

                    if (latitude != null && longitude != null) {
                      final driverLocation = LatLng(latitude, longitude);
                      controller.animateCamera(
                        CameraUpdate.newLatLngZoom(driverLocation, 12),
                      );
                    }
                  }
                }
              });
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(25.2048, 55.2708), // Dubai coordinates
              zoom: 12,
            ),
            markers: markers.value,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            buildingsEnabled: true,
            trafficEnabled: false,
          ),

          // Bottom Carousel with Booking Cards
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: drivers.when(
              data: (driversList) => SizedBox(
                height: 320.h,
                child: CarouselSlider(
                  carouselController: carouselController.value,
                  options: CarouselOptions(
                    height: 300.h,
                    viewportFraction: 0.8,
                    initialPage: currentCarouselPage.value,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enlargeFactor: 0,
                    onPageChanged: (index, reason) {
                      // Update current page
                      currentCarouselPage.value = index;

                      // Update focused index to trigger camera movement
                      ref.read(focusedBookingIndexProvider.notifier).state =
                          index;

                      // Move camera to the new driver location
                      if (mapController != null) {
                        final driver = driversList[index];
                        if (driver.currentLocation != null) {
                          final currentLocation = driver.currentLocation!;
                          final latitude =
                              currentLocation['latitude'] as double?;
                          final longitude =
                              currentLocation['longitude'] as double?;

                          if (latitude != null && longitude != null) {
                            final driverLocation = LatLng(latitude, longitude);
                            mapController.animateCamera(
                              CameraUpdate.newLatLngZoom(driverLocation, 15),
                            );
                          }
                        }
                      }
                    },
                  ),
                  items: driversList.map((driver) {
                    // Create a temporary booking object to keep BookingCard unchanged
                    // final tempBooking = BookingModel(
                    //   id: driver.name,
                    //   driverName: driver.name,
                    //   driverPhone: driver.phoneNumber,
                    //   driverPhoto: driver.profilePicture ?? '',
                    //   vehicleType: 'Car',
                    //   vehicleModel: driver.vehicleModel ?? 'Vehicle',
                    //   licensePlate: '',
                    //   pickupLocation: '',
                    //   destination: '',
                    //   pickupCoordinates: driver.currentLocation != null
                    //       ? LatLng(
                    //           driver.currentLocation!['latitude'] as double? ??
                    //               0.0,
                    //           driver.currentLocation!['longitude'] as double? ??
                    //               0.0,
                    //         )
                    //       : const LatLng(0, 0),
                    //   destinationCoordinates: const LatLng(0, 0),
                    //   driverLocation: driver.currentLocation != null
                    //       ? LatLng(
                    //           driver.currentLocation!['latitude'] as double? ??
                    //               0.0,
                    //           driver.currentLocation!['longitude'] as double? ??
                    //               0.0,
                    //         )
                    //       : const LatLng(0, 0),
                    //   pickupTime: DateTime.now(),
                    //   fare: 0.0,
                    //   status: 'pending',
                    //   category: 'Daily Transportation',
                    //   rating: 4.5, // Default rating
                    // );

                    return DriverCard(
                      driver: driver,
                      onTap: () {
                        // Handle driver card tap - you can navigate to driver details
                        // context.push('/driver_details', extra: driver);
                      },
                    );
                  }).toList(),
                ),
              ),
              loading: () => SizedBox(
                height: 320.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => SizedBox(
                height: 320.h,
                child: Center(
                  child: Text('Error loading drivers: $error'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
