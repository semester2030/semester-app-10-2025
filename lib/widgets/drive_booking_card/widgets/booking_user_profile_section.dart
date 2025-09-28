import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingUserProfileSection extends StatelessWidget {
  final RequestBookingModel booking;
  final UserSignupModel? userProfile;
  final AppLocalizations l10n;
  final bool isLoading;
  final bool isError;

  const BookingUserProfileSection({
    super.key,
    required this.booking,
    required this.userProfile,
    required this.l10n,
    this.isLoading = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // User Profile Image (Requester)
        _buildUserProfileInfo(userProfile, context),
        12.horizontalSpace,

        // User Details (Requester)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getUserDisplayName(),
                style: montserrat(14, grey36, FontWeight.w400),
              ),
              2.verticalSpace,
              Text(
                booking.serviceType.displayName,
                style: montserrat(10, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
        // Pricing info on the right
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              booking.finalPrice?.toStringAsFixed(2) ?? "0.00",
              style: montserrat(14, grey36, FontWeight.w400),
            ),
            2.verticalSpace,
            Text(
              l10n.pricing,
              style: montserrat(10, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserProfileInfo(UserSignupModel? user, BuildContext context) {
    if (isLoading) {
      // Loading state
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey[300],
        child: SizedBox(
          height: 15.h,
          width: 15.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: accentPurple,
          ),
        ),
      );
    }

    if (isError || user == null) {
      // Error state
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.person,
          size: 24.sp,
          color: Colors.grey[600],
        ),
      );
    }

    final displayName = user.name;

    if (user.profilePicture == null || user.profilePicture!.isEmpty) {
      // No profile picture - show initials
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: accentPurple,
        child: Text(
          _getInitials(displayName),
          style: montserrat(16, whiteColor, FontWeight.w600),
        ),
      );
    } else {
      // Show profile picture
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: accentPurple.withOpacity(0.1),
        backgroundImage: NetworkImage(user.profilePicture!),
      );
    }
  }

  String _getUserDisplayName() {
    if (isLoading) {
      return 'Loading user data...';
    }
    if (isError || userProfile == null) {
      return "Unknown User";
    }
    return userProfile!.name;
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "?";

    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      // Get first letter of first and last name
      return "${parts[0][0]}${parts[parts.length - 1][0]}".toUpperCase();
    } else if (parts.length == 1) {
      // Just get the first letter if only one name
      return parts[0][0].toUpperCase();
    } else {
      return "?";
    }
  }
}
