import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/page/chat_page.dart';
import 'package:chat_app/page/setting_page.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/service/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.primary,
        title: Text(
          'CHAT APP',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingPage()),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.withOpacity(0.2) : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 23,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _buildUserList(context),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text('Something went wrong'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            ),
          );
        }

        final users = snapshot.data!
            .where(
              (userData) =>
                  userData['email'] != _authService.getCurrentUser()?.email,
            )
            .toList();

        if (users.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No users yet',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: users
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    final email = userData['email'];
    final name = _formatNameFromEmail(email);

    return UserTile(
      text: name,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ChatPage(receiverEmail: email, receiverId: userData['uid']),
          ),
        );
      },
    );
  }

  String _formatNameFromEmail(String email) {
    String namePart = email.split('@')[0];
    List<String> words = namePart.split(RegExp(r'[._0-9]+'));
    return words
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

/// code

// import 'package:chat_app/components/user_tile.dart';
// import 'package:chat_app/page/chat_page.dart';
// import 'package:chat_app/page/setting_page.dart';
// import 'package:chat_app/service/auth/auth_service.dart';
// import 'package:chat_app/service/chat/chat_service.dart';
// import 'package:flutter/material.dart';
//
// class HomePage extends StatelessWidget {
//   HomePage({super.key});
//
//   /// CHAT & AUTH SERVICE
//   final ChatService _chatService = ChatService();
//   final AuthService _authService = AuthService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.grey,
//         elevation: 0,
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => SettingPage()),
//               );
//             },
//             icon: Icon(Icons.settings),
//           ),
//         ],
//       ),
//       body: _buildUserList(),
//     );
//   }
//
//   Widget _buildUserList() {
//     return StreamBuilder(
//       stream: _chatService.getUserStream(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error');
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text('Loading..');
//         }
//
//         return ListView(
//           children: snapshot.data!
//               .map<Widget>((userData) => _buildUserListItem(userData, context))
//               .toList(),
//         );
//       },
//     );
//   }
//
//   Widget _buildUserListItem(
//     Map<String, dynamic> userData,
//     BuildContext context,
//   ) {
//     final currentUser = _authService.getCurrentUser();
//     final email = userData['email'];
//
//     if (email == currentUser!.email) {
//       return const SizedBox();
//     }
//
//     final name = _formatNameFromEmail(email);
//
//     return UserTile(
//       text: name,
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) =>
//                 ChatPage(receiverEmail: email, receiverId: userData['uid']),
//           ),
//         );
//       },
//     );
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
// }
