import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/on_boarding_index_indicator.dart';
import 'package:semester_student_ride_app/widgets/outline_button_widget.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class Onboarding3 extends HookConsumerWidget {
  const Onboarding3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    void movetoMainRoleSelection() {
      context.push('/main_role_selection');
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
              130.verticalSpace,
              // Main content - Logo
              Image.asset(
                AppImages.logo,
                width: 320.w,
                fit: BoxFit.contain,
              ),
              Spacer(),
              // Bottom section with description and button
              ClipPath(
                clipper: CircularTopClipper(),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25.w, 100.h, 25.w, 40.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.onboarding3Title,
                          style: montserrat(22, grey36, FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                        16.verticalSpace,
                        Text(
                          l10n.onboarding3Description,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        40.verticalSpace,

                        // Progress indicator
                        OnboardingProgressIndicator(currentIndex: 2),

                        40.verticalSpace,

                        // Next button
                        OutlineButtonWidget(
                          text: l10n.getStarted,
                          onPressed: movetoMainRoleSelection,
                          borderColor: accentPurple,
                          textColor: accentPurple,
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
