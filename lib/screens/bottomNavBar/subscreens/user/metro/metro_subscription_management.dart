import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class MetroSubscriptionManagementScreen extends HookConsumerWidget {
  const MetroSubscriptionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // Local state
    final activeSubscriptions = useState<List<Map<String, dynamic>>>([]);
    final selectedSubscription = useState<Map<String, dynamic>?>(null);

    // Sample subscription data
    final sampleSubscriptions = [
      {
        'id': '1',
        'route': 'Home → Union Square Station',
        'schedule': 'Mon-Fri, 8:00 AM - 6:00 PM',
        'status': 'active',
        'startDate': '2024-01-01',
        'endDate': '2024-01-31',
        'price': '250 SAR',
        'driver': {
          'name': 'Ahmed Al-Rashid',
          'rating': 4.8,
          'vehicle': 'Toyota Camry',
          'phone': '+966501234567',
        },
        'nextRide': 'Today, 8:00 AM',
      },
      {
        'id': '2',
        'route': 'Home → Central Station',
        'schedule': 'Mon-Fri, 7:30 AM - 5:30 PM',
        'status': 'paused',
        'startDate': '2024-01-15',
        'endDate': '2024-02-15',
        'price': '300 SAR',
        'driver': {
          'name': 'Sara Al-Mansouri',
          'rating': 4.9,
          'vehicle': 'Honda Accord',
          'phone': '+966507654321',
        },
        'nextRide': 'Paused',
      },
    ];

    // Initialize subscriptions
    useEffect(() {
      activeSubscriptions.value = sampleSubscriptions;
      return null;
    }, []);

    void onSubscriptionSelected(Map<String, dynamic> subscription) {
      selectedSubscription.value = subscription;
    }

    void onPauseSubscription(String subscriptionId) {
      // TODO: Implement pause functionality
      showSuccessFlushBar(
        message: 'Subscription paused',
        context: context,
      );
    }

    void onResumeSubscription(String subscriptionId) {
      // TODO: Implement resume functionality
      showSuccessFlushBar(
        message: 'Subscription resumed',
        context: context,
      );
    }

    void onCancelSubscription(String subscriptionId) {
      // TODO: Implement cancel functionality
      showSuccessFlushBar(
        message: 'Subscription cancelled',
        context: context,
      );
    }

    void onEditSubscription(Map<String, dynamic> subscription) {
      // TODO: Navigate to edit screen
      context.push('/metro_route_setup', extra: {'edit': true, 'subscription': subscription});
    }

    void onAddNewSubscription() {
      context.push('/metro_route_setup');
    }

    return ScreenWithTopAppbar(
      title: 'Metro Subscriptions',
      child: Column(
        children: [
          // Header with add button
          Container(
            padding: EdgeInsets.all(24.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Subscriptions',
                        style: montserrat(24, grey36, FontWeight.w600),
                      ),
                      8.verticalSpace,
                      Text(
                        'Manage your metro rides',
                        style: montserrat(16, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                
                // Add new subscription button
                GestureDetector(
                  onTap: onAddNewSubscription,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: accentPurple,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Subscriptions list
          Expanded(
            child: activeSubscriptions.value.isEmpty
                ? _buildEmptyState(context, l10n)
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: activeSubscriptions.value.length,
                    itemBuilder: (context, index) {
                      final subscription = activeSubscriptions.value[index];
                      return _buildSubscriptionCard(
                        subscription: subscription,
                        isSelected: selectedSubscription.value?['id'] == subscription['id'],
                        onTap: () => onSubscriptionSelected(subscription),
                        onPause: () => onPauseSubscription(subscription['id']),
                        onResume: () => onResumeSubscription(subscription['id']),
                        onCancel: () => onCancelSubscription(subscription['id']),
                        onEdit: () => onEditSubscription(subscription),
                      );
                    },
                  ),
          ),
        ],
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
              Icons.directions_subway,
              size: 60.sp,
              color: accentPurple,
            ),
          ),
          
          24.verticalSpace,
          
          Text(
            'No Subscriptions',
            style: montserrat(20, grey36, FontWeight.w600),
          ),
          
          8.verticalSpace,
          
          Text(
            'Create your first subscription',
            style: montserrat(16, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          
          32.verticalSpace,
          
          NormalCustomButton(
            label: 'Create Subscription',
            onPressed: () => context.push('/metro_route_setup'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required Map<String, dynamic> subscription,
    required bool isSelected,
    required VoidCallback onTap,
    required VoidCallback onPause,
    required VoidCallback onResume,
    required VoidCallback onCancel,
    required VoidCallback onEdit,
  }) {
    final status = subscription['status'];
    final isActive = status == 'active';
    final isPaused = status == 'paused';
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? accentPurple.withOpacity(0.05) : Colors.white,
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
            // Header with status
            Row(
              children: [
                Expanded(
                  child: Text(
                    subscription['route'],
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                ),
                
                _buildStatusChip(status),
              ],
            ),
            
            8.verticalSpace,
            
            // Schedule
            Text(
              subscription['schedule'],
              style: montserrat(14, grey5F63, FontWeight.w400),
            ),
            
            16.verticalSpace,
            
            // Driver info
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: accentPurple.withOpacity(0.1),
                  child: Text(
                    subscription['driver']['name'].substring(0, 1),
                    style: montserrat(16, accentPurple, FontWeight.w600),
                  ),
                ),
                
                12.horizontalSpace,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription['driver']['name'],
                        style: montserrat(14, grey36, FontWeight.w600),
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
                            '${subscription['driver']['rating']}',
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                          8.horizontalSpace,
                          Text(
                            subscription['driver']['vehicle'],
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Next ride info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Ride',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    4.verticalSpace,
                    Text(
                      subscription['nextRide'],
                      style: montserrat(12, isActive ? accentPurple : grey5F63, FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            
            16.verticalSpace,
            
            // Price and actions
            Row(
              children: [
                Text(
                  subscription['price'],
                  style: montserrat(18, accentPurple, FontWeight.w600),
                ),
                
                Spacer(),
                
                // Action buttons
                if (isActive) ...[
                  _buildActionButton(
                    icon: Icons.pause,
                    label: 'Pause',
                    onTap: onPause,
                    color: Colors.orange,
                  ),
                  
                  8.horizontalSpace,
                ] else if (isPaused) ...[
                  _buildActionButton(
                    icon: Icons.play_arrow,
                    label: 'Resume',
                    onTap: onResume,
                    color: Colors.green,
                  ),
                  
                  8.horizontalSpace,
                ],
                
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit',
                  onTap: onEdit,
                  color: accentPurple,
                ),
                
                8.horizontalSpace,
                
                _buildActionButton(
                  icon: Icons.cancel,
                  label: 'Cancel',
                  onTap: onCancel,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
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
      case 'paused':
        color = Colors.orange;
        label = 'Paused';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelled';
        break;
      default:
        color = Colors.grey;
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
}
