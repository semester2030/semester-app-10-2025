import 'dart:developer';

import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';

class DriverCard extends ConsumerWidget {
  final UserSignupModel driver;
  final VoidCallback? onTap;

  const DriverCard({
    super.key,
    required this.driver,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section with license plate and icons
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // License plate with car icon
                    CircularProfileImage(
                      imageUrl: driver.vehiclePhotoImage,
                      radius: 20,
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.vehicleMake ?? '', // License plate number
                          style: montserrat(14, grey36, FontWeight.w400),
                        ),
                        Text(
                          driver.fullVehicleName,
                          style: montserrat(10, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                    // Top right icons
                    Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bus/Transport icon
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SvgPicture.asset(AppIcons.carSignal),
                        ),
                        8.horizontalSpace,
                        // Additional icon (like settings/more)
                        SvgPicture.asset(AppIcons.bluetooth),
                      ],
                    ),
                  ],
                ),

                16.verticalSpace,

                // Transportation categories
                SizedBox(
                  height: 87.h,
                  child: Column(
                    children: [
                      ...((driver.availableServices ?? []).map((service) {
                        String serviceText;
                        switch (service.toLowerCase()) {
                          case 'daily':
                            serviceText = l10n.dailyTransportation;
                            break;
                          case 'student':
                            serviceText = l10n.studentTransportation;
                            break;
                          case 'teacher':
                            serviceText = l10n.teacherTransport;
                            break;
                          case 'employee':
                            serviceText = l10n.transportationForEmployees;
                            break;
                          default:
                            serviceText =
                                service; // fallback to the raw service name
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppIcons.successCheck,
                                  width: 15.w, height: 15.w),
                              12.horizontalSpace,
                              Text(
                                serviceText,
                                style:
                                    montserrat(12, grey5F63, FontWeight.w400),
                              ),
                            ],
                          ),
                        );
                      }).toList()),
                    ],
                  ),
                ),
                3.verticalSpace,
                Divider(),
                3.verticalSpace,
                // Driver info section
                Row(
                  children: [
                    // Driver profile picture
                    CircularProfileImage(
                      imageUrl:
                          'https://img.freepik.com/free-photo/man-car-driving_23-2148889981.jpg?semt=ais_hybrid&w=740',
                      radius: 20,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: montserrat(14, grey36, FontWeight.w400),
                          ),
                          2.verticalSpace,
                          Text(driver.email, // Role from the screenshot
                              style: montserrat(10, grey5F63, FontWeight.w400)),
                        ],
                      ),
                    ),
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: yellowE2A640,
                          size: 16.sp,
                        ),
                        4.horizontalSpace,
                        Text(
                          '${4.5} ( ${l10n.rating} )',
                          style: montserrat(10, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),

                15.verticalSpace,

                // Action buttons

                Row(
                  children: [
                    NormalCustomButton(
                      label: l10n.bookNow,
                      width: 146.w,
                      height: 36,
                      titleStyle: montserrat(12, whiteColor, FontWeight.w400),
                      syncCallback: () =>
                          _showServiceSelectionDialog(context, driver),
                    ),
                    12.horizontalSpace,
                    NormalCustomButton(
                      label: l10n.save,
                      width: 146.w,
                      height: 36,
                      titleStyle: montserrat(12, grey5F63, FontWeight.w400),
                      buttonColor: Color(0xFFF3F8FE),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show service selection dialog with driver's available services
  void _showServiceSelectionDialog(
      BuildContext context, UserSignupModel driver) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => ServiceSelectionDialog(
        driver: driver,
        l10n: l10n,
      ),
    );
  }
}

// Service Selection Dialog Widget
class ServiceSelectionDialog extends ConsumerWidget {
  final UserSignupModel driver;
  final AppLocalizations l10n;

  const ServiceSelectionDialog({
    super.key,
    required this.driver,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.local_taxi,
                  color: accentPurple,
                  size: 24.sp,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    "Select Service", // l10n.selectService,
                    style: montserrat(18, grey36, FontWeight.w600),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: grey5F63,
                    size: 24.sp,
                  ),
                ),
              ],
            ),

            16.verticalSpace,

            Text(
              "Choose the service you want to book", // l10n.chooseTheServiceYouWant,
              style: montserrat(14, grey5F63, FontWeight.w400),
            ),

            24.verticalSpace,

            // Service Cards in Grid Layout (2x2)
            ..._buildServiceGrid(context, ref),

            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  // Build service grid layout like home page
  List<Widget> _buildServiceGrid(BuildContext context, WidgetRef ref) {
    final availableServices = _getAvailableServices();
    List<Widget> gridWidgets = [];

    // Build in pairs (rows of 2)
    for (int i = 0; i < availableServices.length; i += 2) {
      List<Widget> rowChildren = [];

      // First service in row
      rowChildren.add(Expanded(
        child: _buildGridServiceCard(context, ref, availableServices[i]),
      ));

      // Second service in row (if exists)
      if (i + 1 < availableServices.length) {
        rowChildren.add(12.horizontalSpace);
        rowChildren.add(Expanded(
          child: _buildGridServiceCard(context, ref, availableServices[i + 1]),
        ));
      } else {
        // If odd number, add spacer
        rowChildren.add(12.horizontalSpace);
        rowChildren.add(Expanded(child: SizedBox()));
      }

      gridWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowChildren,
      ));

      // Add spacing between rows (except for last row)
      if (i + 2 < availableServices.length) {
        gridWidgets.add(16.verticalSpace);
      }
    }

    return gridWidgets;
  }

  // Build grid service card widget matching home page style
  Widget _buildGridServiceCard(BuildContext context, WidgetRef ref,
      TransportationServiceType serviceType) {
    String icon = _getServiceIcon(serviceType);
    String title = _getServiceTitle(serviceType);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Close dialog
        _startBookingProcess(context, ref, serviceType);
      },
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: accentPurple.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: () {
              Navigator.of(context).pop(); // Close dialog
              _startBookingProcess(context, ref, serviceType);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container with gradient background
                  Container(
                    width: 46.w,
                    height: 46.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentPurple.withOpacity(0.1),
                          accentPurple.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: accentPurple.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        icon,
                        height: 28.h,
                        width: 28.w,
                        colorFilter: ColorFilter.mode(
                          accentPurple,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  // Title with better typography
                  Text(
                    title,
                    style: montserrat(12, grey36, FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Get available services for the driver
  List<TransportationServiceType> _getAvailableServices() {
    final driverServices = driver.availableServices ?? [];
    List<TransportationServiceType> availableServices = [];

    for (String service in driverServices) {
      switch (service.toLowerCase()) {
        case 'student':
          availableServices.add(TransportationServiceType.student);
          break;
        case 'teacher':
          availableServices.add(TransportationServiceType.teacher);
          break;
        case 'employee':
          availableServices.add(TransportationServiceType.employee);
          break;
        case 'daily':
          availableServices.add(TransportationServiceType.daily);
          break;
      }
    }

    return availableServices;
  }

  // Build service card widget similar to home page cards
  // Get service icon based on type
  String _getServiceIcon(TransportationServiceType serviceType) {
    switch (serviceType) {
      case TransportationServiceType.student:
        return AppIcons.studentCap;
      case TransportationServiceType.teacher:
        return AppIcons.teacherBag;
      case TransportationServiceType.employee:
        return AppIcons.femaleEmployee;
      case TransportationServiceType.daily:
        return AppIcons.dailyTransport;
    }
  }

  // Get service title based on type
  String _getServiceTitle(TransportationServiceType serviceType) {
    switch (serviceType) {
      case TransportationServiceType.student:
        return l10n.studentTransportationShort;
      case TransportationServiceType.teacher:
        return l10n.teacherTransportation;
      case TransportationServiceType.employee:
        return l10n.employeeTransportation;
      case TransportationServiceType.daily:
        return l10n.dailyTransportationShort;
    }
  }

  // Start booking process with pre-selected driver
  void _startBookingProcess(BuildContext context, WidgetRef ref,
      TransportationServiceType serviceType) {
    final bookingNotifier = ref.read(bookingFlowProvider.notifier);

    log('🚀 Starting booking process with driver: ${driver.name}');
    log('📋 Service type: $serviceType');

    // Initialize booking with pre-selected driver to avoid clearing it
    bookingNotifier.initializeBookingWithDriver(serviceType, driver);

    // Verify driver was selected
    final state = ref.read(bookingFlowProvider);
    log('✅ Driver selected: ${state.selectedDriver?.name ?? 'FAILED!'}');

    // Navigate to address details (step 1), skipping driver selection since driver is pre-selected
    context.push('/booking_map', extra: serviceType);
  }
}
