import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class OfferDetailsScreen extends HookConsumerWidget {
  final Map<String, dynamic> offer;
  
  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state
    final responses = useState<List<Map<String, dynamic>>>([]);
    final selectedResponse = useState<Map<String, dynamic>?>(null);

    // Mock responses data
    useEffect(() {
      responses.value = [
        {
          'id': '1',
          'driverName': 'Ahmed Al-Rashid',
          'driverRating': 4.8,
          'driverImage': 'https://example.com/ahmed.jpg',
          'proposedAmount': '45.00',
          'message': 'I can provide this service for 45 SAR. I have 5 years experience.',
          'responseTime': '2 hours ago',
          'status': 'pending',
        },
        {
          'id': '2',
          'driverName': 'Sara Al-Mansouri',
          'driverRating': 4.9,
          'driverImage': 'https://example.com/sara.jpg',
          'proposedAmount': '48.00',
          'message': 'I offer professional transport service. Available immediately.',
          'responseTime': '1 hour ago',
          'status': 'pending',
        },
        {
          'id': '3',
          'driverName': 'Mohammed Al-Zahra',
          'driverRating': 4.7,
          'driverImage': 'https://example.com/mohammed.jpg',
          'proposedAmount': '50.00',
          'message': 'I can match your price exactly. Very reliable service.',
          'responseTime': '30 minutes ago',
          'status': 'accepted',
        },
      ];
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Offer Details'),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Edit offer logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Offer Header
              _buildOfferHeader(),
              24.verticalSpace,

              // Offer Details
              _buildOfferDetails(),
              24.verticalSpace,

              // Responses Section
              _buildResponsesSection(responses.value, selectedResponse.value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentPurple.withOpacity(0.1),
            accentPurple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentPurple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  offer['title'],
                  style: montserrat(20, grey36, FontWeight.w700),
                ),
              ),
              _buildStatusChip(offer['status']),
            ],
          ),
          12.verticalSpace,
          Text(
            '${offer['amount']} ${offer['currency']}',
            style: montserrat(24, accentPurple, FontWeight.w800),
          ),
          8.verticalSpace,
          Row(
            children: [
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
              8.horizontalSpace,
              if (offer['negotiable'])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'NEGOTIABLE',
                    style: montserrat(12, Colors.green, FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferDetails() {
    return Container(
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
          Text(
            'Offer Details',
            style: montserrat(18, grey36, FontWeight.w600),
          ),
          16.verticalSpace,
          _buildDetailRow('Created', offer['createdAt']),
          _buildDetailRow('Valid Until', offer['validUntil']),
          _buildDetailRow('Responses', '${offer['responses']} drivers'),
          _buildDetailRow('Type', offer['type'].toUpperCase()),
          _buildDetailRow('Negotiable', offer['negotiable'] ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: montserrat(14, grey5F63, FontWeight.w500),
            ),
          ),
          Text(
            ':',
            style: montserrat(14, grey5F63, FontWeight.w500),
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              value,
              style: montserrat(14, grey36, FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsesSection(List<Map<String, dynamic>> responses, Map<String, dynamic>? selectedResponse) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Driver Responses',
              style: montserrat(18, grey36, FontWeight.w600),
            ),
            8.horizontalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${responses.length}',
                style: montserrat(14, accentPurple, FontWeight.w600),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        if (responses.isEmpty)
          _buildEmptyResponses()
        else
          ...responses.map((response) => _buildResponseCard(response, selectedResponse)),
      ],
    );
  }

  Widget _buildEmptyResponses() {
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.message_outlined,
            size: 48.sp,
            color: grey5F63,
          ),
          16.verticalSpace,
          Text(
            'No Responses Yet',
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          8.verticalSpace,
          Text(
            'Drivers will respond to your offer here',
            style: montserrat(14, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard(Map<String, dynamic> response, Map<String, dynamic>? selectedResponse) {
    final isSelected = selectedResponse?['id'] == response['id'];
    final isAccepted = response['status'] == 'accepted';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isSelected ? accentPurple.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? accentPurple : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Info
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(response['driverImage']),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response['driverName'],
                      style: montserrat(16, grey36, FontWeight.w600),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, size: 16.sp, color: Colors.amber),
                        4.horizontalSpace,
                        Text(
                          '${response['driverRating']}',
                          style: montserrat(14, grey5F63, FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isAccepted)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'ACCEPTED',
                    style: montserrat(12, Colors.green, FontWeight.w600),
                  ),
                ),
            ],
          ),
          16.verticalSpace,

          // Proposed Amount
          Row(
            children: [
              Text(
                'Proposed: ',
                style: montserrat(14, grey5F63, FontWeight.w500),
              ),
              Text(
                '${response['proposedAmount']} SAR',
                style: montserrat(16, accentPurple, FontWeight.w700),
              ),
            ],
          ),
          12.verticalSpace,

          // Message
          Text(
            response['message'],
            style: montserrat(14, grey36, FontWeight.w400),
          ),
          12.verticalSpace,

          // Time and Actions
          Row(
            children: [
              Text(
                response['responseTime'],
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
              Spacer(),
              if (!isAccepted) ...[
                OutlinedButton(
                  onPressed: () {
                    // Reject response
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: montserrat(12, Colors.red, FontWeight.w600),
                  ),
                ),
                8.horizontalSpace,
                ElevatedButton(
                  onPressed: () {
                    // Accept response
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: montserrat(12, Colors.white, FontWeight.w600),
                  ),
                ),
              ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: montserrat(12, color, FontWeight.w600),
      ),
    );
  }
}
