import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/service/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    final authService = AuthService();
    if (_passwordController.text == _cPasswordController.text) {
      try {
        authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
        const AlertDialog(title: Text("Passwords don't match!")),
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
            // ── Colorful header — pink/teal gradient ──
            Stack(
              children: [
                Container(
                  height: 260,
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
                          Icons.person_add_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Let's get started!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          height: 1
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create your account ',
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
            const SizedBox(height: 18),

            MyTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _cPasswordController,
              prefixIcon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 50),

            MyButton(bName: 'Create Account', onTap: () => register(context)),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    'Sign in',
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
// class RegisterPage extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _cPasswordController = TextEditingController();
//
//   void Function()? onTap;
//
//   RegisterPage({super.key, required this.onTap});
//
//   void register(BuildContext context) {
//     final authService = AuthService();
//     if (_passwordController.text == _cPasswordController.text) {
//       try {
//         authService.register(
//           _emailController.text.trim(),
//           _passwordController.text.trim(),
//         );
//       } catch (e) {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(title: Text(e.toString())),
//         );
//       }
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(title: Text("Password don't match!")),
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
//               "Let's create ana account for you",
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
//             SizedBox(height: 10),
//
//             /// CONFIRM PASSWORD
//             MyTextField(
//               hintText: 'Confirm Password',
//               obscureText: true,
//               controller: _cPasswordController,
//             ),
//             SizedBox(height: 25),
//
//             /// LOGIN BUTTON
//             MyButton(bName: 'REGISTER', onTap: () => register(context)),
//             SizedBox(height: 25),
//
//             /// Register MSG
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Already have an account ? ",
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: onTap,
//                   child: Text(
//                     "Login now",
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
