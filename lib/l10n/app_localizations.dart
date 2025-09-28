import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'NAYBRZ DXB'**
  String get appTitle;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Change language screen title
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Save language button text
  ///
  /// In en, this message translates to:
  /// **'Save Language'**
  String get saveLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get arabic;

  /// Title for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Your Reliable Ride Partner'**
  String get onboarding1Title;

  /// Description for first onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Whether you\'re a student, parent, or teacher — Semester App offers and scheduled way to commute.'**
  String get onboarding1Description;

  /// Title for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Book Your Ride with Ease'**
  String get onboarding2Title;

  /// Description for second onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Schedule your school rides with verified drivers in just a few simple steps.'**
  String get onboarding2Description;

  /// Title for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Track Your Ride in Real-time'**
  String get onboarding3Title;

  /// Description for third onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Monitor bus location and estimated arrival times with live updates.'**
  String get onboarding3Description;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login screen description
  ///
  /// In en, this message translates to:
  /// **'Enter your login credentials to continue. You won\'t be able to login if your account isn\'t verified.'**
  String get loginDescription;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Login button loading state
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// Sign up prompt text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// Test account dialog title
  ///
  /// In en, this message translates to:
  /// **'Test Account Instructions'**
  String get testAccountInstructions;

  /// Test account dialog description
  ///
  /// In en, this message translates to:
  /// **'To test the app, please use one of the following test accounts:'**
  String get testAccountDescription;

  /// User side test account label
  ///
  /// In en, this message translates to:
  /// **'• For User Side:'**
  String get forUserSide;

  /// Driver side test account label
  ///
  /// In en, this message translates to:
  /// **'• For Driver Side:'**
  String get forDriverSide;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Forgot password screen title
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// Forgot password screen description
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a verification code to reset your password.'**
  String get forgotPasswordDescription;

  /// Send OTP button text
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// Remember password text
  ///
  /// In en, this message translates to:
  /// **'Remember password? '**
  String get rememberPassword;

  /// Back to login link text
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// OTP verification screen title
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// OTP verification screen description
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to your email address.'**
  String get otpDescription;

  /// Enter OTP field label
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// Verify OTP button text
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// Resend OTP prompt text
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveOtp;

  /// Resend OTP button text
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendOtp;

  /// Reset password button text
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Reset password screen description
  ///
  /// In en, this message translates to:
  /// **'Enter your new password for your account.'**
  String get resetPasswordDescription;

  /// New password field placeholder
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// Confirm new password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Update password button text
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// My bookings screen title
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// Messages tab label
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Map tab label
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// Settings tab title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Daily transportation service type
  ///
  /// In en, this message translates to:
  /// **'Daily Transportation'**
  String get dailyTransportation;

  /// Transportation for employees service type
  ///
  /// In en, this message translates to:
  /// **'Transportation for Employees'**
  String get transportationForEmployees;

  /// Student transportation service type
  ///
  /// In en, this message translates to:
  /// **'Student Transportation'**
  String get studentTransportation;

  /// Booking label
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// Book now button text
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// Confirm booking button
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// Cancel booking button text
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// Driver label
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// User role text
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Student role text
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// Employee role text
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// Vehicle placeholder
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// Vehicle type field label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// Vehicle model field label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// License plate label
  ///
  /// In en, this message translates to:
  /// **'License Plate'**
  String get licensePlate;

  /// Pickup location label
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// Destination label
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// Pickup time label
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickupTime;

  /// Fare label
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// Status section title
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Pending status text
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Confirmed status
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// In progress status
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Completed status text
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Cancelled status text
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Active status text
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Review tab title
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// Add review screen title
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// Payment settings option
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Payment method label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Cash payment method
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// Card payment method
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// Digital wallet payment method
  ///
  /// In en, this message translates to:
  /// **'Digital Wallet'**
  String get digitalWallet;

  /// Profile label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Edit profile option
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Notifications settings option
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Help and support option
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Change password option
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Logout option
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Gender field label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for search section
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Select driver screen title
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDriver;

  /// Booking details page title
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Distance label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// UAE Dirham currency
  ///
  /// In en, this message translates to:
  /// **'AED'**
  String get aed;

  /// Currency unit
  ///
  /// In en, this message translates to:
  /// **'Riyal'**
  String get riyal;

  /// Upload documents button text
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// Select vehicle type instruction
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle Type'**
  String get selectVehicleType;

  /// Car vehicle option
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// SUV vehicle type
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get suv;

  /// Van vehicle type
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get van;

  /// Bus vehicle type
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// Sedan vehicle type
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get sedan;

  /// Previous bookings tab
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChangedSuccessfully;

  /// Language selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a language'**
  String get pleaseSelectLanguage;

  /// Register new account title
  ///
  /// In en, this message translates to:
  /// **'Register New Account'**
  String get registerNewAccount;

  /// Account type selection description
  ///
  /// In en, this message translates to:
  /// **'Subscription Date Required'**
  String get chooseAccountType;

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Account type selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select your subscription start date'**
  String get pleaseSelectAccountType;

  /// Personal information screen title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Gender selection placeholder
  ///
  /// In en, this message translates to:
  /// **'Select University'**
  String get selectGender;

  /// No description provided for @selectUniversity.
  ///
  /// In en, this message translates to:
  /// **'Select University'**
  String get selectUniversity;

  /// No description provided for @addUniversityOrInstituteName.
  ///
  /// In en, this message translates to:
  /// **'Add university or institute name'**
  String get addUniversityOrInstituteName;

  /// Vehicle information screen title
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInformation;

  /// Vehicle color field label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Color'**
  String get vehicleColor;

  /// Location information screen title
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// District field label
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// Account information section header
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// Terms and conditions checkbox text
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions'**
  String get termsAndConditions;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Become a driver title
  ///
  /// In en, this message translates to:
  /// **'Become a Driver'**
  String get becomeDriver;

  /// Document verification description
  ///
  /// In en, this message translates to:
  /// **'Verify your identity and vehicle with these required documents to start earning.'**
  String get verifyIdentityDescription;

  /// ID card upload label
  ///
  /// In en, this message translates to:
  /// **'Upload ID Card Photo'**
  String get uploadIdCard;

  /// Driving license upload label
  ///
  /// In en, this message translates to:
  /// **'Driving License Photo'**
  String get drivingLicense;

  /// Vehicle registration document name
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration'**
  String get vehicleRegistration;

  /// Vehicle photo upload label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get vehiclePhoto;

  /// Profile picture upload label
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// Submit button text
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Congratulations title
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulations;

  /// Application submission success message
  ///
  /// In en, this message translates to:
  /// **'Your email verify. Your application has been submitted successfully. We will review your application and contact you within 24 hours.'**
  String get applicationSubmittedSuccessfully;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Role selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a role to proceed'**
  String get pleaseSelectRole;

  /// Gallery selection option
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// Camera option
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Upload instruction text
  ///
  /// In en, this message translates to:
  /// **'Click to upload'**
  String get clickToUpload;

  /// ID card file name
  ///
  /// In en, this message translates to:
  /// **'Id Card.png'**
  String get idCardFileName;

  /// Driving license file name
  ///
  /// In en, this message translates to:
  /// **'Driving License.png'**
  String get drivingLicenseFileName;

  /// Vehicle registration file name
  ///
  /// In en, this message translates to:
  /// **'Vehicle Registration.png'**
  String get vehicleRegistrationFileName;

  /// Vehicle photo file name
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo.png'**
  String get vehiclePhotoFileName;

  /// Profile picture file name
  ///
  /// In en, this message translates to:
  /// **'Profile Picture.png'**
  String get profilePictureFileName;

  /// Driver registration requirements title
  ///
  /// In en, this message translates to:
  /// **'Driver Registration Requirements'**
  String get driverRegistrationRequirements;

  /// User registration requirements title
  ///
  /// In en, this message translates to:
  /// **'User Registration Requirements'**
  String get userRegistrationRequirements;

  /// Age requirement for drivers
  ///
  /// In en, this message translates to:
  /// **'Must be 21 years or older.'**
  String get requirement21Years;

  /// Valid license requirement
  ///
  /// In en, this message translates to:
  /// **'Valid Driving License.'**
  String get requirementValidLicense;

  /// Valid ID requirement
  ///
  /// In en, this message translates to:
  /// **'Valid National ID.'**
  String get requirementValidID;

  /// Vehicle insurance requirement
  ///
  /// In en, this message translates to:
  /// **'Valid Vehicle Insurance.'**
  String get requirementVehicleInsurance;

  /// Personal photo requirement
  ///
  /// In en, this message translates to:
  /// **'Recent Personal Photo'**
  String get requirementPersonalPhoto;

  /// Clean driving record requirement
  ///
  /// In en, this message translates to:
  /// **'Clean Driving Record.'**
  String get requirementCleanRecord;

  /// Age requirement for users
  ///
  /// In en, this message translates to:
  /// **'Must be 18 years old or older'**
  String get requirement18Years;

  /// Mobile number requirement
  ///
  /// In en, this message translates to:
  /// **'Active Mobile Number'**
  String get requirementMobileNumber;

  /// Active email requirement
  ///
  /// In en, this message translates to:
  /// **'Active Email'**
  String get requirementActiveEmail;

  /// Review process message
  ///
  /// In en, this message translates to:
  /// **'Your request will be reviewed and you will be contacted within 24 hours'**
  String get reviewMessage;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Login now link text
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// Security section title
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Create password field placeholder
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createPassword;

  /// Terms and conditions description
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy. Your information will be securely stored and used to enhance your driving experience.'**
  String get termsDescription;

  /// Service type field label
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// Service type field hint
  ///
  /// In en, this message translates to:
  /// **'Select your service type'**
  String get selectServiceType;

  /// Full time service option
  ///
  /// In en, this message translates to:
  /// **'Full Time'**
  String get fullTime;

  /// Part time service option
  ///
  /// In en, this message translates to:
  /// **'Part Time'**
  String get partTime;

  /// Full time description
  ///
  /// In en, this message translates to:
  /// **'40+ hours/week'**
  String get fullTimeDescription;

  /// Part time description
  ///
  /// In en, this message translates to:
  /// **'Flexible hours'**
  String get partTimeDescription;

  /// User information section header
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInformation;

  /// Dialog title for image source selection
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// Camera option in image picker
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery option in image picker
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Documents upload progress section title
  ///
  /// In en, this message translates to:
  /// **'Documents Progress'**
  String get documentsProgress;

  /// Documents upload progress count
  ///
  /// In en, this message translates to:
  /// **'{uploaded} of {total} documents uploaded'**
  String documentsUploaded(int uploaded, int total);

  /// Instruction text for document upload
  ///
  /// In en, this message translates to:
  /// **'Tap to upload document'**
  String get tapToUploadDocument;

  /// Success message when document is uploaded
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploadedSuccessfully;

  /// Reset password screen title
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// Header for password requirements
  ///
  /// In en, this message translates to:
  /// **'Password must contain'**
  String get passwordMustContain;

  /// Password requirement: minimum length
  ///
  /// In en, this message translates to:
  /// **'at least 8 characters long.'**
  String get atLeast8Characters;

  /// Password requirement: uppercase letter
  ///
  /// In en, this message translates to:
  /// **'at least one uppercase letter.'**
  String get atLeastOneUppercase;

  /// Password requirement: lowercase letter
  ///
  /// In en, this message translates to:
  /// **'at least one lowercase letter.'**
  String get atLeastOneLowercase;

  /// Password requirement: number
  ///
  /// In en, this message translates to:
  /// **'at least one number.'**
  String get atLeastOneNumber;

  /// Password requirement: special character
  ///
  /// In en, this message translates to:
  /// **'at least one special character.'**
  String get atLeastOneSpecialChar;

  /// Reset password save button text
  ///
  /// In en, this message translates to:
  /// **'Save & Go to Login'**
  String get saveAndGoToLogin;

  /// Select your role placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectYourRole;

  /// Teacher role option
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// Terms and conditions disclaimer text
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy. Your information will be securely stored and used to enhance your ride experience.'**
  String get termsAndConditionsText;

  /// Continue registration button text
  ///
  /// In en, this message translates to:
  /// **'Continue Registration'**
  String get continueRegistration;

  /// Hello greeting with user name
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}'**
  String helloUser(String userName);

  /// Welcome message on home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Samaster\nTransportation Services'**
  String get welcomeToSamaster;

  /// Welcome card description text
  ///
  /// In en, this message translates to:
  /// **'Choose the service that suits you and enjoy a safe, reliable and easy transportation experience.'**
  String get welcomeDescription;

  /// Student transportation card title
  ///
  /// In en, this message translates to:
  /// **'Student\nTransportation'**
  String get studentTransportationShort;

  /// Teacher transportation card title
  ///
  /// In en, this message translates to:
  /// **'Teacher\nTransportation'**
  String get teacherTransportation;

  /// Employee transportation card title
  ///
  /// In en, this message translates to:
  /// **'Employee\nTransportation'**
  String get employeeTransportation;

  /// Daily transportation card title
  ///
  /// In en, this message translates to:
  /// **'Daily\nTransportation'**
  String get dailyTransportationShort;

  /// Inbox screen title
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// Search placeholder text for messages
  ///
  /// In en, this message translates to:
  /// **'Search messages'**
  String get searchMessages;

  /// Request tab label
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// Typing indicator text
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// Time indicator for current moment
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// Time indicator for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Time indicator for days ago
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Time indicator for one week ago
  ///
  /// In en, this message translates to:
  /// **'1 week ago'**
  String get weekAgo;

  /// Sending OTP loading message
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get sendingOtp;

  /// Phone number verified automatically message
  ///
  /// In en, this message translates to:
  /// **'Phone number verified automatically!'**
  String get phoneVerifiedAutomatically;

  /// Invalid phone number error message
  ///
  /// In en, this message translates to:
  /// **'The provided phone number is not valid.'**
  String get invalidPhoneNumber;

  /// Verification failed error message prefix
  ///
  /// In en, this message translates to:
  /// **'Verification failed: {message}'**
  String verificationFailed(String message);

  /// OTP sent to phone success message
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your phone!'**
  String get otpSentToPhone;

  /// OTP sent to email success message
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your email!'**
  String get otpSentToEmail;

  /// An error occurred message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// Failed to send OTP to email error message
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP to your email. Please try again.'**
  String get failedToSendOtpEmail;

  /// Failed to send OTP general error message
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP'**
  String get failedToSendOtp;

  /// Verifying OTP loading message
  ///
  /// In en, this message translates to:
  /// **'Verifying OTP...'**
  String get verifyingOtp;

  /// Phone number verified successfully message
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully!'**
  String get phoneVerifiedSuccessfully;

  /// Invalid OTP error title
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// Invalid OTP error message
  ///
  /// In en, this message translates to:
  /// **'The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.'**
  String get invalidOtpMessage;

  /// Verification failed error title
  ///
  /// In en, this message translates to:
  /// **'Verification failed'**
  String get verificationFailedTitle;

  /// Verification failed error message with details
  ///
  /// In en, this message translates to:
  /// **'An error occurred during verification: {message}'**
  String verificationFailedMessage(String message);

  /// OTP verified successfully message
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully!'**
  String get otpVerifiedSuccessfully;

  /// Invalid OTP please try again message
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtpTryAgain;

  /// OTP expired error title
  ///
  /// In en, this message translates to:
  /// **'OTP expired'**
  String get otpExpired;

  /// OTP expired error message
  ///
  /// In en, this message translates to:
  /// **'OTP has expired. Please request a new one.'**
  String get otpExpiredMessage;

  /// An error occurred please try again message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorTryAgain;

  /// Email verification success message
  ///
  /// In en, this message translates to:
  /// **'Your email has been verified. Your application has been submitted successfully. We will review your application and contact you within 24 hours.'**
  String get emailVerificationSuccess;

  /// Email verified successfully login now message
  ///
  /// In en, this message translates to:
  /// **'Your email has been verified successfully. You can login now.'**
  String get emailVerifiedSuccessfullyLoginNow;

  /// Please enter valid OTP message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid OTP code'**
  String get pleaseEnterValidOtp;

  /// My profile page title
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// Setting section title
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// Appearance settings option
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Trip count display
  ///
  /// In en, this message translates to:
  /// **'{count} Trip'**
  String tripCount(int count);

  /// Current bookings tab
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Edit booking button text
  ///
  /// In en, this message translates to:
  /// **'Edit Booking'**
  String get editBooking;

  /// Contact driver button text
  ///
  /// In en, this message translates to:
  /// **'Contact Driver'**
  String get contactDriver;

  /// View review button text
  ///
  /// In en, this message translates to:
  /// **'View Review'**
  String get viewReview;

  /// Book again button text
  ///
  /// In en, this message translates to:
  /// **'Book Again'**
  String get bookAgain;

  /// Contact support button text
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No bookings found message
  ///
  /// In en, this message translates to:
  /// **'No {status} bookings'**
  String noBookingsFound(String status);

  /// No bookings message
  ///
  /// In en, this message translates to:
  /// **'Your {status} bookings will appear here'**
  String noBookingsMessage(String status);

  /// Vehicle information section header
  ///
  /// In en, this message translates to:
  /// **'Vehicle Information'**
  String get vehicleInfo;

  /// Base price label
  ///
  /// In en, this message translates to:
  /// **'Base Price:'**
  String get basePrice;

  /// Final price section title
  ///
  /// In en, this message translates to:
  /// **'Final Price'**
  String get finalPrice;

  /// Cost section title
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// Rating and review section header
  ///
  /// In en, this message translates to:
  /// **'Your Rating & Review'**
  String get yourRatingAndReview;

  /// Overall rating label
  ///
  /// In en, this message translates to:
  /// **'Overall Rating'**
  String get overallRating;

  /// Driver communication rating label
  ///
  /// In en, this message translates to:
  /// **'Driver Communication Rating'**
  String get driverCommunicationRating;

  /// Vehicle condition rating label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Condition'**
  String get vehicleCondition;

  /// Your review section header
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// Password change success message
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully.'**
  String get passwordChangedSuccessfully;

  /// Current password validation error
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// New password validation error
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// Password minimum length error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// Password complexity validation error
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase, number and special character'**
  String get passwordComplexityError;

  /// Confirm password validation error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get confirmPasswordRequired;

  /// Error message when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Password change loading message
  ///
  /// In en, this message translates to:
  /// **'Changing password...'**
  String get changingPassword;

  /// No user error message
  ///
  /// In en, this message translates to:
  /// **'No user logged in'**
  String get noUserLoggedIn;

  /// User email error message
  ///
  /// In en, this message translates to:
  /// **'User email not available'**
  String get userEmailNotAvailable;

  /// Wrong current password error
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// Recent login required error
  ///
  /// In en, this message translates to:
  /// **'Please log out and log in again before changing your password'**
  String get recentLoginRequired;

  /// Password change failure dialog title
  ///
  /// In en, this message translates to:
  /// **'Failed to change password'**
  String get passwordChangeFailedTitle;

  /// Password change failure dialog message
  ///
  /// In en, this message translates to:
  /// **'Your current password is incorrect'**
  String get passwordChangeFailedMessage;

  /// School address type
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// University address type
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get university;

  /// Others address type
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// Address type selection label
  ///
  /// In en, this message translates to:
  /// **'Address Type'**
  String get addressType;

  /// Address information header
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get addressInformation;

  /// Subtitle for daily transport location setup
  ///
  /// In en, this message translates to:
  /// **'Set your pickup location and schedule'**
  String get setPickupLocationSchedule;

  /// Subtitle for address information
  ///
  /// In en, this message translates to:
  /// **'Please provide your location details'**
  String get provideLocationDetails;

  /// City field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enterYourCity;

  /// Area/District field label
  ///
  /// In en, this message translates to:
  /// **'Area / District'**
  String get areaDistrict;

  /// Detailed address field label
  ///
  /// In en, this message translates to:
  /// **'Detailed Address'**
  String get detailedAddress;

  /// Detailed address field hint
  ///
  /// In en, this message translates to:
  /// **'Detailed address'**
  String get detailedAddressHint;

  /// Date picker label
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// End time picker label
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// University name field label
  ///
  /// In en, this message translates to:
  /// **'University Name'**
  String get universityName;

  /// School name field label
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get schoolName;

  /// Institution name field label
  ///
  /// In en, this message translates to:
  /// **'Institution Name'**
  String get institutionName;

  /// Neighborhood field label
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get neighborhood;

  /// Neighborhood field hint
  ///
  /// In en, this message translates to:
  /// **'Enter neighborhood area'**
  String get enterNeighborhoodArea;

  /// Student transport service name
  ///
  /// In en, this message translates to:
  /// **'Student Transport'**
  String get studentTransport;

  /// Teacher transport service name
  ///
  /// In en, this message translates to:
  /// **'Teacher Transport'**
  String get teacherTransport;

  /// Employee transport service name
  ///
  /// In en, this message translates to:
  /// **'Employee Transport'**
  String get employeeTransport;

  /// Daily transport app bar title
  ///
  /// In en, this message translates to:
  /// **'Daily Transport'**
  String get dailyTransport;

  /// Step indicator text
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {totalSteps}'**
  String stepXOfY(int currentStep, int totalSteps);

  /// Step 1 label in stepper widget
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// Step 2 label in stepper widget
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get driverSelection;

  /// Additional details section title
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get additionalDetails;

  /// Default driver name placeholder
  ///
  /// In en, this message translates to:
  /// **'Driver Name'**
  String get driverName;

  /// Kilometer unit
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// Vehicle type field label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Text when value is not specified
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// Booking status label
  ///
  /// In en, this message translates to:
  /// **'Booking Status'**
  String get bookingStatus;

  /// Trip type section title
  ///
  /// In en, this message translates to:
  /// **'Trip Type'**
  String get tripType;

  /// Pickup date label
  ///
  /// In en, this message translates to:
  /// **'Pickup Date'**
  String get pickupDate;

  /// Work schedule section title
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get workSchedule;

  /// Driver gender selection title
  ///
  /// In en, this message translates to:
  /// **'Driver\'s Gender'**
  String get driverGender;

  /// Any gender option
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// Subscription plan selection title
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get subscriptionPlan;

  /// Hours label
  ///
  /// In en, this message translates to:
  /// **'Hours:'**
  String get hours;

  /// Price per hour label
  ///
  /// In en, this message translates to:
  /// **'Price per Hour:'**
  String get pricePerHour;

  /// Master Card payment method
  ///
  /// In en, this message translates to:
  /// **'Master Card'**
  String get masterCard;

  /// Area placeholder
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// Institution placeholder
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get institution;

  /// Service vehicle label
  ///
  /// In en, this message translates to:
  /// **'Service Vehicle'**
  String get serviceVehicle;

  /// As per schedule placeholder
  ///
  /// In en, this message translates to:
  /// **'As per schedule'**
  String get asPerSchedule;

  /// Draft status
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// Congratulation dialog title
  ///
  /// In en, this message translates to:
  /// **'Congratulation!'**
  String get congratulation;

  /// Booking success message
  ///
  /// In en, this message translates to:
  /// **'Your Booking has been successfully Booked. You will receive a notification and the driver you selected will contact you.'**
  String get bookingSuccessMessage;

  /// Go to booking button
  ///
  /// In en, this message translates to:
  /// **'Go to Booking'**
  String get goToBooking;

  /// Header text for driver selection section
  ///
  /// In en, this message translates to:
  /// **'Select Driver on Map'**
  String get selectDriverOnMap;

  /// Instruction text for driver selection
  ///
  /// In en, this message translates to:
  /// **'Select a driver from the map to continue.'**
  String get selectDriverFromMap;

  /// Unit for kilometers
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmUnit;

  /// Section title for driver list
  ///
  /// In en, this message translates to:
  /// **'Available Drivers'**
  String get availableDrivers;

  /// Results count suffix
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// Driver rating display text
  ///
  /// In en, this message translates to:
  /// **'{rating} (rating)'**
  String driverRatingText(double rating);

  /// Default driver role text
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get driverRole;

  /// Additional details instruction text
  ///
  /// In en, this message translates to:
  /// **'Please provide additional details.'**
  String get pleaseProvideAdditionalDetails;

  /// One way trip option
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get oneWay;

  /// One way trip description
  ///
  /// In en, this message translates to:
  /// **'Single direction trip'**
  String get singleDirectionTrip;

  /// Return only trip option
  ///
  /// In en, this message translates to:
  /// **'Return Only'**
  String get returnOnly;

  /// Return only trip description
  ///
  /// In en, this message translates to:
  /// **'Return Only trip'**
  String get returnOnlyTrip;

  /// Round trip option
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get roundTrip;

  /// Round trip description
  ///
  /// In en, this message translates to:
  /// **'Both directions included'**
  String get bothDirectionsIncluded;

  /// Transportation options section title
  ///
  /// In en, this message translates to:
  /// **'Transportation Options'**
  String get transportationOptions;

  /// Private transport option
  ///
  /// In en, this message translates to:
  /// **'Private Transport'**
  String get privateTransport;

  /// Private transport description
  ///
  /// In en, this message translates to:
  /// **'Your own private vehicle'**
  String get yourOwnPrivateVehicle;

  /// Subscriber option
  ///
  /// In en, this message translates to:
  /// **'Subscriber'**
  String get subscriber;

  /// Subscriber description
  ///
  /// In en, this message translates to:
  /// **'Join subscription service'**
  String get joinSubscriptionService;

  /// Monthly subscription option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Quarterly subscription option
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get quarterly;

  /// Yearly subscription option
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// Morning schedule option
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// Evening schedule option
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// Flexible schedule option
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get flexible;

  /// Start date label
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// Return time label
  ///
  /// In en, this message translates to:
  /// **'Return Time'**
  String get returnTime;

  /// Total estimate label
  ///
  /// In en, this message translates to:
  /// **'Total Estimate:'**
  String get totalEstimate;

  /// Transportation schedule section title
  ///
  /// In en, this message translates to:
  /// **'Transportation Schedule'**
  String get transportationSchedule;

  /// Mark all notifications as read button text
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllRead;

  /// Yesterday time label for notifications
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Booking update notification title
  ///
  /// In en, this message translates to:
  /// **'Booking Update'**
  String get bookingUpdate;

  /// Ride in progress notification title
  ///
  /// In en, this message translates to:
  /// **'Ride in Progress'**
  String get rideInProgress;

  /// Ride completed notification title
  ///
  /// In en, this message translates to:
  /// **'Ride Completed'**
  String get rideCompleted;

  /// Ride rescheduled notification message
  ///
  /// In en, this message translates to:
  /// **'Your ride with driver {driverName} has been rescheduled.'**
  String rideRescheduledMessage(String driverName);

  /// Driver approaching notification message
  ///
  /// In en, this message translates to:
  /// **'Your driver {driverName} is {minutes} minutes away.'**
  String driverAwayMessage(String driverName, String minutes);

  /// Ride ended successfully notification message
  ///
  /// In en, this message translates to:
  /// **'Your ride with driver {driverName} has ended successfully.'**
  String rideEndedSuccessfullyMessage(String driverName);

  /// Cancellation reason screen title
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReason;

  /// Cancellation reason question
  ///
  /// In en, this message translates to:
  /// **'Why are you canceling?'**
  String get whyAreyouCanceling;

  /// Feedback improvement message
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve.'**
  String get feedbackHelpsImprove;

  /// Cancellation reason - driver taking too long
  ///
  /// In en, this message translates to:
  /// **'Driver taking too long to arrive'**
  String get driverTakingTooLong;

  /// Cancellation reason - found another ride
  ///
  /// In en, this message translates to:
  /// **'Found another ride'**
  String get foundAnotherRide;

  /// Cancellation reason - change of plans
  ///
  /// In en, this message translates to:
  /// **'Change of plans'**
  String get changeOfPlans;

  /// Cancellation reason - incorrect pickup location
  ///
  /// In en, this message translates to:
  /// **'Incorrect pickup location'**
  String get incorrectPickupLocation;

  /// Cancellation reason - driver asked to cancel
  ///
  /// In en, this message translates to:
  /// **'Driver asked me to cancel'**
  String get driverAskedToCancel;

  /// Cancellation reason - driver behavior
  ///
  /// In en, this message translates to:
  /// **'Driver behavior'**
  String get driverBehavior;

  /// Other option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Submit and cancel ride button text
  ///
  /// In en, this message translates to:
  /// **'Submit & Cancel Ride'**
  String get submitCancelRide;

  /// Error message for no cancellation reason selected
  ///
  /// In en, this message translates to:
  /// **'Select a cancellation reason'**
  String get selectCancellationReason;

  /// Cancel ride request dialog title
  ///
  /// In en, this message translates to:
  /// **'Cancel Ride Request?'**
  String get cancelRideRequest;

  /// Cancel ride confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this ride request? We will stop searching for a driver.'**
  String get cancelRideConfirmation;

  /// Yes cancel button text
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No don't cancel button text
  ///
  /// In en, this message translates to:
  /// **'No, Don\'t Cancel'**
  String get noDontCancel;

  /// Ride cancelled success title
  ///
  /// In en, this message translates to:
  /// **'Ride Cancelled!'**
  String get rideCancelled;

  /// Ride cancelled success message
  ///
  /// In en, this message translates to:
  /// **'Your ride has been cancelled successfully. We appreciate your feedback and will work to improve our service.'**
  String get rideCancelledMessage;

  /// Okay button text
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// Add new payment method button text
  ///
  /// In en, this message translates to:
  /// **'Add New Payment'**
  String get addNewPayment;

  /// Saved cards section title
  ///
  /// In en, this message translates to:
  /// **'Saved Cards'**
  String get savedCards;

  /// Google Pay payment method
  ///
  /// In en, this message translates to:
  /// **'Google Pay'**
  String get googlePay;

  /// Apple Pay payment method
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get applePay;

  /// PayPal payment method
  ///
  /// In en, this message translates to:
  /// **'Paypal'**
  String get paypal;

  /// Confirm payment button text
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmPayment;

  /// Select new payment method title
  ///
  /// In en, this message translates to:
  /// **'Select new payment method'**
  String get selectNewPaymentMethod;

  /// Card holder name field label
  ///
  /// In en, this message translates to:
  /// **'Card Holder Name'**
  String get cardHolderName;

  /// Card number field label
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumber;

  /// Expiry date field label
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// CVV field label
  ///
  /// In en, this message translates to:
  /// **'CVV (***)'**
  String get cvv;

  /// Proceed to payment button text
  ///
  /// In en, this message translates to:
  /// **'Proceed To Payment'**
  String get proceedToPayment;

  /// FAQ question about booking a trip
  ///
  /// In en, this message translates to:
  /// **'How can I book a trip?'**
  String get howCanIBookTrip;

  /// FAQ answer about booking a trip
  ///
  /// In en, this message translates to:
  /// **'You can book a trip by choosing the appropriate service type (e.g., student transport, teacher transport, etc.), then determining your location and the desired destination.'**
  String get bookTripAnswer;

  /// FAQ question about payment methods
  ///
  /// In en, this message translates to:
  /// **'How can I pay?'**
  String get howCanIPay;

  /// FAQ answer about payment methods
  ///
  /// In en, this message translates to:
  /// **'We provide several payment methods: bank cards, electronic wallet, or cash payment.'**
  String get paymentMethodsAnswer;

  /// FAQ question about contacting customer service
  ///
  /// In en, this message translates to:
  /// **'How can I contact customer service?'**
  String get howContactCustomerService;

  /// FAQ answer about contacting customer service
  ///
  /// In en, this message translates to:
  /// **'You can contact us via:\nPhone: 92000000\nEmail: support@semester.com'**
  String get contactServiceAnswer;

  /// FAQ question about canceling rides
  ///
  /// In en, this message translates to:
  /// **'How can I cancel my ride?'**
  String get howCancelRide;

  /// FAQ answer about canceling rides
  ///
  /// In en, this message translates to:
  /// **'You can cancel your ride by going to your active rides and selecting the cancel option. Please note that cancellation fees may apply depending on the timing.'**
  String get cancelRideAnswer;

  /// FAQ question about safety measures
  ///
  /// In en, this message translates to:
  /// **'What are the safety measures?'**
  String get whatSafetyMeasures;

  /// FAQ answer about safety measures
  ///
  /// In en, this message translates to:
  /// **'All our drivers are verified and background checked. We provide real-time tracking, emergency contacts, and 24/7 support for your safety.'**
  String get safetyMeasuresAnswer;

  /// FAQ question about reporting issues
  ///
  /// In en, this message translates to:
  /// **'How do I report an issue?'**
  String get howReportIssue;

  /// FAQ answer about reporting issues
  ///
  /// In en, this message translates to:
  /// **'You can report issues through the app by going to Settings > Report Issue, or contact our customer service directly.'**
  String get reportIssueAnswer;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Need More Help?'**
  String get needMoreHelp;

  /// Phone contact information
  ///
  /// In en, this message translates to:
  /// **'Phone: 92000000'**
  String get phoneContact;

  /// Email contact information
  ///
  /// In en, this message translates to:
  /// **'Email: support@semester.com'**
  String get emailContact;

  /// Submit review button text
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// Review submitted success dialog title
  ///
  /// In en, this message translates to:
  /// **'Review Submitted!'**
  String get reviewSubmitted;

  /// Review submitted success message
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback! Your review has been submitted successfully and will help other riders make informed decisions.'**
  String get reviewSubmittedMessage;

  /// Great button text
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get great;

  /// Driver information section title
  ///
  /// In en, this message translates to:
  /// **'Driver Information'**
  String get driverInformation;

  /// Review guidelines section title
  ///
  /// In en, this message translates to:
  /// **'Review Guidelines'**
  String get reviewGuidelines;

  /// Review guideline about public visibility
  ///
  /// In en, this message translates to:
  /// **'Your review will be public and visible to other users'**
  String get guidelinePublic;

  /// Review guideline about honesty
  ///
  /// In en, this message translates to:
  /// **'Be honest and fair in your rating'**
  String get guidelineHonest;

  /// Review guideline about service quality
  ///
  /// In en, this message translates to:
  /// **'Focus on the service quality and safety'**
  String get guidelineServiceQuality;

  /// Review guideline about being respectful
  ///
  /// In en, this message translates to:
  /// **'Keep your review respectful and constructive'**
  String get guidelineRespectful;

  /// Add review comment section title
  ///
  /// In en, this message translates to:
  /// **'Add Review / Comment'**
  String get addReviewComment;

  /// Review text field placeholder
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience with this ride...'**
  String get reviewPlaceholder;

  /// Reviews count label
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// Format for displaying driver rating and review count
  ///
  /// In en, this message translates to:
  /// **'{driver} • {rating} ⭐ ({reviewCount} {reviews})'**
  String driverRatingFormat(
    String driver,
    String rating,
    String reviewCount,
    String reviews,
  );

  /// Greeting for driver on home screen
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloDriver(String name);

  /// Total booking stats card title
  ///
  /// In en, this message translates to:
  /// **'Total Booking'**
  String get totalBooking;

  /// Upcoming bookings stats card title
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// Total earnings stats card title
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get totalEarning;

  /// New withdraw stats card title
  ///
  /// In en, this message translates to:
  /// **'New Withdraw'**
  String get newWithdraw;

  /// New booking requests section title
  ///
  /// In en, this message translates to:
  /// **'New Booking Requests'**
  String get newBookingRequests;

  /// Empty state title when no booking requests
  ///
  /// In en, this message translates to:
  /// **'No new booking requests'**
  String get noNewBookingRequests;

  /// Empty state subtitle for booking requests
  ///
  /// In en, this message translates to:
  /// **'New ride requests will appear here'**
  String get newRideRequestsWillAppear;

  /// Default location text for driver home screen
  ///
  /// In en, this message translates to:
  /// **'Building D-3, Main Campus, Madinah, 41511'**
  String get defaultLocationText;

  /// Text showing when booking was posted
  ///
  /// In en, this message translates to:
  /// **'Posted 2 Mint ago'**
  String get postedMinutesAgo;

  /// Pricing label for booking card
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// Al Rajhi Scheme location name
  ///
  /// In en, this message translates to:
  /// **'Al Rajhi Scheme'**
  String get alRajhiScheme;

  /// King Abdulaziz University location name
  ///
  /// In en, this message translates to:
  /// **'KAU - King Abdulaziz University'**
  String get kauUniversity;

  /// Trip way label
  ///
  /// In en, this message translates to:
  /// **'Trip Way'**
  String get tripWay;

  /// Accept booking button text
  ///
  /// In en, this message translates to:
  /// **'Accept Booking'**
  String get acceptBooking;

  /// Decline booking button text
  ///
  /// In en, this message translates to:
  /// **'Decline Booking'**
  String get declineBooking;

  /// Chat with user button text
  ///
  /// In en, this message translates to:
  /// **'Chat with user'**
  String get chatWithUser;

  /// Close booking button text
  ///
  /// In en, this message translates to:
  /// **'Close Booking'**
  String get closeBooking;

  /// The student reference
  ///
  /// In en, this message translates to:
  /// **'the student'**
  String get theStudent;

  /// The employee reference
  ///
  /// In en, this message translates to:
  /// **'the employee'**
  String get theEmployee;

  /// The user reference
  ///
  /// In en, this message translates to:
  /// **'the user'**
  String get theUser;

  /// Empty state for no current bookings
  ///
  /// In en, this message translates to:
  /// **'No current bookings'**
  String get noCurrentBookings;

  /// Empty state for no previous bookings
  ///
  /// In en, this message translates to:
  /// **'No previous bookings'**
  String get noPreviousBookings;

  /// Empty state subtitle for current bookings
  ///
  /// In en, this message translates to:
  /// **'Your current bookings will appear here'**
  String get currentBookingsWillAppear;

  /// Empty state subtitle for previous bookings
  ///
  /// In en, this message translates to:
  /// **'Your previous bookings will appear here'**
  String get previousBookingsWillAppear;

  /// Flag inappropriate content screen title
  ///
  /// In en, this message translates to:
  /// **'Flag as Inappropriate'**
  String get flagAsInappropriate;

  /// Section title for report issue types
  ///
  /// In en, this message translates to:
  /// **'Type of Issue'**
  String get typeOfIssue;

  /// Helper text explaining why issue type selection is needed
  ///
  /// In en, this message translates to:
  /// **'This helps categorize the report for faster processing by your support team.'**
  String get reportCategorizeHelper;

  /// Safety concern report type
  ///
  /// In en, this message translates to:
  /// **'Safety Concern'**
  String get safetyConcern;

  /// Safety concern report type subtitle
  ///
  /// In en, this message translates to:
  /// **'(e.g., unsafe pick-up/drop-off location, dangerous request)'**
  String get safetyConcernSubtitle;

  /// Navigation or route issue report type
  ///
  /// In en, this message translates to:
  /// **'Navigation/Route Issue'**
  String get navigationRouteIssue;

  /// Invalid pickup or drop-off location report type
  ///
  /// In en, this message translates to:
  /// **'Invalid Pickup/Drop-off'**
  String get invalidPickupDropoff;

  /// Passenger no-show report type
  ///
  /// In en, this message translates to:
  /// **'No-Show (Passenger didn\'t show up)'**
  String get noShowPassenger;

  /// Suspicious activity report type
  ///
  /// In en, this message translates to:
  /// **'Suspicious Activity'**
  String get suspiciousActivity;

  /// Submit report button text
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// Error message when no report reason is selected
  ///
  /// In en, this message translates to:
  /// **'Please select a report reason'**
  String get pleaseSelectReportReason;

  /// Confirmation dialog title for submitting report
  ///
  /// In en, this message translates to:
  /// **'Submit Report?'**
  String get submitReportQuestion;

  /// Confirmation dialog message for submitting report
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to submit this report? Our support team will review it and take appropriate action.'**
  String get submitReportConfirmation;

  /// Confirm submit report button text
  ///
  /// In en, this message translates to:
  /// **'Yes, Submit Report'**
  String get yesSubmitReport;

  /// Success dialog title after report submission
  ///
  /// In en, this message translates to:
  /// **'Report Submitted!'**
  String get reportSubmitted;

  /// Success dialog message after report submission
  ///
  /// In en, this message translates to:
  /// **'Your report has been submitted successfully. Our support team will review it and take appropriate action.'**
  String get reportSubmittedSuccessfully;

  /// Total distance label
  ///
  /// In en, this message translates to:
  /// **'Total Distance'**
  String get totalDistance;

  /// Transportation type label
  ///
  /// In en, this message translates to:
  /// **'Transportations Type'**
  String get transportationType;

  /// Group transport option
  ///
  /// In en, this message translates to:
  /// **'Group Transport'**
  String get groupTransport;

  /// Estimated duration label
  ///
  /// In en, this message translates to:
  /// **'Estimated Duration'**
  String get estimatedDuration;

  /// Sedan car option
  ///
  /// In en, this message translates to:
  /// **'Sedan Car'**
  String get sedanCar;

  /// Passenger capacity description
  ///
  /// In en, this message translates to:
  /// **'Suitable for 4 passengers'**
  String get suitableForPassengers;

  /// Dubai city name
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get dubai;

  /// My earnings page title
  ///
  /// In en, this message translates to:
  /// **'My Earnings'**
  String get myEarnings;

  /// Total earnings label
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// Withdraw label
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// Bookings earning section title
  ///
  /// In en, this message translates to:
  /// **'Bookings Earning'**
  String get bookingsEarning;

  /// Order number prefix
  ///
  /// In en, this message translates to:
  /// **'Order#'**
  String get orderNumber;

  /// Saudi Arabian Riyal currency
  ///
  /// In en, this message translates to:
  /// **'SAR'**
  String get sar;

  /// Reviews and ratings section title
  ///
  /// In en, this message translates to:
  /// **'Reviews & Ratings'**
  String get reviewsRatings;

  /// Total reviews label
  ///
  /// In en, this message translates to:
  /// **'Total Reviews'**
  String get totalReviews;

  /// Recent reviews section title
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recentReviews;

  /// Error message when signing out fails
  ///
  /// In en, this message translates to:
  /// **'Error signing out:'**
  String get errorSigningOut;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Mobile number field label
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Mobile number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterMobileNumber;

  /// Vehicle make field label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Make'**
  String get vehicleMake;

  /// Vehicle make field hint
  ///
  /// In en, this message translates to:
  /// **'Select vehicle make'**
  String get selectVehicleMake;

  /// Vehicle model field hint
  ///
  /// In en, this message translates to:
  /// **'Select vehicle model'**
  String get selectVehicleModel;

  /// Vehicle model field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., Toyota Corolla 2020'**
  String get vehicleModelHint;

  /// Vehicle year field label
  ///
  /// In en, this message translates to:
  /// **'Vehicle Year'**
  String get vehicleYear;

  /// Vehicle year field hint
  ///
  /// In en, this message translates to:
  /// **'Select vehicle year'**
  String get selectVehicleYear;

  /// Service address field label
  ///
  /// In en, this message translates to:
  /// **'Service Address'**
  String get serviceAddress;

  /// Service address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your service area'**
  String get enterServiceArea;

  /// Full time hours description
  ///
  /// In en, this message translates to:
  /// **'40+ hours/week'**
  String get hoursPerWeek;

  /// Part time hours description
  ///
  /// In en, this message translates to:
  /// **'Flexible hours'**
  String get flexibleHours;

  /// License number field label
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// License number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your license number'**
  String get enterLicenseNumber;

  /// Update profile button text
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// Online status
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Message input placeholder text
  ///
  /// In en, this message translates to:
  /// **'Type Your Message'**
  String get typeYourMessage;

  /// Choose a role title
  ///
  /// In en, this message translates to:
  /// **'Choose a Role'**
  String get chooseARole;

  /// Select according to your uses subtitle
  ///
  /// In en, this message translates to:
  /// **'Select according to your uses'**
  String get selectAccordingToYourUses;

  /// I need transport option
  ///
  /// In en, this message translates to:
  /// **'I need transport'**
  String get iNeedTransport;

  /// Customer role
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// I provide transport option
  ///
  /// In en, this message translates to:
  /// **'I provide transport'**
  String get iProvideTransport;

  /// Driver/Company role
  ///
  /// In en, this message translates to:
  /// **'Driver/Company'**
  String get driverCompany;

  /// Select role title
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// Minimal profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Minimal profile'**
  String get minimalProfile;

  /// School student role
  ///
  /// In en, this message translates to:
  /// **'School Student'**
  String get schoolStudent;

  /// Via parent subtitle
  ///
  /// In en, this message translates to:
  /// **'Via Parent'**
  String get viaParent;

  /// Transport visible only via parent description
  ///
  /// In en, this message translates to:
  /// **'Transport visible only via parent'**
  String get transportVisibleOnlyViaParent;

  /// University student role
  ///
  /// In en, this message translates to:
  /// **'University Student'**
  String get universityStudent;

  /// University/Institute student subtitle
  ///
  /// In en, this message translates to:
  /// **'University/Institute Student'**
  String get universityInstituteStudent;

  /// See university transport card description
  ///
  /// In en, this message translates to:
  /// **'See university transport card'**
  String get seeUniversityTransportCard;

  /// Teacher role subtitle
  ///
  /// In en, this message translates to:
  /// **'Teacher Role'**
  String get teacherRole;

  /// See teacher transport card description
  ///
  /// In en, this message translates to:
  /// **'See teacher transport card'**
  String get seeTeacherTransportCard;

  /// Employee role subtitle
  ///
  /// In en, this message translates to:
  /// **'Employee Role'**
  String get employeeRole;

  /// See employee transport card description
  ///
  /// In en, this message translates to:
  /// **'See employee transport card'**
  String get seeEmployeeTransportCard;

  /// Managing kids subtitle
  ///
  /// In en, this message translates to:
  /// **'Managing Kids'**
  String get managingKids;

  /// Add children profiles description
  ///
  /// In en, this message translates to:
  /// **'Add University or Institute Name'**
  String get addChildrenProfiles;

  /// Metro shuttle user role
  ///
  /// In en, this message translates to:
  /// **'Metro Shuttle User'**
  String get metroShuttleUser;

  /// See metro shuttle card description
  ///
  /// In en, this message translates to:
  /// **'See metro shuttle card'**
  String get seeMetroShuttleCard;

  /// Metro shuttle title
  ///
  /// In en, this message translates to:
  /// **'Metro Shuttle'**
  String get metroShuttle;

  /// Setup metro route title
  ///
  /// In en, this message translates to:
  /// **'Setup Metro Route'**
  String get setupMetroRoute;

  /// Configure your metro route subtitle
  ///
  /// In en, this message translates to:
  /// **'Configure your metro route'**
  String get configureYourMetroRoute;

  /// Home address label
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get homeAddress;

  /// Enter your home address subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your home address'**
  String get enterYourHomeAddress;

  /// Enter home address hint
  ///
  /// In en, this message translates to:
  /// **'Enter home address'**
  String get enterHomeAddress;

  /// Metro station label
  ///
  /// In en, this message translates to:
  /// **'Metro Station'**
  String get metroStation;

  /// Select destination station subtitle
  ///
  /// In en, this message translates to:
  /// **'Select destination station'**
  String get selectDestinationStation;

  /// Select metro station title
  ///
  /// In en, this message translates to:
  /// **'Select Metro Station'**
  String get selectMetroStation;

  /// Schedule label
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Select days and times subtitle
  ///
  /// In en, this message translates to:
  /// **'Select days and times'**
  String get selectDaysAndTimes;

  /// Select days label
  ///
  /// In en, this message translates to:
  /// **'Select Days'**
  String get selectDays;

  /// Morning time label
  ///
  /// In en, this message translates to:
  /// **'Morning Time'**
  String get morningTime;

  /// Evening time label
  ///
  /// In en, this message translates to:
  /// **'Evening Time'**
  String get eveningTime;

  /// Select time placeholder
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// Select preferred vehicle subtitle
  ///
  /// In en, this message translates to:
  /// **'Select preferred vehicle'**
  String get selectPreferredVehicle;

  /// Small van option
  ///
  /// In en, this message translates to:
  /// **'Small Van'**
  String get smallVan;

  /// Small bus option
  ///
  /// In en, this message translates to:
  /// **'Small Bus'**
  String get smallBus;

  /// Bus large option
  ///
  /// In en, this message translates to:
  /// **'Bus (Large)'**
  String get busLarge;

  /// Ride type label
  ///
  /// In en, this message translates to:
  /// **'Ride Type'**
  String get rideType;

  /// Choose private or shared subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose private or shared'**
  String get choosePrivateOrShared;

  /// Private ride type
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// Shared ride type
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// Please enter home address error
  ///
  /// In en, this message translates to:
  /// **'Please enter home address'**
  String get pleaseEnterHomeAddress;

  /// Please select metro station error
  ///
  /// In en, this message translates to:
  /// **'Please select metro station'**
  String get pleaseSelectMetroStation;

  /// Please select at least one day error
  ///
  /// In en, this message translates to:
  /// **'Please select at least one day'**
  String get pleaseSelectAtLeastOneDay;

  /// Please select at least one time error
  ///
  /// In en, this message translates to:
  /// **'Please select at least one time'**
  String get pleaseSelectAtLeastOneTime;

  /// Metro subscriptions title
  ///
  /// In en, this message translates to:
  /// **'Metro Subscriptions'**
  String get metroSubscriptions;

  /// My subscriptions title
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscriptions;

  /// Manage your metro rides subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your metro rides'**
  String get manageYourMetroRides;

  /// No subscriptions empty state
  ///
  /// In en, this message translates to:
  /// **'No Subscriptions'**
  String get noSubscriptions;

  /// Create your first subscription message
  ///
  /// In en, this message translates to:
  /// **'Create your first subscription'**
  String get createYourFirstSubscription;

  /// Create subscription button
  ///
  /// In en, this message translates to:
  /// **'Create Subscription'**
  String get createSubscription;

  /// Subscription paused message
  ///
  /// In en, this message translates to:
  /// **'Subscription paused'**
  String get subscriptionPaused;

  /// Subscription resumed message
  ///
  /// In en, this message translates to:
  /// **'Subscription resumed'**
  String get subscriptionResumed;

  /// Subscription cancelled message
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled'**
  String get subscriptionCancelled;

  /// Next ride label
  ///
  /// In en, this message translates to:
  /// **'Next Ride'**
  String get nextRide;

  /// Pause button
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume button
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Company dashboard title
  ///
  /// In en, this message translates to:
  /// **'Company Dashboard'**
  String get companyDashboard;

  /// Manage your fleet subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your fleet'**
  String get manageYourFleet;

  /// Overview section title
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Total bookings label
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// Active drivers label
  ///
  /// In en, this message translates to:
  /// **'Active Drivers'**
  String get activeDrivers;

  /// Total vehicles label
  ///
  /// In en, this message translates to:
  /// **'Total Vehicles'**
  String get totalVehicles;

  /// Monthly revenue label
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// View bookings action
  ///
  /// In en, this message translates to:
  /// **'View Bookings'**
  String get viewBookings;

  /// Manage drivers action
  ///
  /// In en, this message translates to:
  /// **'Manage Drivers'**
  String get manageDrivers;

  /// Manage vehicles action
  ///
  /// In en, this message translates to:
  /// **'Manage Vehicles'**
  String get manageVehicles;

  /// View reports action
  ///
  /// In en, this message translates to:
  /// **'View Reports'**
  String get viewReports;

  /// Recent bookings section title
  ///
  /// In en, this message translates to:
  /// **'Recent Bookings'**
  String get recentBookings;

  /// View all button
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Vehicle management title
  ///
  /// In en, this message translates to:
  /// **'Vehicle Management'**
  String get vehicleManagement;

  /// Search vehicles hint
  ///
  /// In en, this message translates to:
  /// **'Search vehicles'**
  String get searchVehicles;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Maintenance status
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// Inactive status
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No vehicles found empty state
  ///
  /// In en, this message translates to:
  /// **'No vehicles found'**
  String get noVehiclesFound;

  /// Add your first vehicle message
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle'**
  String get addYourFirstVehicle;

  /// Add vehicle screen title
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get addVehicle;

  /// Vehicle deleted message
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted'**
  String get vehicleDeleted;

  /// Number of seats
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get seats;

  /// Mileage label
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileage;

  /// Assign button
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// View details button
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Driver management title
  ///
  /// In en, this message translates to:
  /// **'Driver Management'**
  String get driverManagement;

  /// Search drivers hint
  ///
  /// In en, this message translates to:
  /// **'Search drivers'**
  String get searchDrivers;

  /// Offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Busy status
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get busy;

  /// Suspended status
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspended;

  /// No drivers found empty state
  ///
  /// In en, this message translates to:
  /// **'No drivers found'**
  String get noDriversFound;

  /// Add your first driver message
  ///
  /// In en, this message translates to:
  /// **'Add your first driver'**
  String get addYourFirstDriver;

  /// Add driver screen title
  ///
  /// In en, this message translates to:
  /// **'Add Driver'**
  String get addDriver;

  /// Driver suspended message
  ///
  /// In en, this message translates to:
  /// **'Driver suspended'**
  String get driverSuspended;

  /// Driver activated message
  ///
  /// In en, this message translates to:
  /// **'Driver activated'**
  String get driverActivated;

  /// Activate button
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// Suspend button
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// Assign vehicle button
  ///
  /// In en, this message translates to:
  /// **'Assign Vehicle'**
  String get assignVehicle;

  /// Earnings label
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// Trips label
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// Documents label
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// Verified badge
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Action required label
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get actionRequired;

  /// Unknown status
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Sunday day
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Monday day
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Tuesday day
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Wednesday day
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Thursday day
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Friday day
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Saturday day
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// Union Square Station name
  ///
  /// In en, this message translates to:
  /// **'Union Square Station'**
  String get unionSquareStation;

  /// Red Line name
  ///
  /// In en, this message translates to:
  /// **'Red Line'**
  String get redLine;

  /// Central Station name
  ///
  /// In en, this message translates to:
  /// **'Central Station'**
  String get centralStation;

  /// Blue Line name
  ///
  /// In en, this message translates to:
  /// **'Blue Line'**
  String get blueLine;

  /// West End Station name
  ///
  /// In en, this message translates to:
  /// **'West End Station'**
  String get westEndStation;

  /// Green Line name
  ///
  /// In en, this message translates to:
  /// **'Green Line'**
  String get greenLine;

  /// East Gate Station name
  ///
  /// In en, this message translates to:
  /// **'East Gate Station'**
  String get eastGateStation;

  /// North Terminal Station name
  ///
  /// In en, this message translates to:
  /// **'North Terminal Station'**
  String get northTerminalStation;

  /// Parking facility
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// Elevator facility
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get elevator;

  /// Ramp facility
  ///
  /// In en, this message translates to:
  /// **'Ramp'**
  String get ramp;

  /// WiFi facility
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// Restroom facility
  ///
  /// In en, this message translates to:
  /// **'Restroom'**
  String get restroom;

  /// Facilities label
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// Accessible status
  ///
  /// In en, this message translates to:
  /// **'Accessible'**
  String get accessible;

  /// Please select a station error
  ///
  /// In en, this message translates to:
  /// **'Please select a station'**
  String get pleaseSelectAStation;

  /// Search stations hint
  ///
  /// In en, this message translates to:
  /// **'Search stations'**
  String get searchStations;

  /// Location icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/location.svg'**
  String get locationIcon;

  /// Search icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/search.svg'**
  String get searchIcon;

  /// Dropdown icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/dropdown.svg'**
  String get dropdownIcon;

  /// Calendar icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/calendar.svg'**
  String get calendarIcon;

  /// Car icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/car.svg'**
  String get carIcon;

  /// Users icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/users.svg'**
  String get usersIcon;

  /// Clock icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/clock.svg'**
  String get clockIcon;

  /// Metro icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/metro.svg'**
  String get metroIcon;

  /// Family icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/family.svg'**
  String get familyIcon;

  /// Accessibility icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/accessibility.svg'**
  String get accessibilityIcon;

  /// Document icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/document.svg'**
  String get documentIcon;

  /// Report icon path
  ///
  /// In en, this message translates to:
  /// **'assets/icons/report.svg'**
  String get reportIcon;

  /// Available offers screen title
  ///
  /// In en, this message translates to:
  /// **'Available Offers'**
  String get availableOffers;

  /// Number of offers received
  ///
  /// In en, this message translates to:
  /// **'offers received'**
  String get offersReceived;

  /// Sort by closest option
  ///
  /// In en, this message translates to:
  /// **'Closest'**
  String get closest;

  /// Sort by cheapest option
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// Sort by top rated option
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// Loading message while searching for providers
  ///
  /// In en, this message translates to:
  /// **'Searching for providers...'**
  String get searchingForProviders;

  /// Time estimate for provider search
  ///
  /// In en, this message translates to:
  /// **'This may take up to 30 seconds'**
  String get mayTakeUpTo30Seconds;

  /// Message when no offers are available
  ///
  /// In en, this message translates to:
  /// **'No offers received yet'**
  String get noOffersReceivedYet;

  /// Time limit for provider responses
  ///
  /// In en, this message translates to:
  /// **'Providers have 30 minutes to respond to your request'**
  String get providersHave30MinutesToRespond;

  /// Individual provider type
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// Company provider type
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// Monthly pricing
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// Per ride pricing
  ///
  /// In en, this message translates to:
  /// **'per ride'**
  String get perRide;

  /// Live tracking badge
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// Insured badge
  ///
  /// In en, this message translates to:
  /// **'Insured'**
  String get insured;

  /// Female driver badge
  ///
  /// In en, this message translates to:
  /// **'Female Driver'**
  String get femaleDriver;

  /// Accept offer button
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Negotiate offer button
  ///
  /// In en, this message translates to:
  /// **'Negotiate'**
  String get negotiate;

  /// Chat button
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Decline offer button
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Success message when offer is accepted
  ///
  /// In en, this message translates to:
  /// **'Offer accepted successfully!'**
  String get offerAcceptedSuccessfully;

  /// Error message when offer acceptance fails
  ///
  /// In en, this message translates to:
  /// **'Failed to accept offer'**
  String get failedToAcceptOffer;

  /// Driver information section title
  ///
  /// In en, this message translates to:
  /// **'Driver Info'**
  String get driverInfo;

  /// Name field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterName;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// Assign vehicle section title
  ///
  /// In en, this message translates to:
  /// **'Assign Vehicle (optional)'**
  String get assignVehicleOptional;

  /// Create driver button
  ///
  /// In en, this message translates to:
  /// **'Create Driver'**
  String get createDriver;

  /// Unassigned vehicle option
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// Required fields validation message
  ///
  /// In en, this message translates to:
  /// **'Name and phone are required'**
  String get nameAndPhoneRequired;

  /// Driver creation success message
  ///
  /// In en, this message translates to:
  /// **'Driver created'**
  String get driverCreated;

  /// Basic information section title
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// Plate number field label
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// Vehicle make field label
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// Vehicle model field label
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// Transmission field label
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// Automatic transmission
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// Manual transmission
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// Year field label
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Seat capacity field label
  ///
  /// In en, this message translates to:
  /// **'Seat Capacity'**
  String get seatCapacity;

  /// Create vehicle button
  ///
  /// In en, this message translates to:
  /// **'Create Vehicle'**
  String get createVehicle;

  /// Required fields validation message
  ///
  /// In en, this message translates to:
  /// **'Plate, make and model are required'**
  String get plateMakeModelRequired;

  /// Vehicle creation success message
  ///
  /// In en, this message translates to:
  /// **'Vehicle created'**
  String get vehicleCreated;

  /// Driver type selection screen title
  ///
  /// In en, this message translates to:
  /// **'Choose Driver Type'**
  String get chooseDriverType;

  /// Driver type selection subtitle
  ///
  /// In en, this message translates to:
  /// **'Select how you want to register as a driver'**
  String get selectHowToRegisterAsDriver;

  /// Individual driver option
  ///
  /// In en, this message translates to:
  /// **'Individual Driver'**
  String get individualDriver;

  /// Company driver option
  ///
  /// In en, this message translates to:
  /// **'I represent a company'**
  String get iRepresentCompany;

  /// Company driver option subtitle
  ///
  /// In en, this message translates to:
  /// **'Company Driver'**
  String get companyDriver;

  /// Driver type selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select your driver type'**
  String get pleaseSelectDriverType;

  /// Navigation error message
  ///
  /// In en, this message translates to:
  /// **'Navigation failed'**
  String get navigationFailed;

  /// Company registration screen title
  ///
  /// In en, this message translates to:
  /// **'Company Registration'**
  String get companyRegistration;

  /// Company registration subtitle
  ///
  /// In en, this message translates to:
  /// **'Register your transportation company'**
  String get registerYourTransportationCompany;

  /// Company information section title
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get companyInformation;

  /// Company name field label
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// Company name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get enterCompanyName;

  /// Company email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter company email'**
  String get enterCompanyEmail;

  /// Company phone field hint
  ///
  /// In en, this message translates to:
  /// **'Enter company phone'**
  String get enterCompanyPhone;

  /// Company address field label
  ///
  /// In en, this message translates to:
  /// **'Company Address'**
  String get companyAddress;

  /// Company address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter company address'**
  String get enterCompanyAddress;

  /// Business license number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter business license number'**
  String get enterBusinessLicenseNumber;

  /// Region field label
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// Required fields validation message
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllRequiredFields;

  /// Registration failed error message
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// Phone number verification subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number for verification'**
  String get enterYourPhoneNumberForVerification;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// Verification code information message
  ///
  /// In en, this message translates to:
  /// **'We will send you a verification code to confirm your phone number'**
  String get weWillSendVerificationCode;

  /// Send verification code button
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// Phone number required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// Valid phone number required message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// Account settings section title
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Edit profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get editProfileSubtitle;

  /// Change phone number option
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumber;

  /// Change phone number subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your phone number'**
  String get changePhoneNumberSubtitle;

  /// Change email option
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// Change email subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your email address'**
  String get changeEmailSubtitle;

  /// Change address option
  ///
  /// In en, this message translates to:
  /// **'Change Address'**
  String get changeAddress;

  /// Change address subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your address information'**
  String get changeAddressSubtitle;

  /// App settings section title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// Appearance subtitle
  ///
  /// In en, this message translates to:
  /// **'Customize app appearance'**
  String get appearanceSubtitle;

  /// Notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get notificationsSubtitle;

  /// Location settings option
  ///
  /// In en, this message translates to:
  /// **'Location Settings'**
  String get locationSettings;

  /// Location settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage location permissions'**
  String get locationSettingsSubtitle;

  /// Payment and security section title
  ///
  /// In en, this message translates to:
  /// **'Payment & Security'**
  String get paymentSecurity;

  /// Payment methods option
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// Payment methods subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your payment methods'**
  String get paymentMethodsSubtitle;

  /// Change password subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get changePasswordSubtitle;

  /// Privacy settings option
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Privacy settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your privacy preferences'**
  String get privacySettingsSubtitle;

  /// Support and help section title
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportHelp;

  /// Help and support subtitle
  ///
  /// In en, this message translates to:
  /// **'Get help and support'**
  String get helpSupportSubtitle;

  /// About app option
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// About app subtitle
  ///
  /// In en, this message translates to:
  /// **'App version and information'**
  String get aboutAppSubtitle;

  /// Rate app option
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// Rate app subtitle
  ///
  /// In en, this message translates to:
  /// **'Rate us on the app store'**
  String get rateAppSubtitle;

  /// Contact label
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Error loading data message
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get logoutConfirmation;

  /// Logout error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred during logout'**
  String get logoutError;

  /// Student transport service description
  ///
  /// In en, this message translates to:
  /// **'Transport students to universities and schools'**
  String get studentTransportDescription;

  /// Teacher transport service description
  ///
  /// In en, this message translates to:
  /// **'Transport teachers and staff'**
  String get teacherTransportDescription;

  /// Employee transport service description
  ///
  /// In en, this message translates to:
  /// **'Transport employees to workplaces'**
  String get employeeTransportDescription;

  /// Metro transport service name
  ///
  /// In en, this message translates to:
  /// **'Metro Transport'**
  String get metroTransport;

  /// Metro transport service description
  ///
  /// In en, this message translates to:
  /// **'Transport to metro stations'**
  String get metroTransportDescription;

  /// Error message when no service is selected
  ///
  /// In en, this message translates to:
  /// **'Please select at least one service'**
  String get pleaseSelectAtLeastOneService;

  /// Service selection screen title
  ///
  /// In en, this message translates to:
  /// **'Service Selection'**
  String get serviceSelection;

  /// Service selection screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Select the services you provide'**
  String get selectServicesYouProvide;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Error message when region is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select your region'**
  String get pleaseSelectYourRegion;

  /// Error message when city is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select your city'**
  String get pleaseSelectYourCity;

  /// Error message when district is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select your district'**
  String get pleaseSelectYourDistrict;

  /// Location information screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Select your service area'**
  String get selectYourServiceArea;

  /// Error message when full name is not entered
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// Error message when email is not entered
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterYourEmailAddress;

  /// Error message when password is too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// Error message when gender is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get pleaseSelectYourGender;

  /// Personal information screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourself;

  /// Full name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// Driver license document name
  ///
  /// In en, this message translates to:
  /// **'Driver License'**
  String get driverLicense;

  /// Driver license description
  ///
  /// In en, this message translates to:
  /// **'Valid driving license'**
  String get validDrivingLicense;

  /// Vehicle registration description
  ///
  /// In en, this message translates to:
  /// **'Vehicle registration certificate'**
  String get vehicleRegistrationCertificate;

  /// Insurance certificate document name
  ///
  /// In en, this message translates to:
  /// **'Insurance Certificate'**
  String get insuranceCertificate;

  /// Insurance certificate description
  ///
  /// In en, this message translates to:
  /// **'Vehicle insurance certificate'**
  String get vehicleInsuranceCertificate;

  /// Background check document name
  ///
  /// In en, this message translates to:
  /// **'Background Check'**
  String get backgroundCheck;

  /// Background check description
  ///
  /// In en, this message translates to:
  /// **'Criminal background check'**
  String get criminalBackgroundCheck;

  /// No description provided for @uploadVehiclePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of your vehicle'**
  String get uploadVehiclePhoto;

  /// Medical certificate document name
  ///
  /// In en, this message translates to:
  /// **'Medical Certificate'**
  String get medicalCertificate;

  /// Medical certificate description
  ///
  /// In en, this message translates to:
  /// **'Health certificate'**
  String get healthCertificate;

  /// Error message when required documents are missing
  ///
  /// In en, this message translates to:
  /// **'Please upload all required documents'**
  String get pleaseUploadAllRequiredDocuments;

  /// Document upload screen title
  ///
  /// In en, this message translates to:
  /// **'Document Upload'**
  String get documentUpload;

  /// Document upload screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Upload required documents to complete registration'**
  String get uploadRequiredDocumentsToCompleteRegistration;

  /// Complete registration button text
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// Required document label
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Upload button text
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Error message when vehicle make is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle make'**
  String get pleaseSelectVehicleMake;

  /// Error message when vehicle model is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle model'**
  String get pleaseSelectVehicleModel;

  /// Error message when vehicle year is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle year'**
  String get pleaseSelectVehicleYear;

  /// Error message when plate number is not entered
  ///
  /// In en, this message translates to:
  /// **'Please enter plate number'**
  String get pleaseEnterPlateNumber;

  /// Error message when vehicle type is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle type'**
  String get pleaseSelectVehicleType;

  /// Vehicle information screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Tell us about your vehicle'**
  String get tellUsAboutYourVehicle;

  /// Plate number field hint
  ///
  /// In en, this message translates to:
  /// **'e.g., ABC-1234'**
  String get plateNumberExample;

  /// Air conditioning checkbox label
  ///
  /// In en, this message translates to:
  /// **'Air Conditioning Available'**
  String get airConditioningAvailable;

  /// Error message when verification code is not entered
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get pleaseEnterTheVerificationCode;

  /// Error message when verification code is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit code'**
  String get pleaseEnterValid6DigitCode;

  /// Success message when verification code is sent
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get verificationCodeSentSuccessfully;

  /// Verification code screen title and field label
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// Verification code screen subtitle with phone number
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to\n{phoneNumber}'**
  String enter6DigitCodeSentTo(String phoneNumber);

  /// Verification code field hint
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get enter6DigitCode;

  /// Resend code countdown message
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String resendCodeIn(String time);

  /// Resend code button text
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// Info message about checking SMS
  ///
  /// In en, this message translates to:
  /// **'Check your SMS messages for the verification code'**
  String get checkYourSMSMessagesForVerificationCode;

  /// Verify code button text
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @currentPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Current Phone Number'**
  String get currentPhoneNumber;

  /// No description provided for @newPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'New Phone Number'**
  String get newPhoneNumber;

  /// No description provided for @enterNewPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter new phone number'**
  String get enterNewPhoneNumber;

  /// No description provided for @phoneChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'We will send you a verification code to confirm your new phone number'**
  String get phoneChangeInfo;

  /// No description provided for @updatePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Update Phone Number'**
  String get updatePhoneNumber;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @phoneUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated successfully'**
  String get phoneUpdatedSuccessfully;

  /// No description provided for @currentAddress.
  ///
  /// In en, this message translates to:
  /// **'Current Address'**
  String get currentAddress;

  /// No description provided for @newAddress.
  ///
  /// In en, this message translates to:
  /// **'New Address'**
  String get newAddress;

  /// No description provided for @enterNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter new address'**
  String get enterNewAddress;

  /// No description provided for @addressChangeInfo.
  ///
  /// In en, this message translates to:
  /// **'Your address will be used for pickup and delivery services'**
  String get addressChangeInfo;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddress;

  /// No description provided for @pleaseEnterAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get pleaseEnterAddress;

  /// No description provided for @addressUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdatedSuccessfully;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
