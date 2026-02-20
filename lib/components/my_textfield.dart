import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final IconData? prefixIcon;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: const Color(0xFF6C63FF), size: 20)
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark
                  ? const Color(0xFF2D2D4E)
                  : const Color(0xFFD5CDFF),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF6C63FF),
              width: 2,
            ),
          ),
          fillColor: isDark
              ? const Color(0xFF1A1A2E)
              : const Color(0xFFFFFFFF),
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark
                ? Colors.white38
                : const Color(0xFF9CA3AF),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

/// code

// import 'package:flutter/material.dart';
//
// class MyTextField extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController controller;
//   final FocusNode? focusNode;
//
//   const MyTextField({
//     super.key,
//     required this.hintText,
//     required this.obscureText,
//     required this.controller,
//     this.focusNode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 25),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Theme.of(context).colorScheme.tertiary,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//           fillColor: Theme.of(context).colorScheme.secondary,
//           filled: true,
//           hintText: hintText,
//           hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
//         ),
//       ),
//     );
//   }
// }
