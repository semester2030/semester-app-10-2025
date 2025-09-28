import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class EnhancedBookingFlowScreen extends HookConsumerWidget {
  const EnhancedBookingFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state
    final currentStep = useState<int>(0);
    final pickupController = useTextEditingController();
    final destinationController = useTextEditingController();
    final selectedServiceType = useState<String>('student');
    final selectedVehicleType = useState<String>('sedan');
    final selectedDate = useState<DateTime?>(null);
    final selectedTime = useState<TimeOfDay?>(null);
    final specialRequests = useTextEditingController();
    final isRecurring = useState<bool>(false);
    final recurringDays = useState<List<String>>([]);

    final steps = [
      'Location',
      'Service Type',
      'Schedule',
      'Preferences',
      'Review',
    ];

    final serviceTypes = [
      {
        'key': 'student',
        'title': 'Student Transport',
        'subtitle': 'Daily school/university transport',
        'icon': AppIcons.studentCap,
        'color': Colors.blue,
      },
      {
        'key': 'teacher',
        'title': 'Teacher Transport',
        'subtitle': 'Professional transport service',
        'icon': AppIcons.teacherBag,
        'color': Colors.green,
      },
      {
        'key': 'employee',
        'title': 'Employee Transport',
        'subtitle': 'Corporate transport solution',
        'icon': AppIcons.femaleEmployee,
        'color': Colors.orange,
      },
      {
        'key': 'daily',
        'title': 'Daily Transport',
        'subtitle': 'One-time or occasional rides',
        'icon': AppIcons.dailyTransport,
        'color': Colors.purple,
      },
    ];

    final vehicleTypes = [
      {'key': 'sedan', 'title': 'Sedan', 'icon': Icons.directions_car, 'capacity': '4 passengers'},
      {'key': 'suv', 'title': 'SUV', 'icon': Icons.directions_car, 'capacity': '6 passengers'},
      {'key': 'van', 'title': 'Van', 'icon': Icons.airport_shuttle, 'capacity': '8 passengers'},
      {'key': 'bus', 'title': 'Bus', 'icon': Icons.directions_bus, 'capacity': '20+ passengers'},
    ];

    final daysOfWeek = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    Future<void> completeBooking() async {
      // TODO: Implement booking completion
      context.pop();
    }

    Future<void> onNextStep() async {
      if (currentStep.value < steps.length - 1) {
        currentStep.value++;
      } else {
        // Complete booking
        await completeBooking();
      }
    }

    Future<void> onPreviousStep() async {
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    }

    bool canProceed() {
      switch (currentStep.value) {
        case 0: return pickupController.text.isNotEmpty && destinationController.text.isNotEmpty;
        case 1: return selectedServiceType.value.isNotEmpty;
        case 2: return selectedDate.value != null && selectedTime.value != null;
        case 3: return true; // Preferences are optional
        case 4: return true; // Review step
        default: return false;
      }
    }

    String getStepDescription(int step) {
      switch (step) {
        case 0: return 'Enter your pickup and destination locations';
        case 1: return 'Choose the type of transport service you need';
        case 2: return 'Select when you need the transport';
        case 3: return 'Customize your transport preferences';
        case 4: return 'Review your booking details before confirming';
        default: return '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Enhanced Booking'),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: steps.asMap().entries.map((entry) {
                final index = entry.key;
                final isActive = index == currentStep.value;
                final isCompleted = index < currentStep.value;
                
                return Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: isActive || isCompleted 
                              ? accentPurple 
                              : Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                              : Text(
                                  '${index + 1}',
                                  style: montserrat(
                                    14,
                                    isActive ? Colors.white : grey5F63,
                                    FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      if (index < steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 2.h,
                            color: isCompleted ? accentPurple : Colors.grey[300],
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Step Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[currentStep.value],
                    style: montserrat(24, grey36, FontWeight.w700),
                  ),
                  8.verticalSpace,
                  Text(
                    getStepDescription(currentStep.value),
                    style: montserrat(16, grey5F63, FontWeight.w400),
                  ),
                  32.verticalSpace,

                  // Step 1: Location
                  if (currentStep.value == 0) Column(
                    children: [
                      CustomTextField(
                        controller: pickupController,
                        titleText: 'Pickup Location',
                        hintText: 'Enter pickup address',
                        prefixIcon: AppIcons.locationIcon,
                      ),
                      24.verticalSpace,
                      CustomTextField(
                        controller: destinationController,
                        titleText: 'Destination',
                        hintText: 'Enter destination address',
                        prefixIcon: AppIcons.locationIcon,
                      ),
                    ],
                  ),

                  // Step 2: Service Type
                  if (currentStep.value == 1) Column(
                    children: serviceTypes.map((service) {
                      final isSelected = selectedServiceType.value == service['key'] as String;
                      final serviceColor = service['color'] as Color;
                      final serviceIcon = service['icon'] as String;
                      final serviceTitle = service['title'] as String;
                      final serviceSubtitle = service['subtitle'] as String;
                      return GestureDetector(
                        onTap: () => selectedServiceType.value = service['key'] as String,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: isSelected ? serviceColor.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected ? serviceColor : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                serviceIcon,
                                width: 32.w,
                                height: 32.h,
                                color: isSelected ? serviceColor : grey5F63,
                              ),
                              16.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceTitle,
                                      style: montserrat(16, grey36, FontWeight.w600),
                                    ),
                                    4.verticalSpace,
                                    Text(
                                      serviceSubtitle,
                                      style: montserrat(14, grey5F63, FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(Icons.check_circle, color: serviceColor, size: 24.sp),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Step 3: Schedule
                  if (currentStep.value == 2) Column(
                    children: [
                      // Date Selection
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) selectedDate.value = date;
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: accentPurple),
                              12.horizontalSpace,
                              Text(
                                selectedDate.value != null
                                    ? '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}'
                                    : 'Select Date',
                                style: montserrat(16, grey36, FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.verticalSpace,

                      // Time Selection
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) selectedTime.value = time;
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: accentPurple),
                              12.horizontalSpace,
                              Text(
                                selectedTime.value != null
                                    ? selectedTime.value!.format(context)
                                    : 'Select Time',
                                style: montserrat(16, grey36, FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      24.verticalSpace,

                      // Recurring Option
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Switch(
                              value: isRecurring.value,
                              onChanged: (value) => isRecurring.value = value,
                              activeColor: accentPurple,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Text(
                                'Recurring Transport',
                                style: montserrat(16, grey36, FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Recurring Days
                      if (isRecurring.value) ...[
                        16.verticalSpace,
                        Text(
                          'Select Days',
                          style: montserrat(16, grey36, FontWeight.w600),
                        ),
                        12.verticalSpace,
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: daysOfWeek.map((day) {
                            final isSelected = recurringDays.value.contains(day);
                            return GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  recurringDays.value = recurringDays.value.where((d) => d != day).toList();
                                } else {
                                  recurringDays.value = [...recurringDays.value, day];
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: isSelected ? accentPurple : Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: isSelected ? accentPurple : Colors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  day,
                                  style: montserrat(14, isSelected ? Colors.white : grey5F63, FontWeight.w500),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),

                  // Step 4: Preferences
                  if (currentStep.value == 3) Column(
                    children: [
                      Text(
                        'Vehicle Type',
                        style: montserrat(18, grey36, FontWeight.w600),
                      ),
                      16.verticalSpace,
                      ...vehicleTypes.map((vehicle) {
                        final isSelected = selectedVehicleType.value == vehicle['key'] as String;
                        final vehicleIcon = vehicle['icon'] as IconData;
                        final vehicleTitle = vehicle['title'] as String;
                        final vehicleCapacity = vehicle['capacity'] as String;
                        return GestureDetector(
                          onTap: () => selectedVehicleType.value = vehicle['key'] as String,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: isSelected ? accentPurple : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(vehicleIcon, color: isSelected ? accentPurple : grey5F63),
                                12.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicleTitle,
                                        style: montserrat(16, grey36, FontWeight.w600),
                                      ),
                                      Text(
                                        vehicleCapacity,
                                        style: montserrat(14, grey5F63, FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: accentPurple),
                              ],
                            ),
                          ),
                        );
                      }),
                      32.verticalSpace,
                      CustomTextField(
                        controller: specialRequests,
                        titleText: 'Special Requests',
                        hintText: 'Any special requirements or notes',
                        prefixIcon: AppIcons.edit,
                      ),
                    ],
                  ),

                  // Step 5: Review
                  if (currentStep.value == 4) Column(
                    children: [
                      _buildReviewItem('Pickup', pickupController.text, Icons.location_on),
                      _buildReviewItem('Destination', destinationController.text, Icons.flag),
                      _buildReviewItem('Service Type', selectedServiceType.value, Icons.local_shipping),
                      _buildReviewItem('Vehicle Type', selectedVehicleType.value, Icons.directions_car),
                      _buildReviewItem('Date', selectedDate.value != null ? '${selectedDate.value!.day}/${selectedDate.value!.month}/${selectedDate.value!.year}' : 'Not selected', Icons.calendar_today),
                      _buildReviewItem('Time', selectedTime.value != null ? selectedTime.value!.format(context) : 'Not selected', Icons.access_time),
                      if (isRecurring.value)
                        _buildReviewItem('Recurring Days', recurringDays.value.join(', '), Icons.repeat),
                      if (specialRequests.text.isNotEmpty)
                        _buildReviewItem('Special Requests', specialRequests.text, Icons.note),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                if (currentStep.value > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onPreviousStep,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: accentPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: montserrat(16, accentPurple, FontWeight.w600),
                      ),
                    ),
                  ),
                if (currentStep.value > 0) 16.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    onPressed: canProceed() ? onNextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      currentStep.value == steps.length - 1 ? 'Complete Booking' : 'Next',
                      style: montserrat(16, Colors.white, FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentPurple, size: 20.sp),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: montserrat(14, grey5F63, FontWeight.w500),
                ),
                4.verticalSpace,
                Text(
                  value,
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}