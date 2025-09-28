import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class MultiSelectServiceTypes extends StatelessWidget {
  final Set<TransportationServiceType> selectedServiceTypes;
  final Function(TransportationServiceType) onServiceTypeToggle;
  final String? errorText;
  final String title;

  const MultiSelectServiceTypes({
    super.key,
    required this.selectedServiceTypes,
    required this.onServiceTypeToggle,
    this.errorText,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Service type data with icons and descriptions
    final List<Map<String, dynamic>> serviceTypeData = [
      {
        'type': TransportationServiceType.student,
        'icon': AppIcons.studentCap,
        'title': l10n.studentTransport,
        'description': 'Transportation for students',
      },
      {
        'type': TransportationServiceType.teacher,
        'icon': AppIcons.teacherBag,
        'title': l10n.teacherTransport,
        'description': 'Transportation for teachers',
      },
      {
        'type': TransportationServiceType.employee,
        'icon': AppIcons.femaleEmployee,
        'title': l10n.employeeTransport,
        'description': 'Transportation for employees',
      },
      {
        'type': TransportationServiceType.daily,
        'icon': AppIcons.dailyTransport,
        'title': l10n.dailyTransport,
        'description': 'Daily transportation services',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service type chips container
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 8.h),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(12.r),
          //   border: Border.all(
          //     color: errorText != null
          //         ? Colors.red.withOpacity(0.5)
          //         : grey5E5E5E.withOpacity(0.2),
          //     width: 1,
          //   ),
          //   boxShadow: [
          //     BoxShadow(
          //       color: grey5E5E5E.withOpacity(0.08),
          //       blurRadius: 8,
          //       offset: const Offset(0, 2),
          //     ),
          //   ],
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions text
              // Row(
              //   children: [
              //     Icon(
              //       Icons.info_outline,
              //       color: accentPurple.withOpacity(0.7),
              //       size: 16.sp,
              //     ),
              //     8.horizontalSpace,
              //     Expanded(
              //       child: Text(
              //         'Select the transportation services you want to provide',
              //         style: montserrat(12, grey5F63, FontWeight.w400),
              //       ),
              //     ),
              //   ],
              // ),
              // 16.verticalSpace,

              // Service type chips
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: serviceTypeData.map((data) {
                  final serviceType = data['type'] as TransportationServiceType;
                  final isSelected = selectedServiceTypes.contains(serviceType);

                  return GestureDetector(
                    onTap: () => onServiceTypeToggle(serviceType),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accentPurple.withOpacity(0.1)
                            : containerbackground,
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color:
                              isSelected ? accentPurple : containerbackground,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: accentPurple.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Service icon
                          Container(
                            width: 24.w,
                            height: 24.h,
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? accentPurple
                                  : accentPurple.withOpacity(0.2),
                            ),
                            child: SvgPicture.asset(
                              data['icon'],
                              color: isSelected ? Colors.white : accentPurple,
                              width: 16.w,
                              height: 16.h,
                            ),
                          ),
                          8.horizontalSpace,

                          // Service title
                          Text(
                            data['title'],
                            style: montserrat(
                              14,
                              isSelected ? accentPurple : grey5F63,
                              FontWeight.w500,
                            ),
                          ),

                          // Check icon for selected items
                          if (isSelected) ...[
                            8.horizontalSpace,
                            Icon(
                              Icons.check_circle,
                              color: accentPurple,
                              size: 18.sp,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Error text
        if (errorText != null) ...[
          8.verticalSpace,
          Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 16.sp,
                color: Colors.red.withOpacity(0.8),
              ),
              SizedBox(width: isRTL ? 4.w : 8.w),
              Expanded(
                child: Text(
                  errorText!,
                  style: montserrat(
                    12,
                    Colors.red.withOpacity(0.8),
                    FontWeight.w500,
                  ),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
