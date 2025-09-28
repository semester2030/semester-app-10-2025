import 'dart:developer'
    as developer; // Use standard developer library if needed
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/screens/auth/login/provider/login_provider.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:semester_student_ride_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

import '../../../semester_student_ride_app_imports.dart';
import 'top_curve_clipper.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Use the login notifier to handle state and validation
    final loginNotifier = ref.watch(loginNotifierProvider.notifier);
    final loginState = ref.watch(loginNotifierProvider);

    // Initialize controllers with state values
    final emailController = useTextEditingController(text: loginState.email);
    final passwordController =
        useTextEditingController(text: loginState.password);

    useEffect(() {
      emailController.addListener(() {
        loginNotifier.updateEmail(emailController.text);
      });

      passwordController.addListener(() {
        loginNotifier.updatePassword(passwordController.text);
      });

      return () {
        emailController.removeListener(() {});
        passwordController.removeListener(() {});
      };
    }, []);

    void onSignUpPressed() {
      emailController.text = '';
      passwordController.text = '';
      loginNotifier.reset();
      ref.read(emailValidityNotifierProvider.notifier).reset();
      context.push('/user_driver_selection');
    }

    void onForgetPasswordPressed() {
      emailController.text = '';
      passwordController.text = '';
      loginNotifier.reset();
      ref.read(emailValidityNotifierProvider.notifier).reset();
      context.push('/forget_password');
    }

    Future<void> onLoginPressed() async {
      // Remove focus from text fields
      FocusScope.of(context).unfocus();

      // Check email field for test accounts first
      // final email = emailController.text.trim().toLowerCase();

      // if (email == 'driver@gmail.com') {
      //   // Navigate to bottom nav bar with driver mode (extra: true)
      //   context.go('/bottom_nav_bar', extra: true);
      //   return;
      // } else if (email == 'user@gmail.com') {
      //   // Navigate to bottom nav bar with user mode (extra: false)
      //   context.go('/bottom_nav_bar', extra: false);
      //   return;
      // }

      // For all other emails, use Firebase authentication
      try {
        // showLoadingDialog(context, l10n.loggingIn);

        final loginSuccess = await loginNotifier.login(context);

        // Dismiss loading dialog
        // if (context.mounted && Navigator.canPop(context)) {
        //   Navigator.of(context).pop();
        // }

        if (loginSuccess) {
          // Login successful - determine user type and navigate accordingly
          try {
            if (context.mounted) {
              // Navigate to bottom nav bar with appropriate user type
              ref.invalidate(currentAuthStateProvider);
            }
          } catch (e) {
            // If we can't determine user type, let auth state handle it
            developer.log('Error determining user type: $e');
          }
        } else {
          // Login failed - error is already set in the state
        }
      } catch (e) {
        // Dismiss loading dialog
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        // Show error dialog for unexpected errors
        if (context.mounted) {
          showErrorDialog(
            context,
            l10n.anErrorOccurred,
            l10n.errorTryAgain,
          );
        }
      }
    }

    return Scaffold(
        backgroundColor: accentPurple,
        body: Stack(children: [
          // Background SVG
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

                30.verticalSpace,
                Image.asset(AppImages.logo, width: 230.w, fit: BoxFit.cover),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to language change screen
                        context.push('/change_language');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final currentLocale =
                                    ref.watch(languageNotifierProvider);
                                return Text(
                                  currentLocale.languageCode == 'ar'
                                      ? l10n.arabic
                                      : l10n.english,
                                  style: montserrat(
                                      14, Colors.white, FontWeight.w500),
                                );
                              },
                            ),
                            8.horizontalSpace,
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                200.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 700.h, // Increased height for better proportions
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 300.h, 24.w, 32.h),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ...existing code...
                  HeadingContainer(
                    title: l10n.welcomeBack,
                  ),
                  12.verticalSpace,
                  Text(
                    l10n.loginDescription,
                    style: montserrat(16, grey5F63, FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  45.verticalSpace,
                  EmailTextField(
                      controller: emailController, titleText: l10n.email),
                  if (loginState.emailError != null) ...[
                    8.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade600, size: 16.sp),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            loginState.emailError ?? '',
                            style: montserrat(
                                12, Colors.red.shade600, FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                  20.verticalSpace,
                  PasswordTextField(
                      controller: passwordController, titleText: l10n.password),
                  if (loginState.passwordError != null) ...[
                    8.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 16.sp,
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            loginState.passwordError ?? '',
                            style: montserrat(
                                12, Colors.red.shade600, FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onForgetPasswordPressed,
                        child: Text(
                          l10n.forgotPassword,
                          style: montserrat(14, iconPurple, FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  32.verticalSpace,
                  NormalCustomButton(
                    label: loginState.isLoading ? l10n.loggingIn : l10n.login,
                    syncCallback: loginState.isLoading ? null : onLoginPressed,
                  ),

                  15.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontHaveAccount,
                        style: montserrat(14, grey5F63, FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: onSignUpPressed,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 2.h),
                          child: Text(
                            l10n.registerNow,
                            style: montserrat(14, iconPurple, FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
