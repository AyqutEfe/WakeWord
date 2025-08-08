import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/translation_service.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load();
    print('✅ .env dosyası başarıyla yüklendi');
  } catch (e) {
    print('❌ .env dosyası yüklenemedi: $e');
    print('📝 .env dosyasının proje kök dizininde olduğundan emin olun');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TranslationService(),
      child: MaterialApp(
        title: 'Wake Word Translator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF2D2D2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            bodyMedium: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}