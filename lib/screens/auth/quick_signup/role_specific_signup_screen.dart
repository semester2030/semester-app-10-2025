import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class RoleSpecificSignupScreen extends HookConsumerWidget {
  final String role;
  
  const RoleSpecificSignupScreen({
    super.key,
    required this.role,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Controllers
    final nameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    
    // Local state
    final selectedCity = useState<String?>(null);
    final selectedInstitution = useState<String?>(null);
    final selectedTransportType = useState<String?>(null);
    final isLoading = useState(false);

    // Get role-specific data
    final roleData = _getRoleData(role);
    final cities = _getCities();
    final institutions = selectedCity.value != null 
        ? _getInstitutions(selectedCity.value!) 
        : <String>[];

    Future<void> onSignUpPressed() async {
      if (nameController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.enterFullName,
          context: context,
        );
        return;
      }

      if (passwordController.text.length < 6) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
        return;
      }

      if (selectedCity.value == null) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
        return;
      }

      if (selectedInstitution.value == null) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
        return;
      }

      if (selectedTransportType.value == null) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
        return;
      }

      isLoading.value = true;

      try {
        // TODO: Implement actual signup logic
        await Future.delayed(Duration(seconds: 2)); // Simulate API call
        
        showSuccessFlushBar(
          message: l10n.continueButton,
          context: context,
        );
        
        // Navigate to main app
        context.go('/main');
      } catch (e) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: accentPurple,
      appBar: AppBar(
        backgroundColor: accentPurple,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.continueButton,
          style: montserrat(18, Colors.white, FontWeight.w600),
        ),
      ),
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
                20.verticalSpace,
                
                // Bottom section with form
                ClipPath(
                  clipper: CircularTopClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25.w, 40.h, 25.w, 40.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Role header
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: accentPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  roleData['icon'],
                                  width: 32.w,
                                  height: 32.h,
                                  color: accentPurple,
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        roleData['title'],
                                        style: montserrat(16, accentPurple, FontWeight.w600),
                                      ),
                                      Text(
                                        roleData['subtitle'],
                                        style: montserrat(14, grey5F63, FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          32.verticalSpace,
                          
                          // Personal Information Section
                          _buildSectionHeader(l10n.personalInformation),
                          16.verticalSpace,
                          
                          // Name field
                          CustomTextField(
                            controller: nameController,
                            titleText: l10n.fullName,
                            prefixIcon: AppIcons.userIcon,
                          ),
                          
                          20.verticalSpace,
                          
                          // Password field
                          PasswordTextField(
                            controller: passwordController,
                            titleText: l10n.password,
                          ),
                          
                          20.verticalSpace,
                          
                          // Confirm Password field
                          PasswordTextField(
                            controller: confirmPasswordController,
                            titleText: l10n.confirmPassword,
                          ),
                          
                          32.verticalSpace,
                          
                          // Location Information Section
                          _buildSectionHeader(l10n.personalInformation),
                          16.verticalSpace,
                          
                          // City dropdown
                          _buildDropdown(
                            title: l10n.city,
                            value: selectedCity.value,
                            items: cities,
                            onChanged: (value) {
                              selectedCity.value = value;
                              selectedInstitution.value = null; // Reset institution
                            },
                            icon: AppIcons.locationIcon,
                          ),
                          
                          20.verticalSpace,
                          
                          // Institution dropdown
                          _buildDropdown(
                            title: roleData['institutionLabel'],
                            value: selectedInstitution.value,
                            items: institutions,
                            onChanged: (value) => selectedInstitution.value = value,
                            icon: AppIcons.locationIcon,
                            enabled: selectedCity.value != null,
                          ),
                          
                          32.verticalSpace,
                          
                          // Transport Information Section
                          _buildSectionHeader(l10n.personalInformation),
                          16.verticalSpace,
                          
                          // Transport type selection
                          _buildTransportTypeSelection(
                            selectedType: selectedTransportType.value,
                            onTypeSelected: (type) => selectedTransportType.value = type,
                            transportTypes: roleData['transportTypes'],
                          ),
                          
                          40.verticalSpace,
                          
                          // Sign up button
                          NormalCustomButton(
                            label: l10n.continueButton,
                            onPressed: isLoading.value ? null : onSignUpPressed,
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: montserrat(18, grey36, FontWeight.w600),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String icon,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: title,
          prefixIcon: SvgPicture.asset(
            icon,
            width: 20.w,
            height: 20.h,
            color: enabled ? accentPurple : Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  Widget _buildTransportTypeSelection({
    required String? selectedType,
    required Function(String) onTypeSelected,
    required List<String> transportTypes,
  }) {
    return Column(
      children: transportTypes.map((type) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () => onTypeSelected(type),
            child: Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                color: selectedType == type 
                    ? accentPurple.withOpacity(0.1) 
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: selectedType == type ? accentPurple : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Icon(
                      selectedType == type ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: selectedType == type ? accentPurple : Colors.grey,
                    ),
                    12.horizontalSpace,
                    Text(
                      type,
                      style: montserrat(
                        16,
                        selectedType == type ? accentPurple : grey36,
                        FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _getRoleData(String role) {
    switch (role) {
      case 'school_student':
        return {
          'title': 'School Student',
          'subtitle': 'Via Parent',
          'icon': AppIcons.studentCap,
          'institutionLabel': 'School',
          'transportTypes': ['Private Transport', 'Group Transport'],
        };
      case 'university_student':
        return {
          'title': 'University Student',
          'subtitle': 'University/Institute Student',
          'icon': AppIcons.studentCap,
          'institutionLabel': 'University',
          'transportTypes': ['Private Transport', 'Group Transport'],
        };
      case 'teacher':
        return {
          'title': 'Teacher',
          'subtitle': 'Teacher Role',
          'icon': AppIcons.teacherBag,
          'institutionLabel': 'School',
          'transportTypes': ['Private Transport', 'Group Transport'],
        };
      case 'employee':
        return {
          'title': 'Employee',
          'subtitle': 'Employee Role',
          'icon': AppIcons.femaleEmployee,
          'institutionLabel': 'Company',
          'transportTypes': ['Private Transport', 'Group Transport'],
        };
      case 'parent':
        return {
          'title': 'Parent',
          'subtitle': 'Managing Kids',
          'icon': AppIcons.userIcon,
          'institutionLabel': 'School',
          'transportTypes': ['Private Transport', 'Group Transport'],
        };
      case 'metro_user':
        return {
          'title': 'Metro Shuttle User',
          'subtitle': 'Metro Shuttle User',
          'icon': AppIcons.bus,
          'institutionLabel': 'Metro Station',
          'transportTypes': ['Metro Shuttle'],
        };
      default:
        return {
          'title': 'User',
          'subtitle': 'General User',
          'icon': AppIcons.userIcon,
          'institutionLabel': 'Institution',
          'transportTypes': ['Private Transport', 'Group Transport'],
        };
    }
  }

  List<String> _getCities() {
    return [
      'Riyadh',
      'Jeddah',
      'Dammam',
      'Mecca',
      'Medina',
      'Taif',
      'Buraidah',
      'Tabuk',
      'Khamis Mushait',
      'Hail',
    ];
  }

  List<String> _getInstitutions(String city) {
    switch (city) {
      case 'Riyadh':
        return [
          'King Saud University',
          'Princess Nourah University',
          'Imam Mohammad Ibn Saud University',
          'King Saud University for Health Sciences',
          'Prince Sultan University',
        ];
      case 'Jeddah':
        return [
          'King Abdulaziz University',
          'Effat University',
          'University of Business and Technology',
        ];
      case 'Dammam':
        return [
          'University of Dammam',
          'Imam Abdulrahman Bin Faisal University',
        ];
      default:
        return [
          'University 1',
          'University 2',
          'University 3',
        ];
    }
  }
}
