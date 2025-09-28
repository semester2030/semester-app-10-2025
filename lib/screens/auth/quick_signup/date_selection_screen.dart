import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/services/signup_service.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';

class DateSelectionScreen extends HookConsumerWidget {
  final String role;
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  final String locationType;
  final String city;
  final String district;
  final String address;
  final String university;
  final String universityAddress;
  
  const DateSelectionScreen({
    super.key,
    required this.role,
    required this.phoneNumber,
    required this.name,
    required this.gender,
    required this.password,
    required this.locationType,
    required this.city,
    required this.district,
    required this.address,
    required this.university,
    required this.universityAddress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final selectedDate = useState<DateTime?>(null);
    final selectedMonth = useState<String?>(null);
    final selectedYear = useState<String?>(null);
    final isLoading = useState(false);

    // Month options
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    Future<void> onContinuePressed() async {
      if (selectedDate.value == null) {
        showErrorFlushBar(
          message: l10n.chooseAccountType,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // Create user data model
        final userData = UserSignupModel(
          email: phoneNumber, // Using phone as email for now
          password: password,
          name: name,
          gender: gender,
          phoneNumber: phoneNumber,
          role: role,
          city: city,
          district: district,
          isDriver: false,
          createdAt: DateTime.now(),
        );

        // Save user data to Firestore
        final signupService = SignupService();
        final user = await signupService.signupUser(userData);
        
        if (user != null) {
          if (context.mounted) {
            showSuccessFlushBar(
              message: l10n.chooseAccountType,
              context: context,
            );
            
               // Navigate to booking flow based on role
               // _navigateToBookingFlow(context, role);
          }
        } else {
          throw Exception('signup_failed');
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: l10n.chooseAccountType,
            context: context,
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    // Visible Skip for Test: navigate to new booking flow with prefilled data (no signup)
    Future<void> navigateToBookingFlowForTest() async {
      // Determine service type based on role
      TransportationServiceType serviceType;
      switch (role) {
        case 'university_student':
        case 'student':
          serviceType = TransportationServiceType.student;
          break;
        case 'teacher':
          serviceType = TransportationServiceType.teacher;
          break;
        case 'employee':
          serviceType = TransportationServiceType.employee;
          break;
        case 'metro_user':
          context.push('/metro_route_setup');
          return;
        default:
          serviceType = TransportationServiceType.student;
      }

      // Navigate to booking flow with pre-filled data and bypass auth redirect
      context.push('/booking_map', extra: {
        'serviceType': serviceType,
        'testSkip': true,
      });
    }

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: accentPurple,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: grey36,
              ),
            ),
            child: child!,
          );
        },
      );
      
      if (picked != null && picked != selectedDate.value) {
        selectedDate.value = picked;
        selectedMonth.value = months[picked.month - 1];
        selectedYear.value = picked.year.toString();
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
              
              // Bottom section with date selection
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
                            l10n.chooseAccountType,
                            style: montserrat(14, grey5F63, FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          
                          40.verticalSpace,
                          
                          // Date picker button
                          GestureDetector(
                            onTap: () => selectDate(context),
                            child: Container(
                              width: double.infinity,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: borderGrey),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: accentPurple,
                                      size: 24.sp,
                                    ),
                                    16.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        selectedDate.value != null 
                                            ? '${selectedDate.value!.day} ${selectedMonth.value} ${selectedYear.value}'
                                            : l10n.selectDriver,
                                        style: montserrat(
                                          14,
                                          selectedDate.value != null ? grey36 : grey5F63,
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: grey5F63,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          // Selected date display
                          if (selectedDate.value != null) ...[
                            20.verticalSpace,
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: accentPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: accentPurple.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    l10n.chooseAccountType,
                                    style: montserrat(14, grey36, FontWeight.w600),
                                  ),
                                  8.verticalSpace,
                                  Text(
                                    '${selectedDate.value!.day} ${selectedMonth.value} ${selectedYear.value}',
                                    style: montserrat(16, accentPurple, FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          
                          32.verticalSpace,
                          
                          // Continue button
                          NormalCustomButton(
                            label: l10n.continueButton,
                            onPressed: isLoading.value ? null : onContinuePressed,
                          ),
                          
                          20.verticalSpace,

                          // Skip for Test button (visible)
                          NormalCustomButton(
                            label: l10n.continueButton,
                            onPressed: () => navigateToBookingFlowForTest(),
                          ),

                          12.verticalSpace,
                          
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