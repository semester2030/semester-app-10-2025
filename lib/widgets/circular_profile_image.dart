import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:shimmer/shimmer.dart';

// Replace this with your actual white color constant

// Replace this with your actual shimmer gradient method
Gradient shimmerGradient() {
  return const LinearGradient(
    colors: [Colors.grey, Colors.white, Colors.grey],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );
}

class CircularProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String? userId;
  final bool isClickable;

  const CircularProfileImage({
    super.key,
    required this.imageUrl,
    this.radius = 35,
    this.userId,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget profileImage = Container(
      decoration: BoxDecoration(
          color: whiteColor,
          shape: BoxShape.circle,
          border: Border.all(color: accentPurple)),
      child: ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(radius),
          child: imageUrl == null || imageUrl!.isEmpty
              ? const CircleAvatar(child: Text("A"))
              : CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer(
                      gradient: shimmerGradient(),
                      child: CircleAvatar(radius: radius),
                    );
                  },
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.error)),
                ),
        ),
      ),
    );

    // If userId is provided and isClickable is true, make the image navigable
    if (userId != null && isClickable) {
      return GestureDetector(
        onTap: () {
          // Navigate to user profile detail view
          context.push('/user_profile_detail', extra: userId);
        },
        child: profileImage,
      );
    }

    // Otherwise, return just the image
    return profileImage;
  }
}
