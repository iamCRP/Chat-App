import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/service/auth/auth_gate.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const AuthGate(),
        );
      },
    );
  }
}

/// code

// import 'package:chat_app/firebase_options.dart';
// import 'package:chat_app/page/chat_page.dart';
// import 'package:chat_app/service/auth/auth_gate.dart';
// import 'package:chat_app/service/chat/notification_service.dart';
// import 'package:chat_app/themes/theme_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
//   await NotificationService().initialize();
//   runApp(
//     ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: NavigationService.navigatorKey,
//       home: AuthGate(),
//       routes: {
//         '/chat': (context) {
//           final args =
//           ModalRoute.of(context)!.settings.arguments
//           as Map<String, dynamic>;
//
//           return ChatPage(
//             receiverId: args['receiverId'],
//             receiverEmail: args['receiverEmail'],
//           );
//         },
//       },
//     );
//   }
// }
