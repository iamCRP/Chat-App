import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? LinearGradient(
          colors: isDarkMode
              ? [const Color(0xFF8B5CF6), const Color(0xFF6C63FF)]
              : [const Color(0xFF6C63FF), const Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isCurrentUser
            ? null
            : (isDarkMode
            ? const Color(0xFF1E1E35)
            : const Color(0xFFE8E4FF)),
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
        boxShadow: [
          BoxShadow(
            color: isCurrentUser
                ? const Color(0xFF6C63FF).withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 15,
          color: isCurrentUser
              ? Colors.white
              : (isDarkMode ? Colors.white : const Color(0xFF1A1A2E)),
          height: 1.4,
        ),
      ),
    );
  }
}


/// code


// import 'package:chat_app/themes/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class ChatBubble extends StatelessWidget {
//   final String message;
//   final bool isCurrentUser;
//
//   const ChatBubble({
//     super.key,
//     required this.message,
//     required this.isCurrentUser,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool isDarkMode = Provider.of<ThemeProvider>(
//       context,
//       listen: false,
//     ).isDarkMode;
//
//     return Container(
//       decoration: BoxDecoration(
//         color: isCurrentUser
//             ? (isDarkMode ? Colors.green.shade600 : Colors.grey.shade500)
//             : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       padding: EdgeInsets.all(16),
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
//       child: Text(
//         message,
//         style: TextStyle(
//           color: isCurrentUser
//               ? Colors.white
//               : (isDarkMode ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }
// }
