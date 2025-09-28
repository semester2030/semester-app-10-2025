import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class MetroRouteSetupScreen extends HookConsumerWidget {
  const MetroRouteSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Local state for form data
    final homeAddressController = useTextEditingController();
    final metroStationController = useTextEditingController();
    final selectedDays = useState<Set<String>>({});
    final morningTime = useState<String>('');
    final eveningTime = useState<String>('');
    final selectedVehicleType = useState<String>('');
    final isPrivateRide = useState<bool>(true);

    // Available days
    final days = [
      {'key': 'sunday', 'label': 'Sunday'},
      {'key': 'monday', 'label': 'Monday'},
      {'key': 'tuesday', 'label': 'Tuesday'},
      {'key': 'wednesday', 'label': 'Wednesday'},
      {'key': 'thursday', 'label': 'Thursday'},
    ];

    // Vehicle types
    final vehicleTypes = [
      {'key': 'sedan', 'label': 'Sedan Car'},
      {'key': 'van', 'label': 'Small Van'},
      {'key': 'minibus', 'label': 'Small Bus'},
      {'key': 'bus', 'label': 'Bus (Large)'},
    ];

    void onDayToggle(String day) {
      final newDays = Set<String>.from(selectedDays.value);
      if (newDays.contains(day)) {
        newDays.remove(day);
      } else {
        newDays.add(day);
      }
      selectedDays.value = newDays;
    }

    Future<void> onContinuePressed() async {
      // Validate form
      if (homeAddressController.text.isEmpty) {
        showErrorFlushBar(
          message: 'Please enter home address',
          context: context,
        );
        return;
      }

      if (metroStationController.text.isEmpty) {
        showErrorFlushBar(
          message: 'Please select metro station',
          context: context,
        );
        return;
      }

      if (selectedDays.value.isEmpty) {
        showErrorFlushBar(
          message: 'Please select at least one day',
          context: context,
        );
        return;
      }

      if (morningTime.value.isEmpty && eveningTime.value.isEmpty) {
        showErrorFlushBar(
          message: 'Please select at least one time',
          context: context,
        );
        return;
      }

      // Navigate to next step
      context.push('/metro_schedule_setup', extra: {
        'homeAddress': homeAddressController.text,
        'metroStation': metroStationController.text,
        'selectedDays': selectedDays.value.toList(),
        'morningTime': morningTime.value,
        'eveningTime': eveningTime.value,
        'vehicleType': selectedVehicleType.value,
        'isPrivate': isPrivateRide.value,
      });
    }

    return ScreenWithTopAppbar(
      title: 'Metro Shuttle',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Setup Metro Route',
                style: montserrat(24, grey36, FontWeight.w600),
              ),
              
              8.verticalSpace,
              
              Text(
                'Configure your metro route',
                style: montserrat(16, grey5F63, FontWeight.w400),
              ),
              
              32.verticalSpace,
              
              // Home Address Section
              _buildSectionHeader(
                icon: AppIcons.homeIcon,
                title: 'Home Address',
                subtitle: 'Enter your home address',
              ),
              
              16.verticalSpace,
              
              CustomTextField(
                controller: homeAddressController,
                titleText: 'Home Address',
                hintText: 'Enter home address',
                prefixIcon: AppIcons.locationIcon,
                suffixIcon: SvgPicture.asset(AppIcons.searchIcon),
              ),
              
              32.verticalSpace,
              
              // Metro Station Section
              _buildSectionHeader(
                icon: AppIcons.bus,
                title: 'Metro Station',
                subtitle: 'Select destination station',
              ),
              
              16.verticalSpace,
              
              CustomTextField(
                controller: metroStationController,
                titleText: 'Metro Station',
                hintText: 'Select metro station',
                prefixIcon: AppIcons.bus,
                suffixIcon: SvgPicture.asset(AppIcons.dropdownIcon),
              ),
              
              32.verticalSpace,
              
              // Schedule Section
              _buildSectionHeader(
                icon: AppIcons.calender,
                title: 'Schedule',
                subtitle: 'Select days and times',
              ),
              
              16.verticalSpace,
              
              // Days selection
              Text(
                'Select Days',
                style: montserrat(16, grey36, FontWeight.w600),
              ),
              
              12.verticalSpace,
              
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: days.map((day) => _buildDayChip(
                  label: day['label']!,
                  isSelected: selectedDays.value.contains(day['key']!),
                  onTap: () => onDayToggle(day['key']!),
                )).toList(),
              ),
              
              24.verticalSpace,
              
              // Time selection
              Row(
                children: [
                  Expanded(
                    child: _buildTimeSelector(
                      title: 'Morning Time',
                      time: morningTime.value,
                      onTimeSelected: (time) => morningTime.value = time,
                    ),
                  ),
                  
                  16.horizontalSpace,
                  
                  Expanded(
                    child: _buildTimeSelector(
                      title: 'Evening Time',
                      time: eveningTime.value,
                      onTimeSelected: (time) => eveningTime.value = time,
                    ),
                  ),
                ],
              ),
              
              32.verticalSpace,
              
              // Vehicle Type Section
              _buildSectionHeader(
                icon: AppIcons.carSignal,
                title: 'Vehicle Type',
                subtitle: 'Select preferred vehicle',
              ),
              
              16.verticalSpace,
              
              _buildVehicleTypeSelector(
                vehicleTypes: vehicleTypes,
                selectedType: selectedVehicleType.value,
                onTypeSelected: (type) => selectedVehicleType.value = type,
              ),
              
              32.verticalSpace,
              
              // Ride Type Section
              _buildSectionHeader(
                icon: AppIcons.userIcon,
                title: 'Ride Type',
                subtitle: 'Choose private or shared',
              ),
              
              16.verticalSpace,
              
              _buildRideTypeSelector(
                isPrivate: isPrivateRide.value,
                onTypeChanged: (isPrivate) => isPrivateRide.value = isPrivate,
              ),
              
              40.verticalSpace,
              
              // Continue button
              NormalCustomButton(
                label: 'Continue',
                onPressed: onContinuePressed,
              ),
              
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: accentPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: SvgPicture.asset(
              icon,
              color: accentPurple,
              width: 20.w,
              height: 20.h,
            ),
          ),
        ),
        
        16.horizontalSpace,
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: montserrat(18, grey36, FontWeight.w600),
              ),
              4.verticalSpace,
              Text(
                subtitle,
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? accentPurple : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: montserrat(
            14,
            isSelected ? Colors.white : grey36,
            FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector({
    required String title,
    required String time,
    required Function(String) onTimeSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: montserrat(16, grey36, FontWeight.w600),
        ),
        
        8.verticalSpace,
        
        GestureDetector(
          onTap: () {
            // TODO: Implement time picker
            onTimeSelected('08:00'); // Placeholder
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.clockIcon,
                  color: accentPurple,
                  width: 16.w,
                  height: 16.h,
                ),
                
                12.horizontalSpace,
                
                  Text(
                    time.isEmpty ? 'Select Time' : time,
                    style: montserrat(
                      16,
                      time.isEmpty ? grey5F63 : grey36,
                      FontWeight.w400,
                    ),
                  ),
                
                Spacer(),
                
                Icon(
                  Icons.keyboard_arrow_down,
                  color: accentPurple,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleTypeSelector({
    required List<Map<String, String>> vehicleTypes,
    required String selectedType,
    required Function(String) onTypeSelected,
  }) {
    return Column(
      children: vehicleTypes.map((vehicle) => GestureDetector(
        onTap: () => onTypeSelected(vehicle['key']!),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: selectedType == vehicle['key'] 
                ? accentPurple.withOpacity(0.1) 
                : Colors.white,
            border: Border.all(
              color: selectedType == vehicle['key'] 
                  ? accentPurple 
                  : Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.carIcon,
                color: selectedType == vehicle['key'] 
                    ? accentPurple 
                    : Colors.grey.shade600,
                width: 20.w,
                height: 20.h,
              ),
              
              12.horizontalSpace,
              
              Text(
                vehicle['label']!,
                style: montserrat(
                  16,
                  selectedType == vehicle['key'] 
                      ? accentPurple 
                      : grey36,
                  FontWeight.w500,
                ),
              ),
              
              Spacer(),
              
              if (selectedType == vehicle['key'])
                Icon(
                  Icons.check_circle,
                  color: accentPurple,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildRideTypeSelector({
    required bool isPrivate,
    required Function(bool) onTypeChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTypeChanged(true),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: isPrivate ? accentPurple : Colors.white,
                border: Border.all(
                  color: isPrivate ? accentPurple : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppIcons.userIcon,
                    color: isPrivate ? Colors.white : accentPurple,
                    width: 24.w,
                    height: 24.h,
                  ),
                  
                  8.verticalSpace,
                  
                  Text(
                    'Private',
                    style: montserrat(
                      16,
                      isPrivate ? Colors.white : accentPurple,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        16.horizontalSpace,
        
        Expanded(
          child: GestureDetector(
            onTap: () => onTypeChanged(false),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: !isPrivate ? accentPurple : Colors.white,
                border: Border.all(
                  color: !isPrivate ? accentPurple : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppIcons.usersIcon,
                    color: !isPrivate ? Colors.white : accentPurple,
                    width: 24.w,
                    height: 24.h,
                  ),
                  
                  8.verticalSpace,
                  
                  Text(
                    'Shared',
                    style: montserrat(
                      16,
                      !isPrivate ? Colors.white : accentPurple,
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
