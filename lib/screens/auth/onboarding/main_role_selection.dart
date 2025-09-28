import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class MainRoleSelectionScreen extends HookConsumerWidget {
  const MainRoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Local state for selection
    final selectedType = useState<String?>(null);

    Future<void> onTypeSelected(String type) async {
      selectedType.value = type;
      
      // Navigate based on selection
      if (type == 'customer') {
        context.push('/customer_role_dropdown');
      } else if (type == 'driver') {
        context.push('/driver_type_selection');
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
          // Top-right language toggle
          Positioned(
            top: 40.h,
            right: 16.w,
            child: _LanguageToggle(),
          ),
          
          Column(
            children: [
              // Top spacing
              130.verticalSpace,
              
              // Main illustration area
              Expanded(
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
              
              // Bottom section with role selection
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
                        // Title
                        Text(
                          AppLocalizations.of(context)!.chooseARole,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          AppLocalizations.of(context)!.selectAccordingToYourUses,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        40.verticalSpace,
                        
                        // Type selection buttons
                        Column(
                          children: [
                            // Customer button
                            _buildRoleButton(
                              context: context,
                              icon: AppIcons.userIcon,
                              title: AppLocalizations.of(context)!.iNeedTransport,
                              subtitle: AppLocalizations.of(context)!.customer,
                              isSelected: selectedType.value == 'customer',
                              onTap: () => onTypeSelected('customer'),
                            ),
                            
                            20.verticalSpace,
                            
                            // Driver button
                            _buildRoleButton(
                              context: context,
                              icon: AppIcons.driverIcon,
                              title: AppLocalizations.of(context)!.iProvideTransport,
                              subtitle: AppLocalizations.of(context)!.driverCompany,
                              isSelected: selectedType.value == 'driver',
                              onTap: () => onTypeSelected('driver'),
                            ),
                          ],
                        ),
                        
                        32.verticalSpace,
                        
                        // Continue button
                        NormalCustomButton(
                          label: AppLocalizations.of(context)!.continueButton,
                          onPressed: selectedType.value != null ? () async {
                            await onTypeSelected(selectedType.value!);
                          } : null,
                        ),
                        
                        20.verticalSpace,
                        
                        // Login option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.alreadyHaveAccount,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/login'),
                              child: Text(
                                AppLocalizations.of(context)!.login,
                                style: montserrat(14, accentPurple, FontWeight.w600),
                              ),
                            ),
                          ],
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

  Widget _buildRoleButton({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? accentPurple : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: isSelected ? accentPurple : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  width: 24.w,
                  height: 24.h,
                ),
              ),
            ),
            
            16.horizontalSpace,
            
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: montserrat(
                      16,
                      isSelected ? accentPurple : grey36,
                      FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: montserrat(
                      14,
                      isSelected ? accentPurple : grey5F63,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: isSelected ? accentPurple : Colors.grey.shade400,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageToggle extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(languageNotifierProvider);
    final notifier = ref.read(languageNotifierProvider.notifier);
    final isArabic = current.languageCode.toLowerCase() == 'ar';

    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: () async {
          final next = isArabic ? const Locale('en') : const Locale('ar');
          await notifier.changeLanguage(next.languageCode);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(Icons.language, color: Colors.white, size: 16.sp),
              6.horizontalSpace,
              Text(isArabic ? 'عربي' : 'EN', style: montserrat(12, Colors.white, FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
