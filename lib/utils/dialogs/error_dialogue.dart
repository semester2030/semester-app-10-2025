import 'dart:ui';

import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

void showErrorDialog(
    BuildContext context, String errorTitle, String errorMessage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: whiteColor,
          elevation: 10,
          title: Text(
            errorTitle,
            style: montserrat(14, accentPurple, FontWeight.w600),
          ),
          content: Text(
            errorMessage,
            style: montserrat(12, Colors.redAccent, FontWeight.w500),
          ),
          actions: [
            NormalCustomButton(
              label: "Ok",
              syncCallback: () {
                Navigator.of(context).pop();
              },
              width: 100,
              height: 30,
              titleStyle: montserrat(12, whiteColor, FontWeight.w500),
            ),
          ],
        ),
      );
    },
  );
}
