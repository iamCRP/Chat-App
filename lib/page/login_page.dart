import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/page/reset_password.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Colorful header blob ──
            Stack(
              children: [
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF4C1D95), const Color(0xFF6C63FF)]
                          : [const Color(0xFF6C63FF), const Color(0xFF818CF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to continue chatting',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            MyTextField(
              hintText: 'Email address',
              obscureText: false,
              controller: _emailController,
              prefixIcon: Icons.email_rounded,
            ),
            const SizedBox(height: 18),

            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
              prefixIcon: Icons.lock_rounded,
            ),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 25, top: 10, bottom: 6),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResetPasswordPage(),
                    ),
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: const Color(0xFF6C63FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            MyButton(bName: 'Sign In', onTap: () => login(context)),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    'Register now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


/// code

// import 'package:chat_app/components/my_button.dart';
// import 'package:chat_app/components/my_textfield.dart';
// import 'package:chat_app/service/auth/auth_service.dart';
// import 'package:flutter/material.dart';
//
// class LoginPage extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   void Function()? onTap;
//
//   LoginPage({super.key, required this.onTap});
//
//   void login(BuildContext context) async {
//     final authService = AuthService();
//     try {
//       await authService.login(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );
//     } catch (e) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(title: Text(e.toString())),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             /// LOGO
//             Icon(
//               Icons.message,
//               size: 60,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             SizedBox(height: 50),
//
//             /// WELCOME MSG
//             Text(
//               "Welcome back,you've been missed!",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.primary,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 25),
//
//             /// EMAIL
//             MyTextField(
//               hintText: 'Email',
//               obscureText: false,
//               controller: _emailController,
//             ),
//             SizedBox(height: 10),
//
//             /// PASSWORD
//             MyTextField(
//               hintText: 'Password',
//               obscureText: true,
//               controller: _passwordController,
//             ),
//             SizedBox(height: 25),
//
//             /// LOGIN BUTTON
//             MyButton(bName: 'LOGIN', onTap: () => login(context)),
//             SizedBox(height: 25),
//
//             /// Register MSG
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Not a member ? ",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: onTap,
//                   child: Text(
//                     "Register now",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
