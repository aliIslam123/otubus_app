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
      themeMode: ThemeMode.system,

      // ---------------- LIGHT ----------------
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF000080),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF000080),
              secondary: const Color(0xFFD4AF37),
              background: Colors.white,
              surface: const Color(0xFFF5F5F8),
              onBackground: const Color(0xFF0F172A),
            ),
      ),

      // ---------------- DARK ----------------
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F23),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF3B3BDF),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF3B3BDF),
              secondary: const Color(0xFFD4AF37),
              background: const Color(0xFF0F0F23),
              surface: const Color(0xFF1E1E32),
              onBackground: const Color(0xFFF1F5F9),
            ),
      ),

      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String studentStatus;

  const ProfileScreen({
    super.key,
    this.userName = "Name",
    this.userEmail = "email@university.edu",
    this.studentStatus = "STUDENT PREMIUM",
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: isDark ? Colors.white : colors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ---------------- PROFILE ----------------
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.secondary, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: colors.surface,
                      backgroundImage: const NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: colors.primary,
                      radius: 18,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Text(
              userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.onBackground,
              ),
            ),

            Text(
              userEmail,
              style: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                studentStatus,
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- SECTIONS ----------------
            _section("ACCOUNT", colors, isDark),
            _tile("Edit Profile", Icons.person_outline, colors, isDark),
            _tile("Change Password", Icons.lock_outline, colors, isDark),

            _section("PREFERENCES", colors, isDark),
            _tile(
              "Language",
              Icons.language,
              colors,
              isDark,
              trailing: "English",
            ),
            _tile(
              "Notification Settings",
              Icons.notifications_none,
              colors,
              isDark,
            ),

            _section("PAYMENTS", colors, isDark),
            _tile(
              "Payment Methods",
              Icons.credit_card,
              colors,
              isDark,
              trailing: "VISA ....4242",
            ),

            _section("BUS", colors, isDark),
            _tile(
              "SCAN BUS QR",
              Icons.qr_code_scanner,
              colors,
              isDark,
              special: true,
            ),

            _section("SUPPORT", colors, isDark),
            _tile("Help Center", Icons.help_outline, colors, isDark),
            _tile("Privacy Policy", Icons.security, colors, isDark),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {},
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),

            const Text(
              "VERSION 2.4.1 (BUILD 108)",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: colors.background,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: "Routes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "My Trips",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
        ],
      ),
    );
  }

  Widget _section(String title, ColorScheme colors, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: colors.surface,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _tile(
    String title,
    IconData icon,
    ColorScheme colors,
    bool isDark, {
    String? trailing,
    bool special = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: special ? colors.primary : colors.onBackground,
      ),
      title: Text(title, style: TextStyle(color: colors.onBackground)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
