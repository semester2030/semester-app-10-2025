import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    void handleBackNavigation(BuildContext context) {
      try {
        // Check if we can pop the current route
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          // If we can't pop, navigate to the bottom navigation bar
          GoRouter.of(context).go('/bottom_nav_bar');
        }
      } catch (e) {
        // If there's any error, safely navigate to bottom nav bar
        try {
          GoRouter.of(context).go('/bottom_nav_bar');
        } catch (routerError) {
          // As a last resort, try using the extension method
          context.go('/bottom_nav_bar');
        }
      }
    }

    return GestureDetector(
      onTap: () => handleBackNavigation(context),
      child: SvgPicture.asset(AppIcons.back),
    );

    // GestureDetector(
    //     onTap: () => context.pop(),
    //     child: GestureDetector(
    //       onTap: () => context.pop(),
    //       child: Container(
    //         height: 31.h,
    //         width: 31.h,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5),
    //           color: color ?? black,
    //         ),
    //         alignment: Alignment.center,
    //         child: Icon(Icons.arrow_back,
    //             color: color != null ? black : accentGold),
    //       ),
    //     ));
  }
  // }
}
