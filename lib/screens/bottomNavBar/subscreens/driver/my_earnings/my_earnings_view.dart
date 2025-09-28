import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/chatroom.dart';
import 'package:semester_student_ride_app/models/message.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/utils/dialogs/loading_dialog.dart';
import 'package:semester_student_ride_app/widgets/circular_profile_image.dart';
import 'package:semester_student_ride_app/widgets/section_header.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

// Dummy data for the UI
class DummyMessage {
  final String name;
  final String message;
  final String time;
  final String profileImage;
  final bool isTyping;

  DummyMessage({
    required this.name,
    required this.message,
    required this.time,
    required this.profileImage,
    this.isTyping = false,
  });
}

class MyEarningsView extends HookConsumerWidget {
  const MyEarningsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Stats card widget for driver dashboard
    Widget buildInfoCard(
        String title, String value, String subtitle, String icon) {
      return Container(
        width: 181.w,
        height: 63.h,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: containerbackground,
          borderRadius: BorderRadius.circular(10.r),
          // border: Border.all(
          //   color: Colors.white.withOpacity(0.2),
          //   width: 1,
          // ),
        ),
        child: Row(
          children: [
            10.horizontalSpace,
            Container(
              width: 34.h,
              height: 34.h,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  icon,
                  height: 20.h,
                ),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: montserrat(
                      12,
                      grey5E5E5E,
                      FontWeight.w400,
                    ),
                  ),
                  4.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: montserrat(
                          16,
                          grey36,
                          FontWeight.w500,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        5.horizontalSpace,
                        Text(
                          subtitle,
                          style: montserrat(
                            10,
                            grey5F63,
                            FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: accentPurple,
      // appBar: CustomAppBar(
      //   title: 'Inbox',
      //   showSearchBar: true,
      //   searchHint: 'Search',
      //   onSearchTap: () {
      //     // Handle search tap
      //     developer.log('Search tapped');
      //   },
      // ),
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
                  l10n.myEarnings,
                  style: montserrat(18, whiteColor, FontWeight.w600),
                ),

                70.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: containerbackground,
                    height: 750.h,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 100.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Total Earnings and Withdraw Cards
                  Row(
                    children: [
                      // Total Earning Card
                      Expanded(
                        child: buildInfoCard(
                          l10n.totalEarnings,
                          '1573',
                          l10n.sar,
                          AppIcons.totalEarnings,
                        ),
                      ),
                      16.horizontalSpace,
                      // Withdraw Card
                      Expanded(
                        child: buildInfoCard(
                          l10n.withdraw,
                          '1573',
                          l10n.sar,
                          AppIcons.withdraw,
                        ),
                      ),
                    ],
                  ),

                  24.verticalSpace,

                  // Bookings Earning Section
                  SectionHeader(
                    title: l10n.bookingsEarning,
                    isDark: true,
                  ),
                  20.verticalSpace,

                  // Bookings List
                  ...List.generate(12, (index) {
                    final amounts = [
                      800.0,
                      120.0,
                      300.0,
                      600.0,
                      360.0,
                      300.0,
                      600.0,
                      360.0,
                      500.0,
                      300.0,
                      600.0,
                      360.0
                    ];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: containerbackground,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${l10n.orderNumber} 124929',
                                style: montserrat(14, grey36, FontWeight.w400),
                              ),
                              4.verticalSpace,
                              Text(
                                '02-07-2025',
                                style:
                                    montserrat(12, grey5F63, FontWeight.w400),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${amounts[index].toInt()}.0',
                                style: montserrat(
                                    16, accentPurple, FontWeight.w400),
                              ),
                              8.horizontalSpace,
                              Text(
                                l10n.sar,
                                style:
                                    montserrat(12, grey5F63, FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
