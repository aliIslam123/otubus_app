import 'package:flutter/material.dart';
import 'package:otubus_app/main_screen.dart';

void main() {
  runApp(const MyApp());
}

// ================== APP ==================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notifications',

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A0E21)),
      ),

      home: NotificationsScreen(
        isDark: isDark,
        onToggle: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

// ================== SCREEN ==================
class NotificationsScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const NotificationsScreen({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    // ألوان ديناميك حسب الثيم
    final scaffoldBg = isDark ? const Color(0xFF0A0E21) : Colors.white;
    final cardBg = isDark ? const Color(0xFF1D1E33) : const Color(0xFFF2F2F2);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final primaryBlue = const Color(0xFF4C6FFF);
    final accentGold = const Color(0xFFC5A358);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 0)),
              (route) => false,
            );
          },
        ),
        title: Text(
          "Notifications",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          // زرار تغيير الثيم
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: textColor,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Mark all as read",
              style: TextStyle(color: accentGold, fontSize: 14),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSectionHeader("TODAY", isDark),
          _buildNotificationCard(
            title: "Trip Reminder",
            subtitle:
                "Your bus from Downtown to OTU departs in 45 minutes. Have your QR code ready!",
            time: "45m ago",
            icon: Icons.directions_bus,
            sideColor: Colors.blueAccent,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          _buildNotificationCard(
            title: "Booking Confirmed",
            subtitle: "Your seat (12A) for Oct 25 has been secured.",
            footer: "ID: OTU-992834",
            time: "2h ago",
            icon: Icons.check_circle_outline,
            sideColor: accentGold,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
            footerColor: accentGold,
          ),
          _buildSectionHeader("YESTERDAY", isDark),
          _buildNotificationCard(
            title: "Bus Update",
            subtitle: "The 08:30 AM bus (OTU-402) is running 10 minutes late.",
            time: "Yesterday",
            icon: Icons.access_time,
            sideColor: Colors.transparent,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          _buildSectionHeader("EARLIER", isDark),
          _buildNotificationCard(
            title: "Account Verified",
            subtitle: "Your student ID has been successfully verified.",
            time: "3d ago",
            icon: Icons.person_outline,
            sideColor: Colors.transparent,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: scaffoldBg,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: scaffoldBg,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isDark ? Colors.white60 : Colors.black54,
          unselectedItemColor: isDark ? Colors.white60 : Colors.black54,
          currentIndex: 0,
          onTap: (index) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen(initialIndex: index)),
              (route) => false,
            );
          },
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: "Routes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_outlined),
              activeIcon: Icon(Icons.qr_code_scanner),
              label: "Scan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_num_outlined),
              activeIcon: Icon(Icons.confirmation_num),
              label: "Tickets",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.grey[600] : Colors.grey[700],
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color sideColor,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
    String? footer,
    Color? footerColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            Container(width: 4, height: 100, color: sideColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black12,
                      child: Icon(icon, color: textColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                time,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          if (footer != null) ...[
                            const SizedBox(height: 5),
                            Text(
                              footer,
                              style: TextStyle(
                                color: footerColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
