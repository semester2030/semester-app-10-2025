import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class MapShimmerWidget extends StatelessWidget {
  const MapShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: black,
      child: Stack(
        children: [
          // Map background shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[900]!,
            highlightColor: Colors.grey[700]!,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
          ),

          // Map controls shimmer (top right corner)
          Positioned(
            top: 40,
            right: 10,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[700]!,
              child: Container(
                width: 150.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Map markers shimmer (scattered across the map)

          // Carousel at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[900]!,
              highlightColor: Colors.grey[700]!,
              child: Center(
                child: Container(
                  width: 300.w,
                  height: 130.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
