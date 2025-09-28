import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/widgets/section_header.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/utils/rtl_helper.dart';
import 'package:semester_student_ride_app/providers/current_user_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/models/review_model.dart';
import 'package:semester_student_ride_app/providers/user_provider.dart';
import 'package:intl/intl.dart';

class DriverSettingsView extends HookConsumerWidget {
  DriverSettingsView({super.key});

  // MARK: - Keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  // Helper method to get initials from name
  String _getInitials(String name) {
    if (name.isEmpty) return 'D';

    List<String> names = name.trim().split(' ');
    if (names.length == 1) {
      return names[0][0].toUpperCase();
    } else {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }
  }

  // MARK: - UI Component Methods
  Widget _buildProfileSection(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final currentUserAsync = ref.watch(currentUserDetailsProvider);

        return currentUserAsync.when(
          data: (user) {
            return SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: whiteColor, width: 2),
                            color: greyA0A,
                          ),
                          child: user?.profilePicture != null &&
                                  user!.profilePicture!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    user.profilePicture!,
                                    width: 70.w,
                                    height: 70.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 70.w,
                                        height: 70.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accentPurple,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _getInitials(user.name),
                                            style: montserrat(24, whiteColor,
                                                FontWeight.w600),
                                          ),
                                        ),
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 70.w,
                                        height: 70.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[300],
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: greyA0A,
                                            strokeWidth: 2,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    _getInitials(user?.name ?? 'D'),
                                    style: montserrat(
                                        24, whiteColor, FontWeight.w600),
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              // context.push('/edit_profile');
                            },
                            child: Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                color: accentPurple,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: whiteColor,
                                size: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  15.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name
                      Text(
                        user?.name ?? 'Driver',
                        style: montserrat(16, grey36, FontWeight.w500),
                      ),
                      5.verticalSpace,

                      // User email
                      Text(
                        user?.email ?? 'email@example.com',
                        style: montserrat(14, grey5F63, FontWeight.w400),
                      ),
                      5.verticalSpace,

                      // Phone number
                      Text(
                        user?.phoneNumber ?? '+966 00 000 0000',
                        style: montserrat(14, grey5F63, FontWeight.w400),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          loading: () => SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: whiteColor, width: 2),
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: accentPurple,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    5.verticalSpace,
                    Container(
                      width: 200.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    5.verticalSpace,
                    Container(
                      width: 120.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          error: (error, stack) => SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: whiteColor, width: 2),
                    color: accentPurple,
                  ),
                  child: Center(
                    child: Text(
                      'D',
                      style: montserrat(24, whiteColor, FontWeight.w600),
                    ),
                  ),
                ),
                15.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver',
                      style: montserrat(16, grey36, FontWeight.w500),
                    ),
                    5.verticalSpace,
                    Text(
                      'email@example.com',
                      style: montserrat(14, grey5F63, FontWeight.w400),
                    ),
                    5.verticalSpace,
                    Text(
                      '+966 00 000 0000',
                      style: montserrat(14, grey5F63, FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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

  // MARK: - Content Building Methods
  Widget _buildSettingsContent(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          trailingText: l10n.english,
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
        _buildNewSettingItem(
          icon: AppIcons.serviceType,
          title: 'Service Availability',
          hasSwitch: false,
          onTap: () => context.push('/service_availability'),
        ),

        15.verticalSpace,
        _buildNewSettingItem(
          icon: AppIcons.logout,
          title: l10n.logout,
          hasSwitch: false,
          textColor: Color(0xFF940000),
          onTap: () => _signOut(ref, context),
        ),
      ],
    );
  }

  Widget _buildReviewContent(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        final currentUserAsync = ref.watch(currentUserDetailsProvider);

        return currentUserAsync.when(
          data: (user) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: l10n.reviewsRatings,
                  isDark: true,
                ),
                20.verticalSpace,

                // Overall rating section
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: containerbackground,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 22.sp,
                                color: Colors.amber,
                              ),
                              5.horizontalSpace,
                              Text(
                                (user?.averageRating ?? 0.0).toStringAsFixed(1),
                                style: montserrat(18, grey36, FontWeight.w600),
                              ),
                              5.horizontalSpace,
                            ],
                          ),
                          3.verticalSpace,
                          Text(
                            l10n.overallRating,
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${user?.totalReviews ?? 0}',
                            style: montserrat(18, grey36, FontWeight.w600),
                          ),
                          3.verticalSpace,
                          Text(
                            l10n.totalReviews,
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                20.verticalSpace,

                // Recent reviews
                SectionHeader(
                  title: l10n.recentReviews,
                  isDark: true,
                ),
                10.verticalSpace,

                // Show message if no reviews yet
                if ((user?.totalReviews ?? 0) == 0) ...[
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: containerbackground,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star_border,
                          size: 48.sp,
                          color: Colors.grey[400],
                        ),
                        10.verticalSpace,
                        Text(
                          'No reviews yet',
                          style: montserrat(16, grey36, FontWeight.w500),
                        ),
                        5.verticalSpace,
                        Text(
                          'Complete trips to start receiving reviews from passengers',
                          style: montserrat(14, grey5F63, FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Show real reviews from Firebase
                  Consumer(
                    builder: (context, ref, child) {
                      final reviewsAsync =
                          ref.watch(driverReviewsProvider(user?.id ?? ''));

                      return reviewsAsync.when(
                        data: (reviews) {
                          if (reviews.isEmpty) {
                            return Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: containerbackground,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.star_border,
                                    size: 48.sp,
                                    color: Colors.grey[400],
                                  ),
                                  10.verticalSpace,
                                  Text(
                                    'No reviews yet',
                                    style:
                                        montserrat(16, grey36, FontWeight.w500),
                                  ),
                                  5.verticalSpace,
                                  Text(
                                    'Complete trips to start receiving reviews from passengers',
                                    style: montserrat(
                                        14, grey5F63, FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show actual reviews
                          return Column(
                            children: reviews.take(10).map((review) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: _buildRealReviewItem(review),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => Column(
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: 15.h),
                              child: _buildReviewLoadingItem(),
                            ),
                          ),
                        ),
                        error: (error, stack) => Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: containerbackground,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48.sp,
                                color: Colors.red[400],
                              ),
                              10.verticalSpace,
                              Text(
                                'Error loading reviews',
                                style: montserrat(16, grey36, FontWeight.w500),
                              ),
                              5.verticalSpace,
                              Text(
                                'Please try again later',
                                style:
                                    montserrat(14, grey5F63, FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],

                20.verticalSpace,
              ],
            );
          },
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: l10n.reviewsRatings,
                isDark: true,
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: containerbackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 22.sp,
                              color: Colors.amber,
                            ),
                            5.horizontalSpace,
                            Container(
                              width: 40.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            5.horizontalSpace,
                          ],
                        ),
                        3.verticalSpace,
                        Text(
                          l10n.overallRating,
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 30.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        3.verticalSpace,
                        Text(
                          l10n.totalReviews,
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
            ],
          ),
          error: (error, stack) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: l10n.reviewsRatings,
                isDark: true,
              ),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: containerbackground,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 22.sp,
                              color: Colors.amber,
                            ),
                            5.horizontalSpace,
                            Text(
                              '0.0',
                              style: montserrat(18, grey36, FontWeight.w600),
                            ),
                            5.horizontalSpace,
                          ],
                        ),
                        3.verticalSpace,
                        Text(
                          l10n.overallRating,
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '0',
                          style: montserrat(18, grey36, FontWeight.w600),
                        ),
                        3.verticalSpace,
                        Text(
                          l10n.totalReviews,
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget _buildRealReviewItem(ReviewModel review) {
    final reviewDate = review.createdAt;
    final formattedDate = reviewDate != null
        ? DateFormat('MMM dd, yyyy').format(reviewDate)
        : 'Unknown date';

    return Consumer(
      builder: (context, ref, child) {
        // Get passenger details using the passenger ID
        final passengerAsync = ref.watch(userByIdProvider(review.passengerId));

        return passengerAsync.when(
          data: (passenger) {
            final passengerName = passenger?.name ?? 'Anonymous User';

            return Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: containerbackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: accentPurple,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(passengerName),
                            style:
                                montserrat(14, Colors.white, FontWeight.w600),
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              passengerName,
                              style: montserrat(14, grey36, FontWeight.w600),
                            ),
                            2.verticalSpace,
                            Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) => Icon(
                                      index < review.overallRating.toInt()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: accentPurple,
                                      size: 16.sp,
                                    ),
                                  ),
                                ),
                                5.horizontalSpace,
                                Text(
                                  formattedDate,
                                  style:
                                      montserrat(12, grey5F63, FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (review.reviewText?.isNotEmpty == true) ...[
                    10.verticalSpace,
                    Text(
                      review.reviewText!,
                      style: montserrat(14, grey36, FontWeight.w400),
                    ),
                  ],
                ],
              ),
            );
          },
          loading: () => _buildReviewLoadingItem(),
          error: (error, stack) => Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Anonymous User',
                            style: montserrat(14, grey36, FontWeight.w600),
                          ),
                          2.verticalSpace,
                          Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < review.overallRating.toInt()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: accentPurple,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                formattedDate,
                                style:
                                    montserrat(12, grey5F63, FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (review.reviewText?.isNotEmpty == true) ...[
                  10.verticalSpace,
                  Text(
                    review.reviewText!,
                    style: montserrat(14, grey36, FontWeight.w400),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewLoadingItem() {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: containerbackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    5.verticalSpace,
                    Container(
                      height: 12.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Container(
            height: 14.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          5.verticalSpace,
          Container(
            height: 14.h,
            width: 200.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  // MARK: - Main Build Method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Replace userDetailsProvider with userDetailsStreamProvider for real-time updates

    // State for toggling between Settings and Review
    final selectedView = useState<String>('settings');

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
          Column(
            children: [
              140.verticalSpace,
              Container(
                margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with profile info
                    _buildProfileSection(context, ref),

                    // Toggle buttons for Settings and Review
                    20.verticalSpace,
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: accentPurple,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: accentPurple, width: 1),
                      ),
                      child: Row(
                        children: [
                          // "Settings" toggle button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectedView.value = 'settings',
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: selectedView.value == 'settings'
                                      ? accentPurple
                                      : whiteColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: context.isRTL
                                        ? Radius.zero
                                        : Radius.circular(24),
                                    bottomLeft: context.isRTL
                                        ? Radius.zero
                                        : Radius.circular(24),
                                    topRight: context.isRTL
                                        ? Radius.circular(24)
                                        : Radius.zero,
                                    bottomRight: context.isRTL
                                        ? Radius.circular(24)
                                        : Radius.zero,
                                  ),
                                  border: Border(
                                    right: context.isRTL
                                        ? BorderSide.none
                                        : BorderSide(
                                            color: accentPurple, width: 1),
                                    left: context.isRTL
                                        ? BorderSide(
                                            color: accentPurple, width: 1)
                                        : BorderSide.none,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  l10n.settings,
                                  style: montserrat(
                                    13,
                                    selectedView.value == 'settings'
                                        ? whiteColor
                                        : accentPurple,
                                    FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // "Review" toggle button
                          Expanded(
                            child: GestureDetector(
                              onTap: () => selectedView.value = 'review',
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: selectedView.value == 'review'
                                      ? accentPurple
                                      : whiteColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: context.isRTL
                                        ? Radius.zero
                                        : Radius.circular(24),
                                    bottomRight: context.isRTL
                                        ? Radius.zero
                                        : Radius.circular(24),
                                    topLeft: context.isRTL
                                        ? Radius.circular(24)
                                        : Radius.zero,
                                    bottomLeft: context.isRTL
                                        ? Radius.circular(24)
                                        : Radius.zero,
                                  ),
                                  border: Border(
                                    left: context.isRTL
                                        ? BorderSide.none
                                        : BorderSide(
                                            color: accentPurple, width: 1),
                                    right: context.isRTL
                                        ? BorderSide(
                                            color: accentPurple, width: 1)
                                        : BorderSide.none,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  l10n.review,
                                  style: montserrat(
                                    13,
                                    selectedView.value == 'review'
                                        ? whiteColor
                                        : accentPurple,
                                    FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    10.verticalSpace,
                  ],
                ),
              ),

              // Content area based on selected view
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 20.h),
                  padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: SingleChildScrollView(
                    child: selectedView.value == 'settings'
                        ? _buildSettingsContent(context, ref)
                        : _buildReviewContent(context, ref),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
