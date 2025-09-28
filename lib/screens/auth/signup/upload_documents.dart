import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/screens/auth/signup/provider/signup_provider.dart';
import 'package:semester_student_ride_app/screens/auth/signup/provider/signup_state.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import '../../../semester_student_ride_app_imports.dart';

class UploadDriverDocuments extends HookConsumerWidget {
  // Gender controller for dropdown display

  const UploadDriverDocuments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Get the SignupNotifier
    final signupNotifier = ref.watch(signupNotifierProvider.notifier);
    final signupState = ref.watch(signupNotifierProvider);

    // Setup controllers that sync with the state
    final nameController = useTextEditingController(text: signupState.name);
    final emailController = useTextEditingController(text: signupState.email);

    // Gender controller for dropdown display
    final genderController = useTextEditingController(text: signupState.gender);

    var showSuccessScreen = useState<bool>(false);

    // Update state when controllers change
    useEffect(() {
      nameController.addListener(() {
        signupNotifier.updateName(nameController.text);
      });

      emailController.addListener(() {
        signupNotifier.updateEmail(emailController.text);
      });

      return () {
        nameController.removeListener(() {});
        emailController.removeListener(() {});
      };
    }, []);

    // Keep genderController in sync with signupState.gender
    useValueChanged<String, void>(signupState.gender, (_, __) {
      genderController.text = signupState.gender;
    });

    // Future<void> onSignUpPressed() async {
    // // First check if profile picture is selected
    // if (signupState.profilePicture == null) {
    //   return showErrorFlushBar(
    //       message: 'Please select a profile picture', context: context);
    // }
    // if (!signupNotifier.validateFirstScreen()) return;

    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       backgroundColor: Colors.black,
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           CircularProgressIndicator(
    //             color: accentGold,
    //           ),
    //           20.verticalSpace,
    //           Text(
    //             'Checking email availability...',
    //             style: montserrat(14, accentGold, FontWeight.w500),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );

    // // Set loading state
    // isLoading.value = true;

    // try {
    //   // Check if email already exists in Firebase
    //   final querySnapshot = await userCollection
    //       .where("email", isEqualTo: signupState.email.trim())
    //       .get();

    //   // Close the dialog
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }

    //   // If we found matching documents, this email is already registered
    //   if (querySnapshot.docs.isNotEmpty) {
    //     if (!context.mounted) return;
    //     isLoading.value = false;

    //     return showErrorDialog(context, "Email already in use",
    //         'This email is already registered. Please use a different email or login.');
    //   }

    //   // Email is available, proceed to second screen
    //   signupNotifier.proceedToSecondScreen(context);
    // } catch (e) {
    //   // Close the dialog in case of error
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }

    //   if (!context.mounted) return;
    //   showErrorFlushBar(
    //       message: 'Error checking email availability. Please try again.',
    //       context: context);
    // } finally {
    //   isLoading.value = false;
    // }

    // context.push('/otp', extra: {
    //   'phoneNumber': "forgotPasswordState.email",
    //   'isFromSignup': true
    // });
    // }

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
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 150.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: showSuccessScreen.value
                    ? [
                        // Success Screen Content
                        60.verticalSpace,
                        SvgPicture.asset(AppIcons.successCheck),
                        40.verticalSpace,
                        Text(
                          l10n.congratulations,
                          style: montserrat(24, grey36, FontWeight.w600),
                        ),
                        20.verticalSpace,
                        Text(
                          l10n.applicationSubmittedSuccessfully,
                          textAlign: TextAlign.center,
                          style: montserrat(14, grey5F63, FontWeight.w500),
                        ),
                        80.verticalSpace,
                        NormalCustomButton(
                          label: l10n.done,
                          syncCallback: () {
                            context.go('/login');
                          },
                        ),
                        20.verticalSpace,

                        NormalCustomButton(
                          label: l10n.close,
                          buttonColor: Color(0xffF3F8FE),
                          titleStyle:
                              montserrat(16, grey5E5E5E, FontWeight.w500),
                          syncCallback: () {
                            context.go('/login');
                          },
                        ),
                      ]
                    : [
                        HeadingContainer(
                          title: l10n.becomeDriver,
                        ),

                        8.verticalSpace,
                        Text(
                          l10n.verifyIdentityDescription,
                          style: montserrat(15, grey5F63, FontWeight.w400),
                        ),

                        24.verticalSpace,

                        // Progress indicator
                        _buildProgressIndicator(context, signupState),

                        32.verticalSpace,

                        // ID Card Photo Upload
                        _buildDocumentUploadSection(
                          context: context,
                          title: l10n.uploadIdCard,
                          fileName: signupState.idImage != null
                              ? l10n.idCardFileName
                              : null,
                          onTap: () =>
                              _pickImage(context, 'idCard', signupNotifier),
                          onDelete: signupState.idImage != null
                              ? () => signupNotifier.updateIdImage('')
                              : null,
                        ),

                        20.verticalSpace,

                        // Driving License Photo Upload
                        _buildDocumentUploadSection(
                          context: context,
                          title: l10n.drivingLicense,
                          fileName: signupState.drivingLicenseImage != null
                              ? l10n.drivingLicenseFileName
                              : null,
                          onTap: () => _pickImage(
                              context, 'drivingLicense', signupNotifier),
                          onDelete: signupState.drivingLicenseImage != null
                              ? () => signupNotifier.removeDrivingLicenseImage()
                              : null,
                        ),

                        20.verticalSpace,

                        // Vehicle Photo Upload
                        _buildDocumentUploadSection(
                          context: context,
                          title: l10n.vehicleRegistration,
                          fileName: signupState.vehicleRegistrationImage != null
                              ? l10n.vehicleRegistrationFileName
                              : null,
                          onTap: () =>
                              _pickImage(context, 'vehicle', signupNotifier),
                          onDelete: signupState.vehicleRegistrationImage != null
                              ? () => signupNotifier
                                  .removeVehicleRegistrationImage()
                              : null,
                        ),

                        20.verticalSpace,

                        // Clear Vehicle Photo with License Plate Upload
                        _buildDocumentUploadSection(
                          context: context,
                          title: l10n.vehiclePhoto,
                          fileName: signupState.vehiclePhotoImage != null
                              ? l10n.vehiclePhotoFileName
                              : null,
                          onTap: () => _pickImage(
                              context, 'vehiclePhoto', signupNotifier),
                          onDelete: signupState.vehiclePhotoImage != null
                              ? () => signupNotifier.removeVehiclePhotoImage()
                              : null,
                        ),

                        40.verticalSpace,

                        // Submit Button
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 50.h,
                        //   child: ElevatedButton(
                        //     onPressed: _canSubmit(signupState) ? onSignUpPressed : null,
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: accentPurple,
                        //       disabledBackgroundColor: Colors.grey.shade300,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(25.r),
                        //       ),
                        //     ),
                        //     child: Text(
                        //       'Submit Application',
                        //       style: montserrat(16, Colors.white, FontWeight.w600),
                        //     ),
                        //   ),
                        // ),

                        NormalCustomButton(
                          label: l10n.submit,
                          onPressed: signupState.isLoading
                              ? null
                              : () async {
                                  try {
                                    // Validate that basic info is filled and documents are uploaded
                                    if (signupState.idImage == null ||
                                        signupState.drivingLicenseImage ==
                                            null ||
                                        signupState.vehicleRegistrationImage ==
                                            null ||
                                        signupState.vehiclePhotoImage == null) {
                                      showErrorFlushBar(
                                        message:
                                            'Please upload all required documents',
                                        context: context,
                                      );
                                      return;
                                    }

                                    // Sign up driver with all validations handled inside
                                    await signupNotifier.signupDriver(context);

                                    // Show success screen after successful registration
                                    if (context.mounted) {
                                      showSuccessScreen.value = true;
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      showErrorDialog(context, "Signup Error",
                                          "An error occurred during signup. Please try again.");
                                    }
                                  }
                                },
                        ),
                        20.verticalSpace,
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for image picking
  Future<void> _pickImage(BuildContext context, String imageType,
      SignupNotifier signupNotifier) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Show source selection dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              l10n.selectImageSource,
              style: montserrat(16, Colors.black, FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: accentPurple),
                  title: Text(
                    l10n.camera,
                    style: montserrat(14, Colors.black, FontWeight.w500),
                  ),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: accentPurple),
                  title: Text(
                    l10n.gallery,
                    style: montserrat(14, Colors.black, FontWeight.w500),
                  ),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );

      if (source == null) return;

      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedImage == null) return;

      // Update the appropriate image in state
      switch (imageType) {
        case 'idCard':
          signupNotifier.updateIdImage(pickedImage.path);
          break;
        case 'drivingLicense':
          signupNotifier.updateDrivingLicenseImage(pickedImage.path);
          break;
        case 'vehicle':
          signupNotifier.updateVehicleRegistrationImage(pickedImage.path);
          break;
        case 'vehiclePhoto':
          signupNotifier.updateVehiclePhotoImage(pickedImage.path);
          break;
      }

      // Show success feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Image uploaded successfully!',
              style: montserrat(14, Colors.white, FontWeight.w500),
            ),
            backgroundColor: accentPurple,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showErrorFlushBar(
          message: 'Failed to select image. Please try again.',
          context: context,
        );
      }
    }
  }

  // Helper method to build document upload sections
  Widget _buildDocumentUploadSection({
    required BuildContext context,
    required String title,
    String? fileName,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: fileName != null
                ? accentPurple.withOpacity(0.3)
                : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
        color: fileName != null
            ? accentPurple.withOpacity(0.05)
            : Colors.grey.shade50,
      ),
      child: fileName != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.description,
                        color: accentPurple, size: 24.sp),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: montserrat(14, Colors.black, FontWeight.w600),
                        ),
                        4.verticalSpace,
                        Text(
                          l10n.documentUploadedSuccessfully,
                          style: montserrat(12, Colors.green, FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      AppIcons.upload,
                      width: 40.w,
                      height: 40.h,
                    ),
                    12.verticalSpace,
                    Text(
                      title,
                      style:
                          montserrat(14, Colors.grey.shade700, FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    4.verticalSpace,
                    Text(
                      l10n.tapToUploadDocument,
                      style:
                          montserrat(12, Colors.grey.shade500, FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Helper method to check if all documents are uploaded
  // bool _canSubmit(SignupState signupState) {
  //   return signupState.frontIdImage != null &&
  //       signupState.drivingLicenseImage != null &&
  //       signupState.vehicleImage != null;
  // }

  // Helper method to build progress indicator
  Widget _buildProgressIndicator(
      BuildContext context, SignupState signupState) {
    final l10n = AppLocalizations.of(context)!;
    int uploadedCount = 0;
    const int totalCount = 4;

    if (signupState.idImage != null) uploadedCount++;
    if (signupState.drivingLicenseImage != null) uploadedCount++;
    if (signupState.vehicleRegistrationImage != null) uploadedCount++;
    if (signupState.vehiclePhotoImage != null) uploadedCount++;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: accentPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: accentPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.assignment_turned_in,
            color: accentPurple,
            size: 20.sp,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.documentsProgress,
                  style: montserrat(14, accentPurple, FontWeight.w600),
                ),
                4.verticalSpace,
                Text(
                  l10n.documentsUploaded(uploadedCount, totalCount),
                  style: montserrat(12, Colors.grey.shade600, FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: uploadedCount == totalCount ? Colors.green : accentPurple,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '$uploadedCount/$totalCount',
              style: montserrat(12, Colors.white, FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
