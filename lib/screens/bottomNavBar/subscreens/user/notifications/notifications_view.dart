import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class NotificationsView extends HookConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ScreenWithTopAppbar(
        title: l10n.notifications,
        child: Container(
            margin: EdgeInsets.fromLTRB(24.w, 160.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.today,
                          style: montserrat(18, grey36, FontWeight.w600)),
                      TextButton(
                        onPressed: () {
                          // Mark all as read functionality
                        },
                        child: Text(l10n.markAllRead,
                            style: montserrat(
                                14,
                                const Color.fromARGB(255, 36, 3, 85),
                                FontWeight.w500)),
                      ),
                    ],
                  ),
                  15.verticalSpace,

                  // Today's Notifications
                  _buildNotificationCard(
                    title: l10n.bookingUpdate,
                    description: l10n.rideRescheduledMessage('Fatima'),
                    time: '11:30 PM',
                  ),
                  16.verticalSpace,

                  _buildNotificationCard(
                    title: l10n.pickupLocation,
                    description: '456, Al Andalus Street, Jeddah',
                    time: '11:30 PM',
                  ),

                  20.verticalSpace,

                  // Yesterday Section
                  Text(l10n.yesterday,
                      style: montserrat(18, grey36, FontWeight.w600)),
                  20.verticalSpace,

                  // Yesterday's Notifications
                  _buildNotificationCard(
                    title: l10n.rideInProgress,
                    description: l10n.driverAwayMessage('Ahmed', '5'),
                    time: '11:30 PM',
                  ),
                  16.verticalSpace,

                  _buildNotificationCard(
                    title: l10n.rideCompleted,
                    description: l10n.rideEndedSuccessfullyMessage('Sara'),
                    time: '11:30 PM',
                    backgroundColor: const Color(0xFFE8F5E8),
                  ),
                ],
              ),
            )));
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
    Color? backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: backgroundColor ?? accentPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xFFD9D9D9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: montserrat(14, grey5E5E5E, FontWeight.w500)),
              8.verticalSpace,
              Text(
                description,
                style: montserrat(12, grey5E5E5E, FontWeight.w400),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Text(time, style: montserrat(12, grey5F63, FontWeight.w400)),
      ],
    );
  }
}
