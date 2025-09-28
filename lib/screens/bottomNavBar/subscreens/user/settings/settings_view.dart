import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/providers/current_user_provider.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/providers/completed_trips_provider.dart';

class SettingsView extends HookConsumerWidget {
  SettingsView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // MARK: - Account Management Methods
  Future<void> _showLogoutConfirmationDialog(
      WidgetRef ref, BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            l10n.logout,
            style: montserrat(18, Colors.black, FontWeight.w600),
          ),
          content: Text(
            "Are you sure you want to sign out?",
            style: montserrat(14, Colors.black87, FontWeight.w400),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: montserrat(14, Colors.grey, FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(ref, context);
              },
              child: Text(
                l10n.logout,
                style: montserrat(14, Color(0xFF940000), FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(WidgetRef ref, BuildContext context) async {
    try {
      // Show loading indicator
      showSuccessFlushBar(message: "Signing out...", context: context);
      await FirebaseAuth.instance.signOut();
      ref.invalidate(currentAuthStateProvider);
    } catch (e) {
      log('Error signing out: $e');
      showErrorFlushBar(message: 'Error signing out: $e', context: context);
    }
  }

  // MARK: - UI Component Methods
  Widget _buildProfileSection(BuildContext context, AppLocalizations l10n,
      UserSignupModel? currentUser, int completedTripsCount) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Profile picture with edit button

          // User name
          Text(
            currentUser?.name ?? 'Loading...',
            style: montserrat(22, grey36, FontWeight.w500),
          ),
          5.verticalSpace,

          // User email
          Text(
            currentUser?.email ?? 'Loading...',
            style: montserrat(14, grey5F63, FontWeight.w400),
          ),
          10.verticalSpace,

          // Trip count badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: accentPurple,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              l10n.tripCount(completedTripsCount),
              style: montserrat(12, whiteColor, FontWeight.w400),
            ),
          ),
          10.verticalSpace,
          Divider(),
          10.verticalSpace,
          // Phone number
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 36.h,
                  width: 36.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightPurple,
                  ),
                  child: Center(child: SvgPicture.asset(AppIcons.phoneIcon))),
              10.horizontalSpace,
              Text(
                currentUser?.phoneNumber ?? 'Loading...',
                style: montserrat(16, grey36, FontWeight.w400),
              ),
            ],
          ),

          // Location
          currentUser?.district == null
              ? Container() // Hide if district is not set
              : Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: 36.h,
                          width: 36.h,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: lightPurple,
                          ),
                          child: Center(
                              child: SvgPicture.asset(AppIcons.district))),
                      10.horizontalSpace,
                      Text(
                        currentUser?.district ?? 'Not specified',
                        style: montserrat(16, grey36, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLoadingProfileSection(
      BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // User name - loading shimmer
          Container(
            width: 200.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          5.verticalSpace,

          // User email - loading shimmer
          Container(
            width: 150.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          10.verticalSpace,

          // Trip count badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Loading...',
              style: montserrat(12, Colors.grey[600]!, FontWeight.w400),
            ),
          ),
          10.verticalSpace,
          Divider(),
          10.verticalSpace,
          // Phone number
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 36.h,
                  width: 36.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightPurple,
                  ),
                  child: Center(child: SvgPicture.asset(AppIcons.phoneIcon))),
              10.horizontalSpace,
              Container(
                width: 120.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          15.verticalSpace,

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 36.h,
                  width: 36.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightPurple,
                  ),
                  child: Center(child: SvgPicture.asset(AppIcons.district))),
              10.horizontalSpace,
              Container(
                width: 180.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorProfileSection(
      BuildContext context, AppLocalizations l10n, String error) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red,
          ),
          10.verticalSpace,
          Text(
            'Error loading profile',
            style: montserrat(18, Colors.red, FontWeight.w500),
          ),
          5.verticalSpace,
          Text(
            'Please try again later',
            style: montserrat(14, grey5F63, FontWeight.w400),
          ),
          20.verticalSpace,
          Divider(),
        ],
      ),
    );
  }

  Widget _buildNewSettingItem({
    required String icon,
    required String title,
    required bool hasSwitch,
    bool switchValue = false,
    String? trailingText,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: hasSwitch ? null : onTap,
      child: Row(
        children: [
          Container(
              height: 36.h,
              width: 36.h,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lightPurple,
              ),
              child: Center(
                  child: SvgPicture.asset(
                icon,
                color: textColor,
              ))),
          15.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: montserrat(16, textColor ?? grey36, FontWeight.w400),
            ),
          ),
          if (hasSwitch)
            SvgPicture.asset(
              AppIcons.switchIcon,
              width: 24.w,
              height: 24.h,
              color: switchValue ? accentPurple : grey36,
            )
          // Uncomment the following lines if you want to use a Switch widget instead of an icon
          // Switch(
          //   value: switchValue,
          //   onChanged: (value) => onTap(),
          //   activeColor: whiteColor,
          //   activeTrackColor: accentPurple,
          //   inactiveThumbColor: whiteColor,
          //   inactiveTrackColor: Colors.grey[300],
          //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // )
          else if (trailingText != null)
            Text(
              trailingText,
              style: montserrat(14, Color(0xFF6B3FA0), FontWeight.w500),
            )
          else
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: grey36,
            ),
        ],
      ),
    );
  }

  // MARK: - Main Build Method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(languageNotifierProvider);
    final currentUserAsync = ref.watch(currentUserDetailsProvider);
    final completedTripsAsync = ref.watch(completedTripsCountProvider);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: accentPurple, // Purple background
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
                Text(
                  l10n.myProfile,
                  style: montserrat(18, whiteColor, FontWeight.w600),
                ),

                120.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: containerbackground,
                    height: MediaQuery.of(context).size.height * 0.8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 140.h, 24.w, 20.h),
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with profile info
                  60.verticalSpace,
                  // Combine both async providers
                  currentUserAsync.when(
                    data: (currentUser) => completedTripsAsync.when(
                      data: (completedTripsCount) => _buildProfileSection(
                          context, l10n, currentUser, completedTripsCount),
                      loading: () => _buildLoadingProfileSection(context, l10n),
                      error: (error, stack) => _buildErrorProfileSection(
                          context, l10n, error.toString()),
                    ),
                    loading: () => _buildLoadingProfileSection(context, l10n),
                    error: (error, stack) => _buildErrorProfileSection(
                        context, l10n, error.toString()),
                  ),

                  // Settings title
                  10.verticalSpace,
                  Divider(),
                  10.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.setting,
                      style: montserrat(20, grey36, FontWeight.w500),
                    ),
                  ),
                  20.verticalSpace,

                  // Settings items
                  _buildNewSettingItem(
                    icon: AppIcons.payment,
                    title: l10n.payment,
                    hasSwitch: false,
                    onTap: () => context.push('/payment'),
                  ),
                  15.verticalSpace,

                  _buildNewSettingItem(
                    icon: AppIcons.appearance,
                    title: l10n.appearance,
                    hasSwitch: true,
                    switchValue: true, // You can manage this state
                    onTap: () {
                      // Handle appearance toggle
                    },
                  ),
                  15.verticalSpace,

                  _buildNewSettingItem(
                    icon: AppIcons.notificationBell,
                    title: l10n.notifications,
                    hasSwitch: true,
                    switchValue: true, // You can manage this state
                    onTap: () {
                      // Handle notifications toggle
                    },
                  ),
                  15.verticalSpace,

                  _buildNewSettingItem(
                    icon: AppIcons.changeLanguage,
                    title: l10n.language,
                    hasSwitch: false,
                    trailingText: currentLocale.languageCode == 'ar'
                        ? l10n.arabic
                        : l10n.english,
                    onTap: () {
                      // Handle language change
                      context.push('/change_language');
                    },
                  ),
                  15.verticalSpace,

                  _buildNewSettingItem(
                    icon: AppIcons.help,
                    title: l10n.helpSupport,
                    hasSwitch: false,
                    onTap: () => context.push('/help_support'),
                  ),
                  15.verticalSpace,

                  _buildNewSettingItem(
                    icon: AppIcons.password,
                    title: l10n.changePassword,
                    hasSwitch: false,
                    onTap: () => context.push('/change_password'),
                  ),
                  15.verticalSpace,

                  // _buildNewSettingItem(
                  //   icon: AppIcons.delete,
                  //   title: 'Delete Account',
                  //   hasSwitch: false,
                  //   textColor: Color(0xFF940000),
                  //   onTap: () => _showDeleteAccountDialog(context),
                  // ),

                  // 15.verticalSpace,
                  _buildNewSettingItem(
                    icon: AppIcons.logout,
                    title: l10n.logout,
                    hasSwitch: false,
                    textColor: Color(0xFF940000),
                    onTap: () => _showLogoutConfirmationDialog(ref, context),
                  ),
                  15.verticalSpace,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: Stack(
                children: [
                  currentUserAsync.when(
                    data: (currentUser) {
                      // Helper function to get user initials
                      String getUserInitials(String? name) {
                        if (name == null || name.trim().isEmpty) {
                          return 'U'; // Default to 'U' for User
                        }

                        List<String> nameParts = name.trim().split(' ');
                        if (nameParts.length == 1) {
                          return nameParts[0][0].toUpperCase();
                        } else {
                          return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
                              .toUpperCase();
                        }
                      }

                      return Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: accentPurple, width: 2),
                          color: (currentUser?.profilePicture == null ||
                                  currentUser!.profilePicture!.isEmpty)
                              ? Colors.white
                              : null,
                          image: (currentUser?.profilePicture != null &&
                                  currentUser!.profilePicture!.isNotEmpty)
                              ? DecorationImage(
                                  image:
                                      NetworkImage(currentUser.profilePicture!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (currentUser?.profilePicture == null ||
                                currentUser!.profilePicture!.isEmpty)
                            ? Center(
                                child: Text(
                                  getUserInitials(currentUser?.name),
                                  style: montserrat(
                                      24, accentPurple, FontWeight.w600),
                                ),
                              )
                            : null,
                      );
                    },
                    loading: () => Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: whiteColor, width: 2),
                          color: Colors.grey[300]),
                      child: Icon(Icons.person,
                          size: 60.sp, color: Colors.grey[600]),
                    ),
                    error: (error, stack) => Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: whiteColor, width: 2),
                          color: Colors.white),
                      child: Center(
                        child: Text(
                          'U',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600,
                            color: accentPurple,
                          ),
                        ),
                      ),
                    ),
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
          )
        ],
      ),
    );
  }
}
