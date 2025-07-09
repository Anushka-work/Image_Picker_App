import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:image_picker_app1/create_post_screen.dart';
import 'package:image_picker_app1/image_picker_screen.dart';
import 'package:image_picker_app1/profile_screen.dart';
import 'package:image_picker_app1/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Post Uploader',
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2E),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.white24, blurRadius: 4),
            ],
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.white30, blurRadius: 6),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
          shadows: [
            Shadow(color: Colors.white30, blurRadius: 4),
          ],
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8,
            shadowColor: Colors.white,
            shape:const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle:const TextStyle(
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(color: Colors.white30, blurRadius: 4),
              ],
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
              decorationColor: Colors.white,
            ),
        cardColor: const Color(0xFF2C2C2E),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const ImagePickerScreen(),
        '/create': (_) => const CreatePostScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
