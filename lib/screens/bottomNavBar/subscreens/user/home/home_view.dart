import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/services/providers/location_provider.dart';
import 'package:semester_student_ride_app/services/providers/prefs.dart';
import 'package:semester_student_ride_app/services/shared_preference_service.dart';
import 'package:semester_student_ride_app/widgets/my_booking_card.dart';
import 'package:semester_student_ride_app/widgets/user_booking_card/user_booking_card.dart';
import 'package:semester_student_ride_app/widgets/section_header.dart';
import 'package:semester_student_ride_app/widgets/shimmer/home_screen_shimmer.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/widgets/driver_map_card.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
// Removed old add_address_details flow import
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/utils/rtl_helper.dart';
import 'package:semester_student_ride_app/providers/current_user_provider.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedPref = SPUtils();
    final l10n = AppLocalizations.of(context)!;

    // Watch the current user details from Firebase
    final currentUserAsync = ref.watch(currentUserDetailsStreamProvider);

    // Watch pending and active bookings from Firebase
    final pendingAndActiveBookingsAsync =
        ref.watch(pendingAndActiveBookingsProvider);

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

    // Transportation service card widget
    // The isProminent parameter makes the card stand out with enhanced styling
    Widget transportationServiceCard(
        String icon, String title, VoidCallback onTap,
        {bool isProminent = false}) {
      return Container(
        width: 181.w,
        // height: 140.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: isProminent
                  ? accentPurple.withOpacity(0.15)
                  : accentPurple.withOpacity(0.08),
              blurRadius: isProminent ? 25 : 20,
              offset: const Offset(0, 8),
              spreadRadius: isProminent ? 2 : 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color:
                isProminent ? accentPurple.withOpacity(0.3) : Colors.grey[100]!,
            width: isProminent ? 2.0 : 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container with gradient background
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isProminent
                            ? [
                                accentPurple.withOpacity(0.2),
                                accentPurple.withOpacity(0.1),
                              ]
                            : [
                                accentPurple.withOpacity(0.1),
                                accentPurple.withOpacity(0.05),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isProminent
                            ? accentPurple.withOpacity(0.2)
                            : accentPurple.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        icon,
                        height: 28.h,
                        width: 28.w,
                        colorFilter: ColorFilter.mode(
                          isProminent ? accentPurple : accentPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  // Title with better typography
                  Text(
                    title,
                    style: montserrat(13, isProminent ? accentPurple : grey36,
                        isProminent ? FontWeight.w700 : FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isProminent) ...[
                    4.verticalSpace,
                    // Add a "Recommended" badge for prominent card
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: accentPurple,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Recommended',
                        style: montserrat(8, Colors.white, FontWeight.w600),
                      ),
                    ),
                  ] else
                    4.verticalSpace,
                  // Subtle indicator
                ],
              ),
            ),
          ),
        ),
      );
  }

  // Build role-based services - show only relevant services
  Widget _buildRoleBasedServices(String userRole, AppLocalizations l10n) {
    switch (userRole) {
      case 'student':
      case 'university_student':
        return Column(
          children: [
            // Student Transportation - Prominent
            transportationServiceCard(
              AppIcons.studentCap,
              l10n.studentTransportationShort,
                () {
                  context.push(
                    '/booking_map',
                    extra: TransportationServiceType.student,
                  );
                },
              isProminent: true,
            ),
          ],
        );
        
      case 'teacher':
        return Column(
          children: [
            // Teacher Transportation - Prominent
            transportationServiceCard(
              AppIcons.teacherBag,
              l10n.teacherTransportation,
                () {
                  context.push(
                    '/booking_map',
                    extra: TransportationServiceType.teacher,
                  );
                },
              isProminent: true,
            ),
          ],
        );
        
      case 'employee':
        return Column(
          children: [
            // Employee Transportation - Prominent
            transportationServiceCard(
              AppIcons.femaleEmployee,
              l10n.employeeTransportation,
                () {
                  context.push(
                    '/booking_map',
                    extra: TransportationServiceType.employee,
                  );
                },
              isProminent: true,
            ),
          ],
        );
        
      case 'parent':
        return Column(
          children: [
            // Student Transportation for children - Prominent
            transportationServiceCard(
              AppIcons.studentCap,
              'نقل الأبناء',
                () {
                  context.push(
                    '/booking_map',
                    extra: TransportationServiceType.student,
                  );
                },
              isProminent: true,
            ),
          ],
        );
        
      default:
        // Default fallback - show student transportation only
        return Column(
          children: [
            transportationServiceCard(
              AppIcons.studentCap,
              l10n.studentTransportationShort,
                () {
                  context.push(
                    '/booking_map',
                    extra: TransportationServiceType.student,
                  );
                },
              isProminent: true,
            ),
          ],
        );
    }
  }

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
                                    // Profile picture - now uses Firebase data
                                    currentUserAsync.when(
                                      data: (userData) {
                                        // Helper function to get user initials
                                        String getUserInitials(String? name) {
                                          if (name == null ||
                                              name.trim().isEmpty) {
                                            return 'U'; // Default to 'U' for User
                                          }

                                          List<String> nameParts =
                                              name.trim().split(' ');
                                          if (nameParts.length == 1) {
                                            return nameParts[0][0]
                                                .toUpperCase();
                                          } else {
                                            return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
                                                .toUpperCase();
                                          }
                                        }

                                        return CircleAvatar(
                                          radius: 25.r,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              (userData?.profilePicture !=
                                                          null &&
                                                      userData!.profilePicture!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                      userData.profilePicture!)
                                                  : null,
                                          child: (userData?.profilePicture ==
                                                      null ||
                                                  userData!
                                                      .profilePicture!.isEmpty)
                                              ? Text(
                                                  getUserInitials(
                                                      userData?.name),
                                                  style: montserrat(
                                                      14,
                                                      accentPurple,
                                                      FontWeight.w600))
                                              : null,
                                        );
                                      },
                                      loading: () => CircleAvatar(
                                        radius: 25.r,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      error: (error, stack) => CircleAvatar(
                                        radius: 25.r,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        child: Text(
                                          'U',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: accentPurple,
                                          ),
                                        ),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    // User greeting section - now uses Firebase data
                                    currentUserAsync.when(
                                      data: (userData) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  l10n.helloUser(
                                                      userData?.name ?? 'User'),
                                                  style: montserrat(
                                                      18,
                                                      Colors.white,
                                                      FontWeight.w600),
                                                ),
                                                Text(
                                                  '👋',
                                                  style: TextStyle(
                                                      fontSize: 18.sp),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              userData?.role ?? l10n.student,
                                              style: montserrat(
                                                  14,
                                                  Colors.white.withOpacity(0.8),
                                                  FontWeight.w400),
                                            ),
                                          ],
                                        );
                                      },
                                      loading: () => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                l10n.helloUser('User'),
                                                style: montserrat(
                                                    18,
                                                    Colors.white,
                                                    FontWeight.w600),
                                              ),
                                              Text(
                                                '👋',
                                                style:
                                                    TextStyle(fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            l10n.student,
                                            style: montserrat(
                                                14,
                                                Colors.white.withOpacity(0.8),
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      error: (error, stack) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                l10n.helloUser('User'),
                                                style: montserrat(
                                                    18,
                                                    Colors.white,
                                                    FontWeight.w600),
                                              ),
                                              Text(
                                                '👋',
                                                style:
                                                    TextStyle(fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            l10n.student,
                                            style: montserrat(
                                                14,
                                                Colors.white.withOpacity(0.8),
                                                FontWeight.w400),
                                          ),
                                        ],
                                      ),
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
                            // Welcome Card
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Builder(
                                builder: (context) {
                                  final isRTL = Directionality.of(context) ==
                                      TextDirection.rtl;

                                  return Stack(
                                    children: [
                                      // Car illustration positioned based on text direction
                                      Positioned(
                                        left: isRTL ? 0.w : null,
                                        right: isRTL ? null : 0.w,
                                        top: -10.h,
                                        bottom: -10.h,
                                        child: SvgPicture.asset(
                                          AppImages.homeCardBg,
                                          height: 120.h,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      // Text content positioned based on text direction
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: isRTL ? 130.w : 0,
                                          right: isRTL ? 0 : 130.w,
                                          top: 20.h,
                                          bottom: 20.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.welcomeToSamaster,
                                              style: montserrat(
                                                  14, grey36, FontWeight.w600),
                                              textAlign: isRTL
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                            ),
                                            8.verticalSpace,
                                            Text(
                                              l10n.welcomeDescription,
                                              style: montserrat(12, grey5F63,
                                                  FontWeight.w400),
                                              textAlign: isRTL
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            80.verticalSpace, // Extra space for overlapping cards
                          ],
                        ),
                      ),
                    ),

                    // White Content Section with Curve
                    ClipPath(
                      clipper: TopCurveClipper(),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey[50],
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 280.h, 20.w,
                              20.h), // Top padding for overlapping cards
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // My Bookings Section
                              20.verticalSpace,
                              SectionHeader(
                                title: l10n.myBookings,
                                isDark: true,
                              ),

                              20.verticalSpace,

                              // Booking Items Carousel
                              pendingAndActiveBookingsAsync.when(
                                data: (bookings) {
                                  if (bookings.isEmpty) {
                                    return SizedBox(
                                      height: 280.h,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.local_taxi_outlined,
                                              size: 64.w,
                                              color: grey5F63,
                                            ),
                                            16.verticalSpace,
                                            Text(
                                              'No Active Bookings',
                                              style: montserrat(
                                                  16, grey36, FontWeight.w500),
                                            ),
                                            8.verticalSpace,
                                            Text(
                                              'Book a ride to see your bookings here',
                                              style: montserrat(14, grey5F63,
                                                  FontWeight.w400),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return CarouselSlider(
                                    options: CarouselOptions(
                                      height: 360.h,
                                      viewportFraction: 0.95,
                                      initialPage: 0,
                                      enableInfiniteScroll: false,
                                      reverse: false,
                                      autoPlay: false,
                                      enlargeCenterPage: false,
                                      scrollDirection: Axis.horizontal,
                                      padEnds: true,
                                    ),
                                    items: bookings.map((booking) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: UserBookingCard(
                                                booking: booking,
                                                onTap: () => context.push(
                                                    '/booking_details_view',
                                                    extra: booking)),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  );
                                },
                                loading: () => SizedBox(
                                  height: 280.h,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          accentPurple),
                                    ),
                                  ),
                                ),
                                error: (error, stack) {
                                  log('Error loading bookings: $error');
                                  log('Stack trace: $stack');
                                  return SizedBox(
                                    height: 280.h,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 64.w,
                                            color: Colors.red,
                                          ),
                                          16.verticalSpace,
                                          Text(
                                            'Error Loading Bookings',
                                            style: montserrat(
                                                16, grey36, FontWeight.w500),
                                          ),
                                          8.verticalSpace,
                                          Text(
                                            error.toString(),
                                            style: montserrat(12, Colors.red,
                                                FontWeight.w400),
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          16.verticalSpace,
                                          ElevatedButton(
                                            onPressed: () {
                                              ref.invalidate(
                                                  pendingAndActiveBookingsProvider);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: accentPurple,
                                            ),
                                            child: Text(
                                              'Retry',
                                              style: montserrat(
                                                  14,
                                                  Colors.white,
                                                  FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Transportation Service Cards positioned to overlap
                Positioned(
                  top: 340.h, // Position after the welcome card
                  left: 20.w,
                  right: 20.w,
                  child: currentUserAsync.when(
                    data: (userData) {
                      // Determine which card should be prominent based on user role
                      final userRole =
                          userData?.role?.toLowerCase() ?? 'student';
                      
                      // Check if user is a metro user
                      final isMetroUser = userRole == 'metro user';

                      return Column(
                        children: [
                          // Show Metro Shuttle for metro users, regular services for others
                          if (isMetroUser) ...[
                            // Metro User - Show Metro Shuttle prominently
                            transportationServiceCard(
                              AppIcons.metroIcon,
                              'Metro Shuttle',
                              () {
                                context.push('/metro_route_setup');
                              },
                              isProminent: true,
                            ),
                          ] else ...[
                            // Regular users - Show ONLY services based on role
                            _buildRoleBasedServices(userRole, l10n),
                          ],
                        ],
                      );
                    },
                    loading: () => Column(
                      children: [
                        // Show loading state with student transportation only
                        transportationServiceCard(
                          AppIcons.studentCap,
                          l10n.studentTransportationShort,
                              () {
                                context.push(
                                  '/booking_map',
                                  extra: TransportationServiceType.student,
                                );
                              },
                          isProminent: true,
                        ),
                      ],
                    ),
                    error: (error, stack) => Column(
                      children: [
                        // Show error state with student transportation only
                        transportationServiceCard(
                          AppIcons.studentCap,
                          l10n.studentTransportationShort,
                              () {
                                context.push(
                                  '/booking_map',
                                  extra: TransportationServiceType.student,
                                );
                              },
                          isProminent: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
