import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class CustomerRoleDropdownScreen extends HookConsumerWidget {
  const CustomerRoleDropdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Local state for role selection
    final selectedRole = useState<String?>(null);
    final isDropdownOpen = useState<bool>(false);

    // Available roles with their details
    final l10n = AppLocalizations.of(context)!;
    final roles = [
      {
        'key': 'school_student',
        'title': l10n.schoolStudent,
        'subtitle': l10n.viaParent,
        'icon': AppIcons.studentCap,
        'description': l10n.transportVisibleOnlyViaParent,
      },
      {
        'key': 'university_student',
        'title': l10n.universityStudent,
        'subtitle': l10n.universityInstituteStudent,
        'icon': AppIcons.studentCap,
        'description': l10n.seeUniversityTransportCard,
      },
      {
        'key': 'teacher',
        'title': l10n.teacher,
        'subtitle': l10n.teacherRole,
        'icon': AppIcons.teacherBag,
        'description': l10n.seeTeacherTransportCard,
      },
      {
        'key': 'employee',
        'title': l10n.employee,
        'subtitle': l10n.employeeRole,
        'icon': AppIcons.femaleEmployee,
        'description': l10n.seeEmployeeTransportCard,
      },
      {
        'key': 'metro_user',
        'title': l10n.metroShuttleUser,
        'subtitle': l10n.metroShuttle,
        'icon': AppIcons.bus,
        'description': l10n.seeMetroShuttleCard,
      },
    ];

    void onRoleSelected(String roleKey) {
      selectedRole.value = roleKey;
      isDropdownOpen.value = false;
    }

    Future<void> onContinuePressed() async {
      if (selectedRole.value != null) {
        // Navigate to phone registration screen
        context.push('/phone_registration', extra: selectedRole.value);
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
            
              // Bottom section with role selection
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
                              l10n.selectRole,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            
                            16.verticalSpace,
                            
                            // Subtitle
                            Text(
                              l10n.minimalProfile,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            
                            40.verticalSpace,
                            
                            // Role dropdown
                            _buildRoleDropdown(
                              context: context,
                              roles: roles,
                              selectedRole: selectedRole.value,
                              isOpen: isDropdownOpen.value,
                              onToggle: () => isDropdownOpen.value = !isDropdownOpen.value,
                              onRoleSelected: onRoleSelected,
                            ),
                            
                            40.verticalSpace,
                            
                            // Continue button
                            NormalCustomButton(
                              label: l10n.continueButton,
                              onPressed: selectedRole.value != null ? onContinuePressed : null,
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

  Widget _buildRoleDropdown({
    required BuildContext context,
    required List<Map<String, String>> roles,
    required String? selectedRole,
    required bool isOpen,
    required VoidCallback onToggle,
    required Function(String) onRoleSelected,
  }) {
    return Column(
      children: [
        // Selected role display
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: accentPurple, width: 2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      selectedRole != null 
                          ? roles.firstWhere((r) => r['key'] == selectedRole)['icon']!
                          : AppIcons.userIcon,
                      color: accentPurple,
                      width: 20.w,
                      height: 20.h,
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
                        selectedRole != null 
                            ? roles.firstWhere((r) => r['key'] == selectedRole)['title']!
                            : 'Select Your Role',
                        style: montserrat(
                          16,
                          selectedRole != null ? grey36 : grey5F63,
                          FontWeight.w600,
                        ),
                      ),
                      if (selectedRole != null) ...[
                        4.verticalSpace,
                        Text(
                          roles.firstWhere((r) => r['key'] == selectedRole)['subtitle']!,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Dropdown arrow
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: accentPurple,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
        
        // Dropdown options
        if (isOpen) ...[
          8.verticalSpace,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: roles.map((role) => _buildRoleOption(
                context: context,
                role: role,
                isSelected: selectedRole == role['key'],
                onTap: () => onRoleSelected(role['key']!),
              )).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRoleOption({
    required BuildContext context,
    required Map<String, String> role,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isSelected ? accentPurple : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  role['icon']!,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  width: 20.w,
                  height: 20.h,
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
                    role['title']!,
                    style: montserrat(
                      16,
                      isSelected ? accentPurple : grey36,
                      FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    role['subtitle']!,
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
                size: 20.sp,
              ),
          ],
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