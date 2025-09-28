import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/providers/company_data_provider.dart';

class CompanyDriverManagementScreen extends HookConsumerWidget {
  const CompanyDriverManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Local state
    final searchController = useTextEditingController();
    final drivers = useState<List<Map<String, dynamic>>>([]);
    final selectedDriver = useState<Map<String, dynamic>?>(null);
    final searchQuery = useState<String>('');
    final filterStatus = useState<String>('all');

    // Sample drivers data
    final sampleDrivers = [
      {
        'id': '1',
        'name': 'Sara Al-Mansouri',
        'phone': '+966501234567',
        'email': 'sara.mansouri@email.com',
        'status': 'online',
        'rating': 4.9,
        'totalTrips': 245,
        'joinDate': '2023-01-15',
        'licenseNumber': 'DL-2023-001',
        'licenseExpiry': '2025-01-15',
        'vehicle': 'Toyota Camry',
        'currentLocation': 'Near University',
        'lastActive': '2 minutes ago',
        'earnings': 12500,
        'availability': {
          'monday': {'start': '08:00', 'end': '18:00'},
          'tuesday': {'start': '08:00', 'end': '18:00'},
          'wednesday': {'start': '08:00', 'end': '18:00'},
          'thursday': {'start': '08:00', 'end': '18:00'},
          'friday': {'start': '08:00', 'end': '18:00'},
        },
        'documents': {
          'license': 'verified',
          'insurance': 'verified',
          'vehicleRegistration': 'verified',
          'medicalCertificate': 'verified',
        },
      },
      {
        'id': '2',
        'name': 'Mohammed Al-Sayed',
        'phone': '+966507654321',
        'email': 'mohammed.sayed@email.com',
        'status': 'offline',
        'rating': 4.6,
        'totalTrips': 189,
        'joinDate': '2023-03-20',
        'licenseNumber': 'DL-2023-002',
        'licenseExpiry': '2025-03-20',
        'vehicle': 'Honda Accord',
        'currentLocation': 'At Home',
        'lastActive': '2 hours ago',
        'earnings': 9800,
        'availability': {
          'monday': {'start': '09:00', 'end': '17:00'},
          'tuesday': {'start': '09:00', 'end': '17:00'},
          'wednesday': {'start': '09:00', 'end': '17:00'},
          'thursday': {'start': '09:00', 'end': '17:00'},
          'friday': {'start': '09:00', 'end': '17:00'},
        },
        'documents': {
          'license': 'verified',
          'insurance': 'verified',
          'vehicleRegistration': 'verified',
          'medicalCertificate': 'pending',
        },
      },
      {
        'id': '3',
        'name': 'Aisha Al-Rashid',
        'phone': '+966509876543',
        'email': 'aisha.rashid@email.com',
        'status': 'busy',
        'rating': 4.8,
        'totalTrips': 312,
        'joinDate': '2022-11-10',
        'licenseNumber': 'DL-2022-003',
        'licenseExpiry': '2024-11-10',
        'vehicle': 'Nissan Altima',
        'currentLocation': 'In Transit',
        'lastActive': '5 minutes ago',
        'earnings': 18750,
        'availability': {
          'monday': {'start': '07:00', 'end': '19:00'},
          'tuesday': {'start': '07:00', 'end': '19:00'},
          'wednesday': {'start': '07:00', 'end': '19:00'},
          'thursday': {'start': '07:00', 'end': '19:00'},
          'friday': {'start': '07:00', 'end': '19:00'},
        },
        'documents': {
          'license': 'verified',
          'insurance': 'verified',
          'vehicleRegistration': 'verified',
          'medicalCertificate': 'verified',
        },
      },
      {
        'id': '4',
        'name': 'Omar Al-Hassan',
        'phone': '+966505432109',
        'email': 'omar.hassan@email.com',
        'status': 'suspended',
        'rating': 4.2,
        'totalTrips': 156,
        'joinDate': '2023-06-05',
        'licenseNumber': 'DL-2023-004',
        'licenseExpiry': '2025-06-05',
        'vehicle': 'Hyundai Sonata',
        'currentLocation': 'Not Available',
        'lastActive': '1 day ago',
        'earnings': 7200,
        'availability': {},
        'documents': {
          'license': 'verified',
          'insurance': 'expired',
          'vehicleRegistration': 'verified',
          'medicalCertificate': 'verified',
        },
        'suspensionReason': 'Insurance expired',
      },
    ];

    // Initialize drivers and seed central store once
    useEffect(() {
      drivers.value = sampleDrivers;
      ref.read(companyDataNotifierProvider.notifier).seedDrivers(sampleDrivers);
      return null;
    }, []);

    // Filter drivers based on search and status
    List<Map<String, dynamic>> getFilteredDrivers() {
      var filtered = drivers.value;
      
      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        filtered = filtered.where((driver) {
          return driver['name'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                 driver['phone'].contains(searchQuery.value) ||
                 driver['email'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                 driver['vehicle'].toLowerCase().contains(searchQuery.value.toLowerCase());
        }).toList();
      }
      
      // Filter by status
      if (filterStatus.value != 'all') {
        filtered = filtered.where((driver) => driver['status'] == filterStatus.value).toList();
      }
      
      return filtered;
    }

    Future<void> onAddDriver() async {
      // Navigate to add driver screen
      if (context.mounted) {
        context.push('/add_driver');
      }
    }

    void onEditDriver(Map<String, dynamic> driver) {
      // Navigate to edit driver screen
      if (context.mounted) {
        context.push('/edit_driver', extra: driver);
      }
    }

    void onSuspendDriver(String driverId) {
      // TODO: Implement suspend functionality
      showSuccessFlushBar(
        message: 'Driver suspended',
        context: context,
      );
    }

    void onActivateDriver(String driverId) {
      // TODO: Implement activate functionality
      showSuccessFlushBar(
        message: 'Driver activated',
        context: context,
      );
    }

    void onViewDetails(Map<String, dynamic> driver) {
      selectedDriver.value = driver;
      // Show driver details modal
      if (context.mounted) {
        context.push('/driver_details', extra: driver);
      }
    }

    void onAssignVehicle(Map<String, dynamic> driver) {
      // Navigate to vehicle assignment screen
      if (context.mounted) {
        context.push('/assign_vehicle', extra: driver);
      }
    }

    return ScreenWithTopAppbar(
      title: 'Driver Management',
      child: Column(
        children: [
          // Logo
          Container(
            padding: EdgeInsets.all(24.w),
            child: Center(
              child: Image.asset(
                AppImages.logo,
                width: 120.w,
                height: 45.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          
          // Search and filter bar
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                // Search bar
                CustomTextField(
                  controller: searchController,
                  titleText: 'Search Drivers',
                  hintText: 'Search drivers',
                  prefixIcon: AppIcons.searchIcon,
                ),
                
                16.verticalSpace,
                
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        isSelected: filterStatus.value == 'all',
                        onTap: () => filterStatus.value = 'all',
                      ),
                      8.horizontalSpace,
                      _buildFilterChip(
                        label: 'Online',
                        isSelected: filterStatus.value == 'online',
                        onTap: () => filterStatus.value = 'online',
                      ),
                      8.horizontalSpace,
                      _buildFilterChip(
                        label: 'Offline',
                        isSelected: filterStatus.value == 'offline',
                        onTap: () => filterStatus.value = 'offline',
                      ),
                      8.horizontalSpace,
                      _buildFilterChip(
                        label: 'Busy',
                        isSelected: filterStatus.value == 'busy',
                        onTap: () => filterStatus.value = 'busy',
                      ),
                      8.horizontalSpace,
                      _buildFilterChip(
                        label: 'Suspended',
                        isSelected: filterStatus.value == 'suspended',
                        onTap: () => filterStatus.value = 'suspended',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Drivers list
          Expanded(
            child: getFilteredDrivers().isEmpty
                ? _buildEmptyState(context, l10n)
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: getFilteredDrivers().length,
                    itemBuilder: (context, index) {
                      final driver = getFilteredDrivers()[index];
                      return _buildDriverCard(
                        driver: driver,
                        onEdit: () => onEditDriver(driver),
                        onSuspend: () => onSuspendDriver(driver['id']),
                        onActivate: () => onActivateDriver(driver['id']),
                        onViewDetails: () => onViewDetails(driver),
                        onAssignVehicle: () => onAssignVehicle(driver),
                        l10n: l10n,
                      );
                    },
                  ),
          ),
          
          // Add driver button
          Container(
            padding: EdgeInsets.all(24.w),
            child: NormalCustomButton(
              label: 'Add Driver',
              onPressed: onAddDriver,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: montserrat(
            14,
            isSelected ? Colors.white : grey36,
            FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: accentPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: Icon(
              Icons.person,
              size: 60.sp,
              color: accentPurple,
            ),
          ),
          
          24.verticalSpace,
          
          Text(
            'No drivers found',
            style: montserrat(20, grey36, FontWeight.w600),
          ),
          
          8.verticalSpace,
          
          Text(
            'Add your first driver',
            style: montserrat(16, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard({
    required Map<String, dynamic> driver,
    required VoidCallback onEdit,
    required VoidCallback onSuspend,
    required VoidCallback onActivate,
    required VoidCallback onViewDetails,
    required VoidCallback onAssignVehicle,
    required AppLocalizations l10n,
  }) {
    Color statusColor;
    switch (driver['status']) {
      case 'online':
        statusColor = Colors.green;
        break;
      case 'offline':
        statusColor = Colors.grey;
        break;
      case 'busy':
        statusColor = Colors.orange;
        break;
      case 'suspended':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with status
          Row(
            children: [
              CircleAvatar(
                radius: 25.r,
                backgroundColor: accentPurple.withOpacity(0.1),
                child: Text(
                  driver['name'].substring(0, 1),
                  style: montserrat(18, accentPurple, FontWeight.w600),
                ),
              ),
              
              16.horizontalSpace,
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name'],
                      style: montserrat(18, grey36, FontWeight.w600),
                    ),
                    
                    4.verticalSpace,
                    
                    Text(
                      driver['phone'],
                      style: montserrat(14, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ),
              
              _buildStatusChip(driver['status'], statusColor, l10n),
            ],
          ),
          
          16.verticalSpace,
          
          // Driver stats
          Row(
            children: [
              _buildStatItem(
                icon: Icons.star,
                label: 'Rating',
                value: '${driver['rating']}',
                color: Colors.amber,
              ),
              
              16.horizontalSpace,
              
              _buildStatItem(
                icon: Icons.directions_car,
                label: 'Trips',
                value: '${driver['totalTrips']}',
                color: accentPurple,
              ),
              
              16.horizontalSpace,
              
              _buildStatItem(
                icon: Icons.attach_money,
                label: 'Earnings',
                value: '${driver['earnings']} SAR',
                color: Colors.green,
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Vehicle and location info
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.carIcon,
                color: accentPurple,
                width: 16.w,
                height: 16.h,
              ),
              
              8.horizontalSpace,
              
              Text(
                driver['vehicle'],
                style: montserrat(14, grey36, FontWeight.w600),
              ),
              
              Spacer(),
              
              SvgPicture.asset(
                AppIcons.locationIcon,
                color: accentPurple,
                width: 16.w,
                height: 16.h,
              ),
              
              8.horizontalSpace,
              
              Text(
                driver['currentLocation'],
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Documents status
          _buildDocumentsStatus(driver['documents'], l10n),
          
          16.verticalSpace,
          
          // Action buttons (wrap to avoid horizontal overflow)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildActionButton(
                icon: Icons.visibility,
                label: 'View Details',
                onTap: onViewDetails,
                color: accentPurple,
              ),
              _buildActionButton(
                icon: Icons.edit,
                label: 'Edit',
                onTap: onEdit,
                color: Colors.blue,
              ),
              if (driver['status'] == 'suspended')
                _buildActionButton(
                  icon: Icons.check_circle,
                  label: 'Activate',
                  onTap: onActivate,
                  color: Colors.green,
                )
              else
                _buildActionButton(
                  icon: Icons.block,
                  label: 'Suspend',
                  onTap: onSuspend,
                  color: Colors.red,
                ),
              _buildActionButton(
                icon: Icons.directions_car,
                label: 'Assign Vehicle',
                onTap: onAssignVehicle,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color, AppLocalizations l10n) {
    String label;
    switch (status) {
      case 'online':
        label = 'Online';
        break;
      case 'offline':
        label = 'Offline';
        break;
      case 'busy':
        label = 'Busy';
        break;
      case 'suspended':
        label = 'Suspended';
        break;
      default:
        label = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: montserrat(12, color, FontWeight.w600),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16.sp,
          ),
          
          6.horizontalSpace,
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: montserrat(10, grey5F63, FontWeight.w400),
              ),
              Text(
                value,
                style: montserrat(12, grey36, FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsStatus(Map<String, dynamic> documents, AppLocalizations l10n) {
    final verifiedCount = documents.values.where((status) => status == 'verified').length;
    final totalCount = documents.length;
    
    return Row(
      children: [
        SvgPicture.asset(
          AppIcons.documentIcon,
          color: accentPurple,
          width: 16.w,
          height: 16.h,
        ),
        
        8.horizontalSpace,
        
        Text(
          'Documents',
          style: montserrat(14, grey5F63, FontWeight.w500),
        ),
        
        8.horizontalSpace,
        
        Text(
          '$verifiedCount/$totalCount Verified',
          style: montserrat(14, verifiedCount == totalCount ? Colors.green : Colors.orange, FontWeight.w600),
        ),
        
        Spacer(),
        
        if (verifiedCount < totalCount)
          Text(
            'Action Required',
            style: montserrat(12, Colors.red, FontWeight.w500),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 14.sp,
              ),
              6.horizontalSpace,
              Text(
                label,
                style: montserrat(12, color, FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
