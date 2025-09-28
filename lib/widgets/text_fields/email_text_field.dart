import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';

class EmailTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String titleText;
  final int maxlines;
  final int? maxlength;
  final TextInputType inputType;
  final String? icon;
  final TextStyle? textFieldTextStyle;

  const EmailTextField({
    super.key,
    required this.controller,
    required this.titleText,
    this.maxlines = 1,
    this.maxlength,
    this.textFieldTextStyle,
    this.inputType = TextInputType.emailAddress,
    this.icon,
  });

  @override
  ConsumerState<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends ConsumerState<EmailTextField> {
  @override
  Widget build(BuildContext context) {
    final emailValidityNotifier = ref.watch(emailValidityNotifierProvider);

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
            valueListenable: emailValidityNotifier,
            builder: (context, isValid, child) {
              return TextFormField(
                controller: widget.controller,
                maxLines: widget.maxlines,
                maxLength: widget.maxlength,
                onChanged: (value) {
                  ref
                      .read(emailValidityNotifierProvider.notifier)
                      .validateEmail(value);
                },
                cursorColor: accentPurple,
                keyboardType: widget.inputType,
                style: montserrat(14, grey36, FontWeight.w500),
                decoration: inputDecoration.copyWith(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 5.w),
                    child: SvgPicture.asset(
                      AppIcons.emailIcon,
                      // color: accentPurple,
                      // color: accentGold,
                      height: 24.h,
                    ),
                  ),
                  hintText: widget.titleText,

                  // suffixIcon: !isValid
                  //     ? SizedBox(width: 15.w)
                  //     : Padding(
                  //         padding: const EdgeInsetsDirectional.only(
                  //             start: 15, end: 15),
                  //         child: ImageUtils.imageUtilsInstance
                  //             .showSVGIcon(AppIcons.tick, height: 14.h),
                  //       ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
