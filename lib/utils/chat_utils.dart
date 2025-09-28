import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

/// Global utility class for chat-related functions
class ChatUtils {
  /// Generates a consistent thread ID for chat between two users
  /// This function ensures that the same thread ID is generated
  /// regardless of which user initiates the chat
  static String generateThreadId(String user1, String user2) {
    // Sort the user IDs alphabetically to ensure consistent thread ID
    List<String> users = [user1, user2];
    users.sort(); // Ensures consistent order regardless of who initiates
    return '${users[0]}${users[1]}'; // Concatenate sorted IDs
  }

  /// Global function to start a chat with another user
  /// This function should be used throughout the app to ensure consistency
  static void startChat({
    required BuildContext context,
    required UserSignupModel otherUser,
    required WidgetRef ref,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to start chat'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final otherUserId = otherUser.id;

    if (otherUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to start chat: User ID not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Generate consistent thread ID
    final threadId = generateThreadId(currentUserId, otherUserId);

    // Navigate to chat screen
    _navigateToChatDetail(context, ref, otherUser, threadId);
  }

  /// Internal method to navigate to chat detail screen
  static void _navigateToChatDetail(
    BuildContext context,
    WidgetRef ref,
    UserSignupModel otherUser,
    String chatRoomId,
  ) {
    // Include the chat information in the navigation
    final extraData = {
      'threadId': chatRoomId,
      'otherUser': otherUser,
    };

    context.push('/chatting', extra: extraData);
  }

  /// Utility method to start chat with a user by their ID
  /// This is useful when you only have the user ID and need to fetch user data first
  static Future<void> startChatWithUserId({
    required BuildContext context,
    required String otherUserId,
    required WidgetRef ref,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to start chat'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Here you would typically fetch the user data from your user service
      // For now, we'll show a loading state and let the calling code handle user fetching
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loading user details...'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting chat: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
