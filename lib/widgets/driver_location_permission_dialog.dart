import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/providers/driver_location_provider.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationPermissionDialog extends HookConsumerWidget {
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const DriverLocationPermissionDialog({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(driverLocationPermissionProvider);
    final locationNotifier =
        ref.read(driverLocationPermissionProvider.notifier);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      contentPadding: EdgeInsets.all(24.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: accentPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: accentPurple,
              size: 40.w,
            ),
          ),

          20.verticalSpace,

          // Title
          Text(
            'Location Permission Required',
            style: montserrat(18, grey36, FontWeight.w600),
            textAlign: TextAlign.center,
          ),

          16.verticalSpace,

          // Description
          Text(
            'As a driver, you need to enable location tracking to:'
            '\n\n• Allow passengers to see your location'
            '\n• Receive ride requests nearby'
            '\n• Provide accurate pickup times'
            '\n• Ensure passenger safety',
            style: openSans(14, grey5E5E5E, FontWeight.w400),
            textAlign: TextAlign.left,
          ),

          24.verticalSpace,

          // Error message if any
          if (locationState.error != null) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20.w,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      locationState.error!,
                      style: openSans(12, Colors.red, FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
          ],

          // Buttons
          Row(
            children: [
              // Deny button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onPermissionDenied?.call();
                  },
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: grey160),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'Not Now',
                        style: montserrat(14, grey5E5E5E, FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),

              12.horizontalSpace,

              // Allow button
              Expanded(
                child: GestureDetector(
                  onTap: locationState.isLoading
                      ? null
                      : () async {
                          final granted =
                              await locationNotifier.requestPermission();

                          if (granted) {
                            Navigator.of(context).pop();
                            onPermissionGranted?.call();
                          }
                        },
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: locationState.isLoading
                          ? accentPurple.withOpacity(0.6)
                          : accentPurple,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: locationState.isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Allow Location',
                              style:
                                  montserrat(14, whiteColor, FontWeight.w600),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          16.verticalSpace,

          // Settings button (if permission was denied forever)
          GestureDetector(
            onTap: () async {
              await Geolocator.openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: montserrat(12, accentPurple, FontWeight.w500)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  /// Show the permission dialog
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onPermissionGranted,
    VoidCallback? onPermissionDenied,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DriverLocationPermissionDialog(
        onPermissionGranted: onPermissionGranted,
        onPermissionDenied: onPermissionDenied,
      ),
    );
  }
}
