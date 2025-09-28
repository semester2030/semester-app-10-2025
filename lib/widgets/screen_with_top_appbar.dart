import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';

import '../semester_student_ride_app_imports.dart';

class ScreenWithTopAppbar extends StatelessWidget {
  const ScreenWithTopAppbar(
      {super.key, required this.child, required this.title});

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    // Check if the current locale is RTL
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top spacing
                50.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button positioning based on RTL
                    if (!isRTL) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: BackBtn(),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: montserrat(18, whiteColor, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                          width: 44.w), // Match back button width for centering
                    ] else ...[
                      Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: BackBtn(),
                      ),
                      // RTL layout: title on left, back button on right
                      // SizedBox(
                      //     width: 44.w), // Match back button width for centering
                      Expanded(
                        child: Text(
                          title,
                          style: montserrat(18, whiteColor, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),

                30.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: containerbackground,
                    height: MediaQuery.of(context).size.height * 0.9,
                  ),
                ),
              ],
            ),
          ),
          child
        ],
      ),
    );
  }
}
