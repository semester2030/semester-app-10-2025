import 'dart:developer';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class EnhancedMapScreen extends HookConsumerWidget {
  const EnhancedMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Local state
    final mapController = useState<GoogleMapController?>(null);
    final markers = useState<Set<Marker>>({});
    final selectedCompany = useState<Map<String, dynamic>?>(null);
    final companies = useState<List<Map<String, dynamic>>>([]);
    final isLoading = useState<bool>(true);

    // Mock companies data
    useEffect(() {
      companies.value = [
        {
          'id': '1',
          'name': 'Riyadh Transport Co.',
          'fleetCount': 25,
          'activeDrivers': 18,
          'rating': 4.8,
          'position': LatLng(24.7136, 46.6753),
          'color': Colors.blue,
          'isOnline': true,
        },
        {
          'id': '2',
          'name': 'Saudi Fleet Services',
          'fleetCount': 42,
          'activeDrivers': 35,
          'rating': 4.6,
          'position': LatLng(24.7200, 46.6800),
          'color': Colors.green,
          'isOnline': true,
        },
        {
          'id': '3',
          'name': 'Metro Shuttle Co.',
          'fleetCount': 15,
          'activeDrivers': 12,
          'rating': 4.9,
          'position': LatLng(24.7100, 46.6700),
          'color': Colors.purple,
          'isOnline': false,
        },
      ];
      isLoading.value = false;
      return null;
    }, []);

    // Update markers when companies change
    useEffect(() {
      _updateMarkers(companies.value, markers);
      return null;
    }, [companies.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setting),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, companies.value, l10n);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(24.7136, 46.6753), // Riyadh center
              zoom: 12.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController.value = controller;
            },
            markers: markers.value,
            onTap: (LatLng position) {
              selectedCompany.value = null;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          ),

          // Company Info Panel
          if (selectedCompany.value != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCompanyInfoPanel(selectedCompany.value!, l10n),
            ),

          // Loading Overlay
          if (isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: accentPurple,
                ),
              ),
            ),

          // Company List Button
          Positioned(
            top: 16.h,
            right: 16.w,
            child: FloatingActionButton(
              onPressed: () => _showCompanyList(context, companies.value, l10n),
              backgroundColor: accentPurple,
              child: Icon(Icons.list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMarkers(List<Map<String, dynamic>> companies, ValueNotifier<Set<Marker>> markers) {
    Set<Marker> newMarkers = {};

    for (final company in companies) {
      final position = company['position'] as LatLng;
      final isOnline = company['isOnline'] as bool;
      
      newMarkers.add(
        Marker(
          markerId: MarkerId('company_${company['id']}'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isOnline ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
          ),
          infoWindow: InfoWindow(
            title: company['name'],
            snippet: '${company['fleetCount']} vehicles • ${company['activeDrivers']} active',
          ),
          onTap: () {
            // Handle marker tap
            log('Company tapped: ${company['name']}');
          },
        ),
      );
    }

    markers.value = newMarkers;
  }

  Widget _buildCompanyInfoPanel(Map<String, dynamic> company, AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              IconButton(
                onPressed: () {
                  // Close panel
                },
                icon: Icon(Icons.close, color: grey5F63),
              ),
            ],
          ),
          16.verticalSpace,

          // Company Stats
          Row(
            children: [
              _buildStatItem(
                icon: Icons.local_shipping,
                label: l10n.personalInformation,
                value: '${company['fleetCount']}',
                color: company['color'],
              ),
              24.horizontalSpace,
              _buildStatItem(
                icon: Icons.person,
                label: l10n.driver,
                value: '${company['activeDrivers']}',
                color: Colors.green,
              ),
              24.horizontalSpace,
              _buildStatItem(
                icon: Icons.star,
                label: l10n.reviews,
                value: '${company['rating']}',
                color: Colors.amber,
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
                    l10n.search,
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
                    l10n.continueButton,
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

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24.sp),
        8.verticalSpace,
        Text(
          value,
          style: montserrat(16, grey36, FontWeight.w700),
        ),
        4.verticalSpace,
        Text(
          label,
          style: montserrat(12, grey5F63, FontWeight.w500),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context, List<Map<String, dynamic>> companies, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.search),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.language),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text(l10n.reviews),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text(l10n.personalInformation),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.continueButton),
          ),
        ],
      ),
    );
  }

  void _showCompanyList(BuildContext context, List<Map<String, dynamic>> companies, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            16.verticalSpace,
            Text(
            l10n.search,
              style: montserrat(20, grey36, FontWeight.w700),
            ),
            16.verticalSpace,
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return _buildCompanyListItem(company, l10n);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyListItem(Map<String, dynamic> company, AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: company['isOnline'] ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company['name'],
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Icon(Icons.local_shipping, size: 14.sp, color: grey5F63),
                    4.horizontalSpace,
                    Text(
                  '${company['fleetCount']}',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    16.horizontalSpace,
                    Icon(Icons.person, size: 14.sp, color: grey5F63),
                    4.horizontalSpace,
                    Text(
                  '${company['activeDrivers']}',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
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
              8.verticalSpace,
              ElevatedButton(
                onPressed: () {
                  // Handle company selection
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  minimumSize: Size(80.w, 32.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  l10n.continueButton,
                  style: montserrat(12, Colors.white, FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 