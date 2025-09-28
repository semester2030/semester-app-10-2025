import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/screens/auth/signup/provider/signup_provider.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import '../../../semester_student_ride_app_imports.dart';

class SignUpScreenUser extends HookConsumerWidget {
  const SignUpScreenUser({super.key});

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

    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 4.w),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              size: 16.sp, color: Colors.red.withOpacity(0.8)),
          8.horizontalSpace,
          Expanded(
            child: Text(
              errorText,
              style:
                  montserrat(12, Colors.red.withOpacity(0.8), FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Build a radio button style role selector
  static Widget _buildRoleButton(
      String role, bool isSelected, VoidCallback onTap) {
    return Builder(
      builder: (context) {
        final isRTL = Directionality.of(context) == TextDirection.rtl;

        return GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? accentPurple : grey5E5E5E,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: const Center(
                          child: Icon(
                            Icons.circle,
                            size: 12,
                            color: accentPurple,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: isRTL ? 4 : 8),
              Text(
                role,
                style: montserrat(14, grey5E5E5E, FontWeight.w500),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
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
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Get the SignupNotifier
    final signupNotifier = ref.watch(signupNotifierProvider.notifier);
    final signupState = ref.watch(signupNotifierProvider);

    // Get role from previous screen
    final routeData = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final selectedRole = routeData?['role'] as String?;

    // Setup controllers that sync with the state
    final nameController = useTextEditingController(text: signupState.name);
    final phoneController = useTextEditingController(
        text: signupState.phoneNumber.startsWith('+966')
            ? signupState.phoneNumber.substring(4) // Remove +966 for display
            : signupState.phoneNumber);
    final passwordController =
        useTextEditingController(text: signupState.password);
    final emailController = useTextEditingController(text: signupState.email);

    // Gender controller for dropdown display
    final genderController = useTextEditingController(text: signupState.gender);

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

      return () {
        nameController.removeListener(nameListener);
        emailController.removeListener(emailListener);
        passwordController.removeListener(passwordListener);
      };
    }, []);

    // Keep genderController in sync with signupState.gender
    useValueChanged<String, void>(signupState.gender, (_, __) {
      genderController.text = signupState.gender;
    });

    // Set role from previous screen if provided
    useEffect(() {
      if (selectedRole != null && signupState.role.isEmpty) {
        // Map role keys to display names
        String roleDisplayName;
        switch (selectedRole) {
          case 'school_student':
            roleDisplayName = 'Student';
            break;
          case 'university_student':
            roleDisplayName = 'Student';
            break;
          case 'teacher':
            roleDisplayName = 'Teacher';
            break;
          case 'employee':
            roleDisplayName = 'Employee';
            break;
          case 'parent':
            roleDisplayName = 'Parent';
            break;
          case 'metro_user':
            roleDisplayName = 'Metro User';
            break;
          default:
            roleDisplayName = 'Student';
        }
        signupNotifier.updateRole(roleDisplayName);
      }
      return null;
    }, [selectedRole]);

    void updateGenderPrefrence(String value) {
      signupNotifier.updateGender(value);
    }

    void updateRolePreference(String value) {
      signupNotifier.updateRole(value);
    }

    Future<void> onSignUpPressed() async {
      print('Debug: Continue Registration button pressed');
      print('Debug: Current signup state:');
      print('  - Name: ${signupState.name}');
      print('  - Email: ${signupState.email}');
      print('  - Phone: ${signupState.phoneNumber}');
      print(
          '  - Password: ${signupState.password.isNotEmpty ? "***" : "empty"}');
      print('  - Gender: ${signupState.gender}');
      print('  - Role: ${signupState.role}');
      print('  - IsLoading: ${signupState.isLoading}');

      try {
        print('Debug: Sending email verification OTP...');
        // Send OTP to email for verification first
        await signupNotifier.sendEmailVerificationOtp(context);
        print('Debug: Email verification OTP sent');

        // Navigation will happen in sendEmailVerificationOtp method
      } catch (e) {
        print('Debug: Error in sending email verification OTP: $e');

        // Show error dialog
        if (context.mounted) {
          showErrorDialog(context, "Signup Error",
              "An error occurred during signup. Please try again.");
        }
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
                    // Saudi Phone Number Field with Country Code
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50.h, // Match CustomTextField height
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: grey5E5E5E.withOpacity(0.3),
                              width: 1,
                            ),
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
                              // Country Code Container
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
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

                    // User Information Section
                    _buildSectionHeader(l10n.userInformation),
                    16.verticalSpace,

                    // Enhanced Gender Dropdown
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: accentPurple.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          AbsorbPointer(
                            child: CustomTextField(
                              controller: genderController,
                              prefixIcon: AppIcons.genderIcon,
                              titleText: l10n.gender,
                              hintText: l10n.selectGender,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: isRTL
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                margin: isRTL
                                    ? EdgeInsets.only(left: 12.w)
                                    : EdgeInsets.only(right: 12.w),
                                child: PopupMenuButton<String>(
                                  icon: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: accentPurple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(Icons.keyboard_arrow_down,
                                        color: accentPurple, size: 20.sp),
                                  ),
                                  color: Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  onSelected: (String value) {
                                    if (value != signupState.gender) {
                                      updateGenderPrefrence(value);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Male',
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: accentPurple
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                              child: SvgPicture.asset(
                                                  AppIcons.userIcon,
                                                  width: 16.w,
                                                  height: 16.w,
                                                  color: accentPurple),
                                            ),
                                            SizedBox(width: isRTL ? 8.w : 12.w),
                                            Text(l10n.male,
                                                style: montserrat(16, grey36,
                                                    FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Female',
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: accentPurple
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                              child: SvgPicture.asset(
                                                  AppIcons.userIcon,
                                                  width: 16.w,
                                                  height: 16.w,
                                                  color: accentPurple),
                                            ),
                                            SizedBox(width: isRTL ? 8.w : 12.w),
                                            Text(l10n.female,
                                                style: montserrat(16, grey36,
                                                    FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildErrorText(signupState.genderError),

                    16.verticalSpace,

                    // Enhanced Role Selection Section with better styling
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentPurple.withOpacity(0.05),
                            accentPurple.withOpacity(0.02)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                            color: accentPurple.withOpacity(0.15), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 3.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: accentPurple,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              8.horizontalSpace,
                              Text(l10n.selectYourRole,
                                  style: montserrat(
                                      16, accentPurple, FontWeight.w600)),
                            ],
                          ),
                          12.verticalSpace,
                          // First row: Student, Teacher, Employee
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SignUpScreenUser._buildRoleButton(
                                l10n.student,
                                signupState.role == 'Student',
                                () => updateRolePreference('Student'),
                              ),
                              SignUpScreenUser._buildRoleButton(
                                l10n.teacher,
                                signupState.role == 'Teacher',
                                () => updateRolePreference('Teacher'),
                              ),
                              SignUpScreenUser._buildRoleButton(
                                l10n.employee,
                                signupState.role == 'Employee',
                                () => updateRolePreference('Employee'),
                              ),
                            ],
                          ),
                          16.verticalSpace,
                          // Second row: Parent, Metro User
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SignUpScreenUser._buildRoleButton(
                                'Parent',
                                signupState.role == 'Parent',
                                () => updateRolePreference('Parent'),
                              ),
                              SignUpScreenUser._buildRoleButton(
                                'Metro User',
                                signupState.role == 'Metro User',
                                () => updateRolePreference('Metro User'),
                              ),
                              const SizedBox(width: 100), // Empty space for alignment
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildErrorText(signupState.roleError),

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
                              l10n.termsAndConditionsText,
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
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  Text(
                                    'Processing...',
                                    style: montserrat(
                                        16, Colors.white, FontWeight.w600),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add,
                                      color: Colors.white, size: 20.sp),
                                  12.horizontalSpace,
                                  Text(
                                    l10n.continueRegistration,
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
