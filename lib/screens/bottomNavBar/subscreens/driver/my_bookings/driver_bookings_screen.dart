import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/driver_booking_card.dart';
import 'package:semester_student_ride_app/widgets/my_booking_card.dart';
import 'package:semester_student_ride_app/utils/rtl_helper.dart';
import 'package:semester_student_ride_app/providers/driver_bookings_provider.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

class MyBookingsScreenDriver extends HookConsumerWidget {
  const MyBookingsScreenDriver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // State for toggling between Pending, Current and Previous
    final selectedView = useState<String>('pending');

    // Get filtered driver bookings based on the selected view
    Widget buildBookingsContent() {
      return RefreshIndicator(
        color: accentPurple,
        onRefresh: () async {
          // Invalidate the provider to trigger a refresh
          ref.invalidate(driverBookingsProvider);
          // Small delay to ensure the refresh completes
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ref.watch(driverBookingsProvider).when(
              data: (bookings) {
                List<RequestBookingModel> filteredBookings = [];

                // Filter bookings based on selected view
                switch (selectedView.value) {
                  case 'pending':
                    filteredBookings = bookings
                        .where((booking) =>
                            booking.status == BookingStatus.pending)
                        .toList();
                    break;
                  case 'current':
                    filteredBookings = bookings
                        .where((booking) => booking.status?.isActive == true)
                        .toList();
                    break;
                  case 'previous':
                    filteredBookings = bookings
                        .where((booking) => booking.status?.isFinished == true)
                        .toList();
                    break;
                }

                if (filteredBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.bookings,
                          width: 100.w,
                          height: 100.h,
                        ),
                        16.verticalSpace,
                        Text(
                          selectedView.value == 'current'
                              ? l10n.noCurrentBookings
                              : selectedView.value == 'pending'
                                  ? 'No pending bookings'
                                  : l10n.noPreviousBookings,
                          style:
                              montserrat(18, Colors.grey[600], FontWeight.w500),
                        ),
                        8.verticalSpace,
                        Text(
                          selectedView.value == 'current'
                              ? l10n.currentBookingsWillAppear
                              : selectedView.value == 'pending'
                                  ? 'Your pending bookings will appear here'
                                  : l10n.previousBookingsWillAppear,
                          style:
                              montserrat(14, Colors.grey[500], FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    // ListView
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15.h),
                        padding: EdgeInsets.only(
                            top: 10.h, bottom: 100.h, left: 20.w, right: 20.w),
                        itemCount: filteredBookings.length,
                        itemBuilder: (context, index) {
                          final booking = filteredBookings[index];
                          return DriverBookingCard(
                            booking: booking,
                            onTap: () => context.push(
                                '/booking_details_driver_view',
                                extra: booking),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
      );
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
                  l10n.myBookings,
                  style: montserrat(18, whiteColor, FontWeight.w600),
                ),

                20.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: containerbackground,
                    height: 780.h,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              110.verticalSpace,
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
                        ref.invalidate(driverBookingsProvider);
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
                            l10n.pending,
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
                            border: Border(
                              right: BorderSide(color: accentPurple, width: 1),
                              left: BorderSide(color: accentPurple, width: 1),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            l10n.current,
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
                            l10n.previous,
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
                child: buildBookingsContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
