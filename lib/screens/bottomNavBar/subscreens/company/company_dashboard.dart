import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/providers/company_data_provider.dart';

class CompanyDashboardScreen extends HookConsumerWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Local state
    final companyStats = useState<Map<String, dynamic>>({});
    final recentBookings = useState<List<Map<String, dynamic>>>([]);
    final activeDrivers = useState<List<Map<String, dynamic>>>([]);

    // Sample company data
    final sampleStats = {
      'totalBookings': 156,
      'activeDrivers': 12,
      'totalVehicles': 15,
      'monthlyRevenue': 45000,
      'averageRating': 4.7,
      'pendingRequests': 8,
      'completedTrips': 142,
      'cancelledTrips': 14,
      'totalEarnings': 125000,
      'activeRoutes': 8,
    };

    final sampleBookings = [
      {
        'id': '1',
        'customer': 'Ahmed Al-Rashid',
        'route': 'Home → University',
        'time': '8:00 AM',
        'status': 'active',
        'driver': 'Sara Al-Mansouri',
        'price': '25 SAR',
      },
      {
        'id': '2',
        'customer': 'Fatima Al-Zahra',
        'route': 'Office → Metro Station',
        'time': '6:00 PM',
        'status': 'completed',
        'driver': 'Mohammed Al-Sayed',
        'price': '30 SAR',
      },
      {
        'id': '3',
        'customer': 'Omar Al-Hassan',
        'route': 'School → Home',
        'time': '3:30 PM',
        'status': 'pending',
        'driver': 'Not Assigned',
        'price': '20 SAR',
      },
    ];

    final sampleDrivers = [
      {
        'id': '1',
        'name': 'Sara Al-Mansouri',
        'status': 'online',
        'currentLocation': 'Near University',
        'rating': 4.9,
        'totalTrips': 245,
        'vehicle': 'Toyota Camry',
      },
      {
        'id': '2',
        'name': 'Mohammed Al-Sayed',
        'status': 'offline',
        'currentLocation': 'At Home',
        'rating': 4.6,
        'totalTrips': 189,
        'vehicle': 'Honda Accord',
      },
      {
        'id': '4',
        'name': 'Ahmed Al-Rashid',
        'status': 'online',
        'currentLocation': 'Near Mall',
        'rating': 4.7,
        'totalTrips': 203,
        'vehicle': 'Hyundai Sonata',
      },
      {
        'id': '5',
        'name': 'Fatima Al-Zahra',
        'status': 'busy',
        'currentLocation': 'In Transit',
        'rating': 4.8,
        'totalTrips': 278,
        'vehicle': 'Nissan Altima',
      },
      {
        'id': '3',
        'name': 'Aisha Al-Rashid',
        'status': 'busy',
        'currentLocation': 'In Transit',
        'rating': 4.8,
        'totalTrips': 312,
        'vehicle': 'Nissan Altima',
      },
    ];

    // Initialize data and connect to central provider for counts
    useEffect(() {
      companyStats.value = sampleStats;
      recentBookings.value = sampleBookings;
      activeDrivers.value = sampleDrivers;
      return null;
    }, []);

    void onViewAllBookings() {
      // Navigate to bookings screen
      if (context.mounted) {
        context.push('/my_bookings');
      }
    }

    void onViewAllDrivers() {
      // Navigate to drivers screen
      if (context.mounted) {
        context.push('/company_driver_management');
      }
    }

    void onManageVehicles() {
      // Navigate to vehicles screen
      if (context.mounted) {
        context.push('/company_vehicle_management');
      }
    }

    void onViewReports() {
      // Navigate to reports screen
      if (context.mounted) {
        context.push('/company_dashboard'); // For now, stay on dashboard
      }
    }


    return ScreenWithTopAppbar(
      title: 'Company Dashboard',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  AppImages.logo,
                  width: 120.w,
                  height: 45.h,
                  fit: BoxFit.contain,
                ),
              ),
              
              20.verticalSpace,
              
              // Welcome header
              Text(
                'Welcome back',
                style: montserrat(24, grey36, FontWeight.w600),
              ),
              
              8.verticalSpace,
              
              Text(
                'Manage your fleet',
                style: montserrat(16, grey5F63, FontWeight.w400),
              ),
              
              32.verticalSpace,
              
              // Stats cards
              _buildStatsSection(context, ref, companyStats.value, l10n),
              
              32.verticalSpace,
              
              // Quick actions
              _buildQuickActionsSection(
                onViewAllBookings: onViewAllBookings,
                onViewAllDrivers: onViewAllDrivers,
                onManageVehicles: onManageVehicles,
                onViewReports: onViewReports,
                l10n: l10n,
              ),
              
              32.verticalSpace,
              
              // Recent bookings
              _buildRecentBookingsSection(recentBookings.value, l10n, context),
              
              32.verticalSpace,
              
              // Active drivers
              _buildActiveDriversSection(activeDrivers.value, l10n, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, WidgetRef ref, Map<String, dynamic> stats, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: montserrat(20, grey36, FontWeight.w600),
        ),
        
        16.verticalSpace,
        
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          // Slightly taller tiles to avoid content overflow on small screens
          childAspectRatio: 1.6,
          children: [
            _buildStatCard(
              title: 'Total Bookings',
              value: '${stats['totalBookings']}',
              icon: AppIcons.bookings,
              color: accentPurple,
              onTap: () {
                if (context.mounted) {
                  context.push('/my_bookings');
                }
              },
            ),
            _buildStatCard(
              title: 'Active Drivers',
              value: '${ref.watch(activeDriversCountProvider)}',
              icon: AppIcons.driverIcon,
              color: Colors.green,
              onTap: () {
                if (context.mounted) {
                  context.push('/company_driver_management');
                }
              },
            ),
            _buildStatCard(
              title: 'Total Vehicles',
              value: '${ref.watch(totalVehiclesProvider)}',
              icon: AppIcons.carIcon,
              color: Colors.blue,
              onTap: () {
                if (context.mounted) {
                  context.push('/company_vehicle_management');
                }
              },
            ),
            _buildStatCard(
              title: 'Monthly Revenue',
              value: '${stats['monthlyRevenue']} SAR',
              icon: AppIcons.pay,
              color: Colors.orange,
              onTap: () {
                if (context.mounted) {
                  context.push('/company_revenue');
                }
              },
              tooltip: 'View detailed revenue breakdown',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String icon,
    required Color color,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    final card = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    icon,
                    color: color,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
              
              Text(
                value,
                style: montserrat(20, grey36, FontWeight.w600),
              ),
              
              Text(
                title,
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip, child: card) : card;
  }

  Widget _buildQuickActionsSection({
    required VoidCallback onViewAllBookings,
    required VoidCallback onViewAllDrivers,
    required VoidCallback onManageVehicles,
    required VoidCallback onViewReports,
    required AppLocalizations l10n,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: montserrat(20, grey36, FontWeight.w600),
        ),
        
        16.verticalSpace,
        
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'View Bookings',
                icon: AppIcons.bookings,
                onTap: onViewAllBookings,
              ),
            ),
            
            16.horizontalSpace,
            
            Expanded(
              child: _buildActionCard(
                title: 'Manage Drivers',
                icon: AppIcons.driverIcon,
                onTap: onViewAllDrivers,
              ),
            ),
          ],
        ),
        
        16.verticalSpace,
        
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Manage Vehicles',
                icon: AppIcons.carIcon,
                onTap: onManageVehicles,
              ),
            ),
            
            16.horizontalSpace,
            
            Expanded(
              child: _buildActionCard(
                title: 'View Reports',
                icon: AppIcons.reportIcon,
                onTap: onViewReports,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              color: accentPurple,
              width: 24.w,
              height: 24.h,
            ),
            
            12.verticalSpace,
            
            Text(
              title,
              style: montserrat(14, grey36, FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookingsSection(List<Map<String, dynamic>> bookings, AppLocalizations l10n, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Bookings',
              style: montserrat(20, grey36, FontWeight.w600),
            ),
            
            Spacer(),
            
            GestureDetector(
              onTap: () {
                if (context.mounted) {
                  context.push('/my_bookings');
                }
              },
              child: Text(
                'View All',
                style: montserrat(14, accentPurple, FontWeight.w600),
              ),
            ),
          ],
        ),
        
        16.verticalSpace,
        
        ...bookings.map((booking) => _buildBookingCard(booking, l10n)),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, AppLocalizations l10n) {
    Color statusColor;
    switch (booking['status']) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'completed':
        statusColor = Colors.blue;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Icon(
                Icons.directions_car,
                color: statusColor,
                size: 20.sp,
              ),
            ),
          ),
          
          16.horizontalSpace,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['customer'],
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                
                4.verticalSpace,
                
                Text(
                  booking['route'],
                  style: montserrat(14, grey5F63, FontWeight.w400),
                ),
                
                4.verticalSpace,
                
                Text(
                  '${booking['time']} • ${booking['driver']}',
                  style: montserrat(12, grey5F63, FontWeight.w400),
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                booking['price'],
                style: montserrat(16, accentPurple, FontWeight.w600),
              ),
              
              4.verticalSpace,
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  booking['status'].toUpperCase(),
                  style: montserrat(10, statusColor, FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveDriversSection(List<Map<String, dynamic>> drivers, AppLocalizations l10n, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Active Drivers',
              style: montserrat(20, grey36, FontWeight.w600),
            ),
            
            Spacer(),
            
            GestureDetector(
              onTap: () {
                if (context.mounted) {
                  context.push('/company_driver_management');
                }
              },
              child: Text(
                'View All',
                style: montserrat(14, accentPurple, FontWeight.w600),
              ),
            ),
            
            8.horizontalSpace,
            
            GestureDetector(
              onTap: () {
                if (context.mounted) {
                  context.push('/company_driver_management');
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: accentPurple,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Add Driver',
                  style: montserrat(12, Colors.white, FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        
        16.verticalSpace,
        
        ...drivers.map((driver) => _buildDriverCard(driver, l10n)),
      ],
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver, AppLocalizations l10n) {
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
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: accentPurple.withOpacity(0.1),
            child: Text(
              driver['name'].substring(0, 1),
              style: montserrat(16, accentPurple, FontWeight.w600),
            ),
          ),
          
          16.horizontalSpace,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver['name'],
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                
                4.verticalSpace,
                
                Text(
                  driver['currentLocation'],
                  style: montserrat(14, grey5F63, FontWeight.w400),
                ),
                
                4.verticalSpace,
                
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14.sp,
                    ),
                    4.horizontalSpace,
                    Text(
                      '${driver['rating']}',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    8.horizontalSpace,
                    Text(
                      '${driver['totalTrips']} trips',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              
              8.verticalSpace,
              
              Text(
                driver['status'].toUpperCase(),
                style: montserrat(10, statusColor, FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
