import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nepak_bulu_2/router/app_router.dart';
import 'package:nepak_bulu_2/theme/app_theme.dart';
import 'package:nepak_bulu_2/components/layout/mobile_web_layout.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matchmaking App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        return MobileWebLayout(child: child!);
      },
    );
  }
}
