import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String bName;
  final void Function()? onTap;

  const MyButton({super.key, required this.bName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF8B5CF6), const Color(0xFF6C63FF)]
                : [const Color(0xFF6C63FF), const Color(0xFF4F46E5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            bName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}


/// code

// import 'package:flutter/material.dart';
//
// class MyButton extends StatelessWidget {
//   final String bName;
//   final void Function()? onTap;
//
//   const MyButton({super.key, required this.bName, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.secondary,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: EdgeInsets.all(18),
//         margin: EdgeInsets.symmetric(horizontal: 20),
//         child: Center(child: Text(bName)),
//       ),
//     );
//   }
// }
