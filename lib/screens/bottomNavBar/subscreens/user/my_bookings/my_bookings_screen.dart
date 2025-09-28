import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/widgets/user_booking_card/user_booking_card.dart';
import 'package:semester_student_ride_app/utils/rtl_helper.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

class MyBookingsScreen extends HookConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State for toggling between Pending, Current, and Previous
    final selectedView = useState<String>('pending');

    // Watch user bookings from Firebase
    final userBookingsAsync = ref.watch(userBookingsProvider);

    // Filter bookings based on selected view
    List<RequestBookingModel> getFilteredBookings(
        List<RequestBookingModel> allBookings) {
      switch (selectedView.value) {
        case 'pending':
          return allBookings
              .where((booking) => booking.status == BookingStatus.pending)
              .toList();
        case 'current':
          return allBookings
              .where((booking) => booking.status?.isActive == true)
              .toList();
        case 'previous':
          return allBookings
              .where((booking) => booking.status?.isFinished == true)
              .toList();
        default:
          return allBookings
              .where((booking) => booking.status == BookingStatus.pending)
              .toList();
      }
    }

    // Main content based on selected view

    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top spacing
                50.verticalSpace,
                Text(
                  AppLocalizations.of(context)!.myBookings,
                  style: montserrat(18, whiteColor, FontWeight.w600),
                ),

                20.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: containerbackground,
                    height: 800.h,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              120.verticalSpace,
              // Toggle buttons at the top
              // Small reload button at the top
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Invalidate the provider to refresh bookings
                        ref.invalidate(userBookingsProvider);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: accentPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: accentPurple, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 16.sp,
                              color: accentPurple,
                            ),
                            4.horizontalSpace,
                            Text(
                              'Reload',
                              style:
                                  montserrat(12, accentPurple, FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle buttons at the top
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: accentPurple,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: accentPurple, width: 1),
                ),
                child: Row(
                  children: [
                    // "Pending" toggle button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedView.value = 'pending',
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: selectedView.value == 'pending'
                                ? accentPurple
                                : whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: context.isRTL
                                  ? Radius.zero
                                  : Radius.circular(24),
                              bottomLeft: context.isRTL
                                  ? Radius.zero
                                  : Radius.circular(24),
                              topRight: context.isRTL
                                  ? Radius.circular(24)
                                  : Radius.zero,
                              bottomRight: context.isRTL
                                  ? Radius.circular(24)
                                  : Radius.zero,
                            ),
                            border: Border(
                              right: context.isRTL
                                  ? BorderSide.none
                                  : BorderSide(color: accentPurple, width: 1),
                              left: context.isRTL
                                  ? BorderSide(color: accentPurple, width: 1)
                                  : BorderSide.none,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.pending,
                            style: montserrat(
                              13,
                              selectedView.value == 'pending'
                                  ? whiteColor
                                  : accentPurple,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // "Current" toggle button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedView.value = 'current',
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: selectedView.value == 'current'
                                ? accentPurple
                                : whiteColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.current,
                            style: montserrat(
                              13,
                              selectedView.value == 'current'
                                  ? whiteColor
                                  : accentPurple,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // "Previous" toggle button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => selectedView.value = 'previous',
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: selectedView.value == 'previous'
                                ? accentPurple
                                : whiteColor,
                            borderRadius: BorderRadius.only(
                              topRight: context.isRTL
                                  ? Radius.zero
                                  : Radius.circular(24),
                              bottomRight: context.isRTL
                                  ? Radius.zero
                                  : Radius.circular(24),
                              topLeft: context.isRTL
                                  ? Radius.circular(24)
                                  : Radius.zero,
                              bottomLeft: context.isRTL
                                  ? Radius.circular(24)
                                  : Radius.zero,
                            ),
                            border: Border(
                              left: context.isRTL
                                  ? BorderSide.none
                                  : BorderSide(color: accentPurple, width: 1),
                              right: context.isRTL
                                  ? BorderSide(color: accentPurple, width: 1)
                                  : BorderSide.none,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)!.previous,
                            style: montserrat(
                              13,
                              selectedView.value == 'previous'
                                  ? whiteColor
                                  : accentPurple,
                              FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content area
              Expanded(
                child: userBookingsAsync.when(
                  data: (allBookings) {
                    final filteredBookings = getFilteredBookings(allBookings);

                    return filteredBookings.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppIcons.bookings,
                                    height: 100.h),
                                16.verticalSpace,
                                Text(
                                  AppLocalizations.of(context)!
                                      .noBookingsFound(selectedView.value),
                                  style: montserrat(
                                      18, Colors.grey[600], FontWeight.w500),
                                ),
                                8.verticalSpace,
                                Text(
                                  AppLocalizations.of(context)!
                                      .noBookingsMessage(selectedView.value),
                                  style: montserrat(
                                      14, Colors.grey[500], FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 10.h, bottom: 100.h),
                            itemCount: filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = filteredBookings[index];
                              return UserBookingCard(
                                  booking: booking,
                                  onTap: () => context.push(
                                      '/booking_details_view',
                                      extra: booking));
                            },
                          );
                  },
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(accentPurple),
                        ),
                        16.verticalSpace,
                        Text(
                          'Loading bookings...',
                          style:
                              montserrat(16, Colors.grey[600], FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        16.verticalSpace,
                        Text(
                          'Error loading bookings',
                          style:
                              montserrat(18, Colors.grey[600], FontWeight.w500),
                        ),
                        8.verticalSpace,
                        Text(
                          error.toString(),
                          style: montserrat(14, Colors.red, FontWeight.w400),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        16.verticalSpace,
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(userBookingsProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentPurple,
                          ),
                          child: Text(
                            'Retry',
                            style:
                                montserrat(14, Colors.white, FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
