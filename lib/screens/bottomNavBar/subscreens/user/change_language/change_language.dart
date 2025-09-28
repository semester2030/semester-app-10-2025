import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class ChangeLanguage extends HookConsumerWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageNotifier = ref.read(languageNotifierProvider.notifier);
    final currentLocale = ref.watch(languageNotifierProvider);
    final selectedLanguage = useState<String>(currentLocale.languageCode);
    final l10n = AppLocalizations.of(context)!;

    return ScreenWithTopAppbar(
        title: l10n.language,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.fromLTRB(24.w, 170.h, 24.w, 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.changeLanguage,
                    style: montserrat(18, grey36, FontWeight.w600),
                  ),
                  24.verticalSpace,

                  // Language Options
                  _buildLanguageCard(
                    language: l10n.english,
                    languageCode: 'EN',
                    icon: AppIcons.english,
                    isSelected: selectedLanguage.value == 'en',
                    onTap: () => selectedLanguage.value = 'en',
                  ),

                  20.verticalSpace,

                  // Arabic Option
                  _buildLanguageCard(
                    language: l10n.arabic,
                    languageCode: 'AR',
                    icon: AppIcons.arabic,
                    isSelected: selectedLanguage.value == 'ar',
                    onTap: () => selectedLanguage.value = 'ar',
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
              child: NormalCustomButton(
                  label: l10n.saveLanguage,
                  syncCallback: () async {
                    // Save the selected language
                    try {
                      // Clear any existing SnackBars first
                      ScaffoldMessenger.of(context).clearSnackBars();

                      await languageNotifier
                          .changeLanguage(selectedLanguage.value);
                      if (context.mounted) {
                        // Show success message with unique key
                        showSuccessFlushBar(
                            message: l10n.languageChangedSuccessfully,
                            context: context);

                        // Add a small delay before navigating back to allow the language change to process
                        await Future.delayed(Duration(milliseconds: 500));
                        if (context.mounted) {
                          context.pop();
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        // Clear any existing SnackBars first
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            key: ValueKey(
                                'language_error_${DateTime.now().millisecondsSinceEpoch}'),
                            content: Text(l10n.error),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  }),
            ),
          ],
        ));
  }

  Widget _buildLanguageCard({
    required String language,
    required String languageCode,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        // Check if the current locale is RTL
        final isRTL = Directionality.of(context) == TextDirection.rtl;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentPurple.withOpacity(0.08)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected ? accentPurple : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentPurple.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Flag/Icon
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentPurple.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? accentPurple.withOpacity(0.2)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      height: 24.sp,
                      color: isSelected ? accentPurple : Colors.grey.shade600,
                    ),
                  ),
                ),

                // Dynamic spacing based on RTL
                SizedBox(width: isRTL ? 8.w : 16.w),

                // Language Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: isRTL
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        language,
                        style: montserrat(
                          16,
                          isSelected ? accentPurple : grey36,
                          FontWeight.w600,
                        ),
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                      4.verticalSpace,
                      Text(
                        languageCode,
                        style: montserrat(
                          12,
                          isSelected
                              ? accentPurple.withOpacity(0.7)
                              : grey36.withOpacity(0.6),
                          FontWeight.w400,
                        ),
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),

                // Dynamic spacing for selection indicator
                SizedBox(width: isRTL ? 16.w : 8.w),

                // Selection Indicator
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: isSelected ? accentPurple : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? accentPurple : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
