import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/signup/provider/signup_state.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:semester_student_ride_app/services/signup_service.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/utils/flushbar.dart';
import 'package:semester_student_ride_app/utils/send_signup_email_otp.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.g.dart';

@riverpod
class SignupNotifier extends _$SignupNotifier {
  @override
  SignupState build() {
    return const SignupState();
  }

  // Update methods for basic fields
  void updateName(String value) {
    Future.microtask(() {
      state = state.copyWith(name: value, nameError: null);
    });
  }

  void updateEmail(String value) {
    Future.microtask(() {
      state = state.copyWith(email: value, emailError: null);
    });
  }

  void updatePhoneNumber(String value) {
    Future.microtask(() {
      state = state.copyWith(phoneNumber: value, phoneError: null);
    });
  }

  void updatePassword(String value) {
    Future.microtask(() {
      state = state.copyWith(password: value, passwordError: null);
    });
  }

  void updateConfirmPassword(String value) {
    Future.microtask(() {
      state =
          state.copyWith(confirmPassword: value, confirmPasswordError: null);
    });
  }

  void updateIsDriver(bool value) {
    Future.microtask(() {
      state = state.copyWith(isDriver: value);
    });
  }

  // Student-specific update methods
  void updateGender(String value) {
    Future.microtask(() {
      state = state.copyWith(gender: value, genderError: null);
    });
  }

  void updateRole(String value) {
    Future.microtask(() {
      state = state.copyWith(role: value, roleError: null);
    });
  }

  // Driver-specific update methods
  void updateVehicleMake(String value) {
    Future.microtask(() {
      // When make changes, clear model and year
      state = state.copyWith(
        vehicleMake: value,
        vehicleMakeError: null,
        vehicleModel: '',
        vehicleModelError: null,
        vehicleYear: '',
        vehicleYearError: null,
      );
    });
  }

  void updateVehicleModel(String value) {
    Future.microtask(() {
      // When model changes, clear year
      state = state.copyWith(
        vehicleModel: value,
        vehicleModelError: null,
        vehicleYear: '',
        vehicleYearError: null,
      );
    });
  }

  void updateVehicleYear(String value) {
    Future.microtask(() {
      state = state.copyWith(vehicleYear: value, vehicleYearError: null);
    });
  }

  // Location update methods (cascading dropdowns)
  void updateRegion(String value) {
    Future.microtask(() {
      state = state.copyWith(
        region: value,
        regionError: null,
        // Reset dependent fields when region changes
        city: '',
        district: '',
        cityError: null,
        districtError: null,
      );
    });
  }

  void updateCity(String value) {
    Future.microtask(() {
      state = state.copyWith(
        city: value,
        cityError: null,
        // Reset dependent field when city changes
        district: '',
        districtError: null,
      );
    });
  }

  void updateDistrict(String value) {
    Future.microtask(() {
      state = state.copyWith(district: value, districtError: null);
    });
  }

  void updateServiceType(String value) {
    Future.microtask(() {
      state = state.copyWith(serviceType: value, serviceTypeError: null);
    });
  }

  // New methods for handling multiple service types
  void toggleServiceType(TransportationServiceType serviceType) {
    Future.microtask(() {
      final currentSelection =
          Set<TransportationServiceType>.from(state.selectedServiceTypes);

      if (currentSelection.contains(serviceType)) {
        currentSelection.remove(serviceType);
      } else {
        currentSelection.add(serviceType);
      }

      state = state.copyWith(
        selectedServiceTypes: currentSelection,
        serviceTypeError: null,
      );
    });
  }

  void updateSelectedServiceTypes(Set<TransportationServiceType> serviceTypes) {
    Future.microtask(() {
      state = state.copyWith(
        selectedServiceTypes: serviceTypes,
        serviceTypeError: null,
      );
    });
  }

  void clearSelectedServiceTypes() {
    Future.microtask(() {
      state =
          state.copyWith(selectedServiceTypes: <TransportationServiceType>{});
    });
  }

  void updateIsLoading(bool value) {
    Future.microtask(() {
      state = state.copyWith(isLoading: value);
    });
  }

  void setEmailError(String error) {
    Future.microtask(() {
      state = state.copyWith(emailError: error, isLoading: false);
    });
  }

  void setPhoneError(String error) {
    Future.microtask(() {
      state = state.copyWith(phoneError: error, isLoading: false);
    });
  }

  // Location error setter methods
  void setRegionError(String error) {
    Future.microtask(() {
      state = state.copyWith(regionError: error);
    });
  }

  void setCityError(String error) {
    Future.microtask(() {
      state = state.copyWith(cityError: error);
    });
  }

  void setDistrictError(String error) {
    Future.microtask(() {
      state = state.copyWith(districtError: error);
    });
  }

  // Document image update methods
  void updateIdImage(String imagePath) {
    Future.microtask(() {
      state = state.copyWith(idImage: imagePath);
    });
  }

  void updateProfilePicture(String imagePath) {
    Future.microtask(() {
      state = state.copyWith(profilePicture: imagePath);
    });
  }

  void updateDrivingLicenseImage(String imagePath) {
    Future.microtask(() {
      state = state.copyWith(drivingLicenseImage: imagePath);
    });
  }

  void updateVehicleRegistrationImage(String imagePath) {
    Future.microtask(() {
      state = state.copyWith(vehicleRegistrationImage: imagePath);
    });
  }

  // Remove document methods
  void removeDrivingLicenseImage() {
    Future.microtask(() {
      state = state.copyWith(drivingLicenseImage: null);
    });
  }

  void removeVehicleRegistrationImage() {
    Future.microtask(() {
      state = state.copyWith(vehicleRegistrationImage: null);
    });
  }

  void updateVehiclePhotoImage(String imagePath) {
    Future.microtask(() {
      state = state.copyWith(vehiclePhotoImage: imagePath);
    });
  }

  void removeVehiclePhotoImage() {
    Future.microtask(() {
      state = state.copyWith(vehiclePhotoImage: null);
    });
  }

  // Upload image to Firebase Storage
  Future<String?> uploadImageToFirebase(String imagePath, String folder) async {
    try {
      final File file = File(imagePath);
      // Create a unique filename with timestamp
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

      // Reference to the storage location
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('$folder/$fileName');

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(file);

      // Wait for completion and get the download URL
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print('Successfully uploaded $fileName to $folder');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to $folder: $e');
      return null;
    }
  }

  // Validation methods
  bool validateStudentSignup() {
    bool isValid = true;

    // Validate name
    if (state.name.isEmpty) {
      state = state.copyWith(nameError: "Name is required.");
      isValid = false;
    }

    // Validate email
    if (state.email.isEmpty) {
      state = state.copyWith(emailError: "Email is required.");
      isValid = false;
    } else if (!isvalidateEmailInput(state.email)) {
      state = state.copyWith(emailError: "Please enter a valid email.");
      isValid = false;
    }

    // Validate phone number
    if (state.phoneNumber.isEmpty) {
      state = state.copyWith(phoneError: "Phone number is required.");
      isValid = false;
    } else if (!state.phoneNumber.startsWith('+966')) {
      state =
          state.copyWith(phoneError: "Phone number must be a Saudi number.");
      isValid = false;
    } else {
      // Check if the phone number after +966 has exactly 9 digits
      String phoneDigits = state.phoneNumber.substring(4);
      if (phoneDigits.length != 9) {
        state = state.copyWith(
            phoneError: "Phone number must be 9 digits after +966.");
        isValid = false;
      } else if (!phoneDigits.startsWith('5')) {
        state = state.copyWith(
            phoneError: "Saudi mobile numbers must start with 5.");
        isValid = false;
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneDigits)) {
        state = state.copyWith(
            phoneError: "Phone number must contain only digits.");
        isValid = false;
      }
    }

    // Validate password
    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: "Password is required.");
      isValid = false;
    } else if (state.password.length < 8) {
      state = state.copyWith(
          passwordError: "Password must be at least 8 characters.");
      isValid = false;
    } else if (!validatePassword(state.password)) {
      state = state.copyWith(
          passwordError:
              "Password must contain uppercase, lowercase, number and special character");
      isValid = false;
    }

    // Validate confirm password
    if (state.confirmPassword.isEmpty) {
      state =
          state.copyWith(confirmPasswordError: "Please confirm your password.");
      isValid = false;
    } else if (state.password != state.confirmPassword) {
      state = state.copyWith(confirmPasswordError: "Passwords do not match.");
      isValid = false;
    }

    // Validate gender
    if (state.gender.isEmpty) {
      state = state.copyWith(genderError: "Please select your gender.");
      isValid = false;
    }

    return isValid;
  }

  bool validateDriverSignup() {
    bool isValid = true;

    // Validate name
    if (state.name.isEmpty) {
      state = state.copyWith(nameError: "Name is required.");
      isValid = false;
    } else {
      state = state.copyWith(nameError: null);
    }

    // Validate email
    if (state.email.isEmpty) {
      state = state.copyWith(emailError: "Email is required.");
      isValid = false;
    } else if (!isvalidateEmailInput(state.email)) {
      state = state.copyWith(emailError: "Please enter a valid email.");
      isValid = false;
    } else {
      state = state.copyWith(emailError: null);
    }

    // Validate phone number
    if (state.phoneNumber.isEmpty) {
      state = state.copyWith(phoneError: "Phone number is required.");
      isValid = false;
    } else if (!state.phoneNumber.startsWith('+966')) {
      state =
          state.copyWith(phoneError: "Phone number must be a Saudi number.");
      isValid = false;
    } else {
      // Check if the phone number after +966 has exactly 9 digits
      String phoneDigits = state.phoneNumber.substring(4);
      if (phoneDigits.length != 9) {
        state = state.copyWith(
            phoneError: "Phone number must be 9 digits after +966.");
        isValid = false;
      } else if (!phoneDigits.startsWith('5')) {
        state = state.copyWith(
            phoneError: "Saudi mobile numbers must start with 5.");
        isValid = false;
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phoneDigits)) {
        state = state.copyWith(
            phoneError: "Phone number must contain only digits.");
        isValid = false;
      } else {
        state = state.copyWith(phoneError: null);
      }
    }

    // Validate password
    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: "Password is required.");
      isValid = false;
    } else if (state.password.length < 8) {
      state = state.copyWith(
          passwordError: "Password must be at least 8 characters.");
      isValid = false;
    } else if (!validatePassword(state.password)) {
      state = state.copyWith(
          passwordError:
              "Password must contain uppercase, lowercase, number and special character");
      isValid = false;
    } else {
      state = state.copyWith(passwordError: null);
    }

    // Driver-specific validation
    if (state.vehicleMake.isEmpty) {
      state = state.copyWith(vehicleMakeError: "Vehicle make is required.");
      isValid = false;
    } else {
      state = state.copyWith(vehicleMakeError: null);
    }

    if (state.vehicleModel.isEmpty) {
      state = state.copyWith(vehicleModelError: "Vehicle model is required.");
      isValid = false;
    } else {
      state = state.copyWith(vehicleModelError: null);
    }

    if (state.vehicleYear.isEmpty) {
      state = state.copyWith(vehicleYearError: "Vehicle year is required.");
      isValid = false;
    } else {
      state = state.copyWith(vehicleYearError: null);
    }

    // Location validation (cascading dropdowns)
    if (state.region.isEmpty) {
      state = state.copyWith(regionError: "Region is required.");
      isValid = false;
    } else {
      state = state.copyWith(regionError: null);
    }

    if (state.city.isEmpty) {
      state = state.copyWith(cityError: "City is required.");
      isValid = false;
    } else {
      state = state.copyWith(cityError: null);
    }

    if (state.district.isEmpty) {
      state = state.copyWith(districtError: "District is required.");
      isValid = false;
    } else {
      state = state.copyWith(districtError: null);
    }

    // Validate selected service types (multi-select)
    if (state.selectedServiceTypes.isEmpty) {
      state = state.copyWith(
          serviceTypeError: "At least one service type must be selected.");
      isValid = false;
    } else {
      state = state.copyWith(serviceTypeError: null);
    }

    return isValid;
  }

  bool validateDriverDocuments() {
    bool isValid = true;

    if (state.idImage == null) {
      isValid = false;
    }

    if (state.drivingLicenseImage == null) {
      isValid = false;
    }

    if (state.vehicleRegistrationImage == null) {
      isValid = false;
    }

    if (state.vehiclePhotoImage == null) {
      isValid = false;
    }

    return isValid;
  }

  // Navigation methods
  void proceedToStudentSignup(BuildContext context) {
    context.push('/signup_user');
  }

  void proceedToDriverSignup(BuildContext context) {
    context.push('/signup_driver');
  }

  void proceedToUploadDocuments(BuildContext context) {
    context.push('/upload_documents');
  }

  // Signup methods
  /// Send OTP for email verification before registration
  Future<void> sendEmailVerificationOtp(BuildContext context) async {
    // Set confirmPassword to match password since we don't have a confirm field in student signup
    state = state.copyWith(confirmPassword: state.password);

    print('Debug: Starting student signup validation...');
    print('Debug: Name: ${state.name}');
    print('Debug: Email: ${state.email}');
    print('Debug: Phone: ${state.phoneNumber}');
    print('Debug: Password length: ${state.password.length}');
    print('Debug: Gender: ${state.gender}');
    print('Debug: Role: ${state.role}');

    if (!validateStudentSignup()) {
      print('Debug: Validation failed');
      print('Debug: Name error: ${state.nameError}');
      print('Debug: Email error: ${state.emailError}');
      print('Debug: Phone error: ${state.phoneError}');
      print('Debug: Password error: ${state.passwordError}');
      print('Debug: Gender error: ${state.genderError}');
      print('Debug: Role error: ${state.roleError}');
      return;
    }

    print('Debug: Validation passed, checking email availability...');
    state = state.copyWith(isLoading: true);

    try {
      final signupService = SignupService();

      // Check if email already exists
      final emailExists =
          await signupService.isEmailAlreadyRegistered(state.email);
      if (emailExists) {
        state = state.copyWith(
          emailError: "This email is already registered.",
          isLoading: false,
        );
        return;
      }

      // Check if phone already exists
      final phoneExists =
          await signupService.isPhoneNumberAlreadyRegistered(state.phoneNumber);
      if (phoneExists) {
        state = state.copyWith(
          phoneError: "This phone number is already registered.",
          isLoading: false,
        );
        return;
      }

      // Import the signup email OTP service
      // final sendSignupOtpEmail = await import('package:semester_student_ride_app/utils/send_signup_email_otp.dart');

      // Send OTP to email for verification
      final otpSent = await sendSignupOtpEmail(state.email);

      if (otpSent && context.mounted) {
        // Navigate to OTP verification for email
        context.push('/otp', extra: {
          'phoneNumber': state.email, // Use email for OTP verification
          'isFromSignup': true
        });
      } else {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Failed to send verification email. Please try again.',
            context: context,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrorFlushBar(message: e.toString(), context: context);
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Complete student registration after email verification
  Future<void> signupStudent(BuildContext context) async {
    print('Debug: Completing student registration after email verification...');
    state = state.copyWith(isLoading: true);

    try {
      // Upload images to Firebase Storage if they exist
      String? profilePictureUrl;
      String? idImageUrl;

      // Upload Profile Picture if exists
      if (state.profilePicture != null) {
        profilePictureUrl = await uploadImageToFirebase(
            state.profilePicture!, 'profile_pictures');
        if (profilePictureUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload profile picture. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      // Upload ID Image if exists
      if (state.idImage != null) {
        idImageUrl = await uploadImageToFirebase(
            state.idImage!, 'student_documents/id_cards');
        if (idImageUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload ID image. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      final user = UserSignupModel(
        name: state.name,
        email: state.email.toLowerCase(),
        phoneNumber: state.phoneNumber,
        password: state.password,
        isDriver: false,
        gender: state.gender,
        role: state.role,
        profilePicture: profilePictureUrl,
        IdImage: idImageUrl,
      );

      final signupService = SignupService();
      final firebaseUser = await signupService.signupUser(user);

      if (firebaseUser != null && context.mounted) {
        print('Debug: Student registered successfully');
        // Success will be handled by the OTP screen
      }
    } catch (e) {
      print('Debug: Error during final registration: $e');
      if (context.mounted) {
        showErrorFlushBar(message: e.toString(), context: context);
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signupDriver(BuildContext context) async {
    if (!validateDriverSignup()) return;

    state = state.copyWith(isLoading: true);

    try {
      final signupService = SignupService();

      if (!validateDriverDocuments()) {
        showErrorFlushBar(
          message: 'Please upload all required documents',
          context: context,
        );
        state = state.copyWith(isLoading: false);
        return;
      }

      // Upload all document images to Firebase Storage and get download URLs
      String? idImageUrl;
      String? drivingLicenseUrl;
      String? vehicleRegistrationUrl;
      String? profilePictureUrl;

      // Upload ID Image
      if (state.idImage != null) {
        idImageUrl = await uploadImageToFirebase(
            state.idImage!, 'driver_documents/id_cards');
        if (idImageUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload ID image. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      // Upload Driving License
      if (state.drivingLicenseImage != null) {
        drivingLicenseUrl = await uploadImageToFirebase(
            state.drivingLicenseImage!, 'driver_documents/driving_licenses');
        if (drivingLicenseUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload driving license. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      // Upload Vehicle Registration
      if (state.vehicleRegistrationImage != null) {
        vehicleRegistrationUrl = await uploadImageToFirebase(
            state.vehicleRegistrationImage!,
            'driver_documents/vehicle_registrations');
        if (vehicleRegistrationUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload vehicle registration. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      // Upload Vehicle Photo
      String? vehiclePhotoUrl;
      if (state.vehiclePhotoImage != null) {
        vehiclePhotoUrl = await uploadImageToFirebase(
            state.vehiclePhotoImage!, 'driver_documents/vehicle_photos');
        if (vehiclePhotoUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload vehicle photo. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      // Upload Profile Picture if exists
      if (state.profilePicture != null) {
        profilePictureUrl = await uploadImageToFirebase(
            state.profilePicture!, 'profile_pictures');
        if (profilePictureUrl == null) {
          showErrorFlushBar(
            message: 'Failed to upload profile picture. Please try again.',
            context: context,
          );
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      final user = UserSignupModel(
        name: state.name,
        email: state.email.toLowerCase(),
        phoneNumber: state.phoneNumber,
        password: state.password,
        isDriver: true,
        vehicleMake: state.vehicleMake,
        vehicleModel: state.vehicleModel,
        vehicleYear: state.vehicleYear,

        // New cascading location fields
        region: state.region,
        city: state.city,
        district: state.district,

        serviceType: state.serviceType, // Keep for backwards compatibility
        availableServices:
            state.selectedServiceTypes.map((e) => e.name).toList(),
        profilePicture: profilePictureUrl,
        IdImage: idImageUrl,
        drivingLicenseImage: drivingLicenseUrl,
        vehicleRegistrationImage: vehicleRegistrationUrl,
        vehiclePhotoImage: vehiclePhotoUrl,
        isDocumentsVerified: true, // Will be verified by admin
      );

      final firebaseUser = await signupService.signupUser(user);

      if (firebaseUser != null && context.mounted) {
        await FirebaseAuth.instance.signOut(); // Sign out after registration
        // Don't navigate automatically - let the UI handle showing success screen
      }
    } catch (e) {
      if (context.mounted) {
        showErrorFlushBar(message: e.toString(), context: context);
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
