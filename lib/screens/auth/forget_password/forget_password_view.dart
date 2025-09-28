import 'dart:developer' as dev;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/screens/auth/forget_password/provider/forget_password_provider.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Use the forget password notifier to handle state and validation
    final forgetPasswordNotifier =
        ref.watch(forgetPasswordNotifierProvider.notifier);
    final forgetPasswordState = ref.watch(forgetPasswordNotifierProvider);

    // Initialize controllers with state values
    final emailController =
        useTextEditingController(text: forgetPasswordState.email);

    useEffect(() {
      emailController.addListener(() {
        forgetPasswordNotifier.updateEmail(emailController.text);
      });

      return () {
        emailController.removeListener(() {});
      };
    }, []);

    Future<void> otpbuttonPressed() async {
      FocusScope.of(context).unfocus();

      showLoadingDialog(context, l10n.sendingOtp);

      try {
        final success =
            await forgetPasswordNotifier.sendPasswordResetEmail(context);

        Navigator.of(context).pop(); // Dismiss loading dialog

        if (success) {
          // Show success dialog
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                    SizedBox(width: 8),
                    Text(
                      l10n.ok,
                      style: montserrat(18, Colors.black, FontWeight.w600),
                    ),
                  ],
                ),
                content: Text(
                  l10n.otpSentToEmail,
                  style: montserrat(14, Colors.black87, FontWeight.w400),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pop(); // Go back to login screen
                    },
                    child: Text(
                      l10n.ok,
                      style: montserrat(14, accentPurple, FontWeight.w600),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        dev.log('Error sending password reset email: $e');
        showErrorDialog(context, l10n.error,
            "An unexpected error occurred. Please try again.");
      }
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
                  20.verticalSpace,
                  HeadingContainer(
                    title: l10n.forgotPasswordTitle,
                  ),
                  8.verticalSpace,
                  Text(
                    l10n.forgotPasswordDescription,
                    style: montserrat(14, grey5F63, FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  42.verticalSpace,
                  EmailTextField(
                      controller: emailController, titleText: l10n.email),
                  if (forgetPasswordState.emailError != null) ...[
                    8.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade600, size: 16.sp),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            forgetPasswordState.emailError ?? '',
                            style: montserrat(
                                12, Colors.red.shade600, FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                  30.verticalSpace,
                  NormalCustomButton(
                    label: "Send Reset Email",
                    syncCallback:
                        forgetPasswordState.isLoading ? null : otpbuttonPressed,
                  ),
                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.rememberPassword,
                        style: montserrat(14, grey5F63, FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          l10n.backToLogin,
                          style: montserrat(14, iconPurple, FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
