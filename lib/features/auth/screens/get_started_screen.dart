import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const OtubusApp());
}

class OtubusApp extends StatelessWidget {
  const OtubusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTUBUS',
      themeMode: ThemeMode.system, // ✅ Auto switch حسب الجهاز
      // ---------------- LIGHT THEME ----------------
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
              background: const Color(0xFFF5F5F8),
              surface: Colors.white,
              onBackground: const Color(0xFF000000),
            ),
      ),

      // ---------------- DARK THEME ----------------
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
              background: const Color(0xFF121218),
              surface: const Color(0xFF1E1E2D),
              onBackground: Colors.white,
            ),
      ),

      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              color: colors.background,
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF121218),
                        Color(0xFF1E1E2D),
                        Color(0xFF121218),
                      ],
                    )
                  : null,
            ),
          ),

          // Blobs
          Positioned(
            left: -90,
            bottom: -100,
            child: _BlurBlob(
              diameter: isDark ? 300 : 260,
              blur: isDark ? 80 : 40,
              color: colors.primary.withOpacity(isDark ? 0.4 : 0.95),
            ),
          ),
          Positioned(
            right: -110,
            top: 300,
            child: _BlurBlob(
              diameter: isDark ? 300 : 300,
              blur: isDark ? 80 : 40,
              color: colors.secondary.withOpacity(isDark ? 0.4 : 0.9),
            ),
          ),

          // Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  const _BrandArea(),

                  const Spacer(),

                  const _ActionCard(),

                  const SizedBox(height: 40),

                  Container(
                    height: 5,
                    width: 120,
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withOpacity(
                        0.25,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandArea extends StatelessWidget {
  const _BrandArea();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary,
              ),
              child: Icon(
                Icons.directions_bus,
                color: colors.secondary,
                size: 50,
              ),
            ),
            Positioned(
              right: -2,
              top: 2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colors.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.black : Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'OTUBUS',
          style: TextStyle(
            color: isDark ? Colors.white : colors.primary,
            fontSize: 42,
            fontWeight: FontWeight.bold,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Arrive in Excellence.',
          style: TextStyle(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDark ? 0.05 : 0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.1 : 0.4)),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        children: [
          const _PrimaryButton(),
          const SizedBox(height: 12),
          const _LoginButton(),
          const SizedBox(height: 14),
          Text(
            'New to OTUBUS? Create Acc...',
            style: TextStyle(
              color: isDark ? Colors.white70 : colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isDark ? null : colors.primary,
          gradient: isDark
              ? LinearGradient(
                  colors: [colors.primary, colors.primary.withOpacity(0.8)],
                )
              : null,
          borderRadius: BorderRadius.circular(28),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isDark ? 0.05 : 0.4),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.2)
                : colors.primary.withOpacity(0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'Login',
          style: TextStyle(
            color: isDark ? Colors.white : colors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Text(
          'Login Screen (Placeholder)',
          style: TextStyle(color: colors.onBackground),
        ),
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({
    required this.diameter,
    required this.color,
    required this.blur,
  });

  final double diameter;
  final Color color;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
