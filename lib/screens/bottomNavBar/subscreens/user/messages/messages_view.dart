import 'dart:async';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/chatroom.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/screens/auth/login/top_curve_clipper.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/utils/rtl_helper.dart';
import 'package:semester_student_ride_app/widgets/circular_profile_image.dart';

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchController = useTextEditingController();
    final l10n = AppLocalizations.of(context)!;

    // State for managing chats
    final allChats = useState<List<ChatRoom>>([]);
    final filteredChats = useState<List<ChatRoom>>([]);
    final isLoading = useState(true);
    final currentUser = useState<UserSignupModel?>(null);

    // Initialize and fetch chats
    useEffect(() {
      StreamSubscription<QuerySnapshot>? subscription;

      // Get current user first
      _getCurrentUserData().then((user) {
        if (user != null) {
          currentUser.value = user;

          // Then fetch chats
          subscription = _fetchChats(allChats, filteredChats, isLoading);
        }
      });

      return () {
        subscription?.cancel();
      };
    }, []);

    // Filter chats based on search
    useEffect(() {
      final query = searchController.text.toLowerCase();
      if (query.isEmpty) {
        filteredChats.value = allChats.value;
      } else {
        filteredChats.value = allChats.value.where((chat) {
          // This is a simplified filter - in a real app you'd want to filter by actual user names
          return chat.lastMessage.toLowerCase().contains(query);
        }).toList();
      }
      return null;
    }, [searchController.text, allChats.value]);

    return Scaffold(
      backgroundColor: accentPurple,
      body: Stack(
        children: [
          SvgPicture.asset(
            AppImages.splashbackgroundSVG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top spacing
                50.verticalSpace,
                Text(
                  l10n.inbox,
                  style: montserrat(18, whiteColor, FontWeight.w600),
                ),

                70.verticalSpace,

                // Background container with upward circle curve using ClipPath
                ClipPath(
                  clipper: TopCurveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: containerbackground,
                    height: 750.h,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24.w, 100.h, 24.w, 32.h),
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                // Search field
                CustomTextField(
                  controller: searchController,
                  titleText: l10n.searchMessages,
                  letterSpacing: 1,
                  suffixIcon: Builder(
                    builder: (context) {
                      return Padding(
                        padding: context.paddingOnly(
                          left: context.isRTL ? 12.w : 0,
                          right: context.isRTL ? 0 : 12.w,
                        ),
                        child: SvgPicture.asset(AppIcons.search),
                      );
                    },
                  ),
                ),
                20.verticalSpace,

                // Messages header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.messages,
                      style: montserrat(14, grey36, FontWeight.w600),
                    ),
                  ],
                ),
                10.verticalSpace,

                // Messages list
                Expanded(
                  child: isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentPurple),
                          ),
                        )
                      : filteredChats.value.isEmpty
                          ? _buildEmptyState(l10n)
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: filteredChats.value.length,
                              itemBuilder: (context, index) {
                                final chat = filteredChats.value[index];
                                return _buildChatTile(
                                    context, chat, currentUser.value);
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fetch chats from Firestore
  StreamSubscription<QuerySnapshot> _fetchChats(
    ValueNotifier<List<ChatRoom>> allChats,
    ValueNotifier<List<ChatRoom>> filteredChats,
    ValueNotifier<bool> isLoading,
  ) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      isLoading.value = false;
      return const Stream<QuerySnapshot>.empty().listen((_) {});
    }

    return chatsCollection
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      try {
        final chats = snapshot.docs
            .map((doc) => ChatRoom.fromFirestore(doc))
            .where((chat) => chat.status == 'active') // Only show active chats
            .toList();

        allChats.value = chats;
        filteredChats.value = chats;
        isLoading.value = false;

        developer.log('Fetched ${chats.length} chats');
      } catch (e) {
        developer.log('Error fetching chats: $e');
        isLoading.value = false;
      }
    });
  }

  // Build empty state
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: grey5F63,
            size: 48,
          ),
          10.verticalSpace,
          Text(
            'No conversations yet',
            style: montserrat(16, grey5F63, FontWeight.w500),
          ),
          5.verticalSpace,
          Text(
            'Start a conversation by booking a ride',
            style: montserrat(12, grey5F63, FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build individual chat tile
  Widget _buildChatTile(
      BuildContext context, ChatRoom chatRoom, UserSignupModel? currentUser) {
    return StreamBuilder<UserSignupModel?>(
      stream: _getOtherUserStream(chatRoom),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 6.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: grey5F63.withOpacity(0.3),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        decoration: BoxDecoration(
                          color: grey5F63.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      4.verticalSpace,
                      Container(
                        height: 12,
                        width: 200,
                        decoration: BoxDecoration(
                          color: grey5F63.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final otherUser = snapshot.data!;
        final hasUnreadMessage = chatRoom.lastMessageRead == false &&
            chatRoom.amILastMessageSender == false;

        return GestureDetector(
          onTap: () {
            context.push('/chatting', extra: {
              'threadId': chatRoom.id,
              'otherUser': otherUser,
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 6.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: hasUnreadMessage
                  ? accentPurple.withOpacity(0.1)
                  : containerbackground,
              borderRadius: BorderRadius.circular(10.r),
              border: hasUnreadMessage
                  ? Border.all(color: accentPurple.withOpacity(0.3))
                  : null,
            ),
            child: Row(
              children: [
                // Profile image
                CircularProfileImage(
                  imageUrl: otherUser.profilePicture,
                  radius: 20,
                ),
                16.horizontalSpace,
                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            otherUser.name,
                            style: montserrat(
                                14,
                                hasUnreadMessage ? accentPurple : grey36,
                                FontWeight.w600),
                          ),
                          Text(
                            _formatMessageTime(chatRoom.lastMessageTime),
                            style: montserrat(10, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatRoom.lastMessage.isEmpty
                                  ? 'No messages yet'
                                  : chatRoom.lastMessage,
                              style: montserrat(
                                  12,
                                  hasUnreadMessage ? accentPurple : grey5F63,
                                  FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnreadMessage) ...[
                            8.horizontalSpace,
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: accentPurple,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Get other user stream
  Stream<UserSignupModel?> _getOtherUserStream(ChatRoom chatRoom) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return Stream.value(null);

    final otherUserId = chatRoom.participants.firstWhere(
      (userId) => userId != currentUserId,
      orElse: () => '',
    );

    if (otherUserId.isEmpty) return Stream.value(null);

    return userCollection.doc(otherUserId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      try {
        return UserSignupModel.fromJson(
            snapshot.data() as Map<String, dynamic>);
      } catch (e) {
        developer.log('Error parsing user data: $e');
        return null;
      }
    });
  }

  // Get current user data
  Future<UserSignupModel?> _getCurrentUserData() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return null;

    try {
      final doc = await userCollection.doc(currentUserId).get();
      if (!doc.exists || doc.data() == null) return null;

      return UserSignupModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      developer.log('Error getting current user data: $e');
      return null;
    }
  }

  // Format message time
  String _formatMessageTime(DateTime messageTime) {
    final now = DateTime.now();
    final difference = now.difference(messageTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return DateFormat('EEE').format(messageTime); // Mon, Tue, etc.
      } else {
        return DateFormat('MMM d').format(messageTime); // Jan 15
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
