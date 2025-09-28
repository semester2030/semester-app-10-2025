import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class CompanyRegistrationScreen extends HookConsumerWidget {
  const CompanyRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final companyNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final addressController = useTextEditingController();
    final licenseNumberController = useTextEditingController();
    final selectedCity = useState<String?>(null);
    final selectedRegion = useState<String?>(null);
    final isLoading = useState(false);

    // Available cities and regions
    final cities = ['Riyadh', 'Jeddah', 'Dammam', 'Mecca', 'Medina'];
    final regions = ['Central Region', 'Western Region', 'Eastern Region', 'Northern Region', 'Southern Region'];

    Future<void> onContinuePressed() async {
      if (companyNameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          phoneController.text.trim().isEmpty ||
          addressController.text.trim().isEmpty ||
          licenseNumberController.text.trim().isEmpty ||
          selectedCity.value == null ||
          selectedRegion.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseFillAllRequiredFields,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // Navigate to company dashboard or next step
        if (context.mounted) {
          context.push('/company_dashboard', extra: {
            'companyName': companyNameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'address': addressController.text.trim(),
            'licenseNumber': licenseNumberController.text.trim(),
            'city': selectedCity.value,
            'region': selectedRegion.value,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: '${l10n.registrationFailed}: ${e.toString()}',
            context: context,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: accentPurple,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(25.w, 60.h, 25.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppImages.logo,
                      width: 160.w,
                      height: 60.h,
                      fit: BoxFit.contain,
                    ),
                    10.verticalSpace,
                    Text(
                      l10n.companyRegistration,
                      style: montserrat(24, Colors.white, FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    Text(
                      l10n.registerYourTransportationCompany,
                      style: montserrat(14, Colors.white70, FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              40.verticalSpace,
              
              // Company Information Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.companyInformation,
                      style: montserrat(20, Colors.black, FontWeight.w600),
                    ),
                    
                    24.verticalSpace,
                    
                    // Company Name
                    CustomTextField(
                      controller: companyNameController,
                      titleText: l10n.companyName,
                      hintText: l10n.enterCompanyName,
                      prefixIcon: 'assets/icons/business.svg',
                    ),
                    
                    20.verticalSpace,
                    
                    // Email
                    CustomTextField(
                      controller: emailController,
                      titleText: l10n.emailAddress,
                      hintText: l10n.enterCompanyEmail,
                      prefixIcon: 'assets/icons/email.svg',
                    ),
                    
                    20.verticalSpace,
                    
                    // Phone
                    CustomTextField(
                      controller: phoneController,
                      titleText: l10n.phoneNumber,
                      hintText: l10n.enterCompanyPhone,
                      prefixIcon: 'assets/icons/phone.svg',
                    ),
                    
                    20.verticalSpace,
                    
                    // Address
                    CustomTextField(
                      controller: addressController,
                      titleText: l10n.companyAddress,
                      hintText: l10n.enterCompanyAddress,
                      prefixIcon: 'assets/icons/location.svg',
                    ),
                    
                    20.verticalSpace,
                    
                    // License Number
                    CustomTextField(
                      controller: licenseNumberController,
                      titleText: l10n.licenseNumber,
                      hintText: l10n.enterBusinessLicenseNumber,
                      prefixIcon: 'assets/icons/security.svg',
                    ),
                    
                    20.verticalSpace,
                    
                    // Region Selection
                    _buildSelectionField(
                      context,
                      title: l10n.region,
                      selectedValue: selectedRegion.value,
                      options: regions,
                      onChanged: (value) {
                        selectedRegion.value = value;
                        selectedCity.value = null; // Reset city when region changes
                      },
                      icon: Icons.public,
                    ),
                    
                    20.verticalSpace,
                    
                    // City Selection
                    _buildSelectionField(
                      context,
                      title: l10n.city,
                      selectedValue: selectedCity.value,
                      options: cities,
                      onChanged: (value) => selectedCity.value = value,
                      icon: Icons.location_city,
                    ),
                    
                    32.verticalSpace,
                    
                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: isLoading.value ? null : onContinuePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isLoading.value
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                l10n.continueButton,
                                style: montserrat(16, Colors.white, FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          style: montserrat(14, Colors.black, FontWeight.w500),
        ),
        
        8.verticalSpace,
        
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              builder: (context) => Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    
                    20.verticalSpace,
                    
                    Text(
                      'Select $title',
                      style: montserrat(18, Colors.black, FontWeight.w600),
                    ),
                    
                    20.verticalSpace,
                    
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final isSelected = selectedValue == option;
                          
                          return ListTile(
                            leading: Icon(
                              icon,
                              color: isSelected ? accentPurple : Colors.grey[600],
                            ),
                            title: Text(
                              option,
                              style: montserrat(
                                16,
                                isSelected ? accentPurple : Colors.black,
                                FontWeight.w500,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: accentPurple,
                                    size: 24.sp,
                                  )
                                : null,
                            onTap: () {
                              onChanged(option);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selectedValue != null ? accentPurple : Colors.grey[600],
                  size: 20.sp,
                ),
                
                12.horizontalSpace,
                
                Expanded(
                  child: Text(
                    selectedValue ?? 'Select $title',
                    style: montserrat(
                      16,
                      selectedValue != null ? Colors.black : Colors.grey[600],
                      FontWeight.w400,
                    ),
                  ),
                ),
                
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
