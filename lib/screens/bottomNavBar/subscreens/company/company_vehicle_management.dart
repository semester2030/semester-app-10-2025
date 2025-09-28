import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/providers/company_data_provider.dart';

class CompanyVehicleManagementScreen extends HookConsumerWidget {
  const CompanyVehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Local state
    final searchController = useTextEditingController();
    final vehicles = useState<List<Map<String, dynamic>>>([]);
    final selectedVehicle = useState<Map<String, dynamic>?>(null);
    final searchQuery = useState<String>('');
    final filterStatus = useState<String>('all');

    // Sample vehicles data
    final sampleVehicles = [
      {
        'id': '1',
        'make': 'Toyota',
        'model': 'Camry',
        'year': '2022',
        'plateNumber': 'ABC-1234',
        'color': 'White',
        'type': 'Sedan',
        'status': 'active',
        'driver': 'Sara Al-Mansouri',
        'lastService': '2024-01-15',
        'nextService': '2024-02-15',
        'mileage': '45000',
        'fuelType': 'Gasoline',
        'seats': 4,
        'features': ['AC', 'GPS', 'Bluetooth'],
        'insurance': {
          'provider': 'Saudi Insurance',
          'expiry': '2024-12-31',
          'policyNumber': 'SI-2024-001',
        },
      },
      {
        'id': '2',
        'make': 'Honda',
        'model': 'Accord',
        'year': '2021',
        'plateNumber': 'XYZ-5678',
        'color': 'Black',
        'type': 'Sedan',
        'status': 'maintenance',
        'driver': 'Mohammed Al-Sayed',
        'lastService': '2024-01-10',
        'nextService': '2024-02-10',
        'mileage': '52000',
        'fuelType': 'Gasoline',
        'seats': 4,
        'features': ['AC', 'GPS', 'Bluetooth', 'Leather Seats'],
        'insurance': {
          'provider': 'Tawuniya',
          'expiry': '2024-11-30',
          'policyNumber': 'TW-2024-002',
        },
      },
      {
        'id': '3',
        'make': 'Nissan',
        'model': 'Altima',
        'year': '2023',
        'plateNumber': 'DEF-9012',
        'color': 'Silver',
        'type': 'Sedan',
        'status': 'inactive',
        'driver': 'Not Assigned',
        'lastService': '2024-01-20',
        'nextService': '2024-02-20',
        'mileage': '28000',
        'fuelType': 'Gasoline',
        'seats': 4,
        'features': ['AC', 'GPS', 'Bluetooth', 'Sunroof'],
        'insurance': {
          'provider': 'AXA',
          'expiry': '2024-10-15',
          'policyNumber': 'AX-2024-003',
        },
      },
      {
        'id': '4',
        'make': 'Hyundai',
        'model': 'Sonata',
        'year': '2022',
        'plateNumber': 'GHI-3456',
        'color': 'Blue',
        'type': 'Sedan',
        'status': 'active',
        'driver': 'Aisha Al-Rashid',
        'lastService': '2024-01-25',
        'nextService': '2024-02-25',
        'mileage': '38000',
        'fuelType': 'Gasoline',
        'seats': 4,
        'features': ['AC', 'GPS', 'Bluetooth', 'Heated Seats'],
        'insurance': {
          'provider': 'Saudi Insurance',
          'expiry': '2024-09-20',
          'policyNumber': 'SI-2024-004',
        },
      },
    ];

    // Initialize vehicles and seed central store once
    useEffect(() {
      vehicles.value = sampleVehicles;
      ref.read(companyDataNotifierProvider.notifier).seedVehicles(sampleVehicles);
      return null;
    }, []);

    // Filter vehicles based on search and status
    List<Map<String, dynamic>> getFilteredVehicles() {
      var filtered = vehicles.value;
      
      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        filtered = filtered.where((vehicle) {
          return vehicle['make'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                 vehicle['model'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                 vehicle['plateNumber'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                 vehicle['driver'].toLowerCase().contains(searchQuery.value.toLowerCase());
        }).toList();
      }
      
      // Filter by status
      if (filterStatus.value != 'all') {
        filtered = filtered.where((vehicle) => vehicle['status'] == filterStatus.value).toList();
      }
      
      return filtered;
    }

    Future<void> onAddVehicle() async {
      // Navigate to add vehicle screen
      if (context.mounted) {
        context.push('/add_vehicle');
      }
    }

    void onEditVehicle(Map<String, dynamic> vehicle) {
      // Navigate to edit vehicle screen
      if (context.mounted) {
        context.push('/edit_vehicle', extra: vehicle);
      }
    }

    void onDeleteVehicle(String vehicleId) {
      // TODO: Implement delete functionality
      showSuccessFlushBar(
        message: 'Vehicle deleted',
        context: context,
      );
    }

    void onAssignDriver(Map<String, dynamic> vehicle) {
      // Navigate to driver assignment screen
      if (context.mounted) {
        context.push('/assign_driver', extra: vehicle);
      }
    }

    void onViewDetails(Map<String, dynamic> vehicle) {
      selectedVehicle.value = vehicle;
      // Show vehicle details modal
      if (context.mounted) {
        context.push('/vehicle_details', extra: vehicle);
      }
    }

    return ScreenWithTopAppbar(
      title: 'Vehicle Management',
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
                  titleText: 'Search Vehicles',
                  hintText: 'Search vehicles',
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
                        label: 'Active',
                        isSelected: filterStatus.value == 'active',
                        onTap: () => filterStatus.value = 'active',
                      ),
                      8.horizontalSpace,
                      _buildFilterChip(
                        label: 'Maintenance',
                        isSelected: filterStatus.value == 'maintenance',
                        onTap: () => filterStatus.value = 'maintenance',
                      ),
                      8.horizontalSpace,
                      _buildFilterChip(
                        label: 'Inactive',
                        isSelected: filterStatus.value == 'inactive',
                        onTap: () => filterStatus.value = 'inactive',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Vehicles list
          Expanded(
            child: getFilteredVehicles().isEmpty
                ? _buildEmptyState(context, l10n)
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: getFilteredVehicles().length,
                    itemBuilder: (context, index) {
                      final vehicle = getFilteredVehicles()[index];
                      return _buildVehicleCard(
                        vehicle: vehicle,
                        onEdit: () => onEditVehicle(vehicle),
                        onDelete: () => onDeleteVehicle(vehicle['id']),
                        onAssignDriver: () => onAssignDriver(vehicle),
                        onViewDetails: () => onViewDetails(vehicle),
                        l10n: l10n,
                      );
                    },
                  ),
          ),
          
          // Add vehicle button
          Container(
            padding: EdgeInsets.all(24.w),
            child: NormalCustomButton(
              label: 'Add Vehicle',
              onPressed: onAddVehicle,
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
              Icons.directions_car,
              size: 60.sp,
              color: accentPurple,
            ),
          ),
          
          24.verticalSpace,
          
          Text(
            'No vehicles found',
            style: montserrat(20, grey36, FontWeight.w600),
          ),
          
          8.verticalSpace,
          
          Text(
            'Add your first vehicle',
            style: montserrat(16, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard({
    required Map<String, dynamic> vehicle,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onAssignDriver,
    required VoidCallback onViewDetails,
    required AppLocalizations l10n,
  }) {
    Color statusColor;
    switch (vehicle['status']) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'maintenance':
        statusColor = Colors.orange;
        break;
      case 'inactive':
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
        children: [
          // Header with status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle['make']} ${vehicle['model']}',
                      style: montserrat(18, grey36, FontWeight.w600),
                    ),
                    
                    4.verticalSpace,
                    
                    Text(
                      '${vehicle['year']} • ${vehicle['plateNumber']}',
                      style: montserrat(14, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ),
              
              _buildStatusChip(vehicle['status'], statusColor, l10n),
            ],
          ),
          
          16.verticalSpace,
          
          // Vehicle details
          Row(
            children: [
              _buildDetailItem(
                icon: AppIcons.carIcon,
                label: 'Type',
                value: vehicle['type'],
              ),
              
              16.horizontalSpace,
              
              _buildDetailItem(
                icon: AppIcons.usersIcon,
                label: 'Seats',
                value: '${vehicle['seats']}',
              ),
              
              16.horizontalSpace,
              
              _buildDetailItem(
                icon: AppIcons.locationIcon,
                label: 'Mileage',
                value: '${vehicle['mileage']} km',
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Driver info
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.driverIcon,
                color: accentPurple,
                width: 16.w,
                height: 16.h,
              ),
              
              8.horizontalSpace,
              
              Text(
                'Driver',
                style: montserrat(14, grey5F63, FontWeight.w500),
              ),
              
              8.horizontalSpace,
              
              Text(
                vehicle['driver'],
                style: montserrat(14, grey36, FontWeight.w600),
              ),
              
              Spacer(),
              
              if (vehicle['driver'] == 'Not Assigned')
                GestureDetector(
                  onTap: onAssignDriver,
                  child: Text(
                    'Assign',
                    style: montserrat(14, accentPurple, FontWeight.w600),
                  ),
                ),
            ],
          ),
          
          16.verticalSpace,
          
          // Action buttons with computed seats summary
          Row(
            children: [
              _buildActionButton(
                icon: Icons.visibility,
                label: 'View Details',
                onTap: onViewDetails,
                color: accentPurple,
              ),
              
              8.horizontalSpace,
              
              _buildActionButton(
                icon: Icons.edit,
                label: 'Edit',
                onTap: onEdit,
                color: Colors.blue,
              ),
              
              8.horizontalSpace,
              
              _buildActionButton(
                icon: Icons.delete,
                label: 'Delete',
                onTap: onDelete,
                color: Colors.red,
              ),
            ],
          ),
          12.verticalSpace,
          _buildSeatsComputedRow(vehicle),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color, AppLocalizations l10n) {
    String label;
    switch (status) {
      case 'active':
        label = 'Active';
        break;
      case 'maintenance':
        label = 'Maintenance';
        break;
      case 'inactive':
        label = 'Inactive';
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

  Widget _buildDetailItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: accentPurple,
            width: 14.w,
            height: 14.h,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
            4.horizontalSpace,
            Text(
              label,
              style: montserrat(12, color, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsComputedRow(Map<String, dynamic> vehicle) {
    // In real app, compute seatsBooked from active bookings; here mock with 0
    final int capacity = (vehicle['seats'] as int?) ?? 0;
    final int booked = (vehicle['seatsBooked'] as int?) ?? 0;
    final int available = (capacity - booked).clamp(0, capacity);

    return Row(
      children: [
        Icon(Icons.event_seat, color: accentPurple, size: 16.sp),
        6.horizontalSpace,
        Text('Capacity: $capacity', style: montserrat(12, grey36, FontWeight.w500)),
        12.horizontalSpace,
        Icon(Icons.lock_clock, color: Colors.blue, size: 16.sp),
        6.horizontalSpace,
        Text('Booked: $booked', style: montserrat(12, Colors.blue, FontWeight.w600)),
        12.horizontalSpace,
        Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
        6.horizontalSpace,
        Text('Available: $available', style: montserrat(12, Colors.green, FontWeight.w600)),
      ],
    );
  }
}
