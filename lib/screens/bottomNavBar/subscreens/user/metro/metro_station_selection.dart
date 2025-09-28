import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class MetroStationSelectionScreen extends HookConsumerWidget {
  const MetroStationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Local state
    final searchController = useTextEditingController();
    final selectedStation = useState<Map<String, dynamic>?>(null);
    final filteredStations = useState<List<Map<String, dynamic>>>([]);

    // Sample metro stations data
    final metroStations = [
      {
        'id': '1',
        'name': 'Union Square Station',
        'line': 'Red Line',
        'distance': '2.5 km',
        'estimatedTime': '15 min',
        'isAccessible': true,
        'facilities': ['Parking', 'Elevator', 'Ramp'],
      },
      {
        'id': '2',
        'name': 'Central Station',
        'line': 'Blue Line',
        'distance': '3.2 km',
        'estimatedTime': '18 min',
        'isAccessible': true,
        'facilities': ['Parking', 'Elevator', 'Ramp', 'WiFi'],
      },
      {
        'id': '3',
        'name': 'West End Station',
        'line': 'Green Line',
        'distance': '4.1 km',
        'estimatedTime': '22 min',
        'isAccessible': false,
        'facilities': ['Parking'],
      },
      {
        'id': '4',
        'name': 'East Gate Station',
        'line': 'Red Line',
        'distance': '1.8 km',
        'estimatedTime': '12 min',
        'isAccessible': true,
        'facilities': ['Elevator', 'Ramp', 'WiFi'],
      },
      {
        'id': '5',
        'name': 'North Terminal Station',
        'line': 'Blue Line',
        'distance': '5.5 km',
        'estimatedTime': '28 min',
        'isAccessible': true,
        'facilities': ['Parking', 'Elevator', 'Ramp', 'WiFi', 'Restroom'],
      },
    ];

    // Initialize filtered stations
    useEffect(() {
      filteredStations.value = metroStations;
      return null;
    }, []);

    // Search functionality
    void onSearchChanged(String query) {
      if (query.isEmpty) {
        filteredStations.value = metroStations;
      } else {
        filteredStations.value = metroStations.where((station) {
          return station['name']?.toString().toLowerCase().contains(query.toLowerCase()) == true ||
                 station['line']?.toString().toLowerCase().contains(query.toLowerCase()) == true;
        }).toList();
      }
    }

    void onStationSelected(Map<String, dynamic> station) {
      selectedStation.value = station;
    }

    Future<void> onContinuePressed() async {
      if (selectedStation.value == null) {
        showErrorFlushBar(
          message: 'Please select a station',
          context: context,
        );
        return;
      }

      // Navigate back with selected station
      context.pop(selectedStation.value);
    }

    return ScreenWithTopAppbar(
      title: 'Select Metro Station',
      child: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(24.w),
            child: CustomTextField(
              controller: searchController,
              titleText: 'Search Stations',
              hintText: 'Search stations',
              prefixIcon: AppIcons.searchIcon,
            ),
          ),
          
          // Stations list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: filteredStations.value.length,
              itemBuilder: (context, index) {
                final station = filteredStations.value[index];
                final isSelected = selectedStation.value?['id'] == station['id'];
                
                return _buildStationCard(
                  station: station,
                  isSelected: isSelected,
                  onTap: () => onStationSelected(station),
                );
              },
            ),
          ),
          
          // Continue button
          if (selectedStation.value != null)
            Container(
              padding: EdgeInsets.all(24.w),
            child: NormalCustomButton(
              label: 'Continue',
              onPressed: onContinuePressed,
            ),
            ),
        ],
      ),
    );
  }

  Widget _buildStationCard({
    required Map<String, dynamic> station,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? accentPurple : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Station name and line
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: isSelected ? accentPurple : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppIcons.metroIcon,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
                
                16.horizontalSpace,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'],
                        style: montserrat(
                          16,
                          isSelected ? accentPurple : grey36,
                          FontWeight.w600,
                        ),
                      ),
                      
                      4.verticalSpace,
                      
                      Text(
                        station['line'],
                        style: montserrat(
                          14,
                          isSelected ? accentPurple : grey5F63,
                          FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selection indicator
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: accentPurple,
                    size: 24.sp,
                  ),
              ],
            ),
            
            16.verticalSpace,
            
            // Distance and time info
            Row(
              children: [
                _buildInfoChip(
                  icon: AppIcons.locationIcon,
                  text: station['distance'],
                ),
                
                12.horizontalSpace,
                
                _buildInfoChip(
                  icon: AppIcons.clockIcon,
                  text: station['estimatedTime'],
                ),
                
                12.horizontalSpace,
                
                if (station['isAccessible'])
                  _buildInfoChip(
                    icon: AppIcons.accessibilityIcon,
                    text: 'Accessible',
                    color: Colors.green,
                  ),
              ],
            ),
            
            12.verticalSpace,
            
            // Facilities
            if (station['facilities'].isNotEmpty) ...[
              Text(
                'Facilities',
                style: montserrat(12, grey5F63, FontWeight.w500),
              ),
              
              8.verticalSpace,
              
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: (station['facilities'] as List<String>).map((facility) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: accentPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      facility,
                      style: montserrat(10, accentPurple, FontWeight.w500),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String text,
    Color? color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (color ?? accentPurple).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            color: color ?? accentPurple,
            width: 12.w,
            height: 12.h,
          ),
          
          4.horizontalSpace,
          
          Text(
            text,
            style: montserrat(
              12,
              color ?? accentPurple,
              FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
