import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';
import 'package:semester_student_ride_app/widgets/button.dart';

showSuccessFlushBar({required String message, required BuildContext context}) {
  return Flushbar(
    icon: const Icon(
      Icons.check_circle,
      color: Colors.black,
    ),
    shouldIconPulse: false,
    animationDuration: const Duration(seconds: 1),
    backgroundColor: Colors.green,
    messageText: Text(
      message,
      style: montserrat(12, black, FontWeight.w500),
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(0),
    flushbarStyle: FlushbarStyle.FLOATING,
    duration: const Duration(seconds: 3),
  ).show(context);
}

showErrorFlushBar({required String message, required BuildContext context}) {
  return Flushbar(
    icon: const Icon(
      Icons.cancel,
      color: Colors.black,
    ),
    shouldIconPulse: false,
    animationDuration: const Duration(seconds: 1),
    backgroundColor: Colors.red,
    messageText: Text(
      message,
      style: montserrat(12, whiteColor, FontWeight.w500),
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(0),
    flushbarStyle: FlushbarStyle.FLOATING,
    duration: const Duration(seconds: 3),
  ).show(context);
}

showValidationErrorsFlushBar(
    {required List<String> errors, required BuildContext context}) {
  return Flushbar(
    icon: const Icon(
      Icons.cancel,
      color: Colors.black,
    ),
    shouldIconPulse: false,
    animationDuration: const Duration(seconds: 1),
    backgroundColor: Colors.red,
    messageText: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please fix the following errors:',
          style: montserrat(12, whiteColor, FontWeight.w600),
        ),
        const SizedBox(height: 4),
        ...errors
            .map((error) => Text(
                  '• $error',
                  style: montserrat(12, whiteColor, FontWeight.w500),
                ))
            ,
      ],
    ),
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(0),
    flushbarStyle: FlushbarStyle.FLOATING,
    duration: const Duration(seconds: 4),
  ).show(context);
}

void showErrorAlertDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.white,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        actions: <Widget>[
          NormalCustomButton(
              syncCallback: () {
                Navigator.pop(context);
              },
              label: "Ok")
        ],
      );
    },
  );
}
