import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/config/app_images.dart';
import 'package:semester_student_ride_app/utils/image_utils.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';

class PasswordTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String titleText;
  final int maxlines;
  final int? maxlength;
  final TextInputType inputType;
  final String? icon;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.titleText,
    this.maxlines = 1,
    this.maxlength,
    this.inputType = TextInputType.text,
    this.icon,
  });

  @override
  ConsumerState<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends ConsumerState<PasswordTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisibilityNotifier =
        ref.watch(passwordVisibilityNotifierProvider);

    // Check if the current locale is RTL
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    InputDecoration inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      prefixIconConstraints: const BoxConstraints(maxHeight: 20),
      suffixIconConstraints: const BoxConstraints(maxHeight: 30),
      counterText: "",
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
          height: 48.h,
          child: ValueListenableBuilder<bool>(
            valueListenable: passwordVisibilityNotifier,
            builder: (context, isObscure, child) {
              return TextFormField(
                controller: widget.controller,
                maxLines: widget.maxlines,
                maxLength: widget.maxlength,
                obscureText: isObscure,
                obscuringCharacter: ".",
                cursorColor: accentPurple,
                keyboardType: widget.inputType,
                style: montserrat(14, grey36, FontWeight.w500),
                decoration: inputDecoration.copyWith(
                  prefixIcon: Padding(
                    padding: isRTL
                        ? EdgeInsets.only(right: 10.w, left: 5.w)
                        : EdgeInsets.only(left: 10.w, right: 5.w),
                    child: SvgPicture.asset(
                      AppIcons.password,
                      // color: accentGold,
                      // color: iconPurple,

                      height: 24.h,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: isRTL
                        ? EdgeInsets.only(left: 15.w)
                        : EdgeInsets.only(right: 15.w),
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(passwordVisibilityNotifierProvider.notifier)
                            .toggleVisibility();
                      },
                      child: SvgPicture.asset(
                        AppIcons.eye,
                        color: isObscure ? null : iconPurple,
                        height: 24.h,
                      ),
                    ),
                  ),
                  hintText: widget.titleText,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
