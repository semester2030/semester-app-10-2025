import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class StudentUniversitySelectionScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  final String locationType;
  final String city;
  final String district;
  final String address;
  
  const StudentUniversitySelectionScreen({
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
    final otherUniversityController = useTextEditingController();
    final otherAddressController = useTextEditingController();
    
    // Local state
    final selectedUniversity = useState<String?>(null);
    final isOtherSelected = useState(false);

    // Get universities based on city
    final universities = _getUniversitiesByCity(city);

    Future<void> onContinuePressed() async {
      if (selectedUniversity.value == null) {
        showErrorFlushBar(
          message: l10n.universityName,
          context: context,
        );
        return;
      }

      if (isOtherSelected.value) {
        if (otherUniversityController.text.trim().isEmpty) {
          showErrorFlushBar(
            message: l10n.universityName,
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
          'role': 'student',
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': password,
          'locationType': locationType,
          'city': city,
          'district': district,
          'address': address,
          'university': isOtherSelected.value 
              ? otherUniversityController.text.trim()
              : selectedUniversity.value!,
          'universityAddress': isOtherSelected.value 
              ? otherAddressController.text.trim()
              : _getUniversityAddress(selectedUniversity.value!),
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
              // Bottom section with university selection
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
                              l10n.universityName,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            // Subtitle
                            Text(
                              l10n.university,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            // University dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.university,
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
                                      value: selectedUniversity.value,
                                      hint: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.locationIcon, height: 20.h, width: 20.w, color: grey5F63),
                                          10.horizontalSpace,
                                          Text(l10n.selectUniversity, style: montserrat(14, grey5F63, FontWeight.w400)),
                                        ],
                                      ),
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: grey5F63),
                                      onChanged: (value) {
                                        selectedUniversity.value = value;
                                        isOtherSelected.value = value == 'Other';
                                      },
                                      items: [
                                        ...universities.map<DropdownMenuItem<String>>((String university) {
                                          return DropdownMenuItem<String>(
                                            value: university,
                                            child: Text(university, style: montserrat(14, grey36, FontWeight.w500)),
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
                                selectedUniversity.value = 'Other';
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
                                        l10n.addChildrenProfiles,
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
                            // Other university fields (if other is selected)
                            if (isOtherSelected.value) ...[
                              20.verticalSpace,
                              CustomTextField(
                                controller: otherUniversityController,
                                titleText: l10n.universityName,
                                hintText: l10n.universityName,
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

  List<String> _getUniversitiesByCity(String city) {
    final universitiesByCity = {
      'Riyadh': [
        'King Saud University',
        'Princess Nora bint Abdulrahman University',
        'Imam Muhammad ibn Saud Islamic University',
        'King Saud bin Abdulaziz University for Health Sciences',
        'Alfaisal University',
        'Prince Sultan University',
        'Riyadh College of Technology',
      ],
      'Jeddah': [
        'King Abdulaziz University',
        'Effat University',
        'King Saud University - Jeddah',
        'University of Business and Technology',
        'Jeddah College of Technology',
      ],
      'Dammam': [
        'Imam Abdulrahman Bin Faisal University',
        'King Fahd University of Petroleum and Minerals',
        'University of Dammam',
        'Dammam College of Technology',
      ],
      'Mecca': [
        'Umm Al-Qura University',
        'Mecca College of Technology',
      ],
      'Medina': [
        'Taibah University',
        'Islamic University of Medina',
        'Medina College of Technology',
      ],
    };
    
    return universitiesByCity[city] ?? ['No universities found for this city'];
  }

  String _getUniversityAddress(String university) {
    // Return default placeholder address for selected university
    return 'Address';
  }
}
