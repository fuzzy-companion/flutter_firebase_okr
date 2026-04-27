import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_posts/core/services/firebase/firebase_options.dart';
import 'package:instagram_posts/core/themes/dark_theme.dart';
import 'package:instagram_posts/core/themes/light_theme.dart';

void main() async {
  // Firebase configuration
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagramify',
      darkTheme: DarkTheme.darkThemeConfig,
      theme: LightTheme.lightThemeConfig,
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Welcome to Instagramify where firebase meets flutter for sharing and connecting.',
                textAlign: .center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: .w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
