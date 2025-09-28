import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/utils/dialogs/error_dialogue.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/widgets/heading_container.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class HelpSupportView extends HookConsumerWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    Widget buildFAQItem({required String question, required String answer}) {
      final isExpanded = useState(false);

      return Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                isExpanded.value = !isExpanded.value;
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: montserrat(14, grey36, FontWeight.w500),
                      ),
                    ),
                    // Icon(
                    //   isExpanded.value ? Icons.expand_less : Icons.expand_more,
                    //   color: accentPurple,
                    //   size: 20,
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
              child: Text(
                answer,
                style: montserrat(14, grey36, FontWeight.w400),
              ),
            ),
          ],
        ),
      );
    }

    return ScreenWithTopAppbar(
      title: l10n.helpSupport,
      child: Container(
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
              // FAQ Section
              buildFAQItem(
                question: l10n.howCanIBookTrip,
                answer: l10n.bookTripAnswer,
              ),
              16.verticalSpace,

              buildFAQItem(
                question: l10n.howCanIPay,
                answer: l10n.paymentMethodsAnswer,
              ),
              16.verticalSpace,

              buildFAQItem(
                question: l10n.howContactCustomerService,
                answer: l10n.contactServiceAnswer,
              ),
              16.verticalSpace,

              buildFAQItem(
                question: l10n.howCancelRide,
                answer: l10n.cancelRideAnswer,
              ),
              16.verticalSpace,

              buildFAQItem(
                question: l10n.whatSafetyMeasures,
                answer: l10n.safetyMeasuresAnswer,
              ),
              16.verticalSpace,

              buildFAQItem(
                question: l10n.howReportIssue,
                answer: l10n.reportIssueAnswer,
              ),
              32.verticalSpace,

              // Contact Information Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: accentPurple.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.needMoreHelp,
                      style: montserrat(14, grey36, FontWeight.w500),
                    ),
                    12.verticalSpace,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.phoneIcon,
                          width: 20.w,
                          height: 20.h,
                        ),
                        8.horizontalSpace,
                        Text(
                          l10n.phoneContact,
                          style: montserrat(14, grey36, FontWeight.w500),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.emailIcon,
                          width: 20.w,
                          height: 20.h,
                        ),
                        8.horizontalSpace,
                        Text(
                          l10n.emailContact,
                          style: montserrat(14, grey36, FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
