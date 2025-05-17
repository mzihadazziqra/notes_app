import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/app_database.dart';
import 'db/note_database.dart';
import 'db/user_database.dart';
import 'pages/splash_screen.dart';
import 'services/auth_service.dart';
import 'theme/theme_provider.dart';

void main() async {
  // initialize the database
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => NoteDatabase(AppDatabase.isar),
        ),
        ChangeNotifierProvider(
          create: (context) => UserDatabase(AppDatabase.isar),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: themeProvider.themeData,
    );
  }
}
