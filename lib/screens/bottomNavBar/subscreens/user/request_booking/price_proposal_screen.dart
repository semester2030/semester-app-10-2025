import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class PriceProposalScreen extends HookConsumerWidget {
  final TransportationServiceType serviceType;
  final bool showPriceSection;

  const PriceProposalScreen({
    super.key,
    required this.serviceType,
    this.showPriceSection = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingState = ref.watch(bookingFlowProvider);
    // final bookingNotifier = ref.read(bookingFlowProvider.notifier);

    // Pre-fill with booking state data
    useEffect(() {
      if (bookingState.pickupAddress != null && bookingState.dropOffAddress != null) {
        // Data is available from booking flow
        print('✅ Booking data available: ${bookingState.pickupAddress?.address} to ${bookingState.dropOffAddress?.address}');
      }
      return null;
    }, []);

    // Controllers
    final suggestedPriceController = useTextEditingController(text: '500');
    final priceType = useState('monthly');
    final subscriptionDays = useState('Sun-Thu');
    final departureTimes = useState('Morning & Evening');
    final seatsRequired = useState(1);
    final vehicleType = useState('Sedan Car');
    final rideType = useState('Private');
    final driverGender = useState('Any');
    final providerType = useState('Any');
    final minRating = useState(4.0);
    final searchRadius = useState(5.0);

    return ScreenWithTopAppbar(
      title: showPriceSection ? 'Price Proposal' : 'Trip Options',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              showPriceSection ? 'Set Your Price & Preferences' : 'Trip Options & Preferences',
              style: montserrat(24, grey36, FontWeight.w700),
            ),
            8.verticalSpace,
            Text(
              showPriceSection
                  ? 'Enter your suggested price and let providers compete for your business'
                  : 'Select your trip options first, then set your preferred price',
              style: montserrat(14, grey5F63, FontWeight.w400),
            ),

            24.verticalSpace,

            // Subscription Details (Trip schedule before price)
            _buildSubscriptionSection(
              subscriptionDays,
              departureTimes,
              l10n,
            ),

            24.verticalSpace,

            // Vehicle & Ride Preferences
            _buildVehicleSection(
              seatsRequired,
              vehicleType,
              rideType,
              l10n,
            ),

            24.verticalSpace,

            // Provider Preferences
            _buildProviderSection(
              driverGender,
              providerType,
              minRating,
              searchRadius,
              l10n,
            ),

            if (showPriceSection) ...[
              24.verticalSpace,
              // Price Section moved after options
              _buildPriceSection(
                suggestedPriceController,
                priceType,
                l10n,
              ),
              32.verticalSpace,
            ] else ...[
              24.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    // Save options and return to map; price remains on map only
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Save & Back',
                    style: montserrat(16, Colors.white, FontWeight.w600),
                  ),
                ),
              ),
              16.verticalSpace,
            ],

            // Search Button
            if (showPriceSection)
              SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => _searchForProviders(
                  context,
                  ref,
                  suggestedPriceController.text,
                  priceType.value,
                  subscriptionDays.value,
                  departureTimes.value,
                  seatsRequired.value,
                  vehicleType.value,
                  rideType.value,
                  driverGender.value,
                  providerType.value,
                  minRating.value,
                  searchRadius.value,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Search for Providers',
                  style: montserrat(16, Colors.white, FontWeight.w600),
                ),
              ),
            ),

            16.verticalSpace,

            // Info
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: accentPurple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: accentPurple, size: 20.sp),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      'Your request will be sent to providers within ${searchRadius.value.toInt()}km radius. They have 30 minutes to respond.',
                      style: montserrat(12, grey36, FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection(
    TextEditingController controller,
    ValueNotifier<String> priceType,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested Price',
          style: montserrat(18, grey36, FontWeight.w600),
        ),
        16.verticalSpace,
        
        Row(
          children: [
            Expanded(
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: borderGrey),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: montserrat(14, grey5F63, FontWeight.w400),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    prefixText: 'SAR ',
                    prefixStyle: montserrat(16, grey36, FontWeight.w600),
                  ),
                ),
              ),
            ),
            16.horizontalSpace,
            
            // Price Type Dropdown
            Container(
              height: 56.h,
              width: 120.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderGrey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: priceType.value,
                  isExpanded: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  items: ['monthly', 'per_ride'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value == 'monthly' ? 'Monthly' : 'Per Ride',
                        style: montserrat(14, grey36, FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      priceType.value = newValue;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection(
    ValueNotifier<String> subscriptionDays,
    ValueNotifier<String> departureTimes,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Details',
          style: montserrat(18, grey36, FontWeight.w600),
        ),
        16.verticalSpace,
        
        // Days of Week
        _buildDropdown(
          'Days of Week',
          subscriptionDays.value,
          ['Sun-Thu', 'Mon-Fri', 'Sat-Wed', 'Custom'],
          (value) => subscriptionDays.value = value!,
        ),
        
        16.verticalSpace,
        
        // Departure Times
        _buildDropdown(
          'Departure Times',
          departureTimes.value,
          ['Morning & Evening', 'Morning Only', 'Evening Only', 'Custom'],
          (value) => departureTimes.value = value!,
        ),
      ],
    );
  }

  Widget _buildVehicleSection(
    ValueNotifier<int> seatsRequired,
    ValueNotifier<String> vehicleType,
    ValueNotifier<String> rideType,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle & Ride Preferences',
          style: montserrat(18, grey36, FontWeight.w600),
        ),
        16.verticalSpace,
        
        // Seats Required
        _buildNumberInput(
          'Seats Required',
          seatsRequired.value.toString(),
          (value) => seatsRequired.value = int.tryParse(value) ?? 1,
        ),
        
        16.verticalSpace,
        
        // Vehicle Type
        _buildDropdown(
          'Vehicle Type',
          vehicleType.value,
          ['Sedan Car', 'Small Van', 'Small Bus', 'Bus (Large)'],
          (value) => vehicleType.value = value!,
        ),
        
        16.verticalSpace,
        
        // Ride Type
        _buildDropdown(
          'Ride Type',
          rideType.value,
          ['Private', 'Shared'],
          (value) => rideType.value = value!,
        ),
      ],
    );
  }

  Widget _buildProviderSection(
    ValueNotifier<String> driverGender,
    ValueNotifier<String> providerType,
    ValueNotifier<double> minRating,
    ValueNotifier<double> searchRadius,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Provider Preferences',
          style: montserrat(18, grey36, FontWeight.w600),
        ),
        16.verticalSpace,
        
        // Driver Gender
        _buildDropdown(
          'Driver Gender',
          driverGender.value,
          ['Any', 'Male', 'Female'],
          (value) => driverGender.value = value!,
        ),
        
        16.verticalSpace,
        
        // Provider Type
        _buildDropdown(
          'Provider Type',
          providerType.value,
          ['Any', 'Individual', 'Company'],
          (value) => providerType.value = value!,
        ),
        
        16.verticalSpace,
        
        // Minimum Rating
        _buildSlider(
          'Minimum Rating',
          minRating.value,
          1.0,
          5.0,
          (value) => minRating.value = value,
        ),
        
        16.verticalSpace,
        
        // Search Radius
        _buildSlider(
          'Search Radius (km)',
          searchRadius.value,
          1.0,
          20.0,
          (value) => searchRadius.value = value,
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String title,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        8.verticalSpace,
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInput(
    String title,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        8.verticalSpace,
        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderGrey),
          ),
          child: TextField(
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: value,
              hintStyle: montserrat(14, grey5F63, FontWeight.w400),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String title,
    double value,
    double min,
    double max,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: montserrat(14, grey36, FontWeight.w500),
            ),
            Text(
              value.toStringAsFixed(1),
              style: montserrat(14, accentPurple, FontWeight.w600),
            ),
          ],
        ),
        8.verticalSpace,
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).round(),
          activeColor: accentPurple,
          inactiveColor: borderGrey,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _searchForProviders(
    BuildContext context,
    WidgetRef ref,
    String suggestedPrice,
    String priceType,
    String subscriptionDays,
    String departureTimes,
    int seatsRequired,
    String vehicleType,
    String rideType,
    String driverGender,
    String providerType,
    double minRating,
    double searchRadius,
  ) {
    if (suggestedPrice.isEmpty) {
      showErrorFlushBar(
        message: 'Please enter a suggested price',
        context: context,
      );
      return;
    }

    final price = double.tryParse(suggestedPrice);
    if (price == null || price <= 0) {
      showErrorFlushBar(
        message: 'Please enter a valid price',
        context: context,
      );
      return;
    }

    // Get booking state data
    final bookingState = ref.read(bookingFlowProvider);
    
    // Validate required booking data
    if (bookingState.pickupAddress == null || bookingState.dropOffAddress == null) {
      showErrorFlushBar(
        message: 'Please complete address details first',
        context: context,
      );
      return;
    }

    // Show live offers in map screen; no separate offers list navigation
    context.pop();
    // Optionally, could trigger a provider flag to open offers section automatically.
    /*context.push('/offers_list', extra: {
      // Price and preferences
      'suggestedPrice': price,
      'priceType': priceType,
      'subscriptionDays': subscriptionDays,
      'departureTimes': departureTimes,
      'seatsRequired': seatsRequired,
      'vehicleType': vehicleType,
      'rideType': rideType,
      'driverGender': driverGender,
      'providerType': providerType,
      'minRating': minRating,
      'searchRadius': searchRadius,
      
      // Booking flow data
      'serviceType': serviceType.toString(),
      'pickupAddress': bookingState.pickupAddress!.address,
      'dropOffAddress': bookingState.dropOffAddress!.address,
      'city': bookingState.city,
      'schoolName': bookingState.schoolName,
      'areaDistrict': bookingState.areaDistrict,
      'selectedDate': bookingState.selectedDate,
      'startTime': bookingState.startTime,
      'endTime': bookingState.endTime,
      
      // Additional details
      'selectedVehicleType': bookingState.selectedVehicleType,
      'selectedServiceType': bookingState.selectedServiceType,
      'selectedTripType': bookingState.selectedTripType,
      'selectedDriverGender': bookingState.selectedDriverGender,
      'selectedSubscriptionPlan': 'monthly',
      'selectedWorkSchedule': bookingState.selectedWorkSchedule,
    });*/
  }
}
