import 'dart:ui';
import '../../semester_student_ride_app_imports.dart';

/// Shows a loading dialog with a message
///
/// This dialog is non-dismissible and shows a loading indicator with a message
void showLoadingDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: whiteColor,
          content: Row(
            children: [
              LoadingAnimationWidget.discreteCircle(
                  color: accentPurple,
                  size: 40.h,
                  secondRingColor: accentPurple,
                  thirdRingColor: accentPurple),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  message,
                  style: montserrat(16, accentPurple, FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
