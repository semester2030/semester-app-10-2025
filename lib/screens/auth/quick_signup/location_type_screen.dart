import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class LocationTypeScreen extends HookConsumerWidget {
  final String role;
  final String phoneNumber;
  final String name;
  final String gender;
  final String password;
  
  const LocationTypeScreen({
    super.key,
    required this.role,
    required this.phoneNumber,
    required this.name,
    required this.gender,
    required this.password,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final selectedLocationType = useState<String?>(null);

    // Location type options
    final locationTypes = [
      {
        'id': 'current_location',
        'title': l10n.setPickupLocationSchedule,
        'subtitle': l10n.provideLocationDetails,
        'icon': Icons.my_location,
      },
      {
        'id': 'manual_entry',
        'title': l10n.enterHomeAddress,
        'subtitle': l10n.provideLocationDetails,
        'icon': Icons.edit_location,
      },
    ];

    Future<void> onContinuePressed() async {
      if (selectedLocationType.value == null) {
        showErrorFlushBar(
          message: l10n.addressInformation,
          context: context,
        );
        return;
      }

      // Navigate to location details screen
      if (context.mounted) {
        context.push('/location_details', extra: {
          'role': role,
          'phoneNumber': phoneNumber,
          'name': name,
          'gender': gender,
          'password': password,
          'locationType': selectedLocationType.value!,
        });
      }
    }

    return Scaffold(
      backgroundColor: accentPurple,
      body: SafeArea(
        child: Stack(
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
                // Bottom section with location type selection
                Expanded(
                  child: ClipPath(
                    clipper: CircularTopClipper(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: SafeArea(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 40.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                // Location type options
                                Column(
                                  children: locationTypes.map((locationType) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: _buildLocationTypeButton(
                                        context: context,
                                        title: locationType['title'] as String,
                                        subtitle: locationType['subtitle'] as String,
                                        icon: locationType['icon'] as IconData,
                                        isSelected: selectedLocationType.value == locationType['id'],
                                        onTap: () => selectedLocationType.value = locationType['id'] as String,
                                      ),
                                    );
                                  }).toList(),
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTypeButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? accentPurple : grey5F63.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: isSelected ? accentPurple : grey5F63.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : grey5F63,
                size: 24.w,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: montserrat(
                      16,
                      isSelected ? accentPurple : grey36,
                      FontWeight.w600,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: montserrat(
                      12,
                      grey5F63,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: accentPurple,
                size: 24.w,
              ),
          ],
        ),
      ),
    );
  }
}