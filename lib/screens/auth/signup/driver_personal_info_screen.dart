import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverPersonalInfoScreen extends HookConsumerWidget {
  final String phoneNumber;
  final bool isFromDriverSignup;
  
  const DriverPersonalInfoScreen({
    super.key,
    required this.phoneNumber,
    required this.isFromDriverSignup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    
    // Local state
    final selectedGender = useState<String?>(null);
    // final selectedCity = useState<String?>(null);
    final isLoading = useState(false);

    // Sample data
    final genders = ['Male', 'Female'];
    // final cities = ['Riyadh', 'Jeddah', 'Mecca', 'Medina', 'Dammam', 'Khobar'];

    Future<void> onContinuePressed() async {
      if (nameController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseEnterYourFullName,
          context: context,
        );
        return;
      }

      if (emailController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseEnterYourEmailAddress,
          context: context,
        );
        return;
      }

      if (passwordController.text.length < 6) {
        showErrorFlushBar(
          message: l10n.passwordMustBeAtLeast6Characters,
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

      if (selectedGender.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectYourGender,
          context: context,
        );
        return;
      }

      // if (selectedCity.value == null) {
      //   showErrorFlushBar(
      //     message: l10n.pleaseSelectYourCity,
      //     context: context,
      //   );
      //   return;
      // }

      try {
        isLoading.value = true;
        
        // TODO: Save personal info and navigate to location selection
        if (context.mounted) {
          context.push('/driver_location_selection', extra: {
            'phoneNumber': phoneNumber,
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text,
            'gender': selectedGender.value,
            // 'city': selectedCity.value,
            'isFromDriverSignup': isFromDriverSignup,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Failed to save information: ${e.toString()}',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          l10n.tellUsAboutYourself,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        32.verticalSpace,
                        
                        // Name input
                        CustomTextField(
                          controller: nameController,
                          titleText: l10n.fullName,
                          hintText: l10n.enterYourFullName,
                          prefixIcon: 'assets/icons/person.svg',
                        ),
                        
                        16.verticalSpace,
                        
                        // Email input
                        CustomTextField(
                          controller: emailController,
                          titleText: l10n.emailAddress,
                          hintText: l10n.enterYourEmail,
                          prefixIcon: 'assets/icons/email.svg',
                        ),
                        
                        16.verticalSpace,
                        
                        // Password input
                        CustomTextField(
                          controller: passwordController,
                          titleText: l10n.password,
                          hintText: l10n.enterYourPassword,
                          prefixIcon: 'assets/icons/lock.svg',
                        ),
                        
                        16.verticalSpace,
                        
                        // Confirm password input
                        CustomTextField(
                          controller: confirmPasswordController,
                          titleText: l10n.confirmPassword,
                          hintText: l10n.confirmYourPassword,
                          prefixIcon: 'assets/icons/lock.svg',
                        ),
                        
                        16.verticalSpace,
                        
                        // Gender selection
                        _buildSelectionField(
                          context,
                          title: l10n.gender,
                          selectedValue: selectedGender.value,
                          options: genders,
                          onChanged: (value) => selectedGender.value = value,
                          icon: Icons.person_outline,
                        ),
                        
                        // 16.verticalSpace,
                        
                        // // City selection
                        // _buildSelectionField(
                        //   context,
                        //   title: l10n.city,
                        //   selectedValue: selectedCity.value,
                        //   options: cities,
                        //   onChanged: (value) => selectedCity.value = value,
                        //   icon: Icons.location_city,
                        // ),
                        
                        32.verticalSpace,
                        
                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          child: NormalCustomButton(
                            label: l10n.continueText,
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

  Widget _buildSelectionField(
    BuildContext context, {
    required String title,
    required String? selectedValue,
    required List<String> options,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        8.verticalSpace,
        
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select $title',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    16.verticalSpace,
                    
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: options.map((option) => ListTile(
                          title: Text(option),
                          leading: Icon(icon),
                          onTap: () {
                            onChanged(option);
                            Navigator.pop(context);
                          },
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.grey.shade600,
                  size: 20.sp,
                ),
                
                12.horizontalSpace,
                
                Expanded(
                  child: Text(
                    selectedValue ?? 'Select $title',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: selectedValue != null ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                ),
                
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
