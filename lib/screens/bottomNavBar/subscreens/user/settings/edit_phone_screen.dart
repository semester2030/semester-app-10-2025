import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';

class EditPhoneScreen extends HookConsumerWidget {
  const EditPhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final phoneController = useTextEditingController();
    final isLoading = useState<bool>(false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background with curve
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CircularTopClipper(),
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accentPurple, accentPurple.withOpacity(0.8)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Vehicle icons
                    Positioned(
                      top: 20.h,
                      left: 20.w,
                      child: Icon(Icons.directions_car, color: Colors.white.withOpacity(0.3), size: 30.sp),
                    ),
                    Positioned(
                      top: 40.h,
                      right: 30.w,
                      child: Icon(Icons.motorcycle, color: Colors.white.withOpacity(0.3), size: 25.sp),
                    ),
                    Positioned(
                      top: 60.h,
                      left: 50.w,
                      child: Icon(Icons.train, color: Colors.white.withOpacity(0.3), size: 28.sp),
                    ),
                    Positioned(
                      top: 80.h,
                      right: 20.w,
                      child: Icon(Icons.directions_bus, color: Colors.white.withOpacity(0.3), size: 26.sp),
                    ),
                    // Title
                    Positioned(
                      top: 100.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          l10n.changePhoneNumber,
                          style: montserrat(24, Colors.white, FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Positioned(
            top: 150.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 40.h),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Current phone info
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            color: accentPurple,
                            size: 48.sp,
                          ),
                          16.verticalSpace,
                          Text(
                            l10n.currentPhoneNumber,
                            style: montserrat(16, grey36, FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          8.verticalSpace,
                          Text(
                            '+966 50 123 4567', // Placeholder - will be replaced with real data
                            style: montserrat(18, accentPurple, FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    30.verticalSpace,
                    // New phone input
                    CustomTextField(
                      controller: phoneController,
                      titleText: l10n.newPhoneNumber,
                      hintText: l10n.enterNewPhoneNumber,
                    ),
                    20.verticalSpace,
                    // Info text
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: accentPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: accentPurple.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: accentPurple, size: 20.sp),
                          12.horizontalSpace,
                          Expanded(
                            child: Text(
                              l10n.phoneChangeInfo,
                              style: montserrat(14, grey5F63, FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    40.verticalSpace,
                    // Update button
                    NormalCustomButton(
                      label: l10n.updatePhoneNumber,
                      onPressed: () async {
                        if (phoneController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.pleaseEnterPhoneNumber),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        
                        isLoading.value = true;
                        
                        // Simulate API call
                        await Future.delayed(Duration(seconds: 2));
                        
                        isLoading.value = false;
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.phoneUpdatedSuccessfully),
                            backgroundColor: Colors.green,
                          ),
                        );
                        
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
