import '../../../semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _WidgetState();
}

class _WidgetState extends ConsumerState<Splash>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
    
    // الحل الجذري: إجبار الانتقال بعد 3 ثوان
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // التحقق من حالة المستخدم
        final authState = ref.read(currentAuthStateProvider);
        if (authState == AuthState.authenticated) {
          context.go('/bottom_nav_bar');
        } else {
          context.go('/main_role_selection');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          // Background SVG

          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Top-right language toggle
          Positioned(
            top: 40.h,
            right: 16.w,
            child: _LanguageToggle(ref: ref),
          ),
          // Centered logo
          Center(
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: Image.asset(
                AppImages.logo,
                width: 350.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageToggle extends HookConsumerWidget {
  const _LanguageToggle({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(languageNotifierProvider);
    final notifier = ref.read(languageNotifierProvider.notifier);
    final isArabic = current.languageCode.toLowerCase() == 'ar';

    return Material(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: () async {
          final next = isArabic ? const Locale('en') : const Locale('ar');
          await notifier.changeLanguage(next.languageCode);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(Icons.language, color: Colors.white, size: 16.sp),
              6.horizontalSpace,
              Text(isArabic ? 'عربي' : 'EN', style: montserrat(12, Colors.white, FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
