import 'dart:developer';

import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/widgets/circular_profile_image.dart';
import 'package:semester_student_ride_app/widgets/app_dialogs.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';

class CancelRide extends HookConsumerWidget {
  final RequestBookingModel booking;

  const CancelRide({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedReason = useState<String?>(null);

    final cancellationReasons = [
      l10n.driverTakingTooLong,
      l10n.foundAnotherRide,
      l10n.changeOfPlans,
      l10n.incorrectPickupLocation,
      l10n.driverAskedToCancel,
      l10n.driverBehavior,
      l10n.other,
    ];
    return ScreenWithTopAppbar(
        title: l10n.cancellationReason,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 180.h),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.whyAreyouCanceling,
                        style: montserrat(18, grey36, FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.feedbackHelpsImprove,
                        style: montserrat(14, grey5F63, FontWeight.w400),
                      ),
                      SizedBox(height: 24.h),
                      ...cancellationReasons.map((reason) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: GestureDetector(
                              onTap: () {
                                selectedReason.value = reason;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: selectedReason.value == reason
                                      ? 16.h
                                      : 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedReason.value == reason
                                      ? accentPurple.withOpacity(0.1)
                                      : null,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: selectedReason.value == reason
                                        ? accentPurple
                                        : grey5F63,
                                    width:
                                        selectedReason.value == reason ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: montserrat(
                                            14, grey36, FontWeight.w500),
                                      ),
                                    ),
                                    if (selectedReason.value == reason)
                                      SvgPicture.asset(
                                        AppIcons.successCheck,
                                        height: 25.h,
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: NormalCustomButton(
                  label: l10n.submitCancelRide,
                  syncCallback: () async {
                    if (selectedReason.value == null) {
                      showErrorFlushBar(
                          message: l10n.selectCancellationReason,
                          context: context);
                      return;
                    }

                    // Show confirmation dialog
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          contentPadding: EdgeInsets.all(24.w),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // X icon
                              Container(
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 40.sp,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              // Title
                              Text(
                                l10n.cancelRideRequest,
                                style: montserrat(20, grey36, FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              // Message
                              Text(
                                l10n.cancelRideConfirmation,
                                style:
                                    montserrat(14, grey5F63, FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.h),
                              // Yes, Cancel button
                              NormalCustomButton(
                                label: l10n.yesCancel,
                                onPressed: () async {
                                  try {
                                    // Cancel the booking
                                    final bookingService = BookingService();
                                    final success =
                                        await bookingService.cancelBooking(
                                      booking: booking,
                                      reason: selectedReason.value!,
                                    );

                                    if (success) {
                                      log('Booking cancelled successfully');

                                      // Invalidate providers to refresh the UI
                                      ref.invalidate(userBookingsProvider);
                                      ref.invalidate(
                                          pendingAndActiveBookingsProvider);

                                      // Show success dialog and navigate
                                      if (context.mounted) {
                                        await AppDialogs.showSuccessDialog(
                                          context,
                                          title: l10n.rideCancelled,
                                          message: l10n.rideCancelledMessage,
                                          buttonText: l10n.okay,
                                          navigateBack:
                                              false, // Don't navigate back in dialog
                                        );
                                        context.go('/bottom_nav_bar');
                                      }
                                    } else {
                                      // Show error message
                                      if (context.mounted) {
                                        showErrorFlushBar(
                                          message:
                                              'Failed to cancel ride. Please try again.',
                                          context: context,
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    // Close loading dialog if it's open
                                    if (context.mounted &&
                                        Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }

                                    // Show error message
                                    if (context.mounted) {
                                      showErrorFlushBar(
                                        message:
                                            'An error occurred: ${e.toString()}',
                                        context: context,
                                      );
                                    }
                                  }
                                },
                              ),

                              SizedBox(height: 12.h),
                              // No, Don't Cancel button
                              NormalCustomButton(
                                label: l10n.noDontCancel,
                                buttonColor: Color(0xFFF3F8FE),
                                titleStyle:
                                    montserrat(16, grey5E5E5E, FontWeight.w500),
                                onPressed: () async {
                                  Navigator.of(context).pop(); // Close dialog
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
