import 'dart:developer';

import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/forget_password/model/reset_password_model.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final passwordController = useTextEditingController();
    // final emailController = useTextEditingController();
    final confirmpasswordController = useTextEditingController();

    useEffect(() {
      return () {
        passwordController.removeListener(() {});
        confirmpasswordController.removeListener(() {});
      };
    }, []);

    // void showPasswordResetDialog() {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //         child: AlertDialog(
    //           backgroundColor: black,
    //           elevation: 10,
    //           title: Text(
    //             "Password Reset",
    //             style: montserrat(14, accentGold, FontWeight.w600),
    //           ),
    //           content: Text(
    //             "Your password has been reset successfully. Please login to continue.",
    //             style: montserrat(12, accentGold, FontWeight.w500),
    //           ),
    //           actions: [
    //             NormalCustomButton(
    //               label: "Ok",
    //               syncCallback: () {
    //                 Navigator.of(context).pop();
    //                 context.go('/login');
    //               },
    //               width: 100,
    //               height: 30,
    //               titleStyle: montserrat(12, black, FontWeight.w500),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    Future resetPassword() async {
      // if (!forgotPasswordNotifire.validateResetPasswordScreen()) {
      //   return; // Don't proceed if validation fails
      // }
      // showLoadingDialog(context, "Resetting password...");
      // // final errorMessages = [
      // //   if (emailController.text.isEmpty) "נדרש אימייל.",
      // //   if (!isEmailValid(emailController.text)) 'הכנס אימייל תקף.',
      // //   if (passwordController.text.isEmpty) "נדרשת סיסמה",
      // //   if (!validatePassword(passwordController.text)) 'הזן סיסמה חזקה',
      // //   if (passwordController.text.trim() !=
      // //       confirmpasswordController.text.trim())
      // //     "הסיסמאות אינן תואמות"
      // // ];
      // // if (errorMessages.isNotEmpty) {
      // //   return showErrorFlushBar(
      // //       message: errorMessages.first, context: context);
      // // }

      // final resetPasswordResponse = await forgotPasswordNotifire.resetPassword(
      //     email, passwordController.text);
      // if (resetPasswordResponse == Result.success) {
      // showPasswordResetDialog();
      context.go('/login');
      // showSuccessFlushBar(
      //     message: resetPasswordResponse['message'], context: context);
      // ref.read(emailValidityNotifierProvider.notifier).reset();
      // } else {
      //   showErrorDialog(
      //       context, 'Error occured', 'Error occured while resetting password');

      //   // if (!resetPasswordResponse['success']) {
      //   //   return showErrorFlushBar(
      //   //       message: resetPasswordResponse['message'], context: context);
      //   // }

      //   // showSuccessFlushBar(
      //   //     message: resetPasswordResponse['message'], context: context);
      //   // ref.read(emailValidityNotifierProvider.notifier).reset();
      // }
    }

    Widget buildRequirement(String text) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 20.h,
                width: 20.h,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: accentPurple),
                child: Icon(Icons.check, color: whiteColor, size: 15)),
            12.horizontalSpace,
            Expanded(
              child: Text(
                text,
                style: montserrat(14, grey36, FontWeight.w400),
              ),
            ),
          ],
        ),
      );
    }

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
                40.verticalSpace,

                Row(
                  children: [
                    20.horizontalSpace,
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: SvgPicture.asset(AppIcons.back, color: whiteColor),
                    )
                  ],
                ),
                Image.asset(AppImages.logo, width: 230.w, fit: BoxFit.cover),

                210.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 600.h,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 360.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeadingContainer(
                    title: l10n.setNewPassword,
                  ),

                  20.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.passwordMustContain,
                      style: montserrat(16, grey36, FontWeight.w500),
                    ),
                  ),
                  10.verticalSpace,
                  buildRequirement(l10n.atLeast8Characters),
                  buildRequirement(l10n.atLeastOneUppercase),
                  buildRequirement(l10n.atLeastOneLowercase),
                  buildRequirement(l10n.atLeastOneNumber),
                  buildRequirement(l10n.atLeastOneSpecialChar),

                  22.verticalSpace,
                  PasswordTextField(
                      controller: passwordController,
                      titleText: l10n.newPassword),
                  // forgotPasswordState.passwordError != null
                  //     ? Padding(
                  //         padding: EdgeInsets.only(top: 5.h),
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               forgotPasswordState.passwordError ?? '',
                  //               style:
                  //                   montserrat(12, Colors.red, FontWeight.w400),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  20.verticalSpace,
                  PasswordTextField(
                      controller: confirmpasswordController,
                      titleText: l10n.confirmPassword),

                  // forgotPasswordState.confirmPasswordError != null
                  //     ? Padding(
                  //         padding: EdgeInsets.only(top: 5.h),
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               forgotPasswordState.confirmPasswordError ?? '',
                  //               style:
                  //                   montserrat(12, Colors.red, FontWeight.w400),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),
                  30.verticalSpace,
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         agreePrivacy.value = !agreePrivacy.value;
                  //       },
                  //       child: Container(
                  //           height: 20.h,
                  //           width: 20.h,
                  //           padding: const EdgeInsets.all(3),
                  //           decoration: BoxDecoration(
                  //               border: Border.all(
                  //                   color: agreePrivacy.value
                  //                       ? purple1A0C47
                  //                       : greyA0A),
                  //               color: agreePrivacy.value
                  //                   ? purple1A0C47
                  //                   : null,
                  //               borderRadius: BorderRadius.circular(5)),
                  //           child: agreePrivacy.value
                  //               ? SvgPicture.asset(
                  //                   AppIcons.selected,
                  //                   color: whiteColor,
                  //                 )
                  //               : null),
                  //     ),
                  //     10.horizontalSpace,
                  //     Expanded(
                  //       child: RichText(
                  //         text: TextSpan(
                  //           style: montserrat(11, purple1E,
                  //               FontWeight.w400), // Default text style
                  //           children: [
                  //             const TextSpan(text: "I accept the "),
                  //             TextSpan(
                  //               text: "Terms and Conditions",
                  //               style: montserrat(
                  //                       11, darkBlue, FontWeight.w400)
                  //                   .copyWith(
                  //                       decoration:
                  //                           TextDecoration.underline),
                  //               recognizer: TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   // Navigate to Terms & Conditions Page
                  //                   print(
                  //                       "Terms and Conditions Clicked");
                  //                   // You can use Navigator.push() to go to a new screen
                  //                 },
                  //             ),
                  //             const TextSpan(text: " and "),
                  //             TextSpan(
                  //               text: "Privacy Policy",
                  //               style: montserrat(
                  //                       11, darkBlue, FontWeight.w400)
                  //                   .copyWith(
                  //                       decoration:
                  //                           TextDecoration.underline),
                  //               recognizer: TapGestureRecognizer()
                  //                 ..onTap = () {
                  //                   // Navigate to Privacy Policy Page
                  //                   print("Privacy Policy Clicked");
                  //                 },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  NormalCustomButton(
                    label: l10n.saveAndGoToLogin,
                    syncCallback: resetPassword,
                  ),
                  15.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
