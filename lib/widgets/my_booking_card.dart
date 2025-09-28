// import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
// import 'package:semester_student_ride_app/l10n/app_localizations.dart';

// class MyBookingCard extends StatelessWidget {
//   final BookingModel booking;
//   final VoidCallback? onTap;

//   const MyBookingCard({super.key, required this.booking, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap:
//           onTap ?? () => context.push('/booking_details_view', extra: booking),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         padding: EdgeInsets.all(14.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Top row with date and status
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _formatDate(booking.pickupTime),
//                   style: montserrat(12, grey36, FontWeight.w400),
//                 ),
//                 Container(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(booking.status),
//                     borderRadius: BorderRadius.circular(20.r),
//                   ),
//                   child: Text(
//                     _formatStatus(context, booking.status),
//                     style: montserrat(9, Colors.white, FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//             Divider(thickness: 1),
//             6.verticalSpace,
//             // Profile and details row
//             Row(
//               children: [
//                 // Profile Image
//                 CircleAvatar(
//                   radius: 20.r,
//                   backgroundColor: accentPurple.withOpacity(0.1),
//                   backgroundImage: NetworkImage(booking.driverPhoto),
//                 ),
//                 12.horizontalSpace,
//                 // Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         booking.driverName,
//                         style: montserrat(14, grey36, FontWeight.w400),
//                       ),
//                       2.verticalSpace,
//                       Text(
//                         _getRoleFromCategory(context, booking.category),
//                         style: montserrat(10, grey5F63, FontWeight.w400),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Car info on the right
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       booking.licensePlate,
//                       style: montserrat(14, grey36, FontWeight.w400),
//                     ),
//                     Text(
//                       booking.vehicleModel,
//                       style: montserrat(10, grey5F63, FontWeight.w400),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             7.verticalSpace,
//             Divider(),
//             8.verticalSpace,
//             // Location details with custom aligned icons
//             _buildLocationRow(),
//             12.verticalSpace,
//             // Action buttons based on status
//             _buildActionButtons(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationRow() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Custom location icons with dotted line
//         Column(
//           children: [
//             // Start location icon
//             SvgPicture.asset(AppIcons.locationAddress),
//             // Dotted line
//             SizedBox(
//               width: 2.w,
//               height: 20.h,
//               child: Column(
//                 children: List.generate(
//                   5,
//                   (index) => Container(
//                     width: 2.w,
//                     height: 2.h,
//                     margin: EdgeInsets.symmetric(vertical: 1.h),
//                     decoration: BoxDecoration(
//                       color: grey5F63,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // End location icon
//             SvgPicture.asset(AppIcons.locationAddress),
//           ],
//         ),
//         16.horizontalSpace,
//         // Location texts aligned with icons
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               5.verticalSpace,
//               // Pickup location - aligned with top circle
//               Container(
//                 height: 12.w, // Same height as the top circle
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   booking.pickupLocation,
//                   style: montserrat(12, grey36, FontWeight.w400),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               SizedBox(height: 20.h), // Same height as the dotted line
//               // Destination - aligned with bottom circle
//               Container(
//                 height: 12.w, // Same height as the bottom circle
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   booking.destination,
//                   style: montserrat(12, grey36, FontWeight.w400),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     final String status = booking.status.toLowerCase();
//     final bool hasReview = booking.userOverallRating != null;

//     // Build buttons based on booking status
//     List<Widget> actionButtons = [];

//     switch (status) {
//       case 'pending':
//         actionButtons = [
//           NormalCustomButton(
//             width: 155,
//             height: 40,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             label: AppLocalizations.of(context)!.editBooking,
//             syncCallback: () async {
//               // Navigate to edit booking screen
//               // context.push('/edit_booking', extra: booking);
//             },
//           ),
//           16.horizontalSpace,
//           NormalCustomButton(
//             label: AppLocalizations.of(context)!.cancelBooking,
//             width: 155,
//             height: 40,
//             buttonColor: Colors.red,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             syncCallback: () async {
//               context.push('/cancel_ride');
//               // Handle cancel booking
//               // Show confirmation dialog and handle cancellation
//             },
//           ),
//         ];
//         break;

//       case 'active':
//       case 'in_progress':
//         actionButtons = [
//           NormalCustomButton(
//             width: 155,
//             height: 40,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             label: AppLocalizations.of(context)!.contactDriver,
//             syncCallback: () async {
//               // Navigate to contact driver screen or show contact info
//               context.push('/chatting', extra: booking);
//             },
//           ),
//           16.horizontalSpace,
//           NormalCustomButton(
//             label: AppLocalizations.of(context)!.cancelBooking,
//             width: 155,
//             height: 40,
//             buttonColor: Colors.red,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             syncCallback: () async {
//               // Handle cancel booking
//               // Show confirmation dialog and handle cancellation
//               context.push('/cancel_ride');
//             },
//           ),
//         ];
//         break;

//       case 'completed':
//         actionButtons = [
//           // if (!hasReview)
//           NormalCustomButton(
//             width: 170,
//             height: 40,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             label: hasReview
//                 ? AppLocalizations.of(context)!.viewReview
//                 : AppLocalizations.of(context)!.addReview,
//             syncCallback: () async {
//               if (hasReview) {
//                 // Show review details or navigate to review screen
//                 // context.push('/view_review', extra: booking);
//               } else {
//                 // Navigate to add review screen
//                 // context.push('/add_review', extra: booking);
//               }
//             },
//           ),
//           16.horizontalSpace,
//           NormalCustomButton(
//             label: AppLocalizations.of(context)!.bookAgain,
//             width: 170,
//             height: 40,
//             buttonColor: Colors.blue,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             syncCallback: () async {
//               // Navigate to booking screen with pre-filled data
//               // context.push('/book_ride', extra: booking);
//             },
//           ),
//         ];
//         break;

//       case 'cancelled':
//         actionButtons = [
//           NormalCustomButton(
//             width: 180,
//             height: 40,
//             titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//             label: AppLocalizations.of(context)!.bookAgain,
//             syncCallback: () async {
//               // Navigate to booking screen with pre-filled data
//               // context.push('/book_ride', extra: booking);
//             },
//           ),
//           16.horizontalSpace,
//         ];
//         break;

//       default:
//         actionButtons = [
//           // NormalCustomButton(
//           //   width: 160,
//           //   height: 40,
//           //   titleStyle: montserrat(12, whiteColor, FontWeight.w500),
//           //   label: 'Contact Support',
//           //   syncCallback: () async {
//           //     // Navigate to support screen
//           //     // context.push('/support', extra: booking);
//           //   },
//           // ),
//         ];
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: actionButtons,
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'active':
//       case 'in_progress':
//         return accentPurple;
//       case 'pending':
//         return const Color(0xFFB08968);
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _formatDate(DateTime dateTime) {
//     const List<String> months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];

//     String month = months[dateTime.month - 1];
//     String day = dateTime.day.toString().padLeft(2, '0');
//     String year = dateTime.year.toString();

//     // Convert to 12-hour format with AM/PM
//     int hour = dateTime.hour;
//     String period = hour >= 12 ? 'PM' : 'AM';
//     if (hour > 12) {
//       hour -= 12;
//     } else if (hour == 0) {
//       hour = 12;
//     }

//     String formattedTime =
//         "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

//     return "$month $day, $year   $formattedTime";
//   }

//   String _formatStatus(BuildContext context, String status) {
//     switch (status.toLowerCase()) {
//       case 'in_progress':
//         return AppLocalizations.of(context)!.active;
//       case 'pending':
//         return AppLocalizations.of(context)!.pending;
//       case 'completed':
//         return AppLocalizations.of(context)!.completed;
//       case 'cancelled':
//         return AppLocalizations.of(context)!.cancelled;
//       default:
//         return status;
//     }
//   }

//   String _getRoleFromCategory(BuildContext context, String category) {
//     switch (category.toLowerCase()) {
//       case 'daily transportation':
//         return AppLocalizations.of(context)!.student;
//       case 'transportation for employees':
//         return AppLocalizations.of(context)!.employee;
//       default:
//         return AppLocalizations.of(context)!.user;
//     }
//   }
// }
