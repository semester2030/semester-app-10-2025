import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class TeacherSchoolSelectionScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  final String locationType;
  final String city;
  final String district;
  final String address;
  
  const TeacherSchoolSelectionScreen({
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
    final otherSchoolController = useTextEditingController();
    final otherAddressController = useTextEditingController();
    
    // Local state
    final selectedSchool = useState<String?>(null);
    final isOtherSelected = useState(false);

    // Get schools based on city AND district
    final schools = _getSchoolsByCityAndDistrict(city, district);

    Future<void> onContinuePressed() async {
      if (selectedSchool.value == null) {
        showErrorFlushBar(
          message: l10n.schoolName,
          context: context,
        );
        return;
      }

      if (isOtherSelected.value) {
        if (otherSchoolController.text.trim().isEmpty) {
          showErrorFlushBar(
            message: l10n.schoolName,
            context: context,
          );
          return;
        }
        if (otherAddressController.text.trim().isEmpty) {
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
          'role': 'teacher',
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': password,
          'locationType': locationType,
          'city': city,
          'district': district,
          'address': address,
          'school': isOtherSelected.value 
              ? otherSchoolController.text.trim()
              : selectedSchool.value!,
          'schoolAddress': isOtherSelected.value 
              ? otherAddressController.text.trim()
              : _getSchoolAddress(selectedSchool.value!),
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
              // Bottom section with school selection
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
                              l10n.schoolName,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            // Subtitle - Updated to show district
                            Text(
                              '$district, $city',
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            8.verticalSpace,
                            // Auto-detected location info
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: accentPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: accentPurple.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on, color: accentPurple, size: 16.sp),
                                  8.horizontalSpace,
                                  Text(
                                    '${l10n.district}: $district, ${l10n.city}: $city',
                                    style: montserrat(12, accentPurple, FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            40.verticalSpace,
                            // School dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.schoolName,
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
                                      value: selectedSchool.value,
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
                                        selectedSchool.value = value;
                                        isOtherSelected.value = value == 'Other';
                                      },
                                      items: [
                                        ...schools.map<DropdownMenuItem<String>>((String school) {
                                          return DropdownMenuItem<String>(
                                            value: school,
                                            child: Text(school, style: montserrat(14, grey36, FontWeight.w500)),
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
                                selectedSchool.value = 'Other';
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
                            // Other school fields (if other is selected)
                            if (isOtherSelected.value) ...[
                              20.verticalSpace,
                              CustomTextField(
                                controller: otherSchoolController,
                                titleText: l10n.schoolName,
                                hintText: l10n.schoolName,
                                prefixIcon: AppIcons.locationIcon,
                              ),
                              20.verticalSpace,
                              CustomTextField(
                                controller: otherAddressController,
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

  // Updated method to get schools by city AND district
  List<String> _getSchoolsByCityAndDistrict(String city, String district) {
    final schoolsByLocation = {
      'Riyadh': {
        'Al Malaz': [
          'Al Malaz Elementary School',
          'Al Malaz Middle School',
          'Al Malaz High School',
          'Al Malaz International School',
        ],
        'Al Olaya': [
          'Al Olaya Elementary School',
          'Al Olaya Middle School',
          'Al Olaya High School',
          'Al Olaya International School',
        ],
        'Al Naseem': [
          'Al Naseem Elementary School',
          'Al Naseem Middle School',
          'Al Naseem High School',
          'Al Naseem International School',
        ],
        'Al Wurud': [
          'Al Wurud Elementary School',
          'Al Wurud Middle School',
          'Al Wurud High School',
          'Al Wurud International School',
        ],
        'Al Rawdah': [
          'Al Rawdah Elementary School',
          'Al Rawdah Middle School',
          'Al Rawdah High School',
          'Al Rawdah International School',
        ],
      },
      'Jeddah': {
        'Al Hamra': [
          'Al Hamra Elementary School',
          'Al Hamra Middle School',
          'Al Hamra High School',
          'Al Hamra International School',
        ],
        'Al Shati': [
          'Al Shati Elementary School',
          'Al Shati Middle School',
          'Al Shati High School',
          'Al Shati International School',
        ],
        'Al Faisaliyah': [
          'Al Faisaliyah Elementary School',
          'Al Faisaliyah Middle School',
          'Al Faisaliyah High School',
          'Al Faisaliyah International School',
        ],
      },
      'Dammam': {
        'Al Faisaliyah': [
          'Al Faisaliyah Elementary School',
          'Al Faisaliyah Middle School',
          'Al Faisaliyah High School',
          'Al Faisaliyah International School',
        ],
        'Al Olaya': [
          'Al Olaya Elementary School',
          'Al Olaya Middle School',
          'Al Olaya High School',
          'Al Olaya International School',
        ],
      },
    };
    
    // Get schools for specific city and district
    final citySchools = schoolsByLocation[city];
    if (citySchools != null) {
      final districtSchools = citySchools[district];
      if (districtSchools != null) {
        return districtSchools;
      }
    }
    
    // Fallback: return schools for the city if district not found
    return _getSchoolsByCity(city);
  }

  // Keep the old method as fallback
  List<String> _getSchoolsByCity(String city) {
    final schoolsByCity = {
      'Riyadh': [
        'King Saud School',
        'Princess Nora School',
        'Alfaisal School',
        'Prince Sultan School',
        'Riyadh International School',
        'Saudi German School',
        'American School of Riyadh',
        'British School of Riyadh',
      ],
      'Jeddah': [
        'King Abdulaziz School',
        'Effat School',
        'Jeddah International School',
        'German School Jeddah',
        'American School of Jeddah',
        'British School of Jeddah',
      ],
      'Dammam': [
        'King Fahd School',
        'Dammam International School',
        'German School Dammam',
        'American School of Dammam',
      ],
      'Mecca': [
        'Umm Al-Qura School',
        'Mecca International School',
        'German School Mecca',
      ],
      'Medina': [
        'Taibah School',
        'Medina International School',
        'German School Medina',
      ],
    };
    
    return schoolsByCity[city] ?? ['No schools found for this city'];
  }

  String _getSchoolAddress(String school) {
    // Return default address for selected school
    return 'Address';
  }
}
