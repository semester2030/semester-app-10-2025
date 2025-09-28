import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class BookingHistoryEnhancedScreen extends HookConsumerWidget {
  const BookingHistoryEnhancedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final selectedFilter = useState<String>('all');
    final searchController = useTextEditingController();
    final bookings = useState<List<Map<String, dynamic>>>([]);

    // Mock bookings data
    useEffect(() {
      bookings.value = [
        {
          'id': '1',
          'status': 'completed',
          'pickupAddress': 'King Fahd Road, Riyadh',
          'destinationAddress': 'King Saud University, Riyadh',
          'serviceType': 'Student Transport',
          'vehicleType': 'Sedan',
          'driverName': 'Ahmed Al-Rashid',
          'driverRating': 4.8,
          'driverImage': 'https://randomuser.me/api/portraits/men/1.jpg',
          'date': '2024-01-15',
          'time': '08:30 AM',
          'fare': 25.0,
          'duration': '45 minutes',
          'distance': '12.5 km',
          'paymentMethod': 'Credit Card',
          'rating': 5,
          'review': 'Excellent service, very professional driver.',
        },
        {
          'id': '2',
          'status': 'cancelled',
          'pickupAddress': 'Al Olaya District, Riyadh',
          'destinationAddress': 'Riyadh Mall, Riyadh',
          'serviceType': 'Daily Transport',
          'vehicleType': 'SUV',
          'driverName': 'Fatima Al-Zahra',
          'driverRating': 4.6,
          'driverImage': 'https://randomuser.me/api/portraits/women/2.jpg',
          'date': '2024-01-14',
          'time': '02:15 PM',
          'fare': 18.0,
          'duration': '30 minutes',
          'distance': '8.2 km',
          'paymentMethod': 'Apple Pay',
          'rating': null,
          'review': null,
        },
        {
          'id': '3',
          'status': 'in_progress',
          'pickupAddress': 'Al Malaz District, Riyadh',
          'destinationAddress': 'King Khalid International Airport',
          'serviceType': 'Employee Transport',
          'vehicleType': 'Van',
          'driverName': 'Mohammed Al-Sheikh',
          'driverRating': 4.9,
          'driverImage': 'https://randomuser.me/api/portraits/men/3.jpg',
          'date': '2024-01-16',
          'time': '10:00 AM',
          'fare': 45.0,
          'duration': '60 minutes',
          'distance': '25.3 km',
          'paymentMethod': 'Google Pay',
          'rating': null,
          'review': null,
        },
        {
          'id': '4',
          'status': 'scheduled',
          'pickupAddress': 'Al Nakheel District, Riyadh',
          'destinationAddress': 'Riyadh Business District',
          'serviceType': 'Teacher Transport',
          'vehicleType': 'Sedan',
          'driverName': 'Sara Al-Mansouri',
          'driverRating': 4.7,
          'driverImage': 'https://randomuser.me/api/portraits/women/4.jpg',
          'date': '2024-01-17',
          'time': '07:00 AM',
          'fare': 22.0,
          'duration': '35 minutes',
          'distance': '15.1 km',
          'paymentMethod': 'Credit Card',
          'rating': null,
          'review': null,
        },
      ];
      return null;
    }, []);

    // Filter bookings
    final filteredBookings = bookings.value.where((booking) {
      final matchesFilter = selectedFilter.value == 'all' || booking['status'] == selectedFilter.value;
      final matchesSearch = searchController.text.isEmpty ||
          booking['pickupAddress'].toLowerCase().contains(searchController.text.toLowerCase()) ||
          booking['destinationAddress'].toLowerCase().contains(searchController.text.toLowerCase()) ||
          booking['driverName'].toLowerCase().contains(searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();


    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setting),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.grey[50],
            child: Column(
              children: [
                CustomTextField(
                  controller: searchController,
                  titleText: l10n.search,
                  hintText: l10n.search,
                  prefixIcon: AppIcons.searchIcon,
                ),
                16.verticalSpace,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(l10n.all, 'all', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip(l10n.completed, 'completed', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip(l10n.inProgress, 'in_progress', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip(l10n.personalInformation, 'scheduled', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip(l10n.cancel, 'cancelled', selectedFilter.value),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: filteredBookings.isEmpty
                ? _buildEmptyState(l10n)
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return _buildBookingCard(booking, l10n);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String selectedValue) {
    final isSelected = selectedValue == value;
    return GestureDetector(
      onTap: () {
        // Update filter logic here
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? accentPurple : grey5F63,
          ),
        ),
        child: Text(
          label,
          style: montserrat(
            14,
            isSelected ? Colors.white : grey5F63,
            FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.carIcon,
            width: 80.w,
            height: 80.h,
            color: grey5F63,
          ),
          24.verticalSpace,
          Text(
            l10n.search,
            style: montserrat(20, grey36, FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            l10n.chooseAccountType,
            style: montserrat(16, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, AppLocalizations l10n) {
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    switch (booking['status']) {
      case 'completed':
        statusColor = Colors.green;
        statusText = l10n.completed;
        statusIcon = Icons.check_circle;
        break;
      case 'in_progress':
        statusColor = Colors.blue;
        statusText = l10n.inProgress;
        statusIcon = Icons.directions_car;
        break;
      case 'scheduled':
        statusColor = Colors.orange;
        statusText = l10n.personalInformation;
        statusIcon = Icons.schedule;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusText = l10n.cancel;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = Icons.help;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20.sp),
              8.horizontalSpace,
              Text(
                statusText,
                style: montserrat(14, statusColor, FontWeight.w600),
              ),
              Spacer(),
              Text(
                '${booking['date']} • ${booking['time']}',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
          16.verticalSpace,

          // Route Information
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    width: 2.w,
                    height: 20.h,
                    color: Colors.grey[300],
                  ),
                  8.verticalSpace,
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['pickupAddress'],
                      style: montserrat(14, grey36, FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.verticalSpace,
                    Text(
                      booking['destinationAddress'],
                      style: montserrat(14, grey36, FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Driver Information
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(booking['driverImage']),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['driverName'],
                      style: montserrat(14, grey36, FontWeight.w600),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, size: 12.sp, color: Colors.amber),
                        4.horizontalSpace,
                        Text(
                          '${booking['driverRating']}',
                          style: montserrat(12, grey5F63, FontWeight.w500),
                        ),
                        8.horizontalSpace,
                        Text(
                          '${booking['vehicleType']}',
                          style: montserrat(12, grey5F63, FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${booking['fare']} SAR',
                style: montserrat(16, accentPurple, FontWeight.w700),
              ),
            ],
          ),
          16.verticalSpace,

          // Trip Details
          Row(
            children: [
              _buildTripDetail(Icons.access_time, booking['duration']),
              16.horizontalSpace,
              _buildTripDetail(Icons.straighten, booking['distance']),
              16.horizontalSpace,
              _buildTripDetail(Icons.payment, booking['paymentMethod']),
            ],
          ),

          // Rating Section
          if (booking['status'] == 'completed' && booking['rating'] != null) ...[
            16.verticalSpace,
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16.sp),
                  8.horizontalSpace,
                  Text(
                    'Your Rating: ${booking['rating']}/5',
                    style: montserrat(14, grey36, FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],

          // Action Buttons
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to booking details
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accentPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    l10n.search,
                    style: montserrat(12, accentPurple, FontWeight.w600),
                  ),
                ),
              ),
              8.horizontalSpace,
              if (booking['status'] == 'completed' && booking['rating'] == null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to rating screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      l10n.reviews,
                      style: montserrat(12, Colors.white, FontWeight.w600),
                    ),
                  ),
                ),
              if (booking['status'] == 'completed')
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Repeat booking with same details
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      l10n.continueButton,
                      style: montserrat(12, Colors.green, FontWeight.w600),
                    ),
                  ),
                ),
              if (booking['status'] == 'scheduled' || booking['status'] == 'in_progress')
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Cancel booking
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: montserrat(12, Colors.red, FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: grey5F63),
        4.horizontalSpace,
        Text(
          value,
          style: montserrat(12, grey5F63, FontWeight.w500),
        ),
      ],
    );
  }
}
