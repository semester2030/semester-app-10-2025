import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'dart:ui';

class AppDialogs {
  // Loading dialog
  static Future<void> showLoadingDialog(BuildContext context,
      {String message = 'Loading...'}) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: black,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentPurple),
                ),
                20.verticalSpace,
                Text(
                  message,
                  style: montserrat(16, accentPurple, FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Success dialog
  static Future<void> showSuccessDialog(
    BuildContext context, {
    String title = 'Success!',
    String message = 'Operation completed successfully.',
    String buttonText = 'Great!',
    bool navigateBack = true,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: whiteColor,
            title: Row(
              children: [
                Text(
                  title,
                  style: montserrat(18, grey36, FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: montserrat(14, grey5F63, FontWeight.w400),
                ),
              ],
            ),
            actions: [
              NormalCustomButton(
                label: "Ok",
                titleStyle: montserrat(12, whiteColor, FontWeight.w500),
                syncCallback: () {
                  Navigator.pop(context); // Close dialog
                  if (navigateBack) {
                    Navigator.pop(context); // Navigate back
                  }
                },
                height: 30,
                width: 80,
              )
            ],
          ),
        );
      },
    );
  }

  // Error dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    String title = 'Error',
    String message = 'An error occurred. Please try again.',
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: black,
            title: Row(
              children: [
                Text(
                  title,
                  style: montserrat(18, accentPurple, FontWeight.w600),
                ),
              ],
            ),
            content: Text(
              message,
              style: montserrat(14, Colors.red, FontWeight.w400),
            ),
            actions: [
              NormalCustomButton(
                label: "Ok",
                syncCallback: () {
                  Navigator.pop(context);
                },
                height: 30,
                width: 50,
              )
            ],
          ),
        );
      },
    );
  }

  // Accept Booking Confirmation Dialog
  static Future<void> showAcceptBookingDialog(
    BuildContext context, {
    String studentName = 'the student',
    VoidCallback? onGoToBooking,
    VoidCallback? onGoToHome,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  30.verticalSpace,
                  // Success checkmark icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: accentPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: whiteColor,
                      size: 40.sp,
                    ),
                  ),

                  24.verticalSpace,

                  // Congratulations title
                  Text(
                    'Congratulation!',
                    style: montserrat(24, accentPurple, FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),

                  16.verticalSpace,

                  // Success message
                  Text(
                    'Great news! Your offer for a new trip with $studentName.',
                    style: montserrat(14, grey5F63, FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),

                  32.verticalSpace,

                  // Go to Booking button
                  NormalCustomButton(
                    label: 'Go to Booking',
                    titleStyle: montserrat(16, whiteColor, FontWeight.w500),
                    height: 50,
                    syncCallback: () {
                      Navigator.pop(context); // Close dialog
                      if (onGoToBooking != null) {
                        onGoToBooking();
                      }
                    },
                  ),

                  16.verticalSpace,

                  // Home button
                  NormalCustomButton(
                    label: 'Home',
                    titleStyle: montserrat(16, grey5E5E5E, FontWeight.w500),
                    buttonColor: containerbackground,
                    height: 50,
                    syncCallback: () {
                      Navigator.pop(context); // Close dialog
                      if (onGoToHome != null) {
                        onGoToHome();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Decline Booking Confirmation Dialog
  static Future<void> showDeclineBookingDialog(
    BuildContext context, {
    VoidCallback? onGoToNewBooking,
    VoidCallback? onGoToHome,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  30.verticalSpace,
                  // Decline X icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: grey36,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: whiteColor,
                      size: 40.sp,
                    ),
                  ),

                  24.verticalSpace,

                  // Offer Declined title
                  Text(
                    'Offer Declined',
                    style: montserrat(24, grey36, FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),

                  16.verticalSpace,

                  // Decline message
                  Text(
                    'This ride offer has been declined. The passenger is being re-matched with another driver.',
                    style: montserrat(14, grey5F63, FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),

                  32.verticalSpace,

                  // Go to new Booking button
                  NormalCustomButton(
                    label: 'Go to new Booking',
                    titleStyle: montserrat(16, whiteColor, FontWeight.w500),
                    height: 50,
                    syncCallback: () {
                      Navigator.pop(context); // Close dialog
                      if (onGoToNewBooking != null) {
                        onGoToNewBooking();
                      }
                    },
                  ),

                  16.verticalSpace,

                  // Home button
                  NormalCustomButton(
                    label: 'Home',
                    titleStyle: montserrat(16, grey5E5E5E, FontWeight.w500),
                    buttonColor: containerbackground,
                    height: 50,
                    syncCallback: () {
                      Navigator.pop(context); // Close dialog
                      if (onGoToHome != null) {
                        onGoToHome();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
