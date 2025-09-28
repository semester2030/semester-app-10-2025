import 'dart:async';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverOtpVerificationScreen extends HookConsumerWidget {
  final String phoneNumber;
  final bool isFromDriverSignup;
  
  const DriverOtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.isFromDriverSignup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final otpController = useTextEditingController();
    final isLoading = useState(false);
    final timeLeft = useState<int>(300); // 5 minutes
    final canResend = useState(false);

    // Timer for countdown
    useEffect(() {
      if (timeLeft.value > 0) {
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (timeLeft.value > 0) {
            timeLeft.value--;
          } else {
            canResend.value = true;
            timer.cancel();
          }
        });
        
        return () => timer.cancel();
      }
      return null;
    }, []);

    Future<void> onVerifyPressed() async {
      if (otpController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseEnterTheVerificationCode,
          context: context,
        );
        return;
      }

      if (otpController.text.length != 6) {
        showErrorFlushBar(
          message: l10n.pleaseEnterValid6DigitCode,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // TODO: Verify OTP with backend
        // For now, just navigate to next screen
        if (context.mounted) {
          context.push('/driver_personal_info', extra: {
            'phoneNumber': phoneNumber,
            'isFromDriverSignup': isFromDriverSignup,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Verification failed: ${e.toString()}',
            context: context,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> onResendPressed() async {
      if (!canResend.value) return;
      
      try {
        isLoading.value = true;
        
        // TODO: Resend OTP
        showSuccessFlushBar(
          message: l10n.verificationCodeSentSuccessfully,
          context: context,
        );
        
        timeLeft.value = 300;
        canResend.value = false;
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Failed to resend code: ${e.toString()}',
            context: context,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    String formatTime(int seconds) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          // Background SVG
          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          
          Column(
            children: [
              // Top spacing
              80.verticalSpace,
              
              // Main illustration area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        AppImages.logo,
                        width: 160.w,
                        height: 60.h,
                        fit: BoxFit.contain,
                      ),
                      
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
              
              // Bottom section with form
              ClipPath(
                clipper: CircularTopClipper(),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(25.w, 60.h, 25.w, 40.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          l10n.verificationCode,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.enter6DigitCodeSentTo(phoneNumber),
                          textAlign: TextAlign.center,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                        ),
                        
                        32.verticalSpace,
                        
                        // OTP input
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomTextField(
                              controller: otpController,
                              titleText: l10n.verificationCode,
                              hintText: l10n.enter6DigitCode,
                              prefixIcon: 'assets/icons/security.svg',
                            ),
                          ),
                        ),
                        
                        24.verticalSpace,
                        
                        // Timer and resend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (timeLeft.value > 0) ...[
                              Icon(
                                Icons.timer,
                                color: Colors.grey.shade600,
                                size: 16.sp,
                              ),
                              
                              4.horizontalSpace,
                              
                              Text(
                                l10n.resendCodeIn(formatTime(timeLeft.value)),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ] else ...[
                              GestureDetector(
                                onTap: onResendPressed,
                                child: Text(
                                  l10n.resendCode,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: accentPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        
                        24.verticalSpace,
                        
                        // Info text
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: accentPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: accentPurple,
                                size: 20.sp,
                              ),
                              
                              8.horizontalSpace,
                              
                              Expanded(
                                child: Text(
                                  l10n.checkYourSMSMessagesForVerificationCode,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: accentPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        32.verticalSpace,
                        
                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          child: NormalCustomButton(
                            label: l10n.verifyCode,
                            onPressed: isLoading.value ? null : onVerifyPressed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
