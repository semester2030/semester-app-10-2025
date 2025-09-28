import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/models/offer_model.dart';
import 'package:semester_student_ride_app/services/offer_service.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';

class OffersListScreen extends HookConsumerWidget {
  final Map<String, dynamic> requestData;

  const OffersListScreen({
    super.key,
    required this.requestData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final offerService = OfferService();
    
    // Get service type from request data
    final serviceType = TransportationServiceType.values.firstWhere(
      (type) => type.toString() == requestData['serviceType'],
      orElse: () => TransportationServiceType.student,
    );
    
    // State
    final selectedSort = useState('closest');
    final offersCount = useState(0);
    final isLoading = useState(true);
    final offers = useState<List<OfferModel>>([]);

    // Create request and get offers
    useEffect(() {
      Future.microtask(() async {
        try {
          isLoading.value = true;
          
          // Create request
          final request = offerService.bookingStateToRequest(
            'current_user_id', // This should come from auth
            'request_${DateTime.now().millisecondsSinceEpoch}',
            requestData,
          );
          
          final requestId = await offerService.createRequest(request);
          
          // Broadcast request
          await offerService.broadcastRequest(requestId, requestData['searchRadius'] ?? 5.0);
          
          // Listen to offers
          offerService.getOffersForRequest(requestId).listen((offersList) {
            offers.value = offersList;
            offersCount.value = offersList.length;
            isLoading.value = false;
          });
        } catch (e) {
          isLoading.value = false;
          showErrorFlushBar(
            message: 'Failed to create request: $e',
            context: context,
          );
        }
      });
      return null;
    }, []);

    return ScreenWithTopAppbar(
      title: l10n.availableOffers,
      child: Column(
        children: [
          // Header with count and sort
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${offersCount.value} ${l10n.offersReceived}',
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                _buildSortDropdown(context, selectedSort),
              ],
            ),
          ),
          
          // Offers list
          Expanded(
            child: isLoading.value
                ? _buildLoadingState(context)
                : offers.value.isEmpty
                    ? _buildEmptyState(context)
                    : _buildOffersList(context, offers.value, selectedSort.value, offerService, serviceType),
          ),
        ],
      ),
    );
  }

  Widget _buildSortDropdown(BuildContext context, ValueNotifier<String> selectedSort) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 40.h,
      width: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSort.value,
          isExpanded: true,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          items: [
            DropdownMenuItem(value: 'closest', child: Text(l10n.closest, style: montserrat(12, grey36, FontWeight.w500))),
            DropdownMenuItem(value: 'cheapest', child: Text(l10n.cheapest, style: montserrat(12, grey36, FontWeight.w500))),
            DropdownMenuItem(value: 'top_rated', child: Text(l10n.topRated, style: montserrat(12, grey36, FontWeight.w500))),
          ],
          onChanged: (value) {
            if (value != null) {
              selectedSort.value = value;
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: accentPurple),
          16.verticalSpace,
          Text(
            l10n.searchingForProviders,
            style: montserrat(16, grey36, FontWeight.w500),
          ),
          8.verticalSpace,
          Text(
            l10n.mayTakeUpTo30Seconds,
            style: montserrat(14, grey5F63, FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: grey5F63),
          16.verticalSpace,
          Text(
            l10n.noOffersReceivedYet,
            style: montserrat(18, grey36, FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            l10n.providersHave30MinutesToRespond,
            style: montserrat(14, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOffersList(BuildContext context, List<OfferModel> offers, String sortBy, OfferService offerService, TransportationServiceType serviceType) {
    // Sort offers based on selected criteria
    List<OfferModel> sortedOffers = List.from(offers);
    switch (sortBy) {
      case 'closest':
        sortedOffers.sort((a, b) => a.etaMinutes.compareTo(b.etaMinutes));
        break;
      case 'cheapest':
        sortedOffers.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'top_rated':
        sortedOffers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: sortedOffers.length,
      itemBuilder: (context, index) {
        final offer = sortedOffers[index];
        return _buildOfferCard(context, offer, offerService, serviceType);
      },
    );
  }

  Widget _buildOfferCard(BuildContext context, OfferModel offer, OfferService offerService, TransportationServiceType serviceType) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with ETA and distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp, color: accentPurple),
                  4.horizontalSpace,
                  Text(
                    '${offer.etaMinutes} min',
                    style: montserrat(14, accentPurple, FontWeight.w600),
                  ),
                  16.horizontalSpace,
                  Icon(Icons.location_on, size: 16.sp, color: grey5F63),
                  4.horizontalSpace,
                  Text(
                    '${offer.distanceKm.toStringAsFixed(1)} km',
                    style: montserrat(14, grey5F63, FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  offer.providerType == 'individual' ? l10n.individual : l10n.company,
                  style: montserrat(12, accentPurple, FontWeight.w600),
                ),
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Provider info
          Row(
            children: [
              // Provider photo
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(offer.providerPhoto),
                backgroundColor: Colors.grey[300],
              ),
              12.horizontalSpace,
              
              // Provider details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.providerName,
                      style: montserrat(16, grey36, FontWeight.w600),
                    ),
                    4.verticalSpace,
                    
                    Row(
                      children: [
                        Icon(Icons.star, size: 16.sp, color: Colors.amber),
                        4.horizontalSpace,
                        Text(
                          offer.rating.toStringAsFixed(1),
                          style: montserrat(14, grey36, FontWeight.w500),
                        ),
                        8.horizontalSpace,
                        Text(
                          '• ${offer.tripsCount} ${l10n.trips}',
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SAR ${offer.price.toStringAsFixed(0)}',
                    style: montserrat(18, accentPurple, FontWeight.w700),
                  ),
                  Text(
                    offer.priceType == 'monthly' ? l10n.perMonth : l10n.perRide,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Vehicle info
          Row(
            children: [
              Icon(Icons.directions_car, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                '${offer.vehicleType} • ${offer.vehicleModel}',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
              16.horizontalSpace,
              Icon(Icons.people, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                '${offer.seats} ${l10n.seats}',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Badges
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildBadge(l10n.verified, Icons.verified, Colors.green),
              _buildBadge(l10n.liveTracking, Icons.gps_fixed, Colors.blue),
              _buildBadge(l10n.insured, Icons.security, Colors.orange),
              if (offer.providerType == 'individual')
                _buildBadge(l10n.femaleDriver, Icons.person, Colors.pink),
            ],
          ),
          
          16.verticalSpace,
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  l10n.accept,
                  Icons.check,
                  Colors.green,
                  () => _acceptOffer(context, offer, offerService, serviceType),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _buildActionButton(
                  l10n.negotiate,
                  Icons.handshake,
                  Colors.orange,
                  () => _negotiateOffer(offer),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _buildActionButton(
                  l10n.chat,
                  Icons.chat,
                  Colors.blue,
                  () => _chatWithProvider(offer),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _buildActionButton(
                  l10n.decline,
                  Icons.close,
                  Colors.red,
                  () => _declineOffer(offer, offerService),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          4.horizontalSpace,
          Text(
            text,
            style: montserrat(10, color, FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: color),
            4.horizontalSpace,
            Text(
              text,
              style: montserrat(12, color, FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptOffer(BuildContext context, OfferModel offer, OfferService offerService, TransportationServiceType serviceType) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await offerService.acceptOffer(offer.id);
      showSuccessFlushBar(
        message: l10n.offerAcceptedSuccessfully,
        context: context,
      );
      
      // Navigate to booking details with accepted offer
      context.push('/booking_details', extra: {
        'serviceType': serviceType,
        'acceptedOffer': offer.toJson(),
        'fromOffersList': true,
      });
    } catch (e) {
      showErrorFlushBar(
        message: '${l10n.failedToAcceptOffer}: $e',
        context: context,
      );
    }
  }

  // TransportationServiceType _getServiceTypeFromString(String serviceTypeString) {
  //   switch (serviceTypeString) {
  //     case 'TransportationServiceType.student':
  //       return TransportationServiceType.student;
  //     case 'TransportationServiceType.teacher':
  //       return TransportationServiceType.teacher;
  //     case 'TransportationServiceType.employee':
  //       return TransportationServiceType.employee;
  //     case 'TransportationServiceType.daily':
  //       return TransportationServiceType.daily;
  //     default:
  //       return TransportationServiceType.student;
  //   }
  // }

  void _negotiateOffer(OfferModel offer) {
    // Navigate to negotiation screen
  }

  void _chatWithProvider(OfferModel offer) {
    // Navigate to chat screen
  }

  void _declineOffer(OfferModel offer, OfferService offerService) async {
    try {
      await offerService.declineOffer(offer.id);
      // Handle success
    } catch (e) {
      // Handle error
    }
  }
}
