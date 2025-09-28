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

class NewSettingsView extends HookConsumerWidget {
  NewSettingsView({super.key});

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
            l10n.logoutConfirmation,
            style: montserrat(14, Colors.black87, FontWeight.w400),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                l10n.cancel,
                style: montserrat(14, Colors.grey, FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _handleLogout(ref, context);
              },
              child: Text(
                l10n.logout,
                style: montserrat(14, Colors.red, FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout(WidgetRef ref, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/main_role_selection');
      }
    } catch (e) {
      log('Error during logout: $e');
      if (context.mounted) {
        showErrorFlushBar(
          message: 'Error occurred during logout',
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: accentPurple,
      body: SafeArea(
        child: Stack(
          children: [
            // Background SVG
            SvgPicture.asset(
              AppImages.splashbackgroundSVG,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                // Top spacing
                50.verticalSpace,
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Text(
                          l10n.settings,
                          style: montserrat(24, Colors.white, FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                // Main content
                Expanded(
                  child: ClipPath(
                    clipper: CircularTopClipper(),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 40.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile Section
                              _buildProfileSection(context, l10n),
                              30.verticalSpace,

                              // Account Settings
                              _buildSectionTitle(l10n.accountSettings),
                              20.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.phone_outlined,
                                title: l10n.changePhoneNumber,
                                subtitle: l10n.changePhoneNumberSubtitle,
                                onTap: () => context.push('/edit_phone'),
                              ),
                              15.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.location_on_outlined,
                                title: l10n.changeAddress,
                                subtitle: l10n.changeAddressSubtitle,
                                onTap: () => context.push('/edit_address'),
                              ),
                              30.verticalSpace,

                              // App Settings
                              _buildSectionTitle(l10n.appSettings),
                              20.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.palette_outlined,
                                title: l10n.appearance,
                                subtitle: l10n.appearanceSubtitle,
                                trailing: Switch(
                                  value: false, // You can manage this state
                                  onChanged: (value) {
                                    // Handle theme change
                                  },
                                  activeColor: accentPurple,
                                ),
                                onTap: () {},
                              ),
                              15.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.language_outlined,
                                title: l10n.language,
                                subtitle: currentLocale.languageCode == 'ar' 
                                    ? l10n.arabic 
                                    : l10n.english,
                                onTap: () => context.push('/change_language'),
                              ),
                              15.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.location_on_outlined,
                                title: l10n.locationSettings,
                                subtitle: l10n.locationSettingsSubtitle,
                                onTap: () => context.push('/profile'),
                              ),
                              30.verticalSpace,

                              // Payment & Security
                              _buildSectionTitle(l10n.paymentSecurity),
                              20.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.lock_outline,
                                title: l10n.changePassword,
                                subtitle: l10n.changePasswordSubtitle,
                                onTap: () => context.push('/change_password'),
                              ),
                              15.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.security_outlined,
                                title: l10n.privacySettings,
                                subtitle: l10n.privacySettingsSubtitle,
                                onTap: () => context.push('/profile'),
                              ),
                              30.verticalSpace,

                              // Support & Help
                              _buildSectionTitle(l10n.supportHelp),
                              20.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.info_outline,
                                title: l10n.aboutApp,
                                subtitle: l10n.aboutAppSubtitle,
                                onTap: () => context.push('/profile'),
                              ),
                              15.verticalSpace,
                              _buildSettingItem(
                                icon: Icons.rate_review_outlined,
                                title: l10n.rateApp,
                                subtitle: l10n.rateAppSubtitle,
                                onTap: () {
                                  // Handle app rating
                                },
                              ),
                              30.verticalSpace,

                              // Logout Button
                              _buildLogoutButton(context, ref, l10n),
                              20.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppLocalizations l10n) {
    return Container(
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
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentPurple, width: 2),
                ),
                child: _buildDefaultAvatar(),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: accentPurple,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          // User Info
          Column(
            children: [
              Text(
                l10n.user,
                style: montserrat(20, grey36, FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              Text(
                l10n.loading,
                style: montserrat(14, grey5F63, FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          16.verticalSpace,
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                icon: Icons.directions_car,
                label: l10n.trips,
                value: '0',
                onTap: () => context.push('/profile'),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: grey5F63.withOpacity(0.3),
              ),
              _buildStatItem(
                icon: Icons.star,
                label: l10n.rating,
                value: '4.8',
                onTap: () => context.push('/reviews'),
              ),
              Container(
                width: 1,
                height: 40.h,
                color: grey5F63.withOpacity(0.3),
              ),
              _buildStatItem(
                icon: Icons.phone,
                label: l10n.contact,
                value: '',
                onTap: () => context.push('/contact_support'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        'U',
        style: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.w600,
          color: accentPurple,
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: accentPurple,
            size: 24.sp,
          ),
          8.verticalSpace,
          Text(
            value,
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          4.verticalSpace,
          Text(
            label,
            style: montserrat(12, grey5F63, FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: montserrat(18, grey36, FontWeight.w600),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: grey5F63.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: accentPurple,
                size: 20.sp,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: montserrat(16, grey36, FontWeight.w500),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              16.horizontalSpace,
              trailing,
            ] else ...[
              8.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios,
                color: grey5F63.withOpacity(0.5),
                size: 16.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _showLogoutConfirmationDialog(ref, context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
              size: 20.sp,
            ),
            12.horizontalSpace,
            Text(
              l10n.logout,
              style: montserrat(16, Colors.red, FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
