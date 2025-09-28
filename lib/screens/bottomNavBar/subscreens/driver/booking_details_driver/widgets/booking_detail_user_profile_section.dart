import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingDetailUserProfileSection extends StatelessWidget {
  final RequestBookingModel booking;

  const BookingDetailUserProfileSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final userId = booking.userId;

    if (userId == null || userId.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: containerbackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            'User information not available',
            style: montserrat(14, grey5F63, FontWeight.w400),
          ),
        ),
      );
    }

    // Use FutureBuilder to fetch user details by ID
    return FutureBuilder<UserSignupModel?>(
      future: _getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(accentPurple),
                ),
                16.horizontalSpace,
                Text(
                  'Loading user details...',
                  style: montserrat(14, grey5F63, FontWeight.w400),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 20.sp),
                16.horizontalSpace,
                Expanded(
                  child: Text(
                    'Error loading user details: ${snapshot.error}',
                    style: montserrat(14, Colors.red, FontWeight.w400),
                  ),
                ),
              ],
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                CircularProfileImage(
                  imageUrl: 'https://via.placeholder.com/150',
                  radius: 25,
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User not found',
                        style: montserrat(16, grey36, FontWeight.w600),
                      ),
                      4.verticalSpace,
                      Text(
                        userId,
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: containerbackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              CircularProfileImage(
                imageUrl:
                    user.profilePicture ?? 'https://via.placeholder.com/150',
                radius: 25,
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: montserrat(16, grey36, FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    4.verticalSpace,
                    Text(
                      user.email,
                      style: montserrat(11, grey5F63, FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    4.verticalSpace,
                    Text(
                      user.phoneNumber,
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to fetch user details by ID
  Future<UserSignupModel?> _getUserById(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return UserSignupModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error fetching user by ID: $e');
      return null;
    }
  }
}
