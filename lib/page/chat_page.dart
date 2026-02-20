import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/service/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  String get chatRoomId {
    List<String> ids = [_authService.getCurrentUser()!.uid, widget.receiverId];
    ids.sort();
    return ids.join('_');
  }

  // Avatar color based on name
  Color get _avatarColor {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
    ];
    final name = widget.receiverEmail;
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
      );
      _messageController.clear();
    }
    scrollDown();
  }

  String _formatNameFromEmail(String email) {
    String name = email.split('@')[0];
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final name = _formatNameFromEmail(widget.receiverEmail);
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_avatarColor, _avatarColor.withOpacity(0.7)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: _avatarColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
          );
        }
        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          children: snapshot.data!.docs
              .map((doc) => _buildMessageListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    String messageId = doc.id;

    return GestureDetector(
      onLongPress: isCurrentUser
          ? () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SafeArea(
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text("Edit Message"),
                          onTap: () {
                            Navigator.pop(context);
                            _showEditDialog(messageId, data['message']);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text("Delete Message"),
                          onTap: () async {
                            Navigator.pop(context);
                            await _chatService.deleteMessage(
                              chatRoomId,
                              messageId,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          : null,
      child: Container(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: data['isDeleted'] == true
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: isCurrentUser
                        ? const Radius.circular(18)
                        : const Radius.circular(4),
                    bottomRight: isCurrentUser
                        ? const Radius.circular(4)
                        : const Radius.circular(18),
                  ),
                ),
                child: const Text(
                  "This message was deleted",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              )
            : ChatBubble(
                message: data['message'],
                isCurrentUser: isCurrentUser,
              ),
      ),
    );
  }

  Widget _buildUserInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0D0D1A)
                    : const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2D2D4E)
                      : const Color(0xFFD5CDFF),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: myFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white30 : Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        fontSize: 15,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String messageId, String oldMessage) {
    TextEditingController editController = TextEditingController(
      text: oldMessage,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Message"),
          content: TextField(controller: editController, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _chatService.updateMassage(
                  chatRoomId,
                  messageId,
                  editController.text,
                );
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

/// code

// import 'package:chat_app/components/chat_bubble.dart';
// import 'package:chat_app/components/my_textfield.dart';
// import 'package:chat_app/service/auth/auth_service.dart';
// import 'package:chat_app/service/chat/chat_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ChatPage extends StatefulWidget {
//   final String receiverEmail;
//   final String receiverId;
//
//   ChatPage({super.key, required this.receiverEmail, required this.receiverId});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();
//
//   FocusNode myFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     myFocusNode.addListener(() {
//       if (myFocusNode.hasFocus) {
//         Future.delayed(Duration(milliseconds: 500), () => scrollDown());
//       }
//     });
//     Future.delayed(Duration(milliseconds: 500), () => scrollDown());
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     myFocusNode.dispose();
//     _messageController.dispose();
//   }
//
//   // scroll controller
//   final ScrollController _scrollController = ScrollController();
//
//   void scrollDown() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(seconds: 1),
//       curve: Curves.fastOutSlowIn,
//     );
//   }
//
//   /// SEND MESSAGE
//   void sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(
//         widget.receiverId,
//         _messageController.text,
//       );
//       _messageController.clear();
//     }
//     scrollDown();
//   }
//
//   String _formatNameFromEmail(String email) {
//     String namePart = email.split('@')[0];
//
//     List<String> words = namePart.split(RegExp(r'[._0-9]+'));
//
//     return words
//         .where((word) => word.isNotEmpty)
//         .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
//         .join(' ');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.grey,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
//         ),
//         title: Text(_formatNameFromEmail(widget.receiverEmail)),
//       ),
//       body: Column(
//         children: [
//           Expanded(child: _buildMessageList()),
//           _buildUserInput(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessageList() {
//     String senderId = _authService.getCurrentUser()!.uid;
//     return StreamBuilder(
//       stream: _chatService.getMessage(widget.receiverId, senderId),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error');
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text('Loading');
//         }
//         return ListView(
//           controller: _scrollController,
//           children: snapshot.data!.docs
//               .map((doc) => _buildMessageListItem(doc))
//               .toList(),
//         );
//       },
//     );
//   }
//
//   Widget _buildMessageListItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//
//     bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
//
//     var alignment = isCurrentUser
//         ? Alignment.centerRight
//         : Alignment.centerLeft;
//
//     return Container(
//       alignment: alignment,
//       child: Column(
//         crossAxisAlignment: isCurrentUser
//             ? CrossAxisAlignment.end
//             : CrossAxisAlignment.start,
//         children: [
//           ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildUserInput() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 50),
//       child: Row(
//         children: [
//           Expanded(
//             child: MyTextField(
//               focusNode: myFocusNode,
//               hintText: 'Type a message',
//               obscureText: false,
//               controller: _messageController,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.green,
//               shape: BoxShape.circle,
//             ),
//             margin: EdgeInsets.only(right: 20),
//             child: IconButton(
//               onPressed: sendMessage,
//               icon: Icon(Icons.arrow_upward, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
