import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class FleetOverviewScreen extends HookConsumerWidget {
  const FleetOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state
    final companies = useState<List<Map<String, dynamic>>>([]);
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('all');

    // Mock companies data
    useEffect(() {
      companies.value = [
        {
          'id': '1',
          'name': 'Riyadh Transport Co.',
          'fleetCount': 25,
          'activeDrivers': 18,
          'availableVehicles': 12,
          'rating': 4.8,
          'totalTrips': 1250,
          'monthlyRevenue': 45000,
          'vehicleTypes': ['Sedan', 'SUV', 'Van'],
          'coverage': ['Riyadh', 'Jeddah', 'Dammam'],
          'isOnline': true,
          'lastUpdate': '2 minutes ago',
        },
        {
          'id': '2',
          'name': 'Saudi Fleet Services',
          'fleetCount': 42,
          'activeDrivers': 35,
          'availableVehicles': 28,
          'rating': 4.6,
          'totalTrips': 2100,
          'monthlyRevenue': 78000,
          'vehicleTypes': ['Sedan', 'SUV', 'Bus', 'Van'],
          'coverage': ['Riyadh', 'Jeddah', 'Dammam', 'Mecca', 'Medina'],
          'isOnline': true,
          'lastUpdate': '5 minutes ago',
        },
        {
          'id': '3',
          'name': 'Metro Shuttle Co.',
          'fleetCount': 15,
          'activeDrivers': 12,
          'availableVehicles': 8,
          'rating': 4.9,
          'totalTrips': 850,
          'monthlyRevenue': 32000,
          'vehicleTypes': ['Bus', 'Van'],
          'coverage': ['Riyadh Metro Area'],
          'isOnline': false,
          'lastUpdate': '1 hour ago',
        },
      ];
      return null;
    }, []);

    // Filter companies
    final filteredCompanies = companies.value.where((company) {
      final matchesSearch = company['name'].toLowerCase()
          .contains(searchController.text.toLowerCase());
      final matchesFilter = selectedFilter.value == 'all' ||
          (selectedFilter.value == 'online' && company['isOnline']) ||
          (selectedFilter.value == 'offline' && !company['isOnline']);
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Fleet Overview'),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh data
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
                // Search Bar
                CustomTextField(
                  controller: searchController,
                  titleText: 'Search Companies',
                  hintText: 'Search by company name',
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
                      _buildFilterChip('Online', 'online', selectedFilter.value),
                      8.horizontalSpace,
                      _buildFilterChip('Offline', 'offline', selectedFilter.value),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Companies List
          Expanded(
            child: filteredCompanies.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: filteredCompanies.length,
                    itemBuilder: (context, index) {
                      final company = filteredCompanies[index];
                      return _buildCompanyCard(company);
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
            'No Companies Found',
            style: montserrat(20, grey36, FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            'Try adjusting your search or filters',
            style: montserrat(16, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          // Company Header
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: company['isOnline'] ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  company['name'],
                  style: montserrat(18, grey36, FontWeight.w700),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 16.sp, color: Colors.amber),
                  4.horizontalSpace,
                  Text(
                    '${company['rating']}',
                    style: montserrat(14, grey36, FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          16.verticalSpace,

          // Fleet Stats
          Row(
            children: [
              _buildStatCard(
                icon: Icons.local_shipping,
                label: 'Total Fleet',
                value: '${company['fleetCount']}',
                color: accentPurple,
              ),
              12.horizontalSpace,
              _buildStatCard(
                icon: Icons.person,
                label: 'Active Drivers',
                value: '${company['activeDrivers']}',
                color: Colors.green,
              ),
              12.horizontalSpace,
              _buildStatCard(
                icon: Icons.directions_car,
                label: 'Available',
                value: '${company['availableVehicles']}',
                color: Colors.blue,
              ),
            ],
          ),
          16.verticalSpace,

          // Performance Stats
          Row(
            children: [
              _buildStatCard(
                icon: Icons.trip_origin,
                label: 'Total Trips',
                value: '${company['totalTrips']}',
                color: Colors.orange,
              ),
              12.horizontalSpace,
              _buildStatCard(
                icon: Icons.attach_money,
                label: 'Monthly Revenue',
                value: '${company['monthlyRevenue']} SAR',
                color: Colors.green,
              ),
            ],
          ),
          16.verticalSpace,

          // Vehicle Types
          Text(
            'Vehicle Types',
            style: montserrat(14, grey5F63, FontWeight.w500),
          ),
          8.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: (company['vehicleTypes'] as List<String>).map((type) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  type,
                  style: montserrat(12, accentPurple, FontWeight.w500),
                ),
              );
            }).toList(),
          ),
          16.verticalSpace,

          // Coverage Areas
          Text(
            'Coverage Areas',
            style: montserrat(14, grey5F63, FontWeight.w500),
          ),
          8.verticalSpace,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: (company['coverage'] as List<String>).map((area) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  area,
                  style: montserrat(12, Colors.blue, FontWeight.w500),
                ),
              );
            }).toList(),
          ),
          16.verticalSpace,

          // Last Update
          Row(
            children: [
              Icon(Icons.access_time, size: 14.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                'Last update: ${company['lastUpdate']}',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
          20.verticalSpace,

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View company details
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
                    // Book with company
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Book Now',
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.sp),
            8.verticalSpace,
            Text(
              value,
              style: montserrat(14, grey36, FontWeight.w700),
            ),
            4.verticalSpace,
            Text(
              label,
              style: montserrat(10, grey5F63, FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
