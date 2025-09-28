import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ImageUtils {
  static final ImageUtils _imageUtils = ImageUtils();

  static ImageUtils get imageUtilsInstance => _imageUtils;

  Widget showSVGIcon(
    String image, {
    double padding = 0,
    double height = 25,
    double width = 25,
    double progressIndicatorSize = 5,
    Color? color,
    Color progressIndicatorColor = colorBackground,
    bool ofWidth = false,
    bool staticDim = false,
    BoxFit fit = BoxFit.contain,
    bool showProgressIndicator = false,
  }) {
    return Padding(
      padding: EdgeInsets.all(
        padding,
      ),
      child: SvgPicture.asset(
        image,
        fit: fit,
        height: (staticDim) ? height : height.h,
        width: (staticDim) ? width : width.h,
        color: color,
        placeholderBuilder: (BuildContext context) => (showProgressIndicator)
            ? SizedBox(
                height: progressIndicatorSize.h,
                width: progressIndicatorSize.h,
                child: CircularProgressIndicator(
                  color: progressIndicatorColor,
                  strokeWidth: progressIndicatorSize / 2.5,
                ))
            : const SizedBox(),
      ),
    );
  }

  Widget showSVGImage(String image,
      {double padding = 0,
      double height = 100,
      double width = 100,
      double progressIndicatorSize = 11,
      Color progressIndicatorColor = colorBackground,
      bool ofWidth = false,
      BoxFit fit = BoxFit.contain,
      Color? color}) {
    return Padding(
      padding: EdgeInsets.all(
        padding,
      ),
      child: SvgPicture.asset(
        image,
        fit: fit,
        height: height.h,
        width: width.w,
        placeholderBuilder: (BuildContext context) => Center(
          child: SizedBox(
              height: progressIndicatorSize.h,
              width: progressIndicatorSize.h,
              child: CircularProgressIndicator(
                color: progressIndicatorColor,
                strokeWidth: progressIndicatorSize / 2.5,
              )),
        ),
      ),
    );
  }

  shimmerGradient() {
    return LinearGradient(
      colors: [Colors.white, Colors.grey[300]!, Colors.white],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// Creates a CachedNetworkImage with consistent error handling and loading states
  Widget cachedNetworkImageWithFallback({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    IconData errorIcon = Icons.broken_image,
    Color errorIconColor = Colors.grey,
    Color loadingColor = Colors.grey,
    Color backgroundColor = Colors.transparent,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            color: backgroundColor,
            child: Center(
              child: CircularProgressIndicator(
                color: loadingColor,
                strokeWidth: 2,
              ),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: backgroundColor,
            child: Center(
              child: Icon(
                errorIcon,
                color: errorIconColor,
                size: width < height ? width * 0.3 : height * 0.3,
              ),
            ),
          ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Creates a profile image with consistent error handling
  Widget profileImageWithFallback({
    required String? imageUrl,
    required double radius,
    Color backgroundColor = Colors.grey,
    Color errorIconColor = Colors.white,
    Widget? errorWidget,
    Widget? loadingWidget,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: errorWidget ??
            Icon(
              Icons.person,
              color: errorIconColor,
              size: radius,
            ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return errorWidget ??
                Icon(
                  Icons.person,
                  color: errorIconColor,
                  size: radius,
                );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return loadingWidget ??
                Center(
                  child: CircularProgressIndicator(
                    color: errorIconColor,
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
          },
        ),
      ),
    );
  }

  /// Creates an Image.network with consistent error handling
  Widget networkImageWithFallback({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    IconData errorIcon = Icons.broken_image,
    Color errorIconColor = Colors.grey,
    Color backgroundColor = Colors.transparent,
    BorderRadius? borderRadius,
    Widget? errorWidget,
    Widget? loadingWidget,
  }) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: backgroundColor,
              child: Center(
                child: Icon(
                  errorIcon,
                  color: errorIconColor,
                  size: width < height ? width * 0.3 : height * 0.3,
                ),
              ),
            );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return loadingWidget ??
            Container(
              width: width,
              height: height,
              color: backgroundColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: errorIconColor,
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
