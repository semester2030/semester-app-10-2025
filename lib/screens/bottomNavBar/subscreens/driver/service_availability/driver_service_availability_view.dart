import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class DriverServiceAvailabilityView extends HookConsumerWidget {
  const DriverServiceAvailabilityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // State for selected services
    final selectedServices = useState<Set<TransportationServiceType>>({});
    final isLoading = useState<bool>(true);
    final isSaving = useState<bool>(false);

    // Load current driver's service availability
    useEffect(() {
      _loadDriverServices(selectedServices, isLoading);
      return null;
    }, []);

    return ScreenWithTopAppbar(
      title: 'Service Availability',
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                140.verticalSpace,

                // Main content container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: isLoading.value
                        ? Center(
                            child: LoadingAnimationWidget.stretchedDots(
                              color: accentPurple,
                              size: 50.w,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title and description
                              Text(
                                'Select Your Services',
                                style: montserrat(20, grey36, FontWeight.w600),
                              ),
                              10.verticalSpace,
                              Text(
                                'Choose the transportation services you want to provide',
                                style:
                                    montserrat(14, grey5F63, FontWeight.w400),
                              ),
                              30.verticalSpace,

                              // Service options
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildServiceTile(
                                      context: context,
                                      l10n: l10n,
                                      serviceType:
                                          TransportationServiceType.student,
                                      icon: AppIcons.studentCap,
                                      title: l10n.studentTransport,
                                      description:
                                          'Provide transportation services for students',
                                      selectedServices: selectedServices,
                                    ),
                                    20.verticalSpace,
                                    _buildServiceTile(
                                      context: context,
                                      l10n: l10n,
                                      serviceType:
                                          TransportationServiceType.teacher,
                                      icon: AppIcons.teacherBag,
                                      title: l10n.teacherTransport,
                                      description:
                                          'Provide transportation services for teachers',
                                      selectedServices: selectedServices,
                                    ),
                                    20.verticalSpace,
                                    _buildServiceTile(
                                      context: context,
                                      l10n: l10n,
                                      serviceType:
                                          TransportationServiceType.employee,
                                      icon: AppIcons.femaleEmployee,
                                      title: l10n.employeeTransport,
                                      description:
                                          'Provide transportation services for employees',
                                      selectedServices: selectedServices,
                                    ),
                                    20.verticalSpace,
                                    _buildServiceTile(
                                      context: context,
                                      l10n: l10n,
                                      serviceType:
                                          TransportationServiceType.daily,
                                      icon: AppIcons.dailyTransport,
                                      title: l10n.dailyTransport,
                                      description:
                                          'Provide daily transportation services',
                                      selectedServices: selectedServices,
                                    ),
                                  ],
                                ),
                              ),

                              // Save button
                              30.verticalSpace,
                              SizedBox(
                                width: double.infinity,
                                child: NormalCustomButton(
                                  label:
                                      isSaving.value ? 'Saving...' : l10n.save,
                                  onPressed: selectedServices.value.isEmpty
                                      ? null
                                      : () async =>
                                          await _saveServiceAvailability(
                                            context,
                                            selectedServices.value,
                                            isSaving,
                                          ),
                                ),
                              ),
                              20.verticalSpace,
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile({
    required BuildContext context,
    required AppLocalizations l10n,
    required TransportationServiceType serviceType,
    required String icon,
    required String title,
    required String description,
    required ValueNotifier<Set<TransportationServiceType>> selectedServices,
  }) {
    final isSelected = selectedServices.value.contains(serviceType);

    return GestureDetector(
      onTap: () {
        final newSelection =
            Set<TransportationServiceType>.from(selectedServices.value);
        if (isSelected) {
          newSelection.remove(serviceType);
        } else {
          newSelection.add(serviceType);
        }
        selectedServices.value = newSelection;
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color:
              isSelected ? accentPurple.withOpacity(0.1) : containerbackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? accentPurple : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50.h,
              width: 50.h,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentPurple : lightPurple,
              ),
              child: SvgPicture.asset(
                icon,
                color: isSelected ? whiteColor : accentPurple,
              ),
            ),
            15.horizontalSpace,
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
                  5.verticalSpace,
                  Text(
                    description,
                    style: montserrat(13, grey5F63, FontWeight.w400),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? accentPurple : grey36,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadDriverServices(
    ValueNotifier<Set<TransportationServiceType>> selectedServices,
    ValueNotifier<bool> isLoading,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await userCollection.doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final services = data['availableServices'] as List<dynamic>?;

        if (services != null) {
          final Set<TransportationServiceType> serviceSet = {};
          for (final service in services) {
            try {
              final serviceType = TransportationServiceType.values.firstWhere(
                (e) => e.name == service.toString(),
              );
              serviceSet.add(serviceType);
            } catch (e) {
              log('Unknown service type: $service');
            }
          }
          selectedServices.value = serviceSet;
        }
      }
    } catch (e) {
      log('Error loading driver services: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveServiceAvailability(
    BuildContext context,
    Set<TransportationServiceType> selectedServices,
    ValueNotifier<bool> isSaving,
  ) async {
    try {
      isSaving.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final serviceNames =
          selectedServices.map((service) => service.name).toList();

      await userCollection.doc(user.uid).update({
        'availableServices': serviceNames,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      showSuccessFlushBar(
        message: 'Services updated successfully',
        context: context,
      );
    } catch (e) {
      log('Error saving service availability: $e');
      showErrorFlushBar(
        message: 'Error updating services. Please try again.',
        context: context,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
