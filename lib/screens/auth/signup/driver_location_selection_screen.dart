import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverLocationSelectionScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String name;
  final String email;
  final String password;
  final String gender;
  final String city;
  final bool isFromDriverSignup;
  
  const DriverLocationSelectionScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.city,
    required this.isFromDriverSignup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final selectedRegion = useState<String?>(null);
    final selectedCity = useState<String?>(null);
    final selectedDistrict = useState<String?>(null);
    final isLoading = useState(false);

    // Sample data
    final regions = ['Riyadh Region', 'Makkah Region', 'Eastern Region', 'Asir Region'];
    final cities = {
      'Riyadh Region': ['Riyadh', 'Diriyah', 'Al Kharj', 'Al Majma\'ah'],
      'Makkah Region': ['Makkah', 'Jeddah', 'Taif', 'Al Qunfudhah'],
      'Eastern Region': ['Dammam', 'Khobar', 'Dhahran', 'Jubail'],
      'Asir Region': ['Abha', 'Khamis Mushait', 'Bisha', 'Najran'],
    };
    final districts = {
      'Riyadh': ['Al Malaz', 'Al Olaya', 'Al Naseem', 'Al Shifa'],
      'Jeddah': ['Al Balad', 'Al Hamra', 'Al Rawdah', 'Al Shati'],
      'Dammam': ['Al Faisaliyah', 'Al Khaleej', 'Al Corniche', 'Al Aziziyah'],
    };

    Future<void> onContinuePressed() async {
      if (selectedRegion.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectYourRegion,
          context: context,
        );
        return;
      }

      if (selectedCity.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectYourCity,
          context: context,
        );
        return;
      }

      if (selectedDistrict.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectYourDistrict,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // TODO: Save location info and navigate to service selection
        if (context.mounted) {
          context.push('/driver_service_selection', extra: {
            'phoneNumber': phoneNumber,
            'name': name,
            'email': email,
            'password': password,
            'gender': gender,
            'city': city,
            'region': selectedRegion.value ?? '',
            'selectedCity': selectedCity.value ?? '',
            'district': selectedDistrict.value ?? '',
            'isFromDriverSignup': isFromDriverSignup,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Failed to save location: ${e.toString()}',
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
                          l10n.locationInformation,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.selectYourServiceArea,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        32.verticalSpace,
                        
                        // Region selection
                        _buildCascadingSelection(
                          context,
                          title: l10n.region,
                          selectedValue: selectedRegion.value,
                          options: regions,
                          onChanged: (value) {
                            selectedRegion.value = value;
                            selectedCity.value = null;
                            selectedDistrict.value = null;
                          },
                          icon: Icons.public,
                        ),
                        
                        16.verticalSpace,
                        
                        // City selection
                        if (selectedRegion.value != null)
                          _buildCascadingSelection(
                            context,
                            title: l10n.city,
                            selectedValue: selectedCity.value,
                            options: cities[selectedRegion.value] ?? [],
                            onChanged: (value) {
                              selectedCity.value = value;
                              selectedDistrict.value = null;
                            },
                            icon: Icons.location_city,
                          ),
                        
                        if (selectedRegion.value != null) 16.verticalSpace,
                        
                        // District selection
                        if (selectedCity.value != null)
                          _buildCascadingSelection(
                            context,
                            title: l10n.district,
                            selectedValue: selectedDistrict.value,
                            options: districts[selectedCity.value] ?? [],
                            onChanged: (value) => selectedDistrict.value = value,
                            icon: Icons.location_on,
                          ),
                        
                        if (selectedCity.value != null) 16.verticalSpace,
                        
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

  Widget _buildCascadingSelection(
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
