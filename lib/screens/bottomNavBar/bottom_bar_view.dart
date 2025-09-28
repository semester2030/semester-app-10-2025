import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/services/auth_service.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/home_driver/home_view_driver.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/my_bookings/driver_bookings_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/my_earnings/my_earnings_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/settings/settings_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/home/home_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/my_bookings/my_bookings_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/ride_map/ride_map.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/messages/messages_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/settings/settings_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/payment/payment_view.dart';
import 'package:semester_student_ride_app/services/providers/notification_provider.dart';
import 'package:semester_student_ride_app/widgets/notification_badge.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/providers/driver_location_provider.dart';
import 'package:semester_student_ride_app/widgets/driver_location_permission_dialog.dart';

class BottomNavBarScreen extends HookConsumerWidget {
  final bool? isDriver; // Made nullable to determine dynamically

  const BottomNavBarScreen({super.key, this.isDriver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // State to track user type fetched from Firestore
    final userIsDriver = useState<bool?>(isDriver);
    final isLoading = useState<bool>(isDriver == null);

    // Fetch user type from Firestore if not provided
    useEffect(() {
      if (isDriver == null) {
        // Fetch user type from Firestore
        Future<void> fetchUserType() async {
          try {
            final bool driverStatus = await AuthService.isCurrentUserDriver();
            userIsDriver.value = driverStatus;
            isLoading.value = false;
          } catch (e) {
            log('Error fetching user type: $e');
            // Default to user (student) if error occurs
            userIsDriver.value = false;
            isLoading.value = false;
          }
        }

        fetchUserType();
      } else {
        userIsDriver.value = isDriver;
        isLoading.value = false;
      }
      return null;
    }, []);

    // Show loading while fetching user type
    if (isLoading.value || userIsDriver.value == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: accentPurple,
          ),
        ),
      );
    }

    final bool currentUserIsDriver = userIsDriver.value ?? false;

    // Check and request location permission for drivers
    final locationNotifier =
        ref.read(driverLocationPermissionProvider.notifier);

    // Effect to handle driver location permission and tracking
    useEffect(() {
      if (currentUserIsDriver) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Check current permission status
          await locationNotifier.checkPermissionStatus();

          // Get the latest state after checking
          final currentLocationState =
              ref.read(driverLocationPermissionProvider);

          // If driver doesn't have permission, show dialog
          if (!currentLocationState.hasPermission ||
              !currentLocationState.isServiceEnabled) {
            DriverLocationPermissionDialog.show(
              context,
              onPermissionGranted: () async {
                // Start location tracking when permission is granted
                final success = await locationNotifier.startTracking();
                if (success) {
                  log('Driver location tracking started successfully',
                      name: 'BottomNavBar');
                } else {
                  log('Failed to start driver location tracking',
                      name: 'BottomNavBar');
                }
              },
              onPermissionDenied: () {
                // Show a blocking screen or prevent app usage
                _showLocationRequiredBlockingDialog(context);
              },
            );
          } else if (!currentLocationState.isTracking) {
            // If permission exists but tracking is not active, start it
            log('Starting tracking for driver with existing permissions',
                name: 'BottomNavBar');
            await locationNotifier.startTracking();
          } else {
            log('Driver tracking already active', name: 'BottomNavBar');
          }
        });
      }
      // Note: Removed the else branch that was stopping tracking for non-drivers
      // This should be handled elsewhere, not in this effect
      return null;
    }, [currentUserIsDriver]); // Only depend on user type, not location state

    // Separate effect to handle cleanup for non-drivers
    useEffect(() {
      if (!currentUserIsDriver) {
        // If user is not a driver, ensure any existing tracking is stopped
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final currentLocationState =
              ref.read(driverLocationPermissionProvider);
          if (currentLocationState.isTracking) {
            log('Stopping tracking for non-driver user', name: 'BottomNavBar');
            await locationNotifier.setOffline();
          }
        });
      }
      return null;
    }, [currentUserIsDriver]);

    // Initialize the user block watcher to listen for block status changes
    // ref.watch(userBlockWatcherProvider);

    // Refresh subscription status when the screen is shown
    // useEffect(() {
    //   // Refresh subscription status in the background
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     try {
    //       // Update subscription status to ensure it's current
    //       await SubscriptionSync.updateSubscriptionStatus();
    //       log('Subscription refreshed on bottom nav bar load',
    //           name: 'SUBSCRIPTION');
    //     } catch (e) {
    //       log('Error refreshing subscription: $e', name: 'SUBSCRIPTION_ERROR');
    //     }
    //   });
    //   return null;
    // }, const []);

    // Use the provider to manage the active index
    final activeIndexNotifier = ref.watch(activeIndexProvider.notifier);
    final currentIndex =
        ref.watch(activeIndexProvider); // Get the current index

    // Different screens based on user type
    final List<Widget> screens = currentUserIsDriver
        ? [
            DriverHomeScreen(), // Driver dashboard
            MyBookingsScreenDriver(), // Driver earnings/trips
            MessagesScreen(), // Driver messages
            PaymentView(), // Driver payment
            DriverSettingsView(), // Driver settings
          ]
        : [
            HomeScreen(), // Passenger home
            RidesMap(), // Passenger map
            MessagesScreen(), // Passenger messages
            MyBookingsScreen(), // Passenger bookings
            SettingsView(), // Passenger settings
          ];

    // useEffect(() {
    //   // Set status bar to dark icons (for light background)
    //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     statusBarColor: Colors.white, // Background color
    //     statusBarIconBrightness: Brightness.dark, // Dark icons
    //   ));
    //   return null;
    // }, []);

    Widget bottomBarIcon(String icon, int bottomIndex,
        {required String title, bool showBadge = false}) {
      // Get unread notification count if showing badge

      return SizedBox(
        width: 65.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                17.verticalSpace,
                ImageUtils.imageUtilsInstance.showSVGIcon(icon,
                    color: currentIndex == bottomIndex ? accentPurple : grey160,
                    height: 20.h),
                5.verticalSpace,
                Text(title,
                    style: montserrat(
                      10,
                      currentIndex == bottomIndex ? accentPurple : grey160,
                      FontWeight.w400,
                    ).copyWith(decoration: TextDecoration.none)),
              ],
            ),

            // Show notification badge if needed
          ],
        ),
      );
    }

    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: currentIndex),
      screens: screens,
      onItemSelected: (value) {
        activeIndexNotifier
            .setIndex(value); // Update the active index using the provider
      },
      items: currentUserIsDriver
          ? [
              // Driver Navigation Items
              PersistentBottomNavBarItem(
                  activeColorPrimary: accentPurple,
                  inactiveColorPrimary: grey5E5E5E,
                  icon: bottomBarIcon(AppIcons.homeIcon, 0, title: l10n.home)),

              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.bookings, 1,
                    title: l10n.myBookings, showBadge: true),
              ),
              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.bottomNavmessenger, 2,
                    title: l10n.messages, showBadge: true),
              ),

              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.pay, 3, title: l10n.payment),
              ),

              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.userIcon, 4, title: l10n.settings),
              ),
            ]
          : [
              // Passenger Navigation Items
              PersistentBottomNavBarItem(
                  activeColorPrimary: accentPurple,
                  inactiveColorPrimary: grey5E5E5E,
                  icon: bottomBarIcon(AppIcons.homeIcon, 0, title: l10n.home)),
              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.bottomNavMap, 1, title: l10n.map),
              ),
              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.bottomNavmessenger, 2,
                    title: l10n.messages, showBadge: true),
              ),
              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.bookings, 3,
                    title: l10n.myBookings, showBadge: true),
              ),
              PersistentBottomNavBarItem(
                activeColorPrimary: accentPurple,
                inactiveColorPrimary: grey5E5E5E,
                icon: bottomBarIcon(AppIcons.userIcon, 4, title: l10n.settings),
              ),
            ],
      backgroundColor: whiteColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 9,
            offset: const Offset(0, -2), // Shadow positioned above the widget
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
        colorBehindNavBar: whiteColor,
      ),
      navBarHeight: 70.h,
      navBarStyle: NavBarStyle.style12,
    );
  }

  /// Show blocking dialog when driver denies location permission
  void _showLocationRequiredBlockingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.all(24.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              color: Colors.red,
              size: 60.w,
            ),
            20.verticalSpace,
            Text(
              'Location Required',
              style: montserrat(18, grey36, FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            Text(
              'Drivers must enable location tracking to use the app. This is required for passenger safety and ride functionality.',
              style: openSans(14, grey5E5E5E, FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigate back to login or exit app
                      FirebaseAuth.instance.signOut();
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: grey160),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          'Exit App',
                          style: montserrat(14, grey5E5E5E, FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      // Show permission dialog again
                      DriverLocationPermissionDialog.show(context);
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: accentPurple,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          'Enable Location',
                          style: montserrat(14, whiteColor, FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //
  // After dialog is closed, handle navigation if shouldNavigate is true
}
