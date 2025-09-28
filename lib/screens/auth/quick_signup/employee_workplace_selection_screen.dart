import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class EmployeeWorkplaceSelectionScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  final String locationType;
  final String city;
  final String district;
  final String address;
  
  const EmployeeWorkplaceSelectionScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.gender,
    required this.password,
    required this.locationType,
    required this.city,
    required this.district,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final companyController = useTextEditingController();
    final workplaceAddressController = useTextEditingController();
    
    // Local state
    final selectedCompany = useState<String?>(null);
    final isOtherSelected = useState(false);

    // Get companies based on city
    final companies = _getCompaniesByCity(city);

    Future<void> onContinuePressed() async {
      if (selectedCompany.value == null && !isOtherSelected.value) {
        showErrorFlushBar(
          message: l10n.employee,
          context: context,
        );
        return;
      }

      if (isOtherSelected.value) {
        if (companyController.text.trim().isEmpty) {
          showErrorFlushBar(
            message: l10n.employee,
            context: context,
          );
          return;
        }
        if (workplaceAddressController.text.trim().isEmpty) {
          showErrorFlushBar(
            message: l10n.address,
            context: context,
          );
          return;
        }
      }

      // Navigate to date selection screen
      if (context.mounted) {
        context.push('/date_selection', extra: {
          'role': 'employee',
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': password,
          'locationType': locationType,
          'city': city,
          'district': district,
          'address': address,
          'company': isOtherSelected.value 
              ? companyController.text.trim()
              : selectedCompany.value!,
          'workplaceAddress': isOtherSelected.value 
              ? workplaceAddressController.text.trim()
              : _getCompanyAddress(selectedCompany.value!),
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
              // Bottom section with workplace selection
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
                              l10n.employee,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            // Subtitle
                            Text(
                              city,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            // Company dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.employee,
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
                                      value: selectedCompany.value,
                                      hint: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.locationIcon, height: 20.h, width: 20.w, color: grey5F63),
                                          10.horizontalSpace,
                                          Text(l10n.selectDriver, style: montserrat(14, grey5F63, FontWeight.w400)),
                                        ],
                                      ),
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: grey5F63),
                                      onChanged: (value) {
                                        selectedCompany.value = value;
                                        isOtherSelected.value = value == 'Other';
                                      },
                                      items: [
                                        ...companies.map<DropdownMenuItem<String>>((String company) {
                                          return DropdownMenuItem<String>(
                                            value: company,
                                            child: Text(company, style: montserrat(14, grey36, FontWeight.w500)),
                                          );
                                        }),
                                        DropdownMenuItem<String>(
                                          value: 'Other',
                                          child: Text(l10n.other, style: const TextStyle(fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            20.verticalSpace,
                            // Other option
                            GestureDetector(
                              onTap: () {
                                selectedCompany.value = 'Other';
                                isOtherSelected.value = true;
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: isOtherSelected.value ? accentPurple.withOpacity(0.1) : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isOtherSelected.value ? accentPurple : Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: isOtherSelected.value ? accentPurple : grey5F63,
                                        size: 20.sp,
                                      ),
                                      10.horizontalSpace,
                                      Text(
                                        l10n.other,
                                        style: montserrat(
                                          14,
                                          isOtherSelected.value ? accentPurple : grey5F63,
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Other company fields (if other is selected)
                            if (isOtherSelected.value) ...[
                              20.verticalSpace,
                              CustomTextField(
                                controller: companyController,
                                titleText: l10n.employee,
                                hintText: l10n.employee,
                                prefixIcon: AppIcons.locationIcon,
                              ),
                              20.verticalSpace,
                              CustomTextField(
                                controller: workplaceAddressController,
                                titleText: l10n.address,
                                hintText: l10n.address,
                                prefixIcon: AppIcons.locationIcon,
                                maxlines: 2,
                              ),
                            ],
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

  List<String> _getCompaniesByCity(String city) {
    final companiesByCity = {
      'Riyadh': [
        'Saudi Aramco',
        'SABIC',
        'STC',
        'Al Rajhi Bank',
        'Saudi Electricity Company',
        'Ministry of Health',
        'Ministry of Education',
        'King Fahd Medical City',
      ],
      'Jeddah': [
        'King Abdulaziz University',
        'King Fahd Hospital',
        'Jeddah Port',
        'Saudi Airlines',
        'Jeddah Chamber of Commerce',
        'Ministry of Hajj',
      ],
      'Dammam': [
        'King Fahd University of Petroleum and Minerals',
        'Dammam Port',
        'Saudi Aramco - Eastern Province',
        'King Fahd Hospital Dammam',
      ],
      'Mecca': [
        'Umm Al-Qura University',
        'Ministry of Hajj',
        'General Authority of Civil Aviation',
      ],
      'Medina': [
        'Taibah University',
        'Islamic University of Medina',
        'King Fahd Hospital Medina',
      ],
    };
    
    return companiesByCity[city] ?? ['No companies found for this city'];
  }

  String _getCompanyAddress(String company) {
    // Return default address for selected company
    return 'Address';
  }
}
