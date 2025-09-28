import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverPhoneRegistrationScreen extends HookConsumerWidget {
  const DriverPhoneRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final phoneController = useTextEditingController();
    final isLoading = useState(false);

    Future<void> onContinuePressed() async {
      if (phoneController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseEnterYourPhoneNumber,
          context: context,
        );
        return;
      }

      if (phoneController.text.length < 9) {
        showErrorFlushBar(
          message: l10n.pleaseEnterValidPhoneNumber,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // TODO: Send OTP to phone number
        // For now, just navigate to OTP screen
        if (context.mounted) {
          context.push('/driver_otp_verification', extra: {
            'phoneNumber': '+966${phoneController.text}',
            'isFromDriverSignup': true,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: '${l10n.failedToSendOtp}: ${e.toString()}',
            context: context,
          );
        }
      } finally {
        isLoading.value = false;
      }
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
                          l10n.phoneNumber,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.enterYourPhoneNumberForVerification,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        32.verticalSpace,
                        
                        // Phone input
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: CustomTextField(
                              controller: phoneController,
                              titleText: l10n.phoneNumber,
                              hintText: l10n.enterYourPhoneNumber,
                              prefixIcon: 'assets/icons/phone.svg',
                            ),
                          ),
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
                                  l10n.weWillSendVerificationCode,
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
                            label: l10n.sendVerificationCode,
                            onPressed: isLoading.value ? null : onContinuePressed,
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
