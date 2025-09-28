import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class NameGenderScreen extends HookConsumerWidget {
  final String role;
  final String phoneNumber;
  
  const NameGenderScreen({
    super.key,
    required this.role,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final nameController = useTextEditingController();
    final selectedGender = useState<String?>(null);

    Future<void> onContinuePressed() async {
      if (nameController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.enterFullName,
          context: context,
        );
        return;
      }

      if (selectedGender.value == null) {
        showErrorFlushBar(
          message: l10n.selectGender,
          context: context,
        );
        return;
      }

      // Navigate to password screen
      if (context.mounted) {
        context.push('/password_creation', extra: {
          'role': role,
          'phoneNumber': phoneNumber,
          'name': nameController.text.trim(),
          'gender': selectedGender.value!,
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
              // Bottom section with name and gender
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
                              l10n.personalInformation,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            // Subtitle
                            Text(
                              l10n.chooseAccountType,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            // Name field
                            CustomTextField(
                              controller: nameController,
                              titleText: l10n.fullName,
                              hintText: l10n.enterFullName,
                              prefixIcon: AppIcons.userIcon,
                            ),
                            20.verticalSpace,
                            // Gender dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.gender,
                                  style: montserrat(14, grey36, FontWeight.w500),
                                ),
                                8.verticalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: borderGrey),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedGender.value,
                                      hint: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.userIcon, height: 20.h, width: 20.w, color: grey5F63),
                                          10.horizontalSpace,
                                          Text(l10n.selectGender, style: montserrat(14, grey5F63, FontWeight.w400)),
                                        ],
                                      ),
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: grey5F63),
                                      onChanged: (value) => selectedGender.value = value,
                                      items: [l10n.male, l10n.female].map<DropdownMenuItem<String>>((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item, style: montserrat(14, grey36, FontWeight.w500)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
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