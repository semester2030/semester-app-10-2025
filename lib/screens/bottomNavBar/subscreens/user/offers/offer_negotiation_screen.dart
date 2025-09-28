import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class OfferNegotiationScreen extends HookConsumerWidget {
  final Map<String, dynamic> offer;
  final Map<String, dynamic> driver;
  
  const OfferNegotiationScreen({
    super.key,
    required this.offer,
    required this.driver,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state
    final messageController = useTextEditingController();
    final counterOfferController = useTextEditingController();
    final negotiationHistory = useState<List<Map<String, dynamic>>>([]);

    // Mock negotiation history
    useEffect(() {
      negotiationHistory.value = [
        {
          'id': '1',
          'sender': 'driver',
          'message': 'I can provide this service for 45 SAR. I have 5 years experience.',
          'amount': '45.00',
          'timestamp': '2 hours ago',
        },
        {
          'id': '2',
          'sender': 'user',
          'message': 'That sounds good. Can you do 40 SAR?',
          'amount': '40.00',
          'timestamp': '1 hour ago',
        },
        {
          'id': '3',
          'sender': 'driver',
          'message': 'I can meet you at 42 SAR. That\'s my best offer.',
          'amount': '42.00',
          'timestamp': '30 minutes ago',
        },
      ];
      return null;
    }, []);

    Future<void> sendMessage() async {
      if (messageController.text.trim().isEmpty) return;

      // Add message to history
      final newMessage = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': 'user',
        'message': messageController.text.trim(),
        'amount': null,
        'timestamp': 'Just now',
      };
      
      negotiationHistory.value = [...negotiationHistory.value, newMessage];
      messageController.clear();
    }

    Future<void> sendCounterOffer() async {
      if (counterOfferController.text.trim().isEmpty) return;

      // Add counter offer to history
      final newCounterOffer = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': 'user',
        'message': 'Counter offer: ${counterOfferController.text} SAR',
        'amount': counterOfferController.text.trim(),
        'timestamp': 'Just now',
      };
      
      negotiationHistory.value = [...negotiationHistory.value, newCounterOffer];
      counterOfferController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Negotiation'),
            Text(
              driver['driverName'],
              style: montserrat(12, Colors.white70, FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Call driver logic
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Offer Summary
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.grey[50],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundImage: NetworkImage(driver['driverImage']),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver['driverName'],
                        style: montserrat(16, grey36, FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14.sp, color: Colors.amber),
                          4.horizontalSpace,
                          Text(
                            '${driver['driverRating']}',
                            style: montserrat(14, grey5F63, FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Original Offer',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    Text(
                      '${offer['amount']} ${offer['currency']}',
                      style: montserrat(16, accentPurple, FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Negotiation History
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: negotiationHistory.value.length,
              itemBuilder: (context, index) {
                final message = negotiationHistory.value[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Input Section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Counter Offer Input
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: counterOfferController,
                        titleText: 'Counter Offer',
                        hintText: 'Enter amount',
                        prefixIcon: AppIcons.carIcon,
                      ),
                    ),
                    12.horizontalSpace,
                    ElevatedButton(
                      onPressed: sendCounterOffer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: montserrat(12, Colors.white, FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,

                // Message Input
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: messageController,
                        titleText: 'Message',
                        hintText: 'Type your message...',
                        prefixIcon: AppIcons.carIcon,
                      ),
                    ),
                    12.horizontalSpace,
                    ElevatedButton(
                      onPressed: sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Send',
                        style: montserrat(12, Colors.white, FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['sender'] == 'user';
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundImage: NetworkImage(driver['driverImage']),
            ),
            8.horizontalSpace,
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isUser ? accentPurple : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r).copyWith(
                  bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message['amount'] != null) ...[
                    Text(
                      '${message['amount']} SAR',
                      style: montserrat(
                        16,
                        isUser ? Colors.white : accentPurple,
                        FontWeight.w700,
                      ),
                    ),
                    8.verticalSpace,
                  ],
                  Text(
                    message['message'],
                    style: montserrat(
                      14,
                      isUser ? Colors.white : grey36,
                      FontWeight.w400,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    message['timestamp'],
                    style: montserrat(
                      12,
                      isUser ? Colors.white70 : grey5F63,
                      FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            8.horizontalSpace,
            CircleAvatar(
              radius: 16.r,
              backgroundColor: accentPurple,
              child: Icon(
                Icons.person,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
