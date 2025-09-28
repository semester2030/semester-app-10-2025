import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class MetroStudentStationSelectionScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  final String locationType;
  final String city;
  final String district;
  final String address;
  
  const MetroStudentStationSelectionScreen({
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
    final otherStationController = useTextEditingController();
    
    // Local state
    final selectedStation = useState<String?>(null);
    final isOtherSelected = useState(false);
    final isLoading = useState(false);
    final userLocation = useState<Map<String, double>?>(null);

    // Get metro stations based on city
    final stations = _getMetroStationsByCity(city);
    
    // Find nearest station automatically
    useEffect(() {
      _findNearestStation(context, isLoading, userLocation, stations, selectedStation);
      return null;
    }, []);

    Future<void> onContinuePressed() async {
      if (selectedStation.value == null) {
        showErrorFlushBar(
          message: l10n.selectDriver,
          context: context,
        );
        return;
      }

      if (isOtherSelected.value) {
        if (otherStationController.text.trim().isEmpty) {
          showErrorFlushBar(
            message: l10n.fullName,
            context: context,
          );
          return;
        }
      }

      // Navigate to date selection screen
      if (context.mounted) {
        context.push('/date_selection', extra: {
          'role': 'metro_student',
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': password,
          'locationType': locationType,
          'city': city,
          'district': district,
          'address': address,
          'metroStation': isOtherSelected.value 
              ? otherStationController.text.trim()
              : selectedStation.value!,
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
              
              // Bottom section with metro station selection
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
                            l10n.selectDriver,
                            style: montserrat(24, grey36, FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          
                          16.verticalSpace,
                          
                          // Subtitle
                          Text(
                            isLoading.value 
                                ? l10n.chooseAccountType
                                : city,
                            style: montserrat(14, grey5F63, FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          
                          40.verticalSpace,
                          
                          // Loading indicator
                          if (isLoading.value) ...[
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(accentPurple),
                            ),
                            20.verticalSpace,
                            Text(
                              l10n.chooseAccountType,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                          ],
                          
                          // Metro station display (when found)
                          if (!isLoading.value && selectedStation.value != null) ...[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: accentPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: accentPurple, width: 2),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: accentPurple,
                                        size: 24.sp,
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          l10n.selectDriver,
                                          style: montserrat(16, accentPurple, FontWeight.w600),
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 24.sp,
                                      ),
                                    ],
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    selectedStation.value!,
                                    style: montserrat(18, grey36, FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    l10n.chooseAccountType,
                                    style: montserrat(14, grey5F63, FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            20.verticalSpace,
                          ],
                          
                          // Manual selection option
                          if (!isLoading.value) ...[
                            Text(
                              l10n.selectDriver,
                              style: montserrat(14, grey36, FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            16.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: borderGrey),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedStation.value,
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
                                    selectedStation.value = value;
                                    isOtherSelected.value = value == 'Other';
                                  },
                                  items: [
                                    ...stations.map<DropdownMenuItem<String>>((String station) {
                                      return DropdownMenuItem<String>(
                                        value: station,
                                        child: Text(station, style: montserrat(14, grey36, FontWeight.w500)),
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
                          
                          20.verticalSpace,
                          
                          // Other option
                          GestureDetector(
                            onTap: () {
                              selectedStation.value = 'Other';
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
                          
                          // Other station field (if other is selected)
                          if (isOtherSelected.value) ...[
                            20.verticalSpace,
                            CustomTextField(
                              controller: otherStationController,
                              titleText: l10n.fullName,
                              hintText: l10n.enterFullName,
                              prefixIcon: AppIcons.locationIcon,
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

  List<String> _getMetroStationsByCity(String city) {
    final stationsByCity = {
      'Riyadh': [
        'King Khalid International Airport',
        'King Abdulaziz Road',
        'King Fahd Road',
        'Olaya',
        'King Saud University',
        'Riyadh Central',
        'King Abdullah Financial District',
        'King Fahd Medical City',
        'Princess Nora University',
        'King Saud University Medical City',
      ],
      'Jeddah': [
        'King Abdulaziz International Airport',
        'Jeddah Central',
        'King Abdulaziz University',
        'Jeddah Port',
        'King Fahd Hospital',
        'Jeddah Chamber of Commerce',
        'Al Hamra',
        'Al Rawdah',
      ],
      'Dammam': [
        'King Fahd International Airport',
        'Dammam Central',
        'King Fahd University of Petroleum and Minerals',
        'Dammam Port',
        'King Fahd Hospital Dammam',
        'Al Khobar',
        'Dhahran',
      ],
      'Mecca': [
        'Mecca Central',
        'Umm Al-Qura University',
        'King Abdulaziz University - Mecca',
        'Al Haram',
        'Al Aziziyah',
      ],
      'Medina': [
        'Medina Central',
        'Taibah University',
        'Islamic University of Medina',
        'King Fahd Hospital Medina',
        'Al Qiblatain',
      ],
    };
    
    return stationsByCity[city] ?? ['No metro stations found for this city'];
  }

  Future<void> _findNearestStation(
    BuildContext context,
    ValueNotifier<bool> isLoading,
    ValueNotifier<Map<String, double>?> userLocation,
    List<String> stations,
    ValueNotifier<String?> selectedStation,
  ) async {
    try {
      isLoading.value = true;
      
      // Simulate getting user location (in real app, use GPS)
      // For now, we'll use a default location based on city
      final defaultLocation = _getDefaultLocationForCity(city);
      userLocation.value = defaultLocation;
      
      // Find nearest station
      final nearestStation = _calculateNearestStation(defaultLocation, stations);
      selectedStation.value = nearestStation;
      
      // Show success message
      if (context.mounted) {
        showSuccessFlushBar(
          message: 'Found nearest metro station: $nearestStation',
          context: context,
        );
      }
      
    } catch (e) {
      if (context.mounted) {
        showErrorFlushBar(
          message: 'Could not find your location. Please select manually.',
          context: context,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, double> _getDefaultLocationForCity(String city) {
    // Default coordinates for each city (in real app, get from GPS)
    final cityCoordinates = {
      'Riyadh': {'lat': 24.7136, 'lng': 46.6753},
      'Jeddah': {'lat': 21.4858, 'lng': 39.1925},
      'Dammam': {'lat': 26.4207, 'lng': 50.0888},
      'Mecca': {'lat': 21.3891, 'lng': 39.8579},
      'Medina': {'lat': 24.5247, 'lng': 39.5692},
    };
    
    return cityCoordinates[city] ?? {'lat': 24.7136, 'lng': 46.6753};
  }

  String _calculateNearestStation(Map<String, double> userLocation, List<String> stations) {
    // In real app, calculate actual distance using coordinates
    // For now, return the first station as "nearest"
    return stations.isNotEmpty ? stations.first : 'No station found';
  }
}
