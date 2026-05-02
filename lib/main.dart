import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otubus_app/features/auth/screens/get_started_screen.dart';
import 'package:otubus_app/core/providers/theme_provider.dart';
import 'package:otubus_app/core/providers/session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme provider with saved preference
  final themeProvider = ThemeProvider();
  await themeProvider.initializeTheme();

  runApp(OtubusApp(themeProvider: themeProvider));
}

class OtubusApp extends StatefulWidget {
  final ThemeProvider themeProvider;

  const OtubusApp({super.key, required this.themeProvider});

  @override
  State<OtubusApp> createState() => _OtubusAppState();
}

class _OtubusAppState extends State<OtubusApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(
          value: widget.themeProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => SessionProvider()..initializeSession(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'OTUBUS',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF5F5F8),
              colorScheme:
                  ColorScheme.fromSeed(
                    seedColor: const Color(0xFF000080),
                    brightness: Brightness.light,
                  ).copyWith(
                    primary: const Color(0xFF000080),
                    secondary: const Color(0xFFC5A059),
                    surface: Colors.white,
                    onSurface: const Color(0xFF000000),
                  ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121218),
              colorScheme:
                  ColorScheme.fromSeed(
                    seedColor: const Color(0xFF3D5AFE),
                    brightness: Brightness.dark,
                  ).copyWith(
                    primary: const Color(0xFF3D5AFE),
                    secondary: const Color(0xFFC5A059),
                    surface: const Color(0xFF1E1E2D),
                    onSurface: Colors.white,
                  ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
