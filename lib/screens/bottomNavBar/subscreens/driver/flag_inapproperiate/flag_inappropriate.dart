import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/widgets/circular_profile_image.dart';
import 'package:semester_student_ride_app/widgets/app_dialogs.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/services/report_service.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/providers/driver_bookings_provider.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';

class FlagInappropriate extends HookConsumerWidget {
  final RequestBookingModel booking;

  const FlagInappropriate({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedReason = useState<String?>(null);

    final reportReasons = [
      {'title': l10n.safetyConcern, 'subtitle': l10n.safetyConcernSubtitle},
      {'title': l10n.navigationRouteIssue, 'subtitle': null},
      {'title': l10n.invalidPickupDropoff, 'subtitle': null},
      {'title': l10n.noShowPassenger, 'subtitle': null},
      {'title': l10n.suspiciousActivity, 'subtitle': null},
      {'title': l10n.other, 'subtitle': null},
    ];
    return ScreenWithTopAppbar(
        title: l10n.flagAsInappropriate,
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
                        l10n.typeOfIssue,
                        style: montserrat(18, grey36, FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.reportCategorizeHelper,
                        style: montserrat(14, grey5F63, FontWeight.w400),
                      ),
                      SizedBox(height: 24.h),
                      ...reportReasons.map((reason) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: GestureDetector(
                              onTap: () {
                                selectedReason.value = reason['title'];
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical:
                                      selectedReason.value == reason['title']
                                          ? 16.h
                                          : 20.h,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedReason.value == reason['title']
                                      ? accentPurple.withOpacity(0.1)
                                      : null,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color:
                                        selectedReason.value == reason['title']
                                            ? accentPurple
                                            : grey5F63,
                                    width:
                                        selectedReason.value == reason['title']
                                            ? 2
                                            : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reason['title']!,
                                            style: montserrat(
                                                14, grey36, FontWeight.w500),
                                          ),
                                          if (reason['subtitle'] != null) ...[
                                            SizedBox(height: 4.h),
                                            Text(
                                              reason['subtitle']!,
                                              style: montserrat(12, grey5F63,
                                                  FontWeight.w400),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (selectedReason.value == reason['title'])
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
                  label: l10n.submitReport,
                  syncCallback: () async {
                    if (selectedReason.value == null) {
                      showErrorFlushBar(
                          message: l10n.pleaseSelectReportReason,
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
                              // Warning icon
                              Container(
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  color: Colors.orange[600],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                  size: 40.sp,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              // Title
                              Text(
                                l10n.submitReportQuestion,
                                style: montserrat(20, grey36, FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              // Message
                              Text(
                                l10n.submitReportConfirmation,
                                style:
                                    montserrat(14, grey5F63, FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.h),
                              // Yes, Submit button
                              NormalCustomButton(
                                label: l10n.yesSubmitReport,
                                onPressed: () async {
                                  Navigator.of(context).pop(); // Close dialog

                                  // Show loading dialog
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(width: 20),
                                              Text("Submitting report..."),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                  try {
                                    // Submit the report
                                    final reportService = ReportService();
                                    final reportSuccess =
                                        await reportService.reportBooking(
                                      booking: booking,
                                      reason: selectedReason.value!,
                                    );

                                    if (reportSuccess) {
                                      // Decline the booking after successful report
                                      final bookingService = BookingService();
                                      await bookingService.declineBooking(
                                        booking: booking,
                                        reason:
                                            'Reported as inappropriate: ${selectedReason.value}',
                                      );

                                      // Invalidate providers to refresh the UI
                                      ref.invalidate(driverBookingsProvider);
                                      ref.invalidate(userBookingsProvider);

                                      // Close loading dialog
                                      if (context.mounted &&
                                          Navigator.canPop(context)) {
                                        Navigator.of(context).pop();
                                      }

                                      // Show success dialog
                                      if (context.mounted) {
                                        await AppDialogs.showSuccessDialog(
                                          context,
                                          title: l10n.reportSubmitted,
                                          message:
                                              l10n.reportSubmittedSuccessfully,
                                          buttonText: l10n.ok,
                                          navigateBack: true,
                                        );
                                      }
                                    } else {
                                      // Close loading dialog
                                      if (context.mounted &&
                                          Navigator.canPop(context)) {
                                        Navigator.of(context).pop();
                                      }

                                      // Show error message
                                      if (context.mounted) {
                                        showErrorFlushBar(
                                          message:
                                              'Failed to submit report. Please try again.',
                                          context: context,
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    // Close loading dialog
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
                              // No, Cancel button
                              NormalCustomButton(
                                label: l10n.cancel,
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
