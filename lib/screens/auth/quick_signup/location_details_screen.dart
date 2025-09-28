import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class LocationDetailsScreen extends HookConsumerWidget {
  final String role;
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  final String locationType;
  
  const LocationDetailsScreen({
    super.key,
    required this.role,
    required this.phoneNumber,
    required this.name,
    required this.gender,
    required this.password,
    required this.locationType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final districtController = useTextEditingController();
    final addressController = useTextEditingController();
    
    // Local state
    final selectedCity = useState<String?>(null);
    final selectedDistrict = useState<String?>(null);

    // Cities data
    final cities = [
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

    // Districts data loaded from asset
    final districtsByCityState = useState<Map<String, List<String>>>({});
    useEffect(() {
      Future.microtask(() async {
        try {
          final data = await rootBundle.loadString('assets/data/saudi_districts.json');
          final Map<String, dynamic> jsonMap = jsonDecode(data) as Map<String, dynamic>;
          districtsByCityState.value = jsonMap.map((k, v) => MapEntry(k, List<String>.from(v as List)));
        } catch (_) {
          // Ignore and keep fallback empty map
        }
      });
      return null;
    }, []);

    Future<void> onContinuePressed() async {
      if (selectedCity.value == null) {
        showErrorFlushBar(
          message: l10n.city,
          context: context,
        );
        return;
      }

      final districtValue = (selectedDistrict.value ?? districtController.text).trim();
      if (districtValue.isEmpty) {
        showErrorFlushBar(
          message: l10n.district,
          context: context,
        );
        return;
      }

      if (addressController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.address,
          context: context,
        );
        return;
      }

      // Navigate to role-specific selection screen
      if (context.mounted) {
        String routePath;
        switch (role) {
          case 'university_student':
            routePath = '/student_university_selection';
            break;
          case 'teacher':
            routePath = '/teacher_school_selection';
            break;
          case 'employee':
            routePath = '/employee_workplace_selection';
            break;
          case 'metro_user':
            routePath = '/metro_student_station_selection';
            break;
          default:
            routePath = '/student_university_selection'; // Default fallback
        }
        
        context.push(routePath, extra: {
          'role': role,
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': password,
          'locationType': locationType,
          'city': selectedCity.value!,
          'district': districtValue,
          'address': addressController.text.trim(),
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
              // Bottom section with location details
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
                              l10n.locationInformation,
                              style: montserrat(24, grey36, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            // Subtitle
                            Text(
                              l10n.provideLocationDetails,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            // City dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.city,
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
                                      value: selectedCity.value,
                                      hint: Row(
                                        children: [
                                          SvgPicture.asset(AppIcons.locationIcon, height: 20.h, width: 20.w, color: grey5F63),
                                          10.horizontalSpace,
                                          Text(l10n.enterYourCity, style: montserrat(14, grey5F63, FontWeight.w400)),
                                        ],
                                      ),
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: grey5F63),
                                      onChanged: (value) {
                                        selectedCity.value = value;
                                        final suggestions =
                                            districtsByCityState.value[value ?? ''] ?? const [];
                                        // Auto-fill first district if empty
                                        if (suggestions.isNotEmpty) {
                                          selectedDistrict.value = suggestions.first;
                                          districtController.clear();
                                        } else {
                                          selectedDistrict.value = null;
                                        }
                                      },
                                      items: cities.map<DropdownMenuItem<String>>((String city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(city, style: montserrat(14, grey36, FontWeight.w500)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            20.verticalSpace,
                            // District dropdown (falls back to text field if no data)
                            Builder(builder: (_) {
                              final suggestions = districtsByCityState.value[selectedCity.value ?? ''] ?? const [];
                              if (suggestions.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l10n.district, style: montserrat(14, grey36, FontWeight.w500)),
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
                                          value: selectedDistrict.value,
                                          hint: Row(
                                            children: [
                                              SvgPicture.asset(AppIcons.locationIcon, height: 20.h, width: 20.w, color: grey5F63),
                                              10.horizontalSpace,
                                              Text(l10n.district, style: montserrat(14, grey5F63, FontWeight.w400)),
                                            ],
                                          ),
                                          isExpanded: true,
                                          icon: const Icon(Icons.keyboard_arrow_down, color: grey5F63),
                                          onChanged: (value) {
                                            selectedDistrict.value = value;
                                            districtController.clear();
                                          },
                                          items: [
                                            for (final d in suggestions)
                                              DropdownMenuItem(value: d, child: Text(d, style: montserrat(14, grey36, FontWeight.w500))),
                                            DropdownMenuItem(value: '__other__', child: Text(l10n.other)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (selectedDistrict.value == '__other__') ...[
                                      12.verticalSpace,
                                      CustomTextField(
                                        controller: districtController,
                                        titleText: l10n.district,
                                        hintText: l10n.enterNeighborhoodArea,
                                        prefixIcon: AppIcons.locationIcon,
                                      ),
                                    ],
                                  ],
                                );
                              }
                              // Fallback: plain text field
                              return CustomTextField(
                                controller: districtController,
                                titleText: l10n.district,
                                hintText: l10n.enterNeighborhoodArea,
                                prefixIcon: AppIcons.locationIcon,
                              );
                            }),
                            20.verticalSpace,
                            // Address field
                            CustomTextField(
                              controller: addressController,
                              titleText: l10n.address,
                              hintText: l10n.detailedAddress,
                              prefixIcon: AppIcons.locationIcon,
                              maxlines: 2,
                            ),
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
}