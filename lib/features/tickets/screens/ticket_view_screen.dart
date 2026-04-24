import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const BusTicketApp());
}

class AppColors {
  static const Color primaryBlue = Color(0xFF343399);
  static const Color primaryDarkBlue = Color(0xFF18178C);
  static const Color accentGold = Color(0xFFD1AE36);
  static const Color mainBackground = Color(0xFF0E101F);
  static const Color cardBackground = Color(0xFF191A2C);
  static const Color circleButton = Color(0xFF1E293D);
  static const Color darkNav = Color(0xFF1C1C1E);
  static const Color purpleAccent = Color(0xFF7374C4);
  static const Color greenAccent = Color(0xFF3D6C5C);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightCard = Colors.white;
}

class BusTicketApp extends StatelessWidget {
  const BusTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTUBUS Premium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.lightBackground,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.mainBackground,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const DigitalTicketScreen(),
    );
  }
}

class DigitalTicketScreen extends StatelessWidget {
  const DigitalTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.mainBackground
          : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTicketCard(isDark),
                    const SizedBox(height: 20),
                    _buildActionButtons(isDark),
                    const SizedBox(height: 24),
                    _buildInstructions(isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildBottomNav(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.circleButton : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white : AppColors.primaryDarkBlue,
                size: 18,
              ),
            ),
          ),
          Text(
            'DIGITAL TICKET',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: isDark ? Colors.white : AppColors.primaryDarkBlue,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.circleButton : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.share_outlined,
                color: isDark ? Colors.white : AppColors.primaryDarkBlue,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackground : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryBlue, AppColors.primaryDarkBlue],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarkBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.directions_bus,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OPERATOR',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'OTUBUS Premium',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'STUDENT PASS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PASSENGER',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black54,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Eiar',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.primaryDarkBlue,
                            ),
                          ),
                          Text(
                            'Mohamed',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.primaryDarkBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'SEAT',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black54,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Row 3,',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGold,
                          ),
                        ),
                        Text(
                          'B',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  height: 1,
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ROUTE',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Downtown'),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward, size: 14),
                              SizedBox(width: 4),
                              Text('OTU'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumnRight(
                        'TERMINAL',
                        'Main Gate 4',
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumnSimple(
                        'DATE',
                        'Oct 21, 2026',
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoColumnRight(
                        'DEPARTURE',
                        '08:30 AM',
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Divider(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  height: 1,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        QrImageView(
                          data: 'TXN-9920-OTU-881',
                          version: QrVersions.auto,
                          size: 160,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.directions_bus,
                                color: AppColors.primaryDarkBlue,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'TXN-9920-OTU-881',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomPaint(
                  size: const Size(double.infinity, 1),
                  painter: DashedLinePainter(
                    color: isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: AppColors.greenAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'VERIFIED BOOKING',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'VALID FOR 1 ENTRY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value1,
    String value2,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white.withOpacity(0.5) : Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const SizedBox(width: 4),
            Text(
              value1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward,
              size: 14,
              color: isDark ? Colors.white.withOpacity(0.7) : Colors.black87,
            ),
            const SizedBox(width: 4),
            Text(
              value2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoColumnRight(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white.withOpacity(0.5) : Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label == 'TERMINAL') const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoColumnSimple(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white.withOpacity(0.5) : Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkNav : Colors.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wallet,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Add to Apple Wallet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white.withOpacity(0.9) : Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackground : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.15)
                  : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.download,
                color: isDark
                    ? Colors.white.withOpacity(0.9)
                    : AppColors.primaryBlue,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Download Ticket (PDF)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.white.withOpacity(0.9)
                      : AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(bool isDark) {
    return Text(
      'Please present this QR code to the driver upon \nboarding. Ensure your screen brightness is set to \nmaximum for faster scanning.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: isDark
            ? Colors.white.withOpacity(0.4)
            : Colors.black.withOpacity(0.45),
        height: 1.5,
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF12122A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false, isDark),
            _buildNavItem(Icons.search, 'Search', false, isDark),
            _buildNavItem(
              Icons.confirmation_num_outlined,
              'Tickets',
              true,
              isDark,
            ),
            _buildNavItem(Icons.person_outline, 'Profile', false, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected
              ? AppColors.purpleAccent
              : (isDark ? Colors.white.withOpacity(0.4) : Colors.black45),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isSelected
                ? AppColors.purpleAccent
                : (isDark ? Colors.white.withOpacity(0.4) : Colors.black45),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
