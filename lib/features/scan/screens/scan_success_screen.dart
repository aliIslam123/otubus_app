import 'package:flutter/material.dart';

void main() {
  runApp(const ConfirmationApp());
}

class ConfirmationApp extends StatefulWidget {
  const ConfirmationApp({super.key});

  @override
  State<ConfirmationApp> createState() => _ConfirmationAppState();
}

class _ConfirmationAppState extends State<ConfirmationApp> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: ConfirmationScreen(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ConfirmationScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ConfirmationScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF0F0F1A) : Colors.white;
    final navyBlue = const Color(0xFF000080);
    final gold = const Color(0xFFD4AF37);
    final goldLight = const Color(0xFFF5E6C8);
    final goldDark = const Color(0xFF2A2410);

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
                            'CONFIRMATION',
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
                      width: 140,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? gold.withOpacity(0.15)
                                  : goldLight.withOpacity(0.5),
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark
                                  ? gold.withOpacity(0.2)
                                  : goldLight.withOpacity(0.7),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: gold,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 40,
                                weight: 700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    Text(
                      'Confirmed!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : navyBlue,
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
                          'Return to Home',
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