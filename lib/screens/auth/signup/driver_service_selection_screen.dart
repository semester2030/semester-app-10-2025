import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverServiceSelectionScreen extends HookConsumerWidget {
  final String phoneNumber;
  final String name;
  final String email;
  final String password;
  final String gender;
  final String city;
  final String region;
  final String selectedCity;
  final String district;
  final String? subDistrict;
  final bool isFromDriverSignup;
  
  const DriverServiceSelectionScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    required this.city,
    required this.region,
    required this.selectedCity,
    required this.district,
    this.subDistrict,
    required this.isFromDriverSignup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final selectedServices = useState<Set<String>>({});
    final isLoading = useState(false);

    // Available services
    final services = [
      {
        'id': 'student_transport',
        'name': l10n.studentTransport,
        'description': l10n.studentTransportDescription,
        'icon': Icons.school,
        'color': Colors.blue,
      },
      {
        'id': 'teacher_transport',
        'name': l10n.teacherTransport,
        'description': l10n.teacherTransportDescription,
        'icon': Icons.person,
        'color': Colors.green,
      },
      {
        'id': 'employee_transport',
        'name': l10n.employeeTransport,
        'description': l10n.employeeTransportDescription,
        'icon': Icons.work,
        'color': Colors.orange,
      },
      {
        'id': 'metro_transport',
        'name': l10n.metroTransport,
        'description': l10n.metroTransportDescription,
        'icon': Icons.train,
        'color': Colors.red,
      },
    ];

    Future<void> onContinuePressed() async {
      if (selectedServices.value.isEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseSelectAtLeastOneService,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // TODO: Save service info and navigate to vehicle info
        if (context.mounted) {
          context.push('/driver_vehicle_info', extra: {
            'phoneNumber': phoneNumber,
            'name': name,
            'email': email,
            'password': password,
            'gender': gender,
            'city': city,
            'region': region,
            'selectedCity': selectedCity,
            'district': district,
            'subDistrict': subDistrict,
            'services': selectedServices.value.toList(),
            'isFromDriverSignup': isFromDriverSignup,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Failed to save services: ${e.toString()}',
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
                          l10n.serviceSelection,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.selectServicesYouProvide,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        32.verticalSpace,
                        
                        // Services grid
                        ...services.map((service) => _buildServiceCard(
                          service: service,
                          isSelected: selectedServices.value.contains(service['id']),
                          onTap: () {
                            final newServices = Set<String>.from(selectedServices.value);
                            if (newServices.contains(service['id'])) {
                              newServices.remove(service['id']);
                            } else {
                              newServices.add(service['id'] as String);
                            }
                            selectedServices.value = newServices;
                          },
                        )),
                        
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

  Widget _buildServiceCard({
    required Map<String, dynamic> service,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected ? (service['color'] as Color).withOpacity(0.1) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? service['color'] as Color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isSelected ? (service['color'] as Color) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.r),
            ),
                child: Icon(
                  service['icon'] as IconData,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              
              16.horizontalSpace,
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'] as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? service['color'] as Color : Colors.black87,
                      ),
                    ),
                    
                    4.verticalSpace,
                    
                    Text(
                      service['description'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selection indicator
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? service['color'] as Color : Colors.grey.shade400,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
