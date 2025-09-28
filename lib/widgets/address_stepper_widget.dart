import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class AddressStepperWidget extends StatelessWidget {
  final int currentStep; // 1-based index of current step (1, 2, 3, etc.)
  final int totalSteps; // Total number of steps

  const AddressStepperWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step indicator text
          Text(
            l10n.stepXOfY(currentStep, totalSteps),
            style:
                montserrat(12, accentPurple.withOpacity(0.7), FontWeight.w500),
          ),
          8.verticalSpace,

          // Progress bar
          Container(
            height: 8.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: accentPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Stack(
              children: [
                // Background progress bar
                Container(
                  height: 8.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                // Active progress bar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 8.h,
                  width: (MediaQuery.of(context).size.width - 48.w) *
                      (currentStep / totalSteps),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentPurple,
                        accentPurple.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),

          12.verticalSpace,

          // Step circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              int stepNumber = index + 1;
              bool isCompleted = stepNumber < currentStep;
              bool isActive = stepNumber == currentStep;
              bool isUpcoming = stepNumber > currentStep;

              return _buildStepCircle(
                stepNumber: stepNumber,
                isCompleted: isCompleted,
                isActive: isActive,
                isUpcoming: isUpcoming,
              );
            }),
          ),

          8.verticalSpace,

          // Step labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepLabel(l10n.addressDetails, 1),
              _buildStepLabel(l10n.driverSelection, 2),
              _buildStepLabel(l10n.additionalDetails, 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required int stepNumber,
    required bool isCompleted,
    required bool isActive,
    required bool isUpcoming,
  }) {
    Color backgroundColor;
    Color borderColor;
    Widget icon;

    if (isCompleted) {
      backgroundColor = accentPurple;
      borderColor = accentPurple;
      icon = Icon(
        Icons.check,
        color: Colors.white,
        size: 16.sp,
      );
    } else if (isActive) {
      backgroundColor = accentPurple;
      borderColor = accentPurple;
      icon = Text(
        stepNumber.toString(),
        style: montserrat(12, Colors.white, FontWeight.w600),
      );
    } else {
      backgroundColor = Colors.white;
      borderColor = accentPurple.withOpacity(0.3);
      icon = Text(
        stepNumber.toString(),
        style: montserrat(12, accentPurple.withOpacity(0.5), FontWeight.w600),
      );
    }

    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: accentPurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Center(child: icon),
    );
  }

  Widget _buildStepLabel(String label, int stepNumber) {
    bool isCompleted = stepNumber < currentStep;
    bool isActive = stepNumber == currentStep;

    Color textColor;
    FontWeight fontWeight;

    if (isCompleted || isActive) {
      textColor = accentPurple;
      fontWeight = FontWeight.w600;
    } else {
      textColor = accentPurple.withOpacity(0.5);
      fontWeight = FontWeight.w400;
    }

    return Text(
      label,
      style: montserrat(11, textColor, fontWeight),
    );
  }
}
