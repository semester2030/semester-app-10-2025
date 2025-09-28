import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class EditProfileDriver extends HookConsumerWidget {
  const EditProfileDriver({super.key});

  // Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentPurple.withOpacity(0.1),
            accentPurple.withOpacity(0.05)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accentPurple.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentPurple, accentPurple.withOpacity(0.7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          12.horizontalSpace,
          Text(
            title,
            style: montserrat(16, accentPurple, FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Helper method to build error text consistently
  Widget _buildErrorText(String? errorText) {
    if (errorText == null) return const SizedBox();

    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 4.w),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              size: 16.sp, color: Colors.red.withOpacity(0.8)),
          8.horizontalSpace,
          Expanded(
            child: Text(
              errorText,
              style:
                  montserrat(12, Colors.red.withOpacity(0.8), FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Demo data - no actual user fetching
    var nameController = useTextEditingController(text: 'Ahmed Hassan');
    var emailController =
        useTextEditingController(text: 'ahmed.hassan@email.com');
    var phoneController = useTextEditingController(text: '+92 300 1234567');
    var vehicleModelController =
        useTextEditingController(text: 'Toyota Corolla 2020');
    var districtController =
        useTextEditingController(text: 'Gulshan-e-Iqbal, Karachi');
    var licenseController = useTextEditingController(text: 'ABC123456789');

    var serviceTypeController = useTextEditingController(text: l10n.fullTime);

    // State variables
    final selectedServiceType = useState<String>(l10n.fullTime);

    // Error states
    final serviceTypeError = useState<String?>(null);
    final licenseError = useState<String?>(null);

    // For keyboard scrolling
    final scrollController = useScrollController();
    final bioFocusNode = useFocusNode();

    // Listen to keyboard visibility and scroll to bio field when it has focus
    useEffect(() {
      void listener() {
        if (bioFocusNode.hasFocus) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }

      bioFocusNode.addListener(listener);
      return () => bioFocusNode.removeListener(listener);
    }, []);

    //

    return ScreenWithTopAppbar(
      title: l10n.editProfile,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            // Form container
            Container(
              margin: EdgeInsets.fromLTRB(24.w, 160.h, 24.w, 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: whiteColor, width: 2),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://img.freepik.com/free-photo/man-car-driving_23-2148889981.jpg?semt=ais_hybrid&w=740'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Positioned(
                            right: 5,
                            bottom: 10,
                            child: GestureDetector(
                              onTap: () {
                                // context.push('/edit_profile');
                              },
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  color: accentPurple,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: whiteColor,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    24.verticalSpace,

                    // Personal Information Section
                    _buildSectionHeader(l10n.personalInformation),
                    16.verticalSpace,

                    CustomTextField(
                      controller: nameController,
                      prefixIcon: AppIcons.userIcon,
                      titleText: l10n.fullName,
                      hintText: l10n.enterFullName,
                    ),
                    // _buildErrorText(signupState.nameError),

                    16.verticalSpace,
                    EmailTextField(
                      controller: emailController,
                      titleText: l10n.emailAddress,
                    ),
                    // _buildErrorText(signupState.emailError),

                    16.verticalSpace,
                    CustomTextField(
                      controller: phoneController,
                      prefixIcon: AppIcons.phoneIcon,
                      titleText: l10n.mobileNumber,
                      hintText: l10n.enterMobileNumber,
                    ),
                    // _buildErrorText(signupState.nameError),

                    24.verticalSpace,

                    // Vehicle Information Section
                    _buildSectionHeader(l10n.vehicleInformation),
                    16.verticalSpace,

                    CustomTextField(
                      controller: vehicleModelController,
                      prefixIcon: AppIcons.vehicleModel,
                      titleText: l10n.vehicleModel,
                      hintText: l10n.vehicleModelHint,
                    ),
                    // _buildErrorText(signupState.nameError),

                    16.verticalSpace,
                    CustomTextField(
                      controller: districtController,
                      prefixIcon: AppIcons.district,
                      titleText: l10n.serviceAddress,
                      hintText: l10n.enterServiceArea,
                    ),
                    // _buildErrorText(signupState.nameError),

                    16.verticalSpace,

                    // Enhanced Service Type Dropdown
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: accentPurple.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          AbsorbPointer(
                            child: CustomTextField(
                              controller: serviceTypeController,
                              prefixIcon: AppIcons.serviceType,
                              titleText: l10n.serviceType,
                              hintText: l10n.selectServiceType,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 12.w),
                                child: PopupMenuButton<String>(
                                  icon: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: accentPurple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Icon(Icons.keyboard_arrow_down,
                                        color: accentPurple, size: 20.sp),
                                  ),
                                  color: Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  onSelected: (String value) {
                                    serviceTypeController.text = value;
                                    selectedServiceType.value = value;
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: l10n.fullTime,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: accentPurple
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                              child: Icon(Icons.schedule,
                                                  color: accentPurple,
                                                  size: 16.sp),
                                            ),
                                            12.horizontalSpace,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(l10n.fullTime,
                                                    style: montserrat(
                                                        16,
                                                        grey36,
                                                        FontWeight.w600)),
                                                Text(l10n.hoursPerWeek,
                                                    style: montserrat(
                                                        12,
                                                        grey5F63,
                                                        FontWeight.w400)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: l10n.partTime,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(6.w),
                                              decoration: BoxDecoration(
                                                color: accentPurple
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                              child: Icon(Icons.access_time,
                                                  color: accentPurple,
                                                  size: 16.sp),
                                            ),
                                            12.horizontalSpace,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(l10n.partTime,
                                                    style: montserrat(
                                                        16,
                                                        grey36,
                                                        FontWeight.w600)),
                                                Text(l10n.flexibleHours,
                                                    style: montserrat(
                                                        12,
                                                        grey5F63,
                                                        FontWeight.w400)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildErrorText(serviceTypeError.value),

                    16.verticalSpace,

                    // License number
                    CustomTextField(
                      controller: licenseController,
                      prefixIcon: AppIcons.userIcon,
                      titleText: l10n.licenseNumber,
                      hintText: l10n.enterLicenseNumber,
                    ),
                    _buildErrorText(licenseError.value),

                    16.verticalSpace,

                    // Experience
                    // CustomTextField(
                    //   controller: experienceController,
                    //   prefixIcon: AppIcons.userIcon,
                    //   titleText: 'Experience',
                    //   hintText: 'Describe your driving experience',
                    //   maxlines: 3,
                    // ),

                    // 16.verticalSpace,

                    // // Bio
                    // CustomTextField(
                    //   controller: bioController,
                    //   focusNode: bioFocusNode,
                    //   prefixIcon: AppIcons.userIcon,
                    //   titleText: 'Bio',
                    //   hintText: 'Tell us about yourself',
                    //   maxlines: 5,
                    // ),

                    24.verticalSpace,

                    // Save button
                  ],
                ),
              ),
            ),

            1.verticalSpace,

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: NormalCustomButton(
                label: l10n.updateProfile,
                syncCallback: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
