import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/config/app_images.dart';
import 'package:semester_student_ride_app/utils/image_utils.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';
import 'package:shimmer/shimmer.dart';

Widget catagoryListShimmer(BuildContext context) {
  return SizedBox(
    height: 45.h,
    width: MediaQuery.of(context).size.width,
    child: ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        width: 16.w,
      ),
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: whiteColor,
        direction: ShimmerDirection.ltr,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          width: 99.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 10,
                offset:
                    const Offset(0, 1), // changes the position of the shadow
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget mallListShimmer(BuildContext context) {
  return SizedBox(
    height: 95.h,
    width: MediaQuery.of(context).size.width,
    child: ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        width: 23.w,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 6,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: whiteColor,
        direction: ShimmerDirection.ltr,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          width: 73.h,
          height: 73.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset:
                    const Offset(0, 1), // changes the position of the shadow
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget productsListShimmer(
  BuildContext context, {
  bool isFavoritesList = false,
  bool isMyItem = false,
}) {
  return SizedBox(
    height: isFavoritesList ? 132.h : 142.h,
    width: MediaQuery.of(context).size.width,
    child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
              width: 23.w,
            ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: whiteColor,
              direction: ShimmerDirection.ltr,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  width: isFavoritesList ? 132.w : 152.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(
                            0, 1), // changes the position of the shadow
                      ),
                    ],
                  )),
            )),
  );
}

Widget subscriptionPlansListShimmer(BuildContext context) {
  return Expanded(
    child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => SizedBox(
              height: 32.w,
            ),
        itemCount: 6,
        itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: whiteColor,
              direction: ShimmerDirection.ltr,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  height: 200.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(
                            0, 1), // changes the position of the shadow
                      ),
                    ],
                  )),
            )),
  );
}

Widget businessListShimmer(BuildContext context, {bool ismyBusiness = false}) {
  return SizedBox(
    height: 132.h,
    width: MediaQuery.of(context).size.width,
    child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
              width: 42.w,
            ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: whiteColor,
              direction: ShimmerDirection.ltr,
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  width: 132.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(
                            0, 1), // changes the position of the shadow
                      ),
                    ],
                  )),
            )),
  );
}

Widget productWrapShimmer({
  bool isFavoritesList = false,
  bool isMyItem = false,
}) {
  return Wrap(spacing: 30.w, children: [
    for (int i = 0; i < 10; i++)
      Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: whiteColor,
        direction: ShimmerDirection.ltr,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            width: isFavoritesList ? 132.w : 152.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset:
                      const Offset(0, 1), // changes the position of the shadow
                ),
              ],
            )),
      )
  ]);
}

Widget cartItemListShimmer(BuildContext context) {
  return Expanded(
      child: ListView.builder(
    itemCount: 7,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: whiteColor,
      direction: ShimmerDirection.ltr,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          width: 387.w,
          height: 95.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 10,
                offset:
                    const Offset(0, 1), // changes the position of the shadow
              ),
            ],
          )),
    ),
  ));
}
