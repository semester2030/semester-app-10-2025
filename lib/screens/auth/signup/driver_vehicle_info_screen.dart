import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverVehicleInfoScreen extends HookConsumerWidget {
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
  final List<String> services;
  final bool isFromDriverSignup;
  
  const DriverVehicleInfoScreen({
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
    required this.subDistrict,
    required this.services,
    required this.isFromDriverSignup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Controllers
    final plateController = useTextEditingController();
    
    // Local state
    final selectedMake = useState<String?>(null);
    final selectedModel = useState<String?>(null);
    final selectedYear = useState<String?>(null);
    final selectedVehicleType = useState<String?>(null);
    final hasAC = useState(false);
    final isLoading = useState(false);

    // Sample data
    final vehicleMakes = ['Toyota', 'Honda', 'Ford', 'Nissan', 'Hyundai', 'Kia', 'BMW', 'Mercedes', 'Audi', 'Volkswagen'];
    final vehicleModels = {
      'Toyota': ['Camry', 'Corolla', 'Prius', 'RAV4', 'Highlander', 'Sienna', 'Tacoma', 'Tundra'],
      'Honda': ['Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey', 'Fit', 'HR-V', 'Ridgeline'],
      'Ford': ['F-150', 'Explorer', 'Escape', 'Mustang', 'Focus', 'Fusion', 'Edge', 'Expedition'],
      'Nissan': ['Altima', 'Sentra', 'Rogue', 'Pathfinder', 'Murano', 'Versa', 'Maxima', 'Armada'],
      'Hyundai': ['Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Palisade', 'Accent', 'Veloster', 'Genesis'],
      'Kia': ['Optima', 'Sorento', 'Sportage', 'Forte', 'Soul', 'Telluride', 'Stinger', 'Niro'],
      'BMW': ['3 Series', '5 Series', 'X3', 'X5', '7 Series', 'X1', 'X7', 'i3'],
      'Mercedes': ['C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE', 'A-Class', 'G-Class', 'CLA'],
      'Audi': ['A4', 'A6', 'Q5', 'Q7', 'A3', 'Q3', 'A8', 'TT'],
      'Volkswagen': ['Jetta', 'Passat', 'Tiguan', 'Atlas', 'Golf', 'Beetle', 'Arteon', 'ID.4'],
    };
    final vehicleYears = List.generate(25, (index) => (2024 - index).toString());
    final vehicleTypes = [
      {'name': 'Sedan', 'icon': Icons.directions_car},
      {'name': 'SUV', 'icon': Icons.local_shipping},
      {'name': 'Van', 'icon': Icons.airport_shuttle},
      {'name': 'Bus', 'icon': Icons.directions_bus},
      {'name': 'Truck', 'icon': Icons.local_shipping},
    ];

    Future<void> onContinuePressed() async {
      if (selectedMake.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectVehicleMake,
          context: context,
        );
        return;
      }

      if (selectedModel.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectVehicleModel,
          context: context,
        );
        return;
      }

      if (selectedYear.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectVehicleYear,
          context: context,
        );
        return;
      }

      if (plateController.text.trim().isEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseEnterPlateNumber,
          context: context,
        );
        return;
      }

      if (selectedVehicleType.value == null) {
        showErrorFlushBar(
          message: l10n.pleaseSelectVehicleType,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // TODO: Save vehicle info and navigate to documents
        if (context.mounted) {
          context.push('/driver_documents', extra: {
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
            'services': services,
            'vehicleMake': selectedMake.value,
            'vehicleModel': selectedModel.value,
            'vehicleYear': selectedYear.value,
            'plateNumber': plateController.text.trim(),
            'vehicleType': selectedVehicleType.value,
            // Provide safe defaults to avoid null casts in router
            'fuelType': 'Petrol',
            'transmission': 'Automatic',
            'hasAC': hasAC.value,
            'isFromDriverSignup': isFromDriverSignup,
          });
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Failed to save vehicle info: ${e.toString()}',
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
                        width: 140.w, // reduce to avoid overflow warnings
                        height: 50.h,
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
                    // Increase bottom padding to avoid bottom overflow on small screens
                    padding: EdgeInsets.fromLTRB(25.w, 60.h, 25.w, 120.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          l10n.vehicleInformation,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.tellUsAboutYourVehicle,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        32.verticalSpace,
                        
                        // Vehicle make selection
                        _buildSelectionField(
                          context,
                          title: l10n.vehicleMake,
                          selectedValue: selectedMake.value,
                          options: vehicleMakes,
                          onChanged: (value) {
                            selectedMake.value = value;
                            selectedModel.value = null; // Reset model when make changes
                          },
                          icon: Icons.directions_car,
                        ),
                        
                        16.verticalSpace,
                        
                        // Vehicle model selection (only show if make is selected)
                        if (selectedMake.value != null)
                          _buildSelectionField(
                            context,
                            title: l10n.vehicleModel,
                            selectedValue: selectedModel.value,
                            options: vehicleModels[selectedMake.value] ?? [],
                            onChanged: (value) => selectedModel.value = value,
                            icon: Icons.car_rental,
                          ),
                        
                        if (selectedMake.value != null) 16.verticalSpace,
                        
                        // Vehicle year selection
                        _buildSelectionField(
                          context,
                          title: l10n.vehicleYear,
                          selectedValue: selectedYear.value,
                          options: vehicleYears,
                          onChanged: (value) => selectedYear.value = value,
                          icon: Icons.calendar_today,
                        ),
                        
                        16.verticalSpace,
                        
                        // Plate number
                        CustomTextField(
                          controller: plateController,
                          titleText: l10n.plateNumber,
                          hintText: l10n.plateNumberExample,
                          prefixIcon: 'assets/icons/plate.svg',
                        ),
                        
                        16.verticalSpace,
                        
                        // Vehicle type selection
                        _buildVehicleTypeSelection(
                          context,
                          title: l10n.vehicleType,
                          selectedValue: selectedVehicleType.value,
                          options: vehicleTypes,
                          onChanged: (value) => selectedVehicleType.value = value,
                        ),
                        
                        16.verticalSpace,
                        
                        // AC checkbox
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.ac_unit,
                                color: Colors.grey.shade600,
                                size: 20.sp,
                              ),
                              
                              12.horizontalSpace,
                              
                              Expanded(
                                child: Text(
                                  l10n.airConditioningAvailable,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              
                              Switch(
                                value: hasAC.value,
                                onChanged: (value) => hasAC.value = value,
                                activeColor: accentPurple,
                              ),
                            ],
                          ),
                        ),
                        
                        32.verticalSpace,
                        
                        // Continue button
                        SizedBox(
                          width: double.infinity,
                          child: NormalCustomButton(
                            label: l10n.continueText,
                            onPressed: isLoading.value ? null : onContinuePressed,
                          ),
                        ),
                        // Extra safe space after the button to prevent overflow on devices
                        SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
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

  Widget _buildVehicleTypeSelection(
    BuildContext context, {
    required String title,
    required String? selectedValue,
    required List<Map<String, dynamic>> options,
    required Function(String) onChanged,
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
                          title: Text(option['name'] as String),
                          leading: Icon(option['icon'] as IconData),
                          onTap: () {
                            onChanged(option['name'] as String);
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
                  Icons.local_shipping,
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
