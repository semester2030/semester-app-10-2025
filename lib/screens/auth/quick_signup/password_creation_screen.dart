import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class PasswordCreationScreen extends HookConsumerWidget {
  final String role;
  final String phoneNumber;
  final String name;
  final String gender;
  
  const PasswordCreationScreen({
    super.key,
    required this.role,
    required this.phoneNumber,
    required this.name,
    required this.gender,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    // Local state (not used in current implementation)
    // final showPassword = useState(false);
    // final showConfirmPassword = useState(false);

    Future<void> onContinuePressed() async {
      if (passwordController.text.isEmpty) {
        showErrorFlushBar(
          message: l10n.newPasswordRequired,
          context: context,
        );
        return;
      }

      if (passwordController.text.length < 8) {
        showErrorFlushBar(
          message: l10n.passwordMinLength,
          context: context,
        );
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        showErrorFlushBar(
          message: l10n.passwordsDoNotMatch,
          context: context,
        );
        return;
      }

      // Navigate to location type screen
      if (context.mounted) {
        context.push('/location_type', extra: {
          'role': role,
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': passwordController.text,
        });
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
              // Bottom section with password creation
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
                              l10n.createPassword,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            // Subtitle
                            Text(
                              l10n.termsDescription,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            // Password field
                            PasswordTextField(
                              controller: passwordController,
                              titleText: l10n.password,
                            ),
                            20.verticalSpace,
                            // Confirm password field
                            PasswordTextField(
                              controller: confirmPasswordController,
                              titleText: l10n.confirmPassword,
                            ),
                            16.verticalSpace,
                            // Password requirements
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: accentPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.passwordMustContain,
                                    style: montserrat(12, grey36, FontWeight.w600),
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    '• ${l10n.atLeast8Characters}',
                                    style: montserrat(11, grey5F63, FontWeight.w400),
                                  ),
                                  Text(
                                    '• ${l10n.atLeastOneUppercase}',
                                    style: montserrat(11, grey5F63, FontWeight.w400),
                                  ),
                                  Text(
                                    '• ${l10n.atLeastOneLowercase}',
                                    style: montserrat(11, grey5F63, FontWeight.w400),
                                  ),
                                  Text(
                                    '• ${l10n.atLeastOneNumber}',
                                    style: montserrat(11, grey5F63, FontWeight.w400),
                                  ),
                                  Text(
                                    '• ${l10n.atLeastOneSpecialChar}',
                                    style: montserrat(11, grey5F63, FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            32.verticalSpace,
                            // Continue button
                            NormalCustomButton(
                              label: l10n.continueButton,
                              onPressed: onContinuePressed,
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
