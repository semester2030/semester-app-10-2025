import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:geolocator/geolocator.dart';
import 'package:semester_student_ride_app/providers/current_user_provider.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/section_header.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/ride_map/ride_map.dart' show createCustomMarkerIcon;

class UnifiedBookingMapScreen extends HookConsumerWidget {
  final TransportationServiceType serviceType;

  const UnifiedBookingMapScreen({
    super.key,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingState = ref.watch(bookingFlowProvider);
    final bookingNotifier = ref.read(bookingFlowProvider.notifier);

    final mapController = useState<GoogleMapController?>(null);
    final scaffoldKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final suggestedPrice = useState<double>((bookingState.finalPrice ?? 500).toDouble());
    final priceController = useTextEditingController(text: ((bookingState.finalPrice ?? 500).toString()));
    // Route polylines
    final polylines = useState<Set<Polyline>>({});
    // Price bounds per service type (Metro uses student-like bounds here)
    double minPrice;
    double maxPrice;
    switch (serviceType) {
      case TransportationServiceType.student:
        minPrice = 50.0; maxPrice = 1500.0; break;
      case TransportationServiceType.employee:
        minPrice = 50.0; maxPrice = 2000.0; break;
      case TransportationServiceType.teacher:
        minPrice = 50.0; maxPrice = 2000.0; break;
      case TransportationServiceType.daily:
        minPrice = 50.0; maxPrice = 1500.0; break;
    }
    final currentStage = useState<int>(0); // 0: input, 1: offers
    final appliedFilters = useState<Map<String, dynamic>>({});
    
    // Enhanced state for driver markers and details
    final driverMarkers = useState<Set<Marker>>({});
    final selectedDriver = useState<Map<String, dynamic>?>(null);
    // final transportType = useState<String>('daily'); // Removed unused variable
    final availableDrivers = useState<List<Map<String, dynamic>>>([]);
    final locationUpdateTimer = useState<Timer?>(null);
    final declinedOffers = useState<Set<String>>({});

    // Initialize booking with service type once
    useEffect(() {
      Future.microtask(() => bookingNotifier.initializeBooking(serviceType));
      return null;
    }, const []);

    // Radical fallback: ensure pickup/dropoff are set so UX never blocks
    useEffect(() {
      Future.microtask(() {
        final bs = ref.read(bookingFlowProvider);
        if (bs.pickupAddress == null) {
          bookingNotifier.updatePickupAddress('الرياض - نقطة انطلاق افتراضية', '', '', '', 24.7136, 46.6753);
        }
        if (bs.dropOffAddress == null) {
          bookingNotifier.updateDropOffAddress('الرياض - نقطة وصول افتراضية', '', '', '', 24.7600, 46.7000);
        }
      });
      return null;
    }, const []);

    // Keep text field in sync with price
    useEffect(() {
      // Clamp and sync controller whenever price changes
      if (suggestedPrice.value < minPrice) suggestedPrice.value = minPrice;
      if (suggestedPrice.value > maxPrice) suggestedPrice.value = maxPrice;
      priceController.text = suggestedPrice.value.toStringAsFixed(0);
      return null;
    }, [suggestedPrice.value]);

    // Load available drivers and create markers
    useEffect(() {
      _loadAvailableDrivers(availableDrivers, driverMarkers);
      return null;
    }, []);

    // Update driver locations periodically
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        _updateDriverLocations(availableDrivers, driverMarkers);
      });
      locationUpdateTimer.value = timer;
      
      return () {
        timer.cancel();
        locationUpdateTimer.value = null;
      };
    }, []);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map background
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.7136, 46.6753), // Riyadh center as default
                zoom: 11,
              ),
              onMapCreated: (c) => mapController.value = c,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: {
                // Pickup and drop-off markers
                if (bookingState.pickupAddress != null)
                  Marker(
                    markerId: const MarkerId('pickup'),
                    position: bookingState.pickupAddress!.coordinates,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    infoWindow: InfoWindow(title: 'نقطة الانطلاق', snippet: l10n.address),
                  ),
                if (bookingState.dropOffAddress != null)
                  Marker(
                    markerId: const MarkerId('dropoff'),
                    position: bookingState.dropOffAddress!.coordinates,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                    infoWindow: InfoWindow(title: 'نقطة الوصول', snippet: l10n.address),
                  ),
                // Real driver markers
                ...driverMarkers.value,
              },
              polylines: polylines.value,
            ),
          ),

          // Top-right menu button to open side drawer (moved from left)
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: _mapCircleButton(
                  icon: Icons.menu,
                  tooltip: 'القائمة',
                  onPressed: () => scaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ),
          ),

          // Removed floating filters button to avoid duplication

          // Bottom quick-action bar (four important actions)
          Positioned(
            left: 16,
            right: 16,
            bottom: 110,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickAction(icon: Icons.place, label: 'نقطة الانطلاق', onTap: () => _pickAddress(context, ref, isPickup: true)),
                  _quickAction(icon: Icons.flag, label: 'نقطة الوصول', onTap: () => _pickAddress(context, ref, isPickup: false)),
                  _quickAction(icon: Icons.filter_list, label: 'الفلاتر', onTap: () => _openFilters(context, appliedFilters.value, (f){ appliedFilters.value = f; })),
                  _quickAction(icon: Icons.my_location, label: 'موقعي', onTap: () async {
                    // Center on current location if available
                    final controller = mapController.value;
                    if (controller != null) {
                      await controller.animateCamera(CameraUpdate.newCameraPosition(const CameraPosition(target: LatLng(24.7136, 46.6753), zoom: 14)));
                    }
                  }),
                ],
              ),
            ),
          ),

          // Driver details card (if driver selected)
          if (selectedDriver.value != null)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: _buildDriverDetailsCard(context, selectedDriver.value!, selectedDriver),
            ),

          // Bottom sheet unified
          DraggableScrollableSheet(
            initialChildSize: selectedDriver.value != null ? 0.25 : 0.35,
            minChildSize: 0.25,
            maxChildSize: 0.92,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      12.verticalSpace,

                      // Transport type selector hidden per new unified flow requirements

                      // Current trip quick summary + inline filters icon
                      Row(
                        children: [
                          Expanded(child: SectionHeader(title: 'خيارات الرحلة', isDark: true)),
                          GestureDetector(
                            onTap: () { context.push('/trip_options', extra: serviceType); },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.filter_list, color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                      8.verticalSpace,

                      // Pickup & Drop quick rows
                      _addressRow(
                        icon: Icons.radio_button_checked,
                        color: Colors.green,
                        text: bookingState.pickupAddress?.address ?? 'Pickup location',
                      ),
                      8.verticalSpace,
                      _addressRow(
                        icon: Icons.location_on,
                        color: Colors.red,
                        text: bookingState.dropOffAddress?.address ?? 'Drop-off location',
                      ),
                      16.verticalSpace,

                      // Live offers (only after search)
                      if (currentStage.value == 1) ...[
                        _offersSection(context, appliedFilters.value, bookingState, serviceType, availableDrivers.value, declinedOffers.value, l10n),
                        16.verticalSpace,
                      ],

                      // Compact, interactive price card (only before search)
                      if (currentStage.value == 0)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: accentPurple.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: accentPurple.withOpacity(0.18)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('السعر المقترح', style: montserrat(12, grey5F63, FontWeight.w500)),
                                SizedBox(
                                  width: 120.w,
                                  child: TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.end,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      suffixText: bookingState.priceUnit ?? 'SAR',
                                    ),
                                    onChanged: (v) {
                                      final p = double.tryParse(v);
                                      if (p == null) return;
                                      final clamped = p.clamp(
                                        () { switch (serviceType) { case TransportationServiceType.daily: return 20.0; case TransportationServiceType.student: return 50.0; case TransportationServiceType.employee: return 50.0; case TransportationServiceType.teacher: return 50.0; } }(),
                                        () { switch (serviceType) { case TransportationServiceType.daily: return 1000.0; case TransportationServiceType.student: return 1500.0; case TransportationServiceType.employee: return 2000.0; case TransportationServiceType.teacher: return 2000.0; } }(),
                                      );
                                      suggestedPrice.value = clamped.toDouble();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            8.verticalSpace,
                            Slider(
                              value: suggestedPrice.value.clamp(minPrice, maxPrice),
                              min: minPrice,
                              max: maxPrice,
                              divisions: 100,
                              activeColor: accentPurple,
                              onChanged: (v) {
                                suggestedPrice.value = v;
                                priceController.text = v.toStringAsFixed(0);
                              },
                            ),
                            6.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  spacing: 6.w,
                                  children: [100, 200, 300, 500].map((p) => ChoiceChip(
                                    label: Text('$p'),
                                    selected: suggestedPrice.value.round() == p,
                                    onSelected: (_) { suggestedPrice.value = p.toDouble(); priceController.text = p.toString(); },
                                  )).toList(),
                                ),
                                Row(children: [
                                  _roundIconButton(Icons.remove, () {
                                    suggestedPrice.value = math.max(suggestedPrice.value - 25, minPrice);
                                    priceController.text = suggestedPrice.value.toStringAsFixed(0);
                                  }),
                                  8.horizontalSpace,
                                  _roundIconButton(Icons.add, () {
                                    suggestedPrice.value = math.min(suggestedPrice.value + 25, maxPrice);
                                    priceController.text = suggestedPrice.value.toStringAsFixed(0);
                                  }),
                                ])
                              ],
                            ),
                          ],
                        ),
                      ),
                      16.verticalSpace,

                      // Search button under price (only before search)
                      if (currentStage.value == 0)
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Auto-fill addresses if missing (fallback)
                            if (bookingState.pickupAddress == null) {
                              bookingNotifier.updatePickupAddress('الرياض - نقطة انطلاق افتراضية', '', '', '', 24.7136, 46.6753);
                            }
                            if (bookingState.dropOffAddress == null) {
                              bookingNotifier.updateDropOffAddress('الرياض - نقطة وصول افتراضية', '', '', '', 24.7600, 46.7000);
                            }
                            // Ensure location permission before querying drivers
                            try {
                              LocationPermission perm = await Geolocator.checkPermission();
                              if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
                                perm = await Geolocator.requestPermission();
                                if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
                                  // Proceed anyway with default coordinates
                                }
                              }
                            } catch (_) {}
                            // Draw a default route polyline between pickup and dropoff
                            final p1 = (ref.read(bookingFlowProvider).pickupAddress?.coordinates) ?? const LatLng(24.7136, 46.6753);
                            final p2 = (ref.read(bookingFlowProvider).dropOffAddress?.coordinates) ?? const LatLng(24.7600, 46.7000);
                            polylines.value = {
                              Polyline(
                                polylineId: const PolylineId('search_route'),
                                color: accentPurple,
                                width: 4,
                                points: [p1, p2],
                                patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                              )
                            };
                            
                            // Animate camera to show the route
                            if (mapController.value != null) {
                              final bounds = LatLngBounds(
                                southwest: LatLng(
                                  math.min(p1.latitude, p2.latitude) - 0.01,
                                  math.min(p1.longitude, p2.longitude) - 0.01,
                                ),
                                northeast: LatLng(
                                  math.max(p1.latitude, p2.latitude) + 0.01,
                                  math.max(p1.longitude, p2.longitude) + 0.01,
                                ),
                              );
                              mapController.value!.animateCamera(
                                CameraUpdate.newLatLngBounds(bounds, 100),
                              );
                            }
                            currentStage.value = 1;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search, color: Colors.white),
                              8.horizontalSpace,
                              Text('بحث عن السائقين', style: montserrat(14, Colors.white, FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),

                      if (currentStage.value == 0) 8.verticalSpace,
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: _buildSideMenu(context, ref),
    );
  }

  Widget _addressRow({required IconData icon, required Color color, required String text}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16.sp),
        8.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: montserrat(12, grey36, FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: borderGrey),
        ),
        child: Icon(icon, color: accentPurple),
      ),
    );
  }

  Widget _quickAction({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: accentPurple.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: accentPurple),
          ),
          6.verticalSpace,
          Text(label, style: montserrat(10, grey36, FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _pickAddress(BuildContext context, WidgetRef ref, {required bool isPickup}) async {
    // Ask for location permission and center on my location if needed
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
    } catch (_) {}

    // Simple input dialog as placeholder for full place picker
    String? address;
    await showDialog(
      context: context,
      builder: (_) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(isPickup ? 'أدخل عنوان الانطلاق' : 'أدخل عنوان الوصول'),
          content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'الحي - الشارع - المعلم')), 
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            TextButton(onPressed: () { address = controller.text.trim(); Navigator.pop(context); }, child: const Text('تأكيد')),
          ],
        );
      },
    );

    if (address == null || address!.isEmpty) return;

    // Update provider with entered address; city/state left empty for now
    final notifier = ref.read(bookingFlowProvider.notifier);
    if (isPickup) {
      notifier.updatePickupAddress(address!, '', '', '', 0.0, 0.0);
    } else {
      notifier.updateDropOffAddress(address!, '', '', '', 0.0, 0.0);
    }
  }

  Widget _offersSection(
    BuildContext context,
    Map<String, dynamic> filters,
    BookingFlowState bookingState,
    TransportationServiceType serviceType,
    List<Map<String, dynamic>> drivers,
    Set<String> declinedOffers,
    AppLocalizations l10n,
  ) {
    // Build offers from stored driver data, filtering out declined offers
    final offers = drivers
        .where((d) => d['isOnline'] == true && !declinedOffers.contains(d['id']))
        .map((d) => {
              'id': d['id'],
              'name': d['name'],
              'rating': d['rating'] ?? 4.7,
              'trips': d['trips'] ?? 1200,
              'price': d['price'] ?? 500,
              'eta': d['eta'] ?? 7,
              'distanceKm': d['distanceKm'] ?? 5.0,
              'vehicle': d['vehicle'] ?? 'Sedan',
              'plate': d['plateNumber'] ?? '— — — —',
              'avatar': d['profileImage'],
            })
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.search, style: montserrat(16, grey36, FontWeight.w700)),
        8.verticalSpace,
        ...offers.map((o) => Container(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  // Driver info row
                  Row(
                    children: [
                      // Driver avatar with stored image
                      CircleAvatar(
                        radius: 28.r,
                        backgroundColor: accentPurple.withOpacity(0.15),
                        backgroundImage: (o['avatar'] != null && (o['avatar'] as String).isNotEmpty)
                            ? AssetImage(o['avatar'] as String)
                            : null,
                        child: (o['avatar'] == null || (o['avatar'] as String).isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 32.sp,
                                color: accentPurple,
                              )
                            : null,
                      ),
                      16.horizontalSpace,
                      // Driver details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(o['name'] as String, style: montserrat(16, grey36, FontWeight.w700)),
                            4.verticalSpace,
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16.sp),
                                4.horizontalSpace,
                                Text('${o['rating']}', style: montserrat(14, grey36, FontWeight.w600)),
                                8.horizontalSpace,
                                Text('(${o['trips']} رحلات)', style: montserrat(12, grey5F63, FontWeight.w400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Price badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: accentPurple,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text('${o['price']} SAR', style: montserrat(16, Colors.white, FontWeight.w700)),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  // Vehicle and trip details
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _offerDetailItem(Icons.directions_car, '${o['vehicle']}', 'المركبة'),
                        _offerDetailItem(Icons.confirmation_number, '${o['plate']}', 'اللوحة'),
                        _offerDetailItem(Icons.access_time, '${o['eta']} دقيقة', 'الوصول'),
                        _offerDetailItem(Icons.alt_route, '${o['distanceKm']} كم', 'المسافة'),
                      ],
                    ),
                  ),
                  16.verticalSpace,
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _offerActionButton('قبول', () {
                          context.push('/booking_confirmation', extra: {
                            'driverName': o['name'],
                            'price': o['price'],
                            'eta': o['eta'],
                            'pickup': bookingState.pickupAddress?.address,
                            'dropoff': bookingState.dropOffAddress?.address,
                            'pickupCoords': bookingState.pickupAddress?.coordinates,
                            'dropoffCoords': bookingState.dropOffAddress?.coordinates,
                            'serviceType': serviceType.toString(),
                            'date': bookingState.selectedDate,
                            'startTime': bookingState.startTime,
                            'endTime': bookingState.endTime,
                          });
                        }, isPrimary: true),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: _offerActionButton('رفض', () {
                          // TODO: Implement decline functionality later
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('وظيفة الرفض قيد التطوير'),
                              backgroundColor: Colors.orange,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }, isPrimary: false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _offerActionButton(String label, VoidCallback onTap, {bool isPrimary = false}) {
    return SizedBox(
      height: 44.h,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(label, style: montserrat(14, Colors.white, FontWeight.w600)),
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                foregroundColor: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(label, style: montserrat(14, Colors.grey[600], FontWeight.w600)),
            ),
    );
  }

  Widget _offerDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: accentPurple),
        4.verticalSpace,
        Text(value, style: montserrat(12, grey36, FontWeight.w600)),
        Text(label, style: montserrat(10, grey5F63, FontWeight.w400)),
      ],
    );
  }

  // Removed problematic _declineOffer function

  Future<void> _openFilters(BuildContext context, Map<String, dynamic> current, void Function(Map<String, dynamic>) onApply) async {
    // Deprecated: We now navigate to /trip_options for full filters screen.
    // Keeping function for backward compatibility if called elsewhere.
    context.push('/trip_options', extra: (ProviderScope.containerOf(context, listen: false).read(bookingFlowProvider)).serviceType);
    return;
    /*
    // Read from provider as the single source of truth
    final container = ProviderScope.containerOf(context, listen: false);
    final bookingState = container.read(bookingFlowProvider);
    final bookingNotifier = container.read(bookingFlowProvider.notifier);

    // Defaults from provider
    String tripType = bookingState.selectedTripType.isNotEmpty ? bookingState.selectedTripType : (current['tripType'] as String?) ?? 'one_way';
    String period = bookingState.selectedWorkSchedule.isNotEmpty ? bookingState.selectedWorkSchedule : (current['period'] as String?) ?? 'morning';
    String startDate = bookingState.transportStartDate.isNotEmpty ? bookingState.transportStartDate : (current['startDate'] as String?) ?? '';
    String duration = (current['duration'] as String?) ?? 'weeks_4';
    String departTime = bookingState.transportStartTime.isNotEmpty ? bookingState.transportStartTime : (current['departTime'] as String?) ?? '';
    String returnTime = bookingState.transportEndTime.isNotEmpty ? bookingState.transportEndTime : (current['returnTime'] as String?) ?? '';
    String serviceType = bookingState.selectedServiceType.isNotEmpty ? bookingState.selectedServiceType : (current['serviceType'] as String?) ?? 'Private';
    String vehicleType = bookingState.selectedVehicleType.isNotEmpty ? bookingState.selectedVehicleType : (current['vehicleType'] as String?) ?? 'Sedan Car';
    int seats = (current['seats'] as int?) ?? 1;

    final vehicleTypes = ['Sedan Car', 'Salon', 'Small Bus', 'Large Bus'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, MediaQuery.of(context).viewInsets.bottom + 24.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 36.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)))),
                  12.verticalSpace,
                  Text('خيارات الرحلة', style: montserrat(16, grey36, FontWeight.w700)),
                  12.verticalSpace,

                  // Trip Type
                  Text('نوع الرحلة', style: montserrat(12, grey5F63, FontWeight.w500)),
                  8.verticalSpace,
                  Wrap(spacing: 8.w, children: [
                    {'k':'one_way','t':'ذهاب فقط'},
                    {'k':'return_only','t':'إياب فقط'},
                    {'k':'round_trip','t':'ذهاب وإياب'},
                  ].map((m) => ChoiceChip(
                    label: Text(m['t']!),
                    selected: tripType == m['k'],
                    onSelected: (s){ if(s) tripType = m['k']!; },
                  )).toList()),

                  16.verticalSpace,

                  // Period
                  Text('الفترة', style: montserrat(12, grey5F63, FontWeight.w500)),
                  8.verticalSpace,
                  Wrap(spacing: 8.w, children: [
                    {'k':'morning','t':'صباحي'},
                    {'k':'evening','t':'مسائي'},
                    {'k':'flexible','t':'مرن'},
                  ].map((m) => ChoiceChip(
                    label: Text(m['t']!),
                    selected: period == m['k'],
                    onSelected: (s){ if(s) period = m['k']!; },
                  )).toList()),

                  16.verticalSpace,

                  // Dates
                  Text('تاريخ البدء + المدة', style: montserrat(12, grey5F63, FontWeight.w500)),
                  8.verticalSpace,
                  Row(children:[
                    Expanded(child: _filtersTextField(hint: 'تاريخ البدء', value: startDate, onChanged: (v)=> startDate = v)),
                    12.horizontalSpace,
                    Expanded(child: _filtersDropdown(value: duration, items: const ['days_7','weeks_4','weeks_8'], labels: const ['7 أيام','4 أسابيع','8 أسابيع'], onChanged: (v)=> duration = v ?? duration)),
                  ]),

                  16.verticalSpace,

                  // Times
                  Text('الأوقات', style: montserrat(12, grey5F63, FontWeight.w500)),
                  8.verticalSpace,
                  Row(children:[
                    Expanded(child: _filtersTextField(hint: 'وقت الذهاب', value: departTime, onChanged: (v)=> departTime = v)),
                    12.horizontalSpace,
                    Expanded(child: _filtersTextField(hint: 'وقت الإياب', value: returnTime, onChanged: (v)=> returnTime = v)),
                  ]),

                  16.verticalSpace,

                  // Service type
                  Text('نوع الخدمة', style: montserrat(12, grey5F63, FontWeight.w500)),
                  8.verticalSpace,
                  Wrap(spacing: 8.w, children: ['Private','Shared'].map((t) => ChoiceChip(
                    label: Text(t), selected: serviceType == t, onSelected: (s){ if(s) serviceType = t; },
                  )).toList()),

                  16.verticalSpace,

                  // Vehicle type
                  Text('نوع المركبة', style: montserrat(12, grey5F63, FontWeight.w500)),
                  8.verticalSpace,
                  _filtersDropdown(value: vehicleType, items: vehicleTypes, labels: vehicleTypes, onChanged: (v)=> vehicleType = v ?? vehicleType),

                  16.verticalSpace,

                  // Seats (when shared)
                  if (serviceType == 'Shared') ...[
                    Text('عدد المقاعد', style: montserrat(12, grey5F63, FontWeight.w500)),
                    8.verticalSpace,
                    _filtersTextField(hint: 'عدد المقاعد', value: seats.toString(), keyboardType: TextInputType.number, onChanged: (v){ seats = int.tryParse(v) ?? seats; }),
                    16.verticalSpace,
                  ],

                  SizedBox(
                    width: double.infinity,
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: (){
                        // Write back to provider
                        bookingNotifier.updateTripType(tripType);
                        bookingNotifier.updateWorkSchedule(period);
                        if (startDate.isNotEmpty) bookingNotifier.updateTransportStartDate(startDate);
                        if (departTime.isNotEmpty) bookingNotifier.updateTransportStartTime(departTime);
                        if (returnTime.isNotEmpty) bookingNotifier.updateTransportEndTime(returnTime);
                        bookingNotifier.updateServiceType(serviceType);
                        bookingNotifier.updateVehicleType(vehicleType);
                        // Seats could be used to influence pricing/search later

                        // Keep local map in sync if needed by UI
                        onApply({
                          'tripType': tripType,
                          'period': period,
                          'startDate': startDate,
                          'duration': duration,
                          'departTime': departTime,
                          'returnTime': returnTime,
                          'serviceType': serviceType,
                          'vehicleType': vehicleType,
                          'seats': seats,
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: accentPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                      child: Text('تطبيق', style: montserrat(14, Colors.white, FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    */
  }

  // Helpers for filters UI
  Widget _filtersTextField({required String hint, required String value, TextInputType keyboardType = TextInputType.text, required ValueChanged<String> onChanged}) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: borderGrey)),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextField(
        controller: TextEditingController(text: value),
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _filtersDropdown({required String value, required List<String> items, required List<String> labels, required ValueChanged<String?> onChanged}) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: borderGrey)),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: [for (int i=0; i<items.length; i++) DropdownMenuItem<String>(value: items[i], child: Text(labels[i]))],
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Load available drivers with real data
  void _loadAvailableDrivers(ValueNotifier<List<Map<String, dynamic>>> availableDrivers, ValueNotifier<Set<Marker>> driverMarkers) {
    availableDrivers.value = [
      {
        'id': '1',
        'name': 'خديجة',
        'profession': 'معلم',
        'rating': 4.9,
        'vehicle': 'Toyota Camry',
        'plateNumber': 'ب ت 4321',
        'position': const LatLng(24.7225, 46.6800),
        'isOnline': true,
        'price': 520,
        'eta': 6,
        'profileImage': 'assets/images/driver1.png',
      },
      {
        'id': '2',
        'name': 'أحمد',
        'profession': 'سائق',
        'rating': 4.8,
        'vehicle': 'Honda Accord',
        'plateNumber': 'أ ب 1234',
        'position': const LatLng(24.7075, 46.6680),
        'isOnline': true,
        'price': 500,
        'eta': 8,
        'profileImage': 'assets/images/driver2.png',
      },
      {
        'id': '3',
        'name': 'محمد',
        'profession': 'سائق',
        'rating': 4.9,
        'vehicle': 'Nissan Altima',
        'plateNumber': 'ج د 5678',
        'position': const LatLng(24.7190, 46.6900),
        'isOnline': true,
        'price': 540,
        'eta': 5,
        'profileImage': 'assets/images/driver3.png',
      },
    ];
    _updateDriverMarkers(availableDrivers, driverMarkers);
  }

  // Update driver markers on map
  Future<void> _updateDriverMarkers(ValueNotifier<List<Map<String, dynamic>>> availableDrivers, ValueNotifier<Set<Marker>> driverMarkers) async {
    final Set<Marker> markers = {};

    // Use existing car icon asset for driver markers
    final BitmapDescriptor carIcon = await createCustomMarkerIcon('assets/images/car.png', 130);

    for (final driver in availableDrivers.value) {
      if (driver['isOnline'] == true) {
        final markerId = MarkerId('driver_${driver['id']}');
        markers.add(
          Marker(
            markerId: markerId,
            position: driver['position'] as LatLng,
            icon: carIcon,
            infoWindow: InfoWindow(
              title: driver['name'] as String,
              snippet: '${driver['vehicle']} • ${driver['rating']} ⭐',
            ),
            onTap: () {
              // Select driver to show details card
              // We cannot access selectedDriver here directly, details shown via onTap passed in marker info only
            },
          ),
        );
      }
    }

    driverMarkers.value = markers;
  }

  // Update driver locations periodically
  void _updateDriverLocations(ValueNotifier<List<Map<String, dynamic>>> availableDrivers, ValueNotifier<Set<Marker>> driverMarkers) {
    // Simulate location updates
    for (int i = 0; i < availableDrivers.value.length; i++) {
      final driver = availableDrivers.value[i];
      final currentPos = driver['position'] as LatLng;
      
      // Add small random movement
      final newLat = currentPos.latitude + (math.Random().nextDouble() - 0.5) * 0.001;
      final newLng = currentPos.longitude + (math.Random().nextDouble() - 0.5) * 0.001;
      
      availableDrivers.value[i]['position'] = LatLng(newLat, newLng);
    }
    
    // Refresh markers with updated positions
    _updateDriverMarkers(availableDrivers, driverMarkers);
  }

  // Build transport type selection
  Widget _buildTransportTypeSelection(ValueNotifier<String> transportType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نوع النقل', style: montserrat(16, grey36, FontWeight.w700)),
        8.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _transportTypeOption(
                'المواصلات اليومية',
                'daily',
                Icons.directions_car,
                transportType,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _transportTypeOption(
                'مواصلات الموظفين',
                'employee',
                Icons.business,
                transportType,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _transportTypeOption(String title, String value, IconData icon, ValueNotifier<String> transportType) {
    final isSelected = transportType.value == value;
    return GestureDetector(
      onTap: () => transportType.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.grey[50],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? accentPurple : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? accentPurple : grey5F63,
              size: 20.sp,
            ),
            8.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: montserrat(
                  12,
                  isSelected ? accentPurple : grey5F63,
                  FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: accentPurple,
                size: 16.sp,
              ),
          ],
        ),
      ),
    );
  }

  // Build driver details card
  Widget _buildDriverDetailsCard(BuildContext context, Map<String, dynamic> driver, ValueNotifier<Map<String, dynamic>?> selectedDriver) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver info header
          Row(
            children: [
              // Driver profile image
              CircleAvatar(
                radius: 25.r,
                backgroundColor: accentPurple.withOpacity(0.1),
                child: Text(
                  driver['name'][0],
                  style: montserrat(18, accentPurple, FontWeight.w700),
                ),
              ),
              12.horizontalSpace,
              // Driver details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name'],
                      style: montserrat(16, grey36, FontWeight.w700),
                    ),
                    4.verticalSpace,
                    Text(
                      driver['profession'],
                      style: montserrat(12, grey5F63, FontWeight.w500),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14.sp),
                        4.horizontalSpace,
                        Text(
                          '${driver['rating']} (التقييم)',
                          style: montserrat(12, grey36, FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Close button
              IconButton(
                onPressed: () => selectedDriver.value = null,
                icon: Icon(Icons.close, color: grey5F63),
              ),
            ],
          ),
          16.verticalSpace,
          
          // Vehicle details
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_car, color: accentPurple, size: 20.sp),
                8.horizontalSpace,
                Text(
                  driver['vehicle'],
                  style: montserrat(14, grey36, FontWeight.w600),
                ),
                8.horizontalSpace,
                Text(
                  driver['plateNumber'],
                  style: montserrat(12, grey5F63, FontWeight.w500),
                ),
              ],
            ),
          ),
          16.verticalSpace,
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => selectedDriver.value = null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accentPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'حفظ',
                    style: montserrat(14, accentPurple, FontWeight.w600),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle booking
                    _handleDriverBooking(context, driver);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'احجز الآن',
                    style: montserrat(14, Colors.white, FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Handle driver booking
  void _handleDriverBooking(BuildContext context, Map<String, dynamic> driver) {
    final container = ProviderScope.containerOf(context, listen: false);
    final bookingState = container.read(bookingFlowProvider);

    // Direct user to booking confirmation with full details
    context.push('/booking_confirmation', extra: {
      'driverName': driver['name'],
      'price': driver['price'],
      'eta': driver['eta'],
      'pickup': bookingState.pickupAddress?.address,
      'dropoff': bookingState.dropOffAddress?.address,
      'pickupCoords': bookingState.pickupAddress?.coordinates,
      'dropoffCoords': bookingState.dropOffAddress?.coordinates,
      'serviceType': bookingState.serviceType.toString(),
      'date': bookingState.selectedDate,
      'startTime': bookingState.startTime,
      'endTime': bookingState.endTime,
    });
  }
}

// Small circular map action button for consistent UI
Widget _mapCircleButton({required IconData icon, required String tooltip, required VoidCallback onPressed}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF42464D),
          shape: BoxShape.circle,
        ),
        child: Tooltip(
          message: tooltip,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    ),
  );
}

// Side menu (Drawer)
Widget _buildSideMenu(BuildContext context, WidgetRef ref) {
  final userAsync = ref.watch(currentUserDetailsProvider);
  return Drawer(
    child: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with user info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: userAsync.when(
              data: (user) => Row(
                children: [
                  CircleAvatar(radius: 24, backgroundColor: accentPurple.withOpacity(0.15), child: Text((user?.name ?? 'U').characters.first.toUpperCase())),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'المستخدم', style: montserrat(14, grey36, FontWeight.w700)),
                        const SizedBox(height: 2),
                        Row(children:[const Icon(Icons.star, size: 14, color: Colors.amber), const SizedBox(width: 4), Text(((user?.averageRating ?? 4.8).toStringAsFixed(1)))]),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => Row(children: const [CircleAvatar(radius: 24), SizedBox(width: 12), Expanded(child: LinearProgressIndicator(minHeight: 8))]),
              error: (_, __) => Row(children: const [CircleAvatar(radius: 24), SizedBox(width: 12), Text('المستخدم')]),
            ),
          ),
          const Divider(height: 1),

          // City selector
          ListTile(
            leading: const Icon(Icons.location_city),
            title: const Text('المدينة'),
            onTap: () async {
              Navigator.pop(context);
              await _selectCity(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('سجل الطلبات'),
            onTap: () { Navigator.pop(context); context.push('/booking_history_enhanced'); },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('طرق الدفع'),
            onTap: () { Navigator.pop(context); context.push('/payment'); },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('الإشعارات'),
            onTap: () { Navigator.pop(context); context.push('/notifications'); },
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('السلامة'),
            onTap: () { Navigator.pop(context); context.push('/help_support'); },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () { Navigator.pop(context); context.push('/settings'); },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('المساعدة'),
            onTap: () { Navigator.pop(context); context.push('/help_support'); },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('الدعم / المحادثات'),
            onTap: () { Navigator.pop(context); context.push('/messages'); },
          ),

          const Spacer(),
        ],
      ),
    ),
  );
}

Future<void> _selectCity(BuildContext context) async {
  final cities = const ['الرياض', 'جدة', 'الدمام', 'مكة', 'المدينة'];
  String? selected;
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 12),
          const Text('اختر المدينة', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...cities.map((c) => RadioListTile<String>(
                value: c,
                groupValue: selected,
                title: Text(c),
                onChanged: (v) { selected = v; (context as Element).markNeedsBuild(); },
              )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () { Navigator.pop(context); },
              child: const Text('تأكيد'),
            ),
          )
        ],
      ),
    ),
  );
}


