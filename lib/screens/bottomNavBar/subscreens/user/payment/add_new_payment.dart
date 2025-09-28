import 'dart:developer';
import 'dart:io';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/app_dialogs.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

/// A view that displays subscription options for the app
class AddNewPayment extends HookConsumerWidget {
  const AddNewPayment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // State variables
    var cardNumberController = useTextEditingController();
    var expiryDateController = useTextEditingController();
    var cvvController = useTextEditingController();
    var cardholderNameController = useTextEditingController();

    // Fetch current subscription info when the view loads

    return ScreenWithTopAppbar(
      title: l10n.payment,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 160.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saved Cards Section
                Text(l10n.selectNewPaymentMethod,
                    style: montserrat(18, grey36, FontWeight.w600)),
                SizedBox(height: 16.h),

                // Saved Card Item
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accentPurple,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Mastercard icon with overlapping circles
                      Image.asset(
                        AppImages.masterCard,
                        height: 30,
                      ),
                      SizedBox(width: 16.w),
                      Text(l10n.masterCard,
                          style: montserrat(14, grey36, FontWeight.w500)),
                      Spacer(),
                      SvgPicture.asset(AppIcons.successCheck, height: 20.h)
                    ],
                  ),
                ),

                25.verticalSpace,
                CustomTextField(
                    controller: cardholderNameController,
                    titleText: l10n.cardHolderName),
                15.verticalSpace,
                CustomTextField(
                  controller: cardNumberController,
                  titleText: l10n.cardNumber,
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      controller: expiryDateController,
                      width: 200,
                      titleText: l10n.expiryDate,
                    ),
                    CustomTextField(
                      controller: cvvController,
                      width: 130,
                      titleText: l10n.cvv,
                    ),
                  ],
                ),
                50.verticalSpace,

                // Google Pay
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.google,
                        width: 25.h,
                        height: 25.h,
                      ),
                      SizedBox(width: 16.w),
                      Text(l10n.googlePay,
                          style: montserrat(14, grey36, FontWeight.w500)),
                    ],
                  ),
                ),
                20.verticalSpace,
                // Apple Pay
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.apple,
                        width: 25.h,
                        height: 25.h,
                      ),
                      SizedBox(width: 16.w),
                      Text(l10n.applePay,
                          style: montserrat(14, grey36, FontWeight.w500)),
                    ],
                  ),
                ),
                20.verticalSpace,
                // PayPal
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.paypal,
                        width: 25.h,
                        height: 25.h,
                      ),
                      SizedBox(width: 16.w),
                      Text(l10n.paypal,
                          style: montserrat(14, grey36, FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            )),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
            child: NormalCustomButton(
              label: l10n.proceedToPayment,
              onPressed: () => context.push('/payment'),
            ),
          )
        ],
      ),
    );
  }
}
