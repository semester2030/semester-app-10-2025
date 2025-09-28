import 'package:flutter/foundation.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/utils/hooks.dart';

class NormalCustomButton extends HookWidget {
  const NormalCustomButton(
      {super.key,
      required this.label,
      this.onPressed,
      this.syncCallback,
      this.height,
      this.width,
      this.prefixIcon,
      this.radius,
      this.textColor,
      this.titleStyle,
      this.applycolor = true,
      this.buttonColor = accentPurple,
      this.isOutlined = false});

  /// Async callback for asynchronous tasks.
  final AsyncCallback? onPressed;

  /// Sync callback for regular tasks.
  final VoidCallback? syncCallback;

  /// Button label.
  final String label;

  /// Button text color.
  final Color? textColor;

  /// Button width.
  final double? width;

  /// Button height.
  final double? height;

  /// Button title style.
  final TextStyle? titleStyle;

  /// Button border radius.
  final double? radius;

  /// Prefix icon path.
  final String? prefixIcon;
  final bool? applycolor;
  final Color buttonColor;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    // Hook for managing asynchronous task state.
    final (:pending, :snapshot, hasError: _) = useAsyncTask();

    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          pending.value = onPressed!(); // Handle async function.
        } else if (syncCallback != null) {
          syncCallback!(); // Handle normal sync function.
        }
      },
      child: Container(
        height: height?.h ?? 54.h,
        width: width?.w ?? double.infinity,
        decoration: BoxDecoration(
          color: isOutlined ? whiteColor : buttonColor,
          border: Border.all(color: buttonColor),
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        child: Row(
          mainAxisAlignment: prefixIcon != null
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 16.w),
                child: ImageUtils.imageUtilsInstance.showSVGIcon(prefixIcon!,
                    color: applycolor!
                        ? (isOutlined ? buttonColor : whiteColor)
                        : null),
              ),
            if (snapshot.connectionState == ConnectionState.waiting)
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  height: 30.h,
                  width: 30.h,
                  child: CircularProgressIndicator(
                    color: isOutlined ? buttonColor : whiteColor,
                    strokeWidth: 1.5,
                  ),
                ),
              ),
            if (snapshot.connectionState != ConnectionState.waiting)
              // 10.horizontalSpace,
              Text(label,
                  style: titleStyle ??
                      montserrat(
                          16,
                          textColor ?? (isOutlined ? buttonColor : whiteColor),
                          FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
