import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class DriverDocumentsScreen extends HookConsumerWidget {
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
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleYear;
  final String plateNumber;
  final String vehicleType;
  final String fuelType;
  final String transmission;
  final bool hasAC;
  final bool isFromDriverSignup;
  
  const DriverDocumentsScreen({
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
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.plateNumber,
    required this.vehicleType,
    required this.fuelType,
    required this.transmission,
    required this.hasAC,
    required this.isFromDriverSignup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final uploadedDocuments = useState<Map<String, String>>({});
    final isLoading = useState(false);

    // Required documents
    final documents = [
      {
        'id': 'driver_license',
        'name': l10n.driverLicense,
        'description': l10n.validDrivingLicense,
        'icon': Icons.drive_eta,
        'required': true,
      },
      {
        'id': 'vehicle_registration',
        'name': l10n.vehicleRegistration,
        'description': l10n.vehicleRegistrationCertificate,
        'icon': Icons.description,
        'required': true,
      },
      {
        'id': 'insurance_certificate',
        'name': l10n.insuranceCertificate,
        'description': l10n.vehicleInsuranceCertificate,
        'icon': Icons.security,
        'required': true,
      },
      {
        'id': 'background_check',
        'name': l10n.backgroundCheck,
        'description': l10n.criminalBackgroundCheck,
        'icon': Icons.verified_user,
        'required': true,
      },
      // Optional vehicle photo upload instead of medical certificate
      {
        'id': 'vehicle_photo',
        'name': l10n.vehiclePhoto,
        'description': l10n.uploadVehiclePhoto,
        'icon': Icons.directions_car,
        'required': false,
      },
    ];

    Future<void> onUploadDocument(String documentId) async {
      // TODO: Implement document upload
      // For now, just simulate upload
      showSuccessFlushBar(
        message: l10n.documentUploadedSuccessfully,
        context: context,
      );
      
      uploadedDocuments.value = {
        ...uploadedDocuments.value,
        documentId: 'uploaded_${DateTime.now().millisecondsSinceEpoch}',
      };
    }

    Future<void> onCompleteRegistration() async {
      final requiredDocs = documents.where((doc) => doc['required'] == true).toList();
      final missingDocs = requiredDocs.where((doc) => !uploadedDocuments.value.containsKey(doc['id'])).toList();
      
      if (missingDocs.isNotEmpty) {
        showErrorFlushBar(
          message: l10n.pleaseUploadAllRequiredDocuments,
          context: context,
        );
        return;
      }

      try {
        isLoading.value = true;
        
        // TODO: Complete driver registration
        showSuccessFlushBar(
          message: 'Registration completed successfully!',
          context: context,
        );
        
        // Navigate to driver dashboard
        if (context.mounted) {
          context.go('/bottom_nav_bar', extra: true); // true = isDriver
        }
      } catch (e) {
        if (context.mounted) {
          showErrorFlushBar(
            message: 'Registration failed: ${e.toString()}',
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
                        width: 160.w,
                        height: 60.h,
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
                    padding: EdgeInsets.fromLTRB(25.w, 60.h, 25.w, 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          l10n.documentUpload,
                          style: montserrat(24, grey36, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        
                        16.verticalSpace,
                        
                        // Subtitle
                        Text(
                          l10n.uploadRequiredDocumentsToCompleteRegistration,
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                        
                        32.verticalSpace,
                        
                        // Documents list
                        ...documents.map((document) => _buildDocumentCard(
                          context,
                          document: document,
                          isUploaded: uploadedDocuments.value.containsKey(document['id']),
                          onUpload: () => onUploadDocument(document['id'] as String),
                        )),
                        
                        32.verticalSpace,
                        
                        // Complete registration button
                        SizedBox(
                          width: double.infinity,
                          child: NormalCustomButton(
                            label: l10n.completeRegistration,
                            onPressed: isLoading.value ? null : onCompleteRegistration,
                          ),
                        ),
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

  Widget _buildDocumentCard(
    BuildContext context, {
    required Map<String, dynamic> document,
    required bool isUploaded,
    required VoidCallback onUpload,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isRequired = document['required'] as bool;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isUploaded ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUploaded ? Colors.green : Colors.grey.shade300,
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isUploaded ? Colors.green : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              document['icon'] as IconData,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          
          16.horizontalSpace,
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      document['name'] as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isUploaded ? Colors.green : Colors.black87,
                      ),
                    ),
                    
                    if (isRequired) ...[
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          l10n.required,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                4.verticalSpace,
                
                Text(
                  document['description'] as String,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Upload button or status
          if (isUploaded)
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24.sp,
            )
          else
            GestureDetector(
              onTap: onUpload,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: accentPurple,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  l10n.upload,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
