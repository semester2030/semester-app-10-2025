import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class PhoneRegistrationScreen extends HookConsumerWidget {
  final String role;
  
  const PhoneRegistrationScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final phoneController = useTextEditingController();
    final isLoading = useState(false);

    // Get role-specific data (not used in this screen but kept for future use)
    // final roleData = _getRoleData(role);

    Future<void> onContinuePressed() async {
      // For testing purposes - phone number is optional
      String phoneNumber = phoneController.text.trim();
      if (phoneNumber.isEmpty) {
        phoneNumber = '512345678'; // Default test number
        debugPrint('Using default test number: $phoneNumber');
        // Show success message for testing
        showSuccessFlushBar(
          message: l10n.phoneVerifiedAutomatically,
          context: context,
        );
      } else {
        // Validate phone number format if provided
        phoneNumber = phoneNumber.replaceAll(' ', '');
        if (!phoneNumber.startsWith('5') || phoneNumber.length != 9) {
          showErrorFlushBar(
            message: l10n.invalidPhoneNumber,
            context: context,
          );
          return;
        }
        debugPrint('Using provided phone number: $phoneNumber');
      }

      // Add country code
      String fullPhoneNumber = '+966$phoneNumber';

      try {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          context.push('/otp', extra: {
            'email': fullPhoneNumber, // Using phone as email for now
            'isFromSignup': true,
            'phoneNumber': fullPhoneNumber,
            'role': role, // Pass the role to OTP screen
          });
        }
      } catch (e) {
        showErrorFlushBar(
          message: l10n.failedToSendOtpEmail,
          context: context,
        );
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
              130.verticalSpace,
              // Main illustration area
              SizedBox(
                height: 200.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Real Old Logo
                      Image.asset(
                        AppImages.logo,
                        width: 230.w,
                        fit: BoxFit.cover,
                      ),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ),
              // Bottom section with phone registration
              Expanded(
                child: ClipPath(
                  clipper: CircularTopClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25.w, 100.h, 25.w, 40.h),
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
                              l10n.sendingOtp,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            // Phone number field
                            CustomTextField(
                              controller: phoneController,
                              titleText: l10n.phoneNumber,
                              hintText: '5X XXX XXXX',
                              prefixIcon: AppIcons.phoneIcon,
                              isPhoneField: true,
                              inputType: TextInputType.phone,
                            ),
                            32.verticalSpace,
                            // Continue button
                            NormalCustomButton(
                              label: l10n.continueButton,
                              onPressed: isLoading.value ? null : onContinuePressed,
                            ),
                            16.verticalSpace,
                            // Skip for testing button
                            TextButton(
                              onPressed: isLoading.value ? null : () {
                                phoneController.clear();
                                onContinuePressed();
                              },
                              child: Text(
                                l10n.ok,
                                style: montserrat(14, accentPurple, FontWeight.w500),
                              ),
                            ),
                            20.verticalSpace,
                            // Back button
                            TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                l10n.backToLogin,
                                style: montserrat(14, grey5F63, FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
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
