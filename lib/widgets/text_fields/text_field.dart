import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String titleText;
  final String? hintText;
  final bool isEmailField;
  final bool isPhoneField;
  final int maxlines;
  final double width;
  final int? maxlength;
  final int space;
  final TextStyle? titleTextStyle;
  final TextStyle? textFieldTextStyle;
  final bool isFilterField;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final List<TextInputFormatter>? inputFormatter;
  final double height;
  final TextInputType inputType;
  final String? icon;
  final bool? isOptional;
  final bool? applyBorder;
  final bool isDatePicker;
  final String? errorText;
  final bool onlydate;
  final bool onlyTime; // New property for time picker
  final double? letterSpacing;
  final int? maxDays; // New parameter for custom date limit
  final FocusNode? focusNode; // Add FocusNode parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.titleText,
    this.isEmailField = false,
    this.isPhoneField = false,
    this.hintText,
    this.maxlines = 1,
    this.width = double.infinity,
    this.maxlength,
    this.space = 5,
    this.titleTextStyle,
    this.textFieldTextStyle,
    this.isFilterField = false,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatter,
    this.height = 50,
    this.isOptional = false,
    this.inputType = TextInputType.text,
    this.icon,
    this.letterSpacing,
    this.applyBorder = false,
    this.isDatePicker = false, // Default is false
    this.errorText,
    this.onlydate = false, // New property, default false
    this.maxDays, // Add the maxDays parameter
    this.focusNode, // Add it to the constructor
    this.onlyTime = false, // New property for time picker
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();

    // If this is a phone field, set up the phone controller
    if (widget.isPhoneField) {
      // Initialize with +971 prefix if needed
      if (!widget.controller.text.startsWith('+971')) {
        if (widget.controller.text.isEmpty) {
          widget.controller.text = '+971';
        } else {
          // Remove any existing +971 prefix to avoid duplication
          final phoneText =
              widget.controller.text.replaceAll('+971', '').trim();
          widget.controller.text = '+971$phoneText';
        }
      }

      // Format any existing value
      _formatPhoneNumber(widget.controller.text);
    }
  }

  // Format Dubai phone number without spaces
  void _formatPhoneNumber(String value) {
    if (!widget.isPhoneField) return;

    // Remove any non-digit characters except the + sign at the beginning
    String digitsOnly = value.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure it starts with +971
    if (!digitsOnly.startsWith('+971')) {
      digitsOnly = '+971${digitsOnly.replaceAll('+971', '')}';
    }

    // Update the controller value if it's different
    if (widget.controller.text != digitsOnly) {
      // Store the current cursor position
      final currentPosition = widget.controller.selection.baseOffset;

      // Count the difference in length
      final lengthDiff = digitsOnly.length - widget.controller.text.length;

      // Update the text
      widget.controller.text = digitsOnly;

      // Try to maintain cursor position
      if (currentPosition >= 0) {
        int newPosition = currentPosition + lengthDiff;
        if (newPosition > digitsOnly.length) newPosition = digitsOnly.length;
        if (newPosition < 0) newPosition = 0;

        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: newPosition),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // Use widget.maxDays if provided, otherwise use the default values
    final int daysLimit = widget.maxDays ?? (widget.onlydate ? 100 : 7);

    if (widget.onlydate) {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime.now(),
        theme: DatePickerTheme(
            itemHeight: 50.h,
            backgroundColor: accentPurple,
            cancelStyle: montserrat(14, whiteColor, FontWeight.w500),
            doneStyle: montserrat(14, whiteColor, FontWeight.w500),
            itemStyle: montserrat(14, whiteColor, FontWeight.w500)),
        maxTime: DateTime.now().add(Duration(days: daysLimit)),
        onConfirm: (date) {
          widget.controller.text =
              DateFormat('yyyy-MM-dd').format(date.toLocal());
        },
        currentTime: DateTime.now(),
      );
    } else if (widget.onlyTime) {
      DatePicker.showTime12hPicker(
        context,
        showTitleActions: true,
        theme: DatePickerTheme(
            itemHeight: 50.h,
            backgroundColor: accentPurple,
            cancelStyle: montserrat(14, whiteColor, FontWeight.w500),
            doneStyle: montserrat(14, whiteColor, FontWeight.w500),
            itemStyle: montserrat(14, whiteColor, FontWeight.w500)),
        onConfirm: (date) {
          widget.controller.text = DateFormat('h:mm a').format(date.toLocal());
        },
        currentTime: DateTime.now(),
      );
    } else {
      DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        minTime: DateTime.now(),
        theme: DatePickerTheme(
            itemHeight: 50.h,
            backgroundColor: accentPurple,
            cancelStyle: montserrat(14, whiteColor, FontWeight.w500),
            doneStyle: montserrat(14, whiteColor, FontWeight.w500),
            itemStyle: montserrat(14, whiteColor, FontWeight.w500)),
        maxTime: DateTime.now().add(Duration(days: daysLimit)),
        onChanged: (date) {},
        onConfirm: (date) {
          widget.controller.text =
              DateFormat('yyyy-MM-dd  hh:mm a').format(date.toLocal());
        },
        currentTime: DateTime.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      prefixIconConstraints: const BoxConstraints(maxHeight: 20),
      suffixIconConstraints: const BoxConstraints(maxHeight: 30),
      counterText: "",
      filled: true,
      fillColor: whiteColor,
      hintStyle: montserrat(14, greyA0A, FontWeight.w500),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
            color: borderGrey, width: 1), // Replace with `textfieldBorder`
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: borderGrey), // Replace with `textfieldBorder`
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      border: const OutlineInputBorder(
        borderSide:
            BorderSide(color: borderGrey), // Replace with `textfieldBorder`
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: (widget.height *
                  (widget.maxlines > 1 ? (widget.maxlines / 2) : 1))
              .h,
          width: widget.width.w,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode, // Use the focus node here
            maxLines: widget.maxlines,
            maxLength: widget.maxlength,
            cursorColor: accentPurple,
            keyboardType:
                widget.isPhoneField ? TextInputType.phone : widget.inputType,
            style: montserrat(14, grey36, FontWeight.w500),
            decoration: inputDecoration.copyWith(
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 5.w),
                      child: SvgPicture.asset(
                        widget.prefixIcon!,
                        color: accentPurple,
                        // color: accentPurple,
                        height: 24.h,
                      ),
                    )
                  : null,
              hintText: widget.hintText ?? widget.titleText,
              errorText: widget.errorText,
            ),
            readOnly: widget.isDatePicker,
            onTap: widget.isDatePicker ? () => _selectDate(context) : null,
            onChanged: widget.isPhoneField
                ? (value) => _formatPhoneNumber(value)
                : null,
            inputFormatters: widget.isPhoneField
                ? [
                    // Allow only digits for phone field (the formatting function handles the rest)
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]')),
                  ]
                : widget.inputFormatter,
          ),
        ),
      ],
    );
  }
}
