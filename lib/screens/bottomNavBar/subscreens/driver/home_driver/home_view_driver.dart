import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/services/providers/location_provider.dart';
import 'package:semester_student_ride_app/services/providers/prefs.dart';
import 'package:semester_student_ride_app/services/shared_preference_service.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/driver_booking_card.dart';
import 'package:semester_student_ride_app/widgets/driver_request_booking_card.dart';
import 'package:semester_student_ride_app/widgets/my_booking_card.dart';
import 'package:semester_student_ride_app/widgets/section_header.dart';
import 'package:semester_student_ride_app/widgets/shimmer/home_screen_shimmer.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/widgets/driver_map_card.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
// Removed old add_address_details import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/providers/driver_bookings_provider.dart';
import 'package:semester_student_ride_app/providers/driver_location_provider.dart';
import 'package:semester_student_ride_app/providers/current_user_provider.dart';

class DriverHomeScreen extends HookConsumerWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sharedPref = SPUtils();

    // State to track if app opened from terminated state
    final hasShownBusinessDialog = useState<bool>(false);

    // Effect to fetch meetups when the screen is loaded
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        log(sharedPref.locationPermissionStatus,
            name: 'Location Permission Status');

        // Check and show business disclaimer only on app launch from terminated state
        if (!hasShownBusinessDialog.value) {
          hasShownBusinessDialog.value = true;
          checkAndShowBusinessDisclaimer(context);
        }
      });
      return null;
    }, []);

    // Stats card widget for driver dashboard
    Widget buildInfoCard(
        String title, String value, String subtitle, String icon) {
      return Container(
        width: 181.w,
        height: 63.h,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          // border: Border.all(
          //   color: Colors.white.withOpacity(0.2),
          //   width: 1,
          // ),
        ),
        child: Row(
          children: [
            10.horizontalSpace,
            Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  height: 24.h,
                ),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: montserrat(
                      14,
                      grey5E5E5E,
                      FontWeight.w400,
                    ),
                  ),
                  4.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: montserrat(
                          16,
                          grey36,
                          FontWeight.w500,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        5.horizontalSpace,
                        Text(
                          subtitle,
                          style: montserrat(
                            10,
                            grey5F63,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Watch user data to get district for location field
    final currentUserAsync = ref.watch(currentUserDetailsProvider);
    var searchTextController = useTextEditingController(
      text: currentUserAsync.whenOrNull(
            data: (user) => user?.district ?? l10n.defaultLocationText,
          ) ??
          l10n.defaultLocationText,
    );

    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          // Background SVG
          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Single ScrollView with all content
          SingleChildScrollView(
            child: Stack(
              children: [
                // Main Column with purple background
                Column(
                  children: [
                    // Purple Header Section
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Row with profile and notification
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Watch current user data for profile info
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final currentUserAsync = ref
                                            .watch(currentUserDetailsProvider);

                                        return currentUserAsync.when(
                                          data: (user) {
                                            final hasProfilePicture =
                                                user?.profilePicture != null &&
                                                    user!.profilePicture!
                                                        .isNotEmpty;

                                            // Helper function to get initials
                                            String getInitials(String? name) {
                                              if (name == null ||
                                                  name.isEmpty) {
                                                return 'D'; // Default to 'D' for Driver
                                              }
                                              final names =
                                                  name.trim().split(' ');
                                              if (names.length >= 2) {
                                                return '${names[0][0]}${names[1][0]}'
                                                    .toUpperCase();
                                              } else {
                                                return names[0][0]
                                                    .toUpperCase();
                                              }
                                            }

                                            return CircleAvatar(
                                              radius: 25.r,
                                              backgroundColor: Colors.white,
                                              backgroundImage: hasProfilePicture
                                                  ? NetworkImage(
                                                      user.profilePicture!)
                                                  : null,
                                              child: hasProfilePicture
                                                  ? null
                                                  : Text(
                                                      getInitials(user?.name),
                                                      style: montserrat(
                                                          14,
                                                          accentPurple,
                                                          FontWeight.w600)),
                                            );
                                          },
                                          loading: () => CircleAvatar(
                                            radius: 25.r,
                                            backgroundColor:
                                                Colors.white.withOpacity(0.2),
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          error: (error, stack) => CircleAvatar(
                                            radius: 25.r,
                                            backgroundColor:
                                                accentPurple.withOpacity(0.8),
                                            child: Text(
                                              'D',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    12.horizontalSpace,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Watch current user data for name
                                            Consumer(
                                              builder: (context, ref, child) {
                                                final currentUserAsync = ref.watch(
                                                    currentUserDetailsProvider);

                                                return currentUserAsync.when(
                                                  data: (user) => Text(
                                                    l10n.helloDriver(
                                                        user?.name ?? 'Driver'),
                                                    style: montserrat(
                                                        18,
                                                        Colors.white,
                                                        FontWeight.w600),
                                                  ),
                                                  loading: () => Text(
                                                    l10n.helloDriver('...'),
                                                    style: montserrat(
                                                        18,
                                                        Colors.white,
                                                        FontWeight.w600),
                                                  ),
                                                  error: (error, stack) => Text(
                                                    l10n.helloDriver('Driver'),
                                                    style: montserrat(
                                                        18,
                                                        Colors.white,
                                                        FontWeight.w600),
                                                  ),
                                                );
                                              },
                                            ),
                                            Text(
                                              '👋',
                                              style: TextStyle(fontSize: 18.sp),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: yellowE2A640,
                                              size: 14.sp,
                                            ),
                                            2.horizontalSpace,
                                            // Watch current user data for rating
                                            Consumer(
                                              builder: (context, ref, child) {
                                                final currentUserAsync = ref.watch(
                                                    currentUserDetailsProvider);

                                                return currentUserAsync.when(
                                                  data: (user) => Text(
                                                    '${(user?.averageRating ?? 0.0).toStringAsFixed(1)} (${l10n.rating})',
                                                    style: montserrat(
                                                        12,
                                                        whiteColor,
                                                        FontWeight.w400),
                                                  ),
                                                  loading: () => Text(
                                                    '... (${l10n.rating})',
                                                    style: montserrat(
                                                        12,
                                                        whiteColor,
                                                        FontWeight.w400),
                                                  ),
                                                  error: (error, stack) => Text(
                                                    '0.0 (${l10n.rating})',
                                                    style: montserrat(
                                                        12,
                                                        whiteColor,
                                                        FontWeight.w400),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    // Notification Bell
                                    GestureDetector(
                                      onTap: () =>
                                          context.push('/notifications'),
                                      child: Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.notificationBell,
                                              height: 25.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    // Settings/Menu
                                    GestureDetector(
                                      onTap: () =>
                                          context.push('/change_language'),
                                      child: Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: whiteColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppIcons.changeLanguage,
                                            height: 25.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            40.verticalSpace,
                            // Location field with filter
                            CustomTextField(
                                controller: searchTextController,
                                prefixIcon: AppIcons.district,
                                titleText: ''),
                            24.verticalSpace,

                            // Location tracking status widget
                            _buildLocationTrackingStatus(ref),
                            24.verticalSpace,

                            // Stats cards row
                            Consumer(
                              builder: (context, ref, child) {
                                final currentUserAsync =
                                    ref.watch(currentUserDetailsProvider);
                                final bookingsAsync =
                                    ref.watch(driverBookingsProvider);

                                return currentUserAsync.when(
                                  data: (user) {
                                    // Calculate upcoming bookings count
                                    final upcomingCount = bookingsAsync
                                            .whenOrNull(
                                          data: (bookings) => bookings
                                              .where((booking) =>
                                                  booking.status ==
                                                      BookingStatus.pending ||
                                                  booking.status ==
                                                      BookingStatus.active ||
                                                  booking.status ==
                                                      BookingStatus
                                                          .driverComing ||
                                                  booking.status ==
                                                      BookingStatus.tripStarted)
                                              .length,
                                        ) ??
                                        0;

                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: buildInfoCard(
                                                l10n.totalBooking,
                                                '${user?.totalTrips ?? 0}',
                                                '',
                                                AppIcons.totalBooking,
                                              ),
                                            ),
                                            12.horizontalSpace,
                                            Expanded(
                                              child: buildInfoCard(
                                                l10n.upcoming,
                                                '$upcomingCount',
                                                '',
                                                AppIcons.upcomingBooking,
                                              ),
                                            ),
                                          ],
                                        ),
                                        16.verticalSpace,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: buildInfoCard(
                                                l10n.totalEarning,
                                                '0', // This would need to be calculated from completed trips
                                                'SAR',
                                                AppIcons.totalEarnings,
                                              ),
                                            ),
                                            12.horizontalSpace,
                                            Expanded(
                                              child: buildInfoCard(
                                                l10n.newWithdraw,
                                                '0', // This would need to be managed separately
                                                'SAR',
                                                AppIcons.newWithdraw,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  loading: () => Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.totalBooking,
                                              '...',
                                              '',
                                              AppIcons.totalBooking,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.upcoming,
                                              '...',
                                              '',
                                              AppIcons.upcomingBooking,
                                            ),
                                          ),
                                        ],
                                      ),
                                      16.verticalSpace,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.totalEarning,
                                              '...',
                                              'SAR',
                                              AppIcons.totalEarnings,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.newWithdraw,
                                              '...',
                                              'SAR',
                                              AppIcons.newWithdraw,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  error: (error, stack) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.totalBooking,
                                              '0',
                                              '',
                                              AppIcons.totalBooking,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.upcoming,
                                              '0',
                                              '',
                                              AppIcons.upcomingBooking,
                                            ),
                                          ),
                                        ],
                                      ),
                                      16.verticalSpace,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.totalEarning,
                                              '0',
                                              'SAR',
                                              AppIcons.totalEarnings,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Expanded(
                                            child: buildInfoCard(
                                              l10n.newWithdraw,
                                              '0',
                                              'SAR',
                                              AppIcons.newWithdraw,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // White Content Section with Curve
                    ClipPath(
                      clipper: TopCurveClipper(),
                      child: Container(
                        width: double.infinity,
                        // Set minimum height to extend to bottom of screen
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        color: Colors.grey[50],
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w,
                              100.h), // Increased bottom padding to extend content
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              10.verticalSpace,
                              // New Booking Requests Section
                              SectionHeader(
                                title: l10n.newBookingRequests,
                                isDark: true,
                              ),

                              20.verticalSpace,

                              // Booking requests list
                              ref.watch(driverBookingsProvider).when(
                                    data: (bookings) {
                                      final pendingBookings = bookings
                                          .where((booking) =>
                                              booking.status ==
                                              BookingStatus.pending)
                                          .toList();

                                      if (pendingBookings.isEmpty) {
                                        return SizedBox(
                                          height: 200.h,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.inbox_outlined,
                                                  size: 48.sp,
                                                  color: Colors.grey[400],
                                                ),
                                                16.verticalSpace,
                                                Text(
                                                  l10n.noNewBookingRequests,
                                                  style: montserrat(
                                                      16,
                                                      Colors.grey[600],
                                                      FontWeight.w500),
                                                ),
                                                8.verticalSpace,
                                                Text(
                                                  l10n.newRideRequestsWillAppear,
                                                  style: montserrat(
                                                      14,
                                                      Colors.grey[500],
                                                      FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Column(
                                          children:
                                              pendingBookings.map((booking) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 16.h),
                                              child: DriverBookingCard(
                                                booking: booking,
                                                onTap: () => context.push(
                                                    '/booking_details_driver_view',
                                                    extra: booking),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    },
                                    loading: () => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, stack) {
                                      log('Error loading bookings: $error',
                                          name: 'DriverHomeScreen');
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 48.sp,
                                            ),
                                            16.verticalSpace,
                                            Text(
                                              'Failed to load bookings',
                                              style: montserrat(
                                                16,
                                                Colors.grey[600],
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              // Add spacer to ensure content fills to bottom
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // No more overlapping cards for driver view
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build location tracking status widget
  Widget _buildLocationTrackingStatus(WidgetRef ref) {
    final locationState = ref.watch(driverLocationPermissionProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: whiteColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: locationState.isTracking
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              locationState.isTracking ? Icons.location_on : Icons.location_off,
              color: locationState.isTracking ? Colors.green : Colors.orange,
              size: 20.w,
            ),
          ),

          16.horizontalSpace,

          // Status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationState.isTracking
                      ? 'Location Tracking: Active'
                      : 'Location Tracking: Inactive',
                  style: montserrat(14, whiteColor, FontWeight.w600),
                ),
                4.verticalSpace,
                Text(
                  locationState.isTracking
                      ? 'You are visible to nearby passengers'
                      : 'Enable tracking to receive ride requests',
                  style: montserrat(
                      12, whiteColor.withOpacity(0.8), FontWeight.w400),
                ),
              ],
            ),
          ),

          // Action button (if tracking is inactive)
          if (!locationState.isTracking) ...[
            16.horizontalSpace,
            GestureDetector(
              onTap: () async {
                final locationNotifier =
                    ref.read(driverLocationPermissionProvider.notifier);
                await locationNotifier.startTracking();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Enable',
                  style: montserrat(12, accentPurple, FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Function to check if user is a business account and show the disclaimer
void checkAndShowBusinessDisclaimer(BuildContext context) async {
  // Add your business disclaimer logic here if needed
  // This is a placeholder function
}
