import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class OfferManagementScreen extends HookConsumerWidget {
  const OfferManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state
    final offers = useState<List<Map<String, dynamic>>>([]);
    final selectedFilter = useState<String>('all');
    final searchController = useTextEditingController();

    // Mock data
    useEffect(() {
      offers.value = [
        {
          'id': '1',
          'title': 'Student Transport - Fixed Price',
          'amount': '50.00',
          'currency': 'SAR',
          'type': 'fixed',
          'status': 'active',
          'createdAt': '2024-01-15',
          'validUntil': '2024-02-15',
          'negotiable': true,
          'responses': 3,
        },
        {
          'id': '2',
          'title': 'Teacher Transport - Hourly Rate',
          'amount': '25.00',
          'currency': 'SAR',
          'type': 'hourly',
          'status': 'pending',
          'createdAt': '2024-01-14',
          'validUntil': '2024-02-14',
          'negotiable': false,
          'responses': 0,
        },
        {
          'id': '3',
          'title': 'Employee Transport - Price Range',
          'amount': '40.00 - 60.00',
          'currency': 'SAR',
          'type': 'range',
          'status': 'expired',
          'createdAt': '2024-01-10',
          'validUntil': '2024-01-20',
          'negotiable': true,
          'responses': 1,
        },
      ];
      return null;
    }, []);

    // Filter offers
    final filteredOffers = offers.value.where((offer) {
      final matchesSearch = offer['title'].toLowerCase()
          .contains(searchController.text.toLowerCase());
      final matchesFilter = selectedFilter.value == 'all' ||
          offer['status'] == selectedFilter.value;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Offers'),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => context.push('/offer_creation'),
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
                // Search Bar
                CustomTextField(
                  controller: searchController,
                  titleText: 'Search Offers',
                  hintText: 'Search by title or description',
                  prefixIcon: AppIcons.searchIcon,
                ),
                16.verticalSpace,
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip('Active', 'active', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip('Pending', 'pending', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip('Expired', 'expired', selectedFilter.value),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Offers List
          Expanded(
            child: filteredOffers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = filteredOffers[index];
                      return _buildOfferCard(offer, context);
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

  Widget _buildEmptyState() {
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
            'No Offers Found',
            style: montserrat(20, grey36, FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            'Create your first offer to get started',
            style: montserrat(16, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          NormalCustomButton(
            label: 'Create Offer',
            onPressed: () async {
              // Navigate to offer creation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
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
              Expanded(
                child: Text(
                  offer['title'],
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
              ),
              _buildStatusChip(offer['status']),
            ],
          ),
          12.verticalSpace,

          // Amount and Type
          Row(
            children: [
              Text(
                '${offer['amount']} ${offer['currency']}',
                style: montserrat(18, accentPurple, FontWeight.w700),
              ),
              8.horizontalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  offer['type'].toUpperCase(),
                  style: montserrat(12, accentPurple, FontWeight.w600),
                ),
              ),
            ],
          ),
          12.verticalSpace,

          // Details
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                'Valid until ${offer['validUntil']}',
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              16.horizontalSpace,
              Icon(Icons.message, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                '${offer['responses']} responses',
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
            ],
          ),

          16.verticalSpace,

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to offer details
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accentPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: montserrat(14, accentPurple, FontWeight.w600),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Edit offer logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Edit',
                    style: montserrat(14, Colors.white, FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'active':
        color = Colors.green;
        label = 'Active';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'expired':
        color = Colors.red;
        label = 'Expired';
        break;
      default:
        color = grey5F63;
        label = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: montserrat(12, color, FontWeight.w600),
      ),
    );
  }
}
