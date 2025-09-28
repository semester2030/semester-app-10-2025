import 'dart:developer';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/main.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/signup/signup_driver.dart';
import 'package:semester_student_ride_app/screens/auth/signup/upload_documents.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_type_selection_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_phone_registration_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_otp_verification_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_personal_info_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_location_selection_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_service_selection_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_vehicle_info_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/driver_documents_screen.dart';
import 'package:semester_student_ride_app/screens/auth/signup/company_registration_screen.dart';
// Removed user_driver_selection.dart - duplicate screen
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/booking_details_driver/booking_detail_driver_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/flag_inapproperiate/flag_inappropriate.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/service_availability/driver_service_availability_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/add_review/add_review.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking_details/booking_detail_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/cancel_ride/cancel_ride.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/edit_profile/edit_profile_driver.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/driver_tracking/live_driver_tracking_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/help_support/help_support_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/my_bookings/my_bookings_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/payment/add_new_payment.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/change_language/change_language.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/settings/settings_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/settings/new_settings_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/settings/edit_phone_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/settings/edit_address_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/home/home_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/messages/chatting_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/messages/messages_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/notifications/notifications_view.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/payment/payment_view.dart';
// import removed: additional_details is deprecated (legacy flow)
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/request_booking/select_driver.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/request_booking/booking_details_page.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/reset_password/reset_password_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import removed: old AddAddressDetails flow is deprecated
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/request_booking/price_proposal_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/request_booking/unified_booking_map_screen.dart';
// New screens imports
import 'package:semester_student_ride_app/screens/auth/onboarding/main_role_selection.dart';
import 'package:semester_student_ride_app/screens/auth/onboarding/customer_role_dropdown.dart';
// Quick signup screens - imported via semester_student_ride_app_imports.dart
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/metro/metro_route_setup.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/metro/metro_station_selection.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/metro/metro_subscription_management.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/company/company_dashboard.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/company/company_vehicle_management.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/company/company_driver_management.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/company/company_revenue_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/company/company_add_driver_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/company/company_add_vehicle_screen.dart';
// Offer system screens
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/offers/offer_creation_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/offers/offer_management_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/offers/offer_details_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/offers/offer_negotiation_screen.dart';
// Enhanced map screens
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/map/enhanced_map_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/map/fleet_overview_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/map/driver_tracking_enhanced.dart';
// Enhanced booking screens
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking/enhanced_booking_flow.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking/booking_confirmation_screen.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking/booking_history_enhanced.dart';
part 'router.g.dart';

/// The router config for the app.
@riverpod
GoRouter router(Ref ref) {
  // Local notifier for the current auth state. The purpose of this notifier is
  // to provide a [Listenable] to the [GoRouter] exposed by this provider.
  // Notifiers to trigger GoRouter refreshes
  final authStateNotifier = ValueNotifier(AuthState.unknown);
  final splashStateNotifier = ValueNotifier<bool>(ref.read(splashStateProvider));

  // Listen to auth state changes
  ref.listen(currentAuthStateProvider, (_, value) {
    authStateNotifier.value = value;
  });

  // Listen to splash state changes so router can leave splash
  ref.listen(splashStateProvider, (_, value) {
    splashStateNotifier.value = value;
  });

  // This is the only place you need to define your navigation items. The items
  // will be propagated automatically to the router and the navigation bar/rail
  // of the scaffold.
  //
  // To configure the authentication state needed to access a particular item,
  // see [AuthState] enum.

  final navigatorKey = ref.read(navigatorKeyProvider);
  final router = GoRouter(
    debugLogDiagnostics: false, // Disable debug logs to reduce performance issues
    navigatorKey: navigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const Scaffold(),
      ),
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Splash(),
        ),
      ),
      // Onboarding screens
      GoRoute(
        path: '/onboarding1',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Onboarding1(),
        ),
      ),
      GoRoute(
        path: '/onboarding2',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Onboarding2(),
        ),
      ),
      GoRoute(
        path: '/onboarding3',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Onboarding3(),
        ),
      ),
      GoRoute(
        path: '/on_board',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Onboarding1(),
        ),
      ),
      GoRoute(
        path: '/on_board_2',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Onboarding2(),
        ),
      ),
      GoRoute(
        path: '/on_board_3',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const Onboarding3(),
        ),
      ),
      // New role selection screens
      GoRoute(
        path: '/main_role_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MainRoleSelectionScreen(),
        ),
      ),
      GoRoute(
        path: '/customer_role_dropdown',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CustomerRoleDropdownScreen(),
        ),
      ),
      // Quick signup screens
      GoRoute(
        path: '/user_type_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const UserTypeSelectionScreen(),
        ),
      ),
      GoRoute(
        path: '/role_specific_signup',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: RoleSpecificSignupScreen(role: state.extra as String),
        ),
      ),
      // New step-by-step registration flow
      GoRoute(
        path: '/phone_registration',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: PhoneRegistrationScreen(role: state.extra as String),
        ),
      ),
      GoRoute(
        path: '/otp_verification',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: OtpScreen(
            email: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            isFromSignup: (state.extra as Map<String, dynamic>)['isFromSignup'] as bool,
          ),
        ),
      ),
      GoRoute(
        path: '/name_gender',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: NameGenderScreen(
            role: (state.extra as Map<String, dynamic>)['role'] as String,
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/password_creation',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: PasswordCreationScreen(
            role: (state.extra as Map<String, dynamic>)['role'] as String,
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/location_type',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: LocationTypeScreen(
            role: (state.extra as Map<String, dynamic>)['role'] as String,
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
            password: (state.extra as Map<String, dynamic>)['password'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/location_details',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: LocationDetailsScreen(
            role: (state.extra as Map<String, dynamic>)['role'] as String,
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
            password: (state.extra as Map<String, dynamic>)['password'] as String,
            locationType: (state.extra as Map<String, dynamic>)['locationType'] as String,
          ),
        ),
      ),
      // Role-specific selection screens
      GoRoute(
        path: '/student_university_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: StudentUniversitySelectionScreen(
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
            password: (state.extra as Map<String, dynamic>)['password'] as String,
            locationType: (state.extra as Map<String, dynamic>)['locationType'] as String,
            city: (state.extra as Map<String, dynamic>)['city'] as String,
            district: (state.extra as Map<String, dynamic>)['district'] as String,
            address: (state.extra as Map<String, dynamic>)['address'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/teacher_school_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: TeacherSchoolSelectionScreen(
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
            password: (state.extra as Map<String, dynamic>)['password'] as String,
            locationType: (state.extra as Map<String, dynamic>)['locationType'] as String,
            city: (state.extra as Map<String, dynamic>)['city'] as String,
            district: (state.extra as Map<String, dynamic>)['district'] as String,
            address: (state.extra as Map<String, dynamic>)['address'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/employee_workplace_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: EmployeeWorkplaceSelectionScreen(
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
            password: (state.extra as Map<String, dynamic>)['password'] as String,
            locationType: (state.extra as Map<String, dynamic>)['locationType'] as String,
            city: (state.extra as Map<String, dynamic>)['city'] as String,
            district: (state.extra as Map<String, dynamic>)['district'] as String,
            address: (state.extra as Map<String, dynamic>)['address'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/metro_student_station_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: MetroStudentStationSelectionScreen(
            phoneNumber: (state.extra as Map<String, dynamic>)['phoneNumber'] as String,
            name: (state.extra as Map<String, dynamic>)['name'] as String,
            gender: (state.extra as Map<String, dynamic>)['gender'] as String,
            password: (state.extra as Map<String, dynamic>)['password'] as String,
            locationType: (state.extra as Map<String, dynamic>)['locationType'] as String,
            city: (state.extra as Map<String, dynamic>)['city'] as String,
            district: (state.extra as Map<String, dynamic>)['district'] as String,
            address: (state.extra as Map<String, dynamic>)['address'] as String,
          ),
        ),
      ),
      GoRoute(
        path: '/date_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: () {
            final extra = (state.extra ?? <String, dynamic>{}) as Map<String, dynamic>;
            return DateSelectionScreen(
              role: (extra['role'] as String?) ?? '',
              phoneNumber: (extra['phoneNumber'] as String?) ?? '',
              name: (extra['name'] as String?) ?? '',
              gender: (extra['gender'] as String?) ?? '',
              password: (extra['password'] as String?) ?? '',
              locationType: (extra['locationType'] as String?) ?? '',
              city: (extra['city'] as String?) ?? '',
              district: (extra['district'] as String?) ?? '',
              address: (extra['address'] as String?) ?? '',
              university: (extra['university'] as String?) ?? '',
              universityAddress: (extra['universityAddress'] as String?) ?? '',
            );
          }(),
        ),
      ),
      // Metro screens
      GoRoute(
        path: '/metro_route_setup',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MetroRouteSetupScreen(),
        ),
      ),
      GoRoute(
        path: '/metro_station_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MetroStationSelectionScreen(),
        ),
      ),
      GoRoute(
        path: '/metro_subscription_management',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MetroSubscriptionManagementScreen(),
        ),
      ),
    // Company management screens
    GoRoute(
      path: '/company_dashboard',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const CompanyDashboardScreen(),
      ),
    ),
    GoRoute(
      path: '/company_revenue',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const CompanyRevenueScreen(),
      ),
    ),
    GoRoute(
      path: '/company_vehicle_management',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const CompanyVehicleManagementScreen(),
      ),
    ),
    GoRoute(
      path: '/company_driver_management',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const CompanyDriverManagementScreen(),
      ),
    ),
    // Offer system screens
    GoRoute(
      path: '/offer_creation',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const OfferCreationScreen(),
      ),
    ),
    GoRoute(
      path: '/offer_management',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const OfferManagementScreen(),
      ),
    ),
    GoRoute(
      path: '/offer_details',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<Map<String, dynamic>>(
        context: context,
        state: state,
        child: OfferDetailsScreen(offer: state.extra as Map<String, dynamic>),
      ),
    ),
    GoRoute(
      path: '/offer_negotiation',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<Map<String, dynamic>>(
        context: context,
        state: state,
        child: OfferNegotiationScreen(
          offer: (state.extra as Map<String, dynamic>?)?['offer'] as Map<String, dynamic>? ?? {},
          driver: (state.extra as Map<String, dynamic>?)?['driver'] as Map<String, dynamic>? ?? {},
        ),
      ),
    ),
    // Enhanced map screens
    GoRoute(
      path: '/enhanced_map',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const EnhancedMapScreen(),
      ),
    ),
    GoRoute(
      path: '/fleet_overview',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const FleetOverviewScreen(),
      ),
    ),
    GoRoute(
      path: '/driver_tracking_enhanced',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<Map<String, dynamic>>(
        context: context,
        state: state,
        child: DriverTrackingEnhancedScreen(
          driver: (state.extra as Map<String, dynamic>?)?['driver'] as Map<String, dynamic>? ?? {},
          booking: (state.extra as Map<String, dynamic>?)?['booking'] as Map<String, dynamic>? ?? {},
        ),
      ),
    ),
    // Enhanced booking screens
    GoRoute(
      path: '/enhanced_booking_flow',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const EnhancedBookingFlowScreen(),
      ),
    ),
    GoRoute(
      path: '/booking_confirmation',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<Map<String, dynamic>>(
        context: context,
        state: state,
        child: BookingConfirmationScreen(
          bookingDetails: state.extra as Map<String, dynamic>,
        ),
      ),
    ),
    GoRoute(
      path: '/booking_history_enhanced',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const BookingHistoryEnhancedScreen(),
      ),
    ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/forget_password',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const ForgetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/reset_password',
        pageBuilder: (context, state) {
          final String email = state.extra as String;
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: ResetPasswordScreen(email: email),
          );
        },
      ),
      // Removed user_driver_selection route - duplicate screen
      GoRoute(
        path: '/signup_user',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const SignUpScreenUser(),
        ),
      ),
      GoRoute(
        path: '/signup_driver',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const SignUpScreenDriver(),
        ),
      ),
      GoRoute(
        path: '/upload_documents',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const UploadDriverDocuments(),
        ),
      ),
      // Driver type selection (new screen)
      GoRoute(
        path: '/driver_type_selection',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const DriverTypeSelectionScreen(),
        ),
      ),
      // Driver phone registration
      GoRoute(
        path: '/driver_phone_registration',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const DriverPhoneRegistrationScreen(),
        ),
      ),
      // Driver OTP verification
      GoRoute(
        path: '/driver_otp_verification',
        pageBuilder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          final String phoneNumber = data['phoneNumber'] as String;
          final bool isFromDriverSignup = data['isFromDriverSignup'] as bool;
          
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DriverOtpVerificationScreen(
              phoneNumber: phoneNumber,
              isFromDriverSignup: isFromDriverSignup,
            ),
          );
        },
      ),
      // Driver personal info
      GoRoute(
        path: '/driver_personal_info',
        pageBuilder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          final String phoneNumber = data['phoneNumber'] as String;
          final bool isFromDriverSignup = data['isFromDriverSignup'] as bool;
          
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DriverPersonalInfoScreen(
              phoneNumber: phoneNumber,
              isFromDriverSignup: isFromDriverSignup,
            ),
          );
        },
      ),
      // Driver location selection
      GoRoute(
        path: '/driver_location_selection',
        pageBuilder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DriverLocationSelectionScreen(
              phoneNumber: data['phoneNumber'] as String,
              name: data['name'] as String,
              email: data['email'] as String,
              password: data['password'] as String,
              gender: data['gender'] as String,
              city: data['city'] as String,
              isFromDriverSignup: data['isFromDriverSignup'] as bool,
            ),
          );
        },
      ),
      // Driver service selection
      GoRoute(
        path: '/driver_service_selection',
        pageBuilder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DriverServiceSelectionScreen(
              phoneNumber: data['phoneNumber'] as String,
              name: data['name'] as String,
              email: data['email'] as String,
              password: data['password'] as String,
              gender: data['gender'] as String,
              city: data['city'] as String,
              region: data['region'] as String,
              selectedCity: data['selectedCity'] as String,
              district: data['district'] as String,
              subDistrict: data['subDistrict'] as String?,
              isFromDriverSignup: data['isFromDriverSignup'] as bool,
            ),
          );
        },
      ),
      // Driver vehicle info
      GoRoute(
        path: '/driver_vehicle_info',
        pageBuilder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DriverVehicleInfoScreen(
              phoneNumber: data['phoneNumber'] as String,
              name: data['name'] as String,
              email: data['email'] as String,
              password: data['password'] as String,
              gender: data['gender'] as String,
              city: data['city'] as String,
              region: data['region'] as String,
              selectedCity: data['selectedCity'] as String,
              district: data['district'] as String,
              subDistrict: data['subDistrict'] as String?,
              services: List<String>.from(data['services'] as List),
              isFromDriverSignup: data['isFromDriverSignup'] as bool,
            ),
          );
        },
      ),
      // Driver documents
      GoRoute(
        path: '/driver_documents',
        pageBuilder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: DriverDocumentsScreen(
              phoneNumber: data['phoneNumber'] as String,
              name: data['name'] as String,
              email: data['email'] as String,
              password: data['password'] as String,
              gender: data['gender'] as String,
              city: data['city'] as String,
              region: data['region'] as String,
              selectedCity: data['selectedCity'] as String,
              district: data['district'] as String,
              subDistrict: data['subDistrict'] as String?,
              services: List<String>.from(data['services'] as List),
              vehicleMake: data['vehicleMake'] as String,
              vehicleModel: data['vehicleModel'] as String,
              vehicleYear: data['vehicleYear'] as String,
              plateNumber: data['plateNumber'] as String,
              vehicleType: data['vehicleType'] as String,
              fuelType: data['fuelType'] as String,
              transmission: data['transmission'] as String,
              hasAC: data['hasAC'] as bool,
              isFromDriverSignup: data['isFromDriverSignup'] as bool,
            ),
          );
        },
      ),
      // Company registration
      GoRoute(
        path: '/company_registration',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyRegistrationScreen(),
        ),
      ),
      // Add missing routes for company management
      GoRoute(
        path: '/add_driver',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const CompanyAddDriverScreen(),
      ),
      ),
      GoRoute(
        path: '/edit_driver',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyDriverManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/driver_details',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyDriverManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/assign_vehicle',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyVehicleManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/add_vehicle',
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const CompanyAddVehicleScreen(),
      ),
      ),
      GoRoute(
        path: '/edit_vehicle',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyVehicleManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/vehicle_details',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyVehicleManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/assign_driver',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const CompanyDriverManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        pageBuilder: (context, state) {
          // Get the data passed from the previous screen
          // Check if we're using the new format (Map with phoneNumber and isFromSignup)
          if (state.extra is Map) {
            final Map<String, dynamic> data =
                state.extra as Map<String, dynamic>;
            final String phoneNumber = data['phoneNumber'] as String;
            final bool isFromSignup = data['isFromSignup'] as bool;
            final String? role = data['role'] as String?;

            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: OtpScreen(
                email: phoneNumber, 
                isFromSignup: isFromSignup,
                phoneNumber: phoneNumber,
                role: role,
              ),
            );
          }
          // Legacy format (just phoneNumber as String)
          else {
            final String phoneNumber = state.extra as String;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: OtpScreen(
                  email: phoneNumber,
                  isFromSignup: true), // Default to signup flow
            );
          }
        },
      ),
      GoRoute(
          path: '/chatting',
          pageBuilder: (context, state) {
            final Map<String, dynamic> data =
                state.extra as Map<String, dynamic>;
            final String threadId = data['threadId'] as String;
            final UserSignupModel otherUser =
                data['otherUser'] as UserSignupModel;

            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ChattingScreen(
                threadId: threadId,
                secondUser: otherUser,
              ),
            );
          }),
      GoRoute(
          path: '/bottom_nav_bar',
          pageBuilder: (context, state) {
            // Pass the isDriver value if explicitly provided, otherwise null to determine dynamically
            bool? isDriver = state.extra as bool?;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: BottomNavBarScreen(isDriver: isDriver),
            );
          }),
      GoRoute(
          path: '/booking_details_view',
          pageBuilder: (context, state) {
            RequestBookingModel booking = state.extra as RequestBookingModel;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: BookingDetailView(booking: booking),
            );
          }),
      GoRoute(
          path: '/booking_details_driver_view',
          pageBuilder: (context, state) {
            RequestBookingModel booking = state.extra as RequestBookingModel;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: BookingDetailDriverView(booking: booking),
            );
          }),
      GoRoute(
          path: '/flag_inappropriate',
          pageBuilder: (context, state) {
            final booking = state.extra as RequestBookingModel;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: FlagInappropriate(booking: booking),
            );
          }),
      GoRoute(
        path: '/messages',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const MessagesScreen(),
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const NotificationsView(),
        ),
      ),
      GoRoute(
        path: '/payment',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const PaymentView(),
        ),
      ),
      // Deprecated old flow removed: '/add_address_details'
      GoRoute(
          path: '/additional_booking_details',
          pageBuilder: (context, state) {
            TransportationServiceType serviceType =
                state.extra as TransportationServiceType;
            // Legacy reference removed
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: UnifiedBookingMapScreen(serviceType: serviceType),
            );
          }),
      GoRoute(
          path: '/price_proposal',
          pageBuilder: (context, state) {
            TransportationServiceType serviceType = state.extra as TransportationServiceType;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: PriceProposalScreen(serviceType: serviceType, showPriceSection: true),
            );
          }),
      GoRoute(
          path: '/trip_options',
          pageBuilder: (context, state) {
            TransportationServiceType serviceType = state.extra as TransportationServiceType;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: PriceProposalScreen(serviceType: serviceType, showPriceSection: false),
            );
          }),
      GoRoute(
          path: '/booking_map',
          pageBuilder: (context, state) {
            TransportationServiceType serviceType;
            if (state.extra is Map<String, dynamic>) {
              serviceType = (state.extra as Map<String, dynamic>)['serviceType'] as TransportationServiceType;
            } else {
              serviceType = state.extra as TransportationServiceType;
            }
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: UnifiedBookingMapScreen(serviceType: serviceType),
            );
          }),
      // Removed separate offers list screen in favor of unified live offers in map
      GoRoute(
          path: '/select_driver',
          pageBuilder: (context, state) {
            TransportationServiceType serviceType =
                state.extra as TransportationServiceType;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: SelectDriver(serviceType: serviceType),
            );
          }),
      GoRoute(
          path: '/booking_details',
          pageBuilder: (context, state) {
            if (state.extra is Map<String, dynamic>) {
              final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
              final TransportationServiceType serviceType = extra['serviceType'] as TransportationServiceType;
              final Map<String, dynamic>? acceptedOfferData = extra['acceptedOffer'] as Map<String, dynamic>?;
              
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: BookingDetailsPage(
                  serviceType: serviceType,
                  acceptedOfferData: acceptedOfferData,
                ),
              );
            } else {
              // Legacy support for direct service type
              TransportationServiceType serviceType = state.extra as TransportationServiceType;
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: BookingDetailsPage(serviceType: serviceType),
              );
            }
          }),
      GoRoute(
          path: '/cancel_ride',
          pageBuilder: (context, state) {
            final booking = state.extra as RequestBookingModel;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: CancelRide(booking: booking),
            );
          }),
      GoRoute(
          path: '/live_driver_tracking',
          pageBuilder: (context, state) {
            final booking = state.extra as RequestBookingModel;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: LiveDriverTrackingScreen(booking: booking),
            );
          }),
      GoRoute(
          path: '/add_review',
          pageBuilder: (context, state) {
            final booking = state.extra as RequestBookingModel?;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: AddReview(booking: booking),
            );
          }),
      GoRoute(
          path: '/change_language',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ChangeLanguage(),
            );
          }),
      GoRoute(
          path: '/help_support',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: HelpSupportView(),
            );
          }),
      GoRoute(
          path: '/add_payment',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: AddNewPayment(),
            );
          }),
      GoRoute(
          path: '/edit_profile',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: EditProfileDriver(),
            );
          }),
      GoRoute(
          path: '/change_password',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ResetPasswordView(),
            );
          }),
      GoRoute(
          path: '/settings',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: NewSettingsView(),
            );
          }),
      GoRoute(
          path: '/service_availability',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: DriverServiceAvailabilityView(),
            );
          }),
      // legacy '/additional_details' is removed; use '/booking_map'
      GoRoute(
          path: '/price_proposal',
          pageBuilder: (context, state) {
            TransportationServiceType serviceType =
                state.extra as TransportationServiceType;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: PriceProposalScreen(serviceType: serviceType),
            );
          }),
      // Removed: '/offers_list' route (unified live offers in map)
      GoRoute(
          path: '/edit_phone',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: EditPhoneScreen(),
            );
          }),
      GoRoute(
          path: '/edit_address',
          pageBuilder: (context, state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: EditAddressScreen(),
            );
          }),
    ],
    // Refresh router when either auth or splash state changes
    refreshListenable: authStateNotifier,
    // إزالة الـ redirect logic تماماً - الحل الجذري
  );
  // Don't dispose router here as it's managed by GoRouter
  return router;
}
