import 'package:chat_app/service/auth/auth_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.background
            : Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white ,
            fontWeight: FontWeight.bold,
            size: 22,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Column(
          children: [
            SizedBox(height: 20,),
            // Dark mode tile
            _SettingsTile(
              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              iconColor: isDark
                  ? const Color(0xFF8B5CF6)
                  : const Color(0xFFF59E0B),
              title: 'Dark Mode',
              trailing: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                activeColor: const Color(0xFF6C63FF),
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),

            SizedBox(height: 10),

            // Logout tile
            _SettingsTile(
              icon: Icons.logout_rounded,
              iconColor: const Color(0xFFEF4444),
              title: 'Logout',
              onTap: logout,
              showArrow: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : const Color(0xFF6C63FF).withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            trailing ??
                (showArrow
                    ? Icon(
                        Icons.chevron_right_rounded,
                        size: 35,
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      )
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}

/// code

// import 'package:chat_app/service/auth/auth_service.dart';
// import 'package:chat_app/themes/theme_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class SettingPage extends StatelessWidget {
//   const SettingPage({super.key});
//
//   void logout() {
//     final _auth = AuthService();
//     _auth.signOut();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.grey,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
//         ),
//         title: Text('Setting'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//             margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
//             padding: EdgeInsets.all(15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Dark Mode'),
//                 CupertinoSwitch(
//                   value: Provider.of<ThemeProvider>(
//                     context,
//                     listen: false,
//                   ).isDarkMode,
//                   onChanged: (v) => Provider.of<ThemeProvider>(
//                     context,
//                     listen: false,
//                   ).toggleTheme(),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: logout,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
//               padding: EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Logout'),
//                   Icon(Icons.logout),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
