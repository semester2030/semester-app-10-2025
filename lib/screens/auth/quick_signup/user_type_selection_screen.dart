import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class UserTypeSelectionScreen extends HookConsumerWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state for selection
    final selectedType = useState<String?>(null);

    Future<void> onTypeSelected(String type) async {
      selectedType.value = type;
      
      // Navigate based on selection
      if (type == 'customer') {
        context.push('/customer_role_dropdown');
      } else if (type == 'driver') {
        context.push('/signup_driver');
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
          
          SingleChildScrollView(
            child: Column(
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
                        // Old Logo (with graduation cap)
                        Container(
                          width: 300.w,
                          height: 200.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Old logo with graduation cap
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // White shield background
                                  Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                  // Graduation cap
                                  Positioned(
                                    top: 10.h,
                                    child: Icon(
                                      Icons.school,
                                      size: 40.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Network pattern (simplified)
                                  Positioned(
                                    bottom: 20.h,
                                    child: Container(
                                      width: 60.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        color: accentPurple.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              20.verticalSpace,
                              // App name
                              Text(
                                'Semester',
                                style: montserrat(24, Colors.white, FontWeight.w600),
                              ),
                              8.verticalSpace,
                              Text(
                                'نقل آمن وموثوق',
                                style: montserrat(16, Colors.white, FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        
                        40.verticalSpace,
                      ],
                    ),
                  ),
                ),
                
                // Bottom section with type selection
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
                          
                          // Type selection buttons
                          Column(
                            children: [
                              // Customer button
                              _buildTypeButton(
                                context: context,
                                icon: AppIcons.userIcon,
                                title: l10n.iNeedTransport,
                                subtitle: l10n.customer,
                                isSelected: selectedType.value == 'customer',
                                onTap: () => selectedType.value = 'customer',
                              ),
                              
                              20.verticalSpace,
                              
                              // Driver button
                              _buildTypeButton(
                                context: context,
                                icon: AppIcons.driverIcon,
                                title: l10n.iProvideTransport,
                                subtitle: l10n.driver,
                                isSelected: selectedType.value == 'driver',
                                onTap: () => selectedType.value = 'driver',
                              ),
                            ],
                          ),
                          
                          32.verticalSpace,
                          
                          // Continue button
                          NormalCustomButton(
                            label: l10n.continueButton,
                            onPressed: selectedType.value != null ? () async {
                              await onTypeSelected(selectedType.value!);
                            } : null,
                          ),
                          
                          20.verticalSpace,
                          
                          // Login option
                          TextButton(
                            onPressed: () => context.push('/login'),
                            child: Text(
                              l10n.login,
                              style: montserrat(14, accentPurple, FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
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
        height: 80.h,
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accentPurple : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isSelected ? accentPurple : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    color: isSelected ? Colors.white : Colors.grey,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}