import 'package:flutter/material.dart';

void main() {
  runApp(const ScanFailedApp());
}

class ScanFailedApp extends StatefulWidget {
  const ScanFailedApp({super.key});

  @override
  State<ScanFailedApp> createState() => _ScanFailedAppState();
}

class _ScanFailedAppState extends State<ScanFailedApp> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: ScanFailedScreen(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ScanFailedScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ScanFailedScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF0F0F1A) : Colors.white;
    final navyBlue = const Color(0xFF000080);
    final red = const Color(0xFFFF0000);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 56,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1A1A2E)
                                    : const Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                color: isDark ? Colors.white : navyBlue,
                                size: 20,
                              ),
                            ),
                          ),
                          Text(
                            'SCANNING',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF9CA3AF),
                              letterSpacing: 2,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: onToggleTheme,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1A1A2E)
                                      : const Color(0xFFF5F5F5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                                  color: isDark ? Colors.white : navyBlue,
                                  size: 20,
                                ),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF2A1515).withOpacity(0.4)
                                  : const Color(0xFFFFF5F5).withOpacity(0.6),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF3A2020).withOpacity(0.5)
                                  : const Color(0xFFFFE8E8).withOpacity(0.7),
                            ),
                          ),
                          Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? const Color(0xFF2A1010)
                                  : const Color(0xFFFFF0F0),
                            ),
                          ),
                          Container(
                            width: 65,
                            height: 65,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFF0000),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close_rounded,
                                color: isDark ? Colors.black : Colors.white,
                                size: 36,
                                weight: 700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'SCAN FAILED',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: red,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enjoy your journey with OTUBUS',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF9CA3AF),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 120,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2A2A3E)
                            : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: Text(
                          'Scan Again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : navyBlue,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}