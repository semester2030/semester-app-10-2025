import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverTypeSelectionScreen extends HookConsumerWidget {
  const DriverTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final selectedType = useState<String?>(null);
    final isLoading = useState(false);

    Future<void> onContinuePressed() async {
      if (selectedType.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectDriverType,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // Navigate based on selected type
        if (selectedType.value == 'individual') {
          // Navigate to driver-specific phone registration
          if (context.mounted) {
            context.push('/driver_phone_registration');
          }
        } else if (selectedType.value == 'company') {
          // Navigate to company registration
          if (context.mounted) {
            context.push('/company_registration');
          }
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: '${l10n.navigationFailed}: ${e.toString()}',
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
              130.verticalSpace,
              
              // Main illustration area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
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
                          l10n.chooseDriverType,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.selectHowToRegisterAsDriver,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        40.verticalSpace,
                        
                        // Type selection buttons
                        Column(
                          children: [
                            // Individual driver button
                            _buildDriverTypeButton(
                              context: context,
                              icon: Icons.person,
                              title: l10n.iProvideTransport,
                              subtitle: l10n.individualDriver,
                              isSelected: selectedType.value == 'individual',
                              onTap: () => selectedType.value = 'individual',
                            ),
                            
                            16.verticalSpace,
                            
                            // Company driver button
                            _buildDriverTypeButton(
                              context: context,
                              icon: Icons.business,
                              title: l10n.iRepresentCompany,
                              subtitle: l10n.companyDriver,
                              isSelected: selectedType.value == 'company',
                              onTap: () => selectedType.value = 'company',
                            ),
                          ],
                        ),
                        
                        40.verticalSpace,
                        
                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          child: NormalCustomButton(
                            label: l10n.continueButton,
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

  Widget _buildDriverTypeButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accentPurple : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected ? accentPurple : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            
            16.horizontalSpace,
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? accentPurple : Colors.black87,
                    ),
                  ),
                  
                  4.verticalSpace,
                  
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: accentPurple,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}
