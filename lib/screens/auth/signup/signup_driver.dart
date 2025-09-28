import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/screens/auth/signup/provider/signup_provider.dart';
import 'package:semester_student_ride_app/services/signup_service.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/models/vehicle_data.dart';
import 'package:semester_student_ride_app/models/location_data.dart';
import 'package:semester_student_ride_app/widgets/searchable_dropdown_field.dart';
import 'package:semester_student_ride_app/widgets/multi_select_service_types.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import '../../../semester_student_ride_app_imports.dart';

class SignUpScreenDriver extends HookConsumerWidget {
  const SignUpScreenDriver({super.key});

  // Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) {
        final isRTL = Directionality.of(context) == TextDirection.rtl;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentPurple.withOpacity(0.1),
                accentPurple.withOpacity(0.05)
              ],
              begin: isRTL ? Alignment.centerRight : Alignment.centerLeft,
              end: isRTL ? Alignment.centerLeft : Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: accentPurple.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 20.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentPurple, accentPurple.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: isRTL ? 8.w : 12.w),
              Text(
                title,
                style: montserrat(16, accentPurple, FontWeight.w600),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build error text consistently
  Widget _buildErrorText(String? errorText) {
    if (errorText == null) return const SizedBox();

    return Builder(
      builder: (context) {
        final isRTL = Directionality.of(context) == TextDirection.rtl;

        return Padding(
          padding: EdgeInsets.only(
            top: 8.h,
            left: isRTL ? 0 : 4.w,
            right: isRTL ? 4.w : 0,
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline,
                  size: 16.sp, color: Colors.red.withOpacity(0.8)),
              SizedBox(width: isRTL ? 4.w : 8.w),
              Expanded(
                child: Text(
                  errorText,
                  style: montserrat(
                      12, Colors.red.withOpacity(0.8), FontWeight.w500),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Get the SignupNotifier
    final signupNotifier = ref.watch(signupNotifierProvider.notifier);
    final signupState = ref.watch(signupNotifierProvider);

    // Setup controllers that sync with the state
    final nameController = useTextEditingController(text: signupState.name);
    final phoneController = useTextEditingController(
        text: signupState.phoneNumber.startsWith('+966')
            ? signupState.phoneNumber.substring(4) // Remove +966 for display
            : signupState.phoneNumber);
    final passwordController =
        useTextEditingController(text: signupState.password);
    final emailController = useTextEditingController(text: signupState.email);

    // Update state when controllers change
    useEffect(() {
      void nameListener() {
        signupNotifier.updateName(nameController.text);
      }

      void emailListener() {
        signupNotifier.updateEmail(emailController.text);
      }

      void passwordListener() {
        signupNotifier.updatePassword(passwordController.text);
      }

      nameController.addListener(nameListener);
      emailController.addListener(emailListener);
      passwordController.addListener(passwordListener);

      // Set initial values if controllers have text but state is empty
      if (nameController.text.isNotEmpty && signupState.name.isEmpty) {
        signupNotifier.updateName(nameController.text);
      }
      if (emailController.text.isNotEmpty && signupState.email.isEmpty) {
        signupNotifier.updateEmail(emailController.text);
      }
      if (passwordController.text.isNotEmpty && signupState.password.isEmpty) {
        signupNotifier.updatePassword(passwordController.text);
      }

      return () {
        nameController.removeListener(nameListener);
        emailController.removeListener(emailListener);
        passwordController.removeListener(passwordListener);
      };
    }, []);

    // Keep phoneController in sync with signupState.phoneNumber
    useValueChanged<String, void>(signupState.phoneNumber, (_, __) {
      final displayPhone = signupState.phoneNumber.startsWith('+966')
          ? signupState.phoneNumber.substring(4)
          : signupState.phoneNumber;

      // Only update if different to avoid cursor jumping
      if (phoneController.text.replaceAll(' ', '') !=
          displayPhone.replaceAll(' ', '')) {
        // Format the phone number for display
        String cleanedValue = displayPhone.replaceAll(RegExp(r'[^0-9]'), '');
        String formatted = cleanedValue;
        if (cleanedValue.length > 2) {
          formatted =
              '${cleanedValue.substring(0, 2)} ${cleanedValue.substring(2)}';
        }
        if (cleanedValue.length > 5) {
          formatted =
              '${cleanedValue.substring(0, 2)} ${cleanedValue.substring(2, 5)} ${cleanedValue.substring(5)}';
        }
        phoneController.text = formatted;
      }
    });

    Future<void> onSignUpPressed() async {
      FocusScope.of(context).unfocus();

      // Force sync all controller values to state before validation
      signupNotifier.updateName(nameController.text);
      signupNotifier.updateEmail(emailController.text);
      signupNotifier.updatePassword(passwordController.text);

      // Small delay to ensure state is updated
      await Future.delayed(const Duration(milliseconds: 100));

      // Validate all driver fields first
      if (!signupNotifier.validateDriverSignup()) {
        // Validation failed - errors are already set in the state
        // The UI will automatically show the error messages
        print('Debug - Validation failed with errors:');
        print('Name Error: ${signupState.nameError}');
        print('Email Error: ${signupState.emailError}');
        print('Phone Error: ${signupState.phoneError}');
        print('Vehicle Make Error: ${signupState.vehicleMakeError}');
        print('Vehicle Model Error: ${signupState.vehicleModelError}');
        print('Vehicle Year Error: ${signupState.vehicleYearError}');
        print('District Error: ${signupState.districtError}');
        print('Selected Service Types: ${signupState.selectedServiceTypes}');
        print('Service Type Error: ${signupState.serviceTypeError}');
        print('Password Error: ${signupState.passwordError}');
        return;
      }

      try {
        // Set loading state
        signupNotifier.updateIsLoading(true);

        // Check if email is already in use
        final signupService = SignupService();
        final emailExists = await signupService
            .isEmailAlreadyRegistered(signupState.email.toLowerCase());

        if (emailExists) {
          // Email is already registered, show error
          signupNotifier.setEmailError("This email is already registered.");
          return;
        }

        // Check if phone number is already in use
        final phoneExists = await signupService
            .isPhoneNumberAlreadyRegistered(signupState.phoneNumber);

        if (phoneExists) {
          // Phone is already registered, show error
          signupNotifier
              .setPhoneError("This phone number is already registered.");
          return;
        }

        // Set driver flag to true
        signupNotifier.updateIsDriver(true);
        signupNotifier.updateIsLoading(false);

        // Navigate to upload documents screen for drivers
        // The documents will be validated there before final signup
        if (context.mounted) {
          context.push('/upload_documents');
        }
      } catch (e) {
        // Set loading to false and show error dialog
        signupNotifier.updateIsLoading(false);
        if (context.mounted) {
          showErrorDialog(context, "Error",
              "Failed to verify account information. Please check your internet connection and try again.");
        }
        print('Error during email/phone verification: $e');
      }
    }

    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top spacing
                20.verticalSpace,
                Image.asset(AppImages.logo, width: 230.w, fit: BoxFit.cover),

                100.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 750.h,
                  ),
                ),
              ],
            ),
          ),
          // Enhanced main form container with gradient border and improved shadows
          Container(
            margin: EdgeInsets.fromLTRB(20.w, 140.h, 20.w, 32.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: accentPurple.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentPurple.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 32.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Enhanced header container matching section header style
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentPurple.withOpacity(0.1),
                            accentPurple.withOpacity(0.05)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                            color: accentPurple.withOpacity(0.2), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 4.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      accentPurple,
                                      accentPurple.withOpacity(0.7)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              12.horizontalSpace,
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    accentPurple,
                                    accentPurple.withOpacity(0.8)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  l10n.signUp,
                                  style: montserrat(
                                      24, Colors.white, FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // signupState.profilePicture == null
                    //     ? Padding(
                    //         padding: EdgeInsets.only(top: 5.h),
                    //         child: Text(
                    //           'Please select a profile picture',
                    //           style: montserrat(12, Colors.red.withOpacity(0.6),
                    //               FontWeight.w400),
                    //         ),
                    //       )
                    //     : const SizedBox(),
                    // Enhanced form fields with improved spacing and visual hierarchy
                    20.verticalSpace,

                    // Personal Information Section
                    _buildSectionHeader(l10n.personalInformation),
                    16.verticalSpace,

                    CustomTextField(
                      controller: nameController,
                      prefixIcon: AppIcons.userIcon,
                      titleText: l10n.fullName,
                      hintText: l10n.fullName,
                    ),
                    _buildErrorText(signupState.nameError),

                    16.verticalSpace,
                    EmailTextField(
                      controller: emailController,
                      titleText: l10n.email,
                    ),
                    _buildErrorText(signupState.emailError),

                    16.verticalSpace,
                    // Enhanced Phone Number Field with Saudi formatting
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: grey5E5E5E.withOpacity(0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: grey5E5E5E.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Country Code Section
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: grey5E5E5E.withOpacity(0.05),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.r),
                                    bottomLeft: Radius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.phoneIcon,
                                      width: 20.w,
                                      height: 20.w,
                                      color: grey5E5E5E,
                                    ),
                                    8.horizontalSpace,
                                    Text(
                                      '+966',
                                      style: montserrat(
                                          16, grey5E5E5E, FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider line
                              Container(
                                width: 1,
                                height: 32.h,
                                color: grey5E5E5E.withOpacity(0.2),
                              ),
                              // Phone Number Input
                              Expanded(
                                child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  style:
                                      montserrat(16, grey36, FontWeight.w500),
                                  decoration: InputDecoration(
                                    hintText: '5X XXX XXXX',
                                    hintStyle: montserrat(
                                        14,
                                        grey5E5E5E.withOpacity(0.6),
                                        FontWeight.w400),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    // Remove any non-numeric characters and limit to 9 digits
                                    String cleanedValue =
                                        value.replaceAll(RegExp(r'[^0-9]'), '');
                                    if (cleanedValue.length > 9) {
                                      cleanedValue =
                                          cleanedValue.substring(0, 9);
                                    }

                                    // Format the phone number (5X XXX XXXX)
                                    if (cleanedValue.isNotEmpty) {
                                      String formatted = cleanedValue;
                                      if (cleanedValue.length > 2) {
                                        formatted =
                                            '${cleanedValue.substring(0, 2)} ${cleanedValue.substring(2)}';
                                      }
                                      if (cleanedValue.length > 5) {
                                        formatted =
                                            '${cleanedValue.substring(0, 2)} ${cleanedValue.substring(2, 5)} ${cleanedValue.substring(5)}';
                                      }

                                      if (phoneController.text != formatted) {
                                        phoneController.value =
                                            TextEditingValue(
                                          text: formatted,
                                          selection: TextSelection.collapsed(
                                              offset: formatted.length),
                                        );
                                      }
                                    }

                                    // Update the state with the full number including country code
                                    signupNotifier
                                        .updatePhoneNumber('+966$cleanedValue');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _buildErrorText(signupState.phoneError),

                    24.verticalSpace,

                    // Vehicle Information Section
                    _buildSectionHeader(l10n.vehicleInformation),
                    16.verticalSpace,

                    // Vehicle Make Dropdown
                    SearchableDropdownField(
                      title: l10n.vehicleMake,
                      hint: l10n.selectVehicleMake,
                      value: signupState.vehicleMake,
                      items: VehicleData.getAllMakes(),
                      onChanged: (value) {
                        signupNotifier.updateVehicleMake(value);
                      },
                      prefixIcon: AppIcons.carSignal,
                      errorText: signupState.vehicleMakeError,
                    ),

                    16.verticalSpace,

                    // Vehicle Model Dropdown
                    SearchableDropdownField(
                      title: l10n.vehicleModel,
                      hint: l10n.selectVehicleModel,
                      value: signupState.vehicleModel,
                      items: signupState.vehicleMake.isNotEmpty
                          ? VehicleData.getModelsForMake(
                              signupState.vehicleMake)
                          : [],
                      onChanged: (value) {
                        signupNotifier.updateVehicleModel(value);
                      },
                      prefixIcon: AppIcons.vehicleModel,
                      enabled: signupState.vehicleMake.isNotEmpty,
                      errorText: signupState.vehicleModelError,
                    ),

                    16.verticalSpace,

                    // Vehicle Year Dropdown
                    SearchableDropdownField(
                      title: l10n.vehicleYear,
                      hint: l10n.selectVehicleYear,
                      value: signupState.vehicleYear,
                      items: signupState.vehicleMake.isNotEmpty &&
                              signupState.vehicleModel.isNotEmpty
                          ? VehicleData.getYearsForModel(
                              signupState.vehicleMake, signupState.vehicleModel)
                          : [],
                      onChanged: (value) {
                        signupNotifier.updateVehicleYear(value);
                      },
                      prefixIcon: AppIcons.calender,
                      enabled: signupState.vehicleMake.isNotEmpty &&
                          signupState.vehicleModel.isNotEmpty,
                      errorText: signupState.vehicleYearError,
                    ),

                    24.verticalSpace,

                    // Location Section (Cascading Dropdowns)
                    _buildSectionHeader(l10n.locationInformation),
                    16.verticalSpace,

                    // Region Dropdown
                    SearchableDropdownField(
                      title: "Region", // TODO: Add to localizations
                      hint: "Select Region", // TODO: Add to localizations
                      value: signupState.region,
                      items: LocationData.getAllRegions(),
                      onChanged: (value) {
                        signupNotifier.updateRegion(value);
                      },
                      prefixIcon: AppIcons.district,
                      errorText: signupState.regionError,
                    ),

                    16.verticalSpace,

                    // City Dropdown
                    SearchableDropdownField(
                      title: l10n.city,
                      hint: "Select City", // TODO: Add to localizations
                      value: signupState.city,
                      items: signupState.region.isNotEmpty
                          ? LocationData.getCitiesForRegion(signupState.region)
                          : [],
                      onChanged: (value) {
                        signupNotifier.updateCity(value);
                      },
                      prefixIcon: AppIcons.district,
                      enabled: signupState.region.isNotEmpty,
                      errorText: signupState.cityError,
                    ),

                    16.verticalSpace,

                    // District Dropdown
                    SearchableDropdownField(
                      title: l10n.district,
                      hint: "Select District", // TODO: Add to localizations
                      value: signupState.district,
                      items: signupState.city.isNotEmpty
                          ? LocationData.getDistrictsForCity(signupState.city)
                          : [],
                      onChanged: (value) {
                        signupNotifier.updateDistrict(value);
                      },
                      prefixIcon: AppIcons.district,
                      enabled: signupState.city.isNotEmpty,
                      errorText: signupState.districtError,
                    ),

                    16.verticalSpace,
                    _buildSectionHeader(l10n.serviceType),
                    8.verticalSpace,

                    // Multi-Select Service Types
                    MultiSelectServiceTypes(
                      title: l10n.serviceType,
                      selectedServiceTypes: signupState.selectedServiceTypes,
                      onServiceTypeToggle: (serviceType) {
                        signupNotifier.toggleServiceType(serviceType);
                      },
                      errorText: signupState.serviceTypeError,
                    ),

                    24.verticalSpace,

                    // Security Section
                    _buildSectionHeader(l10n.security),
                    16.verticalSpace,

                    PasswordTextField(
                      controller: passwordController,
                      titleText: l10n.createPassword,
                    ),
                    _buildErrorText(signupState.passwordError),

                    // Enhanced terms and conditions section
                    24.verticalSpace,
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: accentPurple.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            Border.all(color: accentPurple.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              color: accentPurple, size: 20.sp),
                          12.horizontalSpace,
                          Expanded(
                            child: Text(
                              l10n.termsDescription,
                              style: montserrat(12, grey5F63, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),

                    24.verticalSpace,
                    // Enhanced CTA Button with gradient
                    Container(
                      width: double.infinity,
                      height: 54.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentPurple, accentPurple.withOpacity(0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: accentPurple.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            signupState.isLoading ? null : onSignUpPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: signupState.isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.drive_eta,
                                      color: Colors.white, size: 20.sp),
                                  12.horizontalSpace,
                                  Text(
                                    l10n.continueButton,
                                    style: montserrat(
                                        16, Colors.white, FontWeight.w600),
                                  ),
                                  8.horizontalSpace,
                                  Icon(Icons.arrow_forward,
                                      color: Colors.white, size: 18.sp),
                                ],
                              ),
                      ),
                    ),

                    5.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
