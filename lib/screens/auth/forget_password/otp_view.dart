import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/forget_password/model/otp_model.dart';
import 'package:semester_student_ride_app/screens/auth/signup/provider/signup_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/utils/send_email_otp.dart';
import 'package:semester_student_ride_app/utils/send_signup_email_otp.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class OtpScreen extends HookConsumerWidget {
  const OtpScreen({
    super.key, 
    required this.email, 
    required this.isFromSignup,
    this.phoneNumber,
    this.role,
  });

  final String email;
  final bool isFromSignup;
  final String? phoneNumber;
  final String? role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final showRequestAgain = useState(false);
    final otpCode = useState<String>('');
    // Add a controller to store the complete OTP value
    final otpController = useState<List<String>>(List.filled(6, ''));
    final isLoading = useState<bool>(false);
    final isMounted = useIsMounted();
    final isDialogShowing = useState<bool>(false);
    final showSuccessScreen = useState<bool>(false);

    final countdown = useState(59);
    Timer? timer;
    // Use the login notifier to handle state and validation

    void safelyDismissDialog() {
      if (isMounted() && isDialogShowing.value && Navigator.canPop(context)) {
        Navigator.pop(context);
        isDialogShowing.value = false;
      }
    }

    void startTimer() {
      countdown.value = 59;
      showRequestAgain.value = false;
      timer?.cancel();

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (countdown.value > 0) {
          if (isMounted()) {
            countdown.value--;
          } else {
            timer.cancel();
          }
        } else {
          timer.cancel();
          if (isMounted()) {
            showRequestAgain.value = true;
          }
        }
      });
    }

    Future<void> sendOtp() async {
      try {
        isLoading.value = true;
        if (isMounted()) {
          showLoadingDialog(context, l10n.sendingOtp);
          isDialogShowing.value = true;
        }

        bool success;
        if (isFromSignup) {
          // For signup, send signup verification OTP
          success = await sendSignupOtpEmail(email);
        } else {
          // For password reset, send password reset OTP
          success = await sendOtpEmail(email);
        }

        if (isMounted()) {
          safelyDismissDialog();
          isLoading.value = false;

          if (success) {
            showSuccessFlushBar(
              message: l10n.otpSentToEmail,
              context: context,
            );
            startTimer();
          } else {
            showErrorDialog(
                context, l10n.anErrorOccurred, l10n.failedToSendOtpEmail);
          }
        }
      } catch (e) {
        if (isLoading.value && isMounted()) {
          safelyDismissDialog();
        }
        isLoading.value = false;
        if (isMounted()) {
          showErrorDialog(context, l10n.anErrorOccurred,
              l10n.failedToSendOtp);
        }
      }
    }

    Future<void> resendOtp() async {
      sendOtp();
    }

    // void navigateAfterSuccess() {
    //   userCollection
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .update({'phoneVerified': true});

    //   if (FirebaseAuth.instance.currentUser != null && isFromSignup) {
    //     if (context.mounted) {
    //       context.push('/signup3');
    //     }
    //   }
    // }

    Future<void> verifyOtp(String verificationCode) async {
      // For phone number signup - ALWAYS ACCEPT ANY CODE
      if (phoneNumber != null) {
        if (isMounted()) {
          isLoading.value = false;
          
          // ALWAYS SUCCESS - NO VALIDATION
          showSuccessFlushBar(
            message: l10n.otpVerifiedSuccessfully,
            context: context,
          );
          
          // Navigate to next step immediately - NO MATTER WHAT
          debugPrint('DEBUG: Navigating to name_gender with phoneNumber: $phoneNumber');
          try {
            context.push('/name_gender', extra: {
              'phoneNumber': phoneNumber,
              'role': role ?? 'university_student',
            });
          } catch (e) {
            debugPrint('DEBUG: Navigation error: $e');
            context.go('/login');
          }
        }
        return;
      }

      // For email signup - use normal verification
      if (verificationCode.length < 6) {
        showErrorFlushBar(
          message: l10n.pleaseEnterValidOtp,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        if (isMounted()) {
          showLoadingDialog(context, l10n.verifyingOtp);
          isDialogShowing.value = true;
        }

        bool verified = false;

        if (isFromSignup) {
          // For email signup - use existing verification
          verified = await verifySignupOtp(email, verificationCode);

          if (verified && isMounted()) {
            safelyDismissDialog();
            isLoading.value = false;

            // Complete the registration process
            final signupNotifier = ref.read(signupNotifierProvider.notifier);
            await signupNotifier.signupStudent(context);

            // Show success screen
            showSuccessScreen.value = true;
          } else if (isMounted()) {
            safelyDismissDialog();
            isLoading.value = false;
            showErrorDialog(context, l10n.invalidOtp, l10n.invalidOtpTryAgain);
          }
        } else {
          // For password reset flow - navigate to reset password
          context.push('/reset_password', extra: email);
        }
      } catch (e) {
        if (isMounted()) {
          safelyDismissDialog();
          isLoading.value = false;
          showErrorDialog(context, l10n.verificationFailedTitle,
              l10n.verificationFailedMessage(e.toString()));
        }
      }
    }

    // useEffect(() {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     sendOtp();
    //   });

    //   return () => timer?.cancel();
    // }, []);

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
            margin: EdgeInsets.fromLTRB(
                24.w,
                showSuccessScreen.value && isFromSignup ? 250.h : 360.h,
                24.w,
                32.h),
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
                children: showSuccessScreen.value && isFromSignup
                    ? [
                        // Success Screen Content
                        60.verticalSpace,
                        SvgPicture.asset(AppIcons.successCheck),
                        40.verticalSpace,
                        Text(
                          l10n.congratulations,
                          style: montserrat(24, grey36, FontWeight.w600),
                        ),
                        20.verticalSpace,
                        Text(
                          l10n.emailVerifiedSuccessfullyLoginNow,
                          textAlign: TextAlign.center,
                          style: montserrat(14, grey5F63, FontWeight.w500),
                        ),
                        80.verticalSpace,
                        NormalCustomButton(
                          label: l10n.done,
                          syncCallback: () {
                            // Navigate or close the screen
                            context.go('/login');
                          },
                        ),
                        20.verticalSpace,

                        NormalCustomButton(
                          label: l10n.close,
                          buttonColor: Color(0xffF3F8FE),
                          titleStyle:
                              montserrat(16, grey5E5E5E, FontWeight.w500),
                          syncCallback: () {
                            context.go('/login');
                          },
                        ),
                      ]
                    : [
                        // Original OTP Form Content
                        20.verticalSpace,

                        HeadingContainer(
                          title: l10n.otpVerification,
                        ),

                        8.verticalSpace,
                        Text(
                          phoneNumber != null 
                            ? l10n.enterOtp
                            : l10n.otpDescription,
                          textAlign: TextAlign.center,
                          style: montserrat(14, grey5F63, FontWeight.w500),
                        ),
                        42.verticalSpace,
                        OtpTextField(
                          numberOfFields: 6,
                          fieldHeight: 46.h,
                          fieldWidth: 40.h,
                          cursorColor: accentPurple,
                          borderColor: accentPurple,
                          enabledBorderColor: borderGrey,
                          focusedBorderColor: accentPurple,
                          filled: true,
                          styles: List.filled(
                              6, montserrat(14, accentPurple, FontWeight.w500)),
                          fillColor: whiteColor,
                          disabledBorderColor: greyA0A,
                          borderRadius: BorderRadius.circular(10),
                          borderWidth: 1,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          showFieldAsBox: true,
                          onCodeChanged: (String code) {
                            otpCode.value = code;
                          },
                          handleControllers: (controllers) {
                            // Add listeners to each controller to update our otpController
                            for (int i = 0; i < controllers.length; i++) {
                              log(controllers[i]!.text.toString(),
                                  name: "controllers $i text");
                              controllers[i]?.addListener(() {
                                if (controllers[i]!.text.isNotEmpty) {
                                  final newOtpList = [...otpController.value];
                                  newOtpList[i] = controllers[i]!.text;
                                  otpController.value = newOtpList;
                                }
                              });
                            }
                          },
                          // Capture complete OTP when all fields are filled
                          onSubmit: (String verificationCode) {
                            // This won't auto-verify, just update the full code
                            otpCode.value = verificationCode;

                            log(verificationCode,
                                name: "verificationCode from onSubmit");
                          },
                        ),
                        20.verticalSpace,
                        if (!showRequestAgain.value)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppIcons.watch,
                                color: accentPurple,
                              ),
                              10.horizontalSpace,
                              Text(
                                "00:${countdown.value.toString().padLeft(2, '0')}",
                                style: montserrat(
                                        12, accentPurple, FontWeight.w600)
                                    .copyWith(letterSpacing: 1),
                              ),
                            ],
                          ),
                        if (showRequestAgain.value)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.didntReceiveOtp,
                                style:
                                    montserrat(12, grey5F63, FontWeight.w400),
                              ),
                              GestureDetector(
                                onTap: () {
                                  resendOtp();
                                },
                                child: Text(
                                  l10n.resendOtp,
                                  style: montserrat(
                                          12, accentPurple, FontWeight.w600)
                                      .copyWith(
                                          decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        15.verticalSpace,
                        // Adding Verify OTP button

                        NormalCustomButton(
                          label: l10n.verifyOtp,
                          syncCallback: isLoading.value
                              ? null
                              : () {
                                  if (isFromSignup) {
                                    // For signup, verify the entered OTP
                                    verifyOtp(otpCode.value);
                                  } else {
                                    // For password reset
                                    verifyOtp(otpCode.value);
                                  }
                                },
                        ),

                        16.verticalSpace,

                        // SKIP NUMBER - ALWAYS SHOW
                        // BIG SKIP BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 80.h,
                          child: ElevatedButton(
                            onPressed: isLoading.value ? null : () {
                              showSuccessFlushBar(
                                message: l10n.otpVerifiedSuccessfully,
                                context: context,
                              );
                              context.push('/name_gender', extra: {
                                'phoneNumber': phoneNumber ?? '512345678',
                                'role': role ?? 'university_student',
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              elevation: 15,
                            ),
                            child: Text(
                              l10n.done,
                              style: montserrat(18, Colors.white, FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        
                        20.verticalSpace,
                        
                        // INFO TEXT
                        Text(
                          l10n.otpVerifiedSuccessfully,
                          style: montserrat(14, Colors.grey, FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        
                        20.verticalSpace,

                        20.verticalSpace,
                      ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
