import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:otubus_app/features/settings/screens/settings_screen.dart';
import 'package:otubus_app/features/scan/screens/scan_qr_screen.dart';
import 'package:otubus_app/features/tickets/screens/ticket_view_screen.dart';
import 'package:otubus_app/features/profile/screens/payment_methods_screen.dart';
import 'package:otubus_app/features/profile/screens/terms_privacy_screen.dart';
import 'package:otubus_app/core/providers/session_provider.dart';
import 'package:otubus_app/features/auth/screens/get_started_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String studentStatus;

  const ProfileScreen({
    super.key,
    this.userName = "Student",
    this.userEmail = "email@university.edu",
    this.studentStatus = "STUDENT PREMIUM",
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
            color: isDark ? Colors.white : colors.onSurface,
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
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: colors.primary.withOpacity(0.5),
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
              widget.userName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            Text(
              widget.userEmail,
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
                widget.studentStatus,
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- SECTIONS ----------------
            _section("ACCOUNT", colors, isDark),
            _tile(
              "Account Settings",
              Icons.settings_outlined,
              colors,
              isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            _section("PREFERENCES", colors, isDark),
            _tile(
              "Language",
              Icons.language,
              colors,
              isDark,
              trailing: "English",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            _tile(
              "Notification Settings",
              Icons.notifications_none,
              colors,
              isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),

            _section("PAYMENTS", colors, isDark),
            _tile(
              "Payment Methods",
              Icons.credit_card,
              colors,
              isDark,
              trailing: "VISA ....4242",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentMethodsScreen(),
                  ),
                );
              },
            ),

            _section("BUS", colors, isDark),
            _tile(
              "My Tickets",
              Icons.confirmation_num_outlined,
              colors,
              isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TicketViewScreen()),
                );
              },
            ),
            _tile(
              "SCAN BUS QR",
              Icons.qr_code_scanner,
              colors,
              isDark,
              special: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScanQrScreen()),
                );
              },
            ),

            _section("SUPPORT", colors, isDark),
            _tile(
              "Terms & Conditions",
              Icons.description,
              colors,
              isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsPrivacyScreen(isPrivacy: false),
                  ),
                );
              },
            ),
            _tile(
              "Privacy Policy",
              Icons.security,
              colors,
              isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsPrivacyScreen(isPrivacy: true),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    // Clear session
                    if (mounted) {
                      final sessionProvider = context.read<SessionProvider>();
                      await sessionProvider.logout();

                      // Navigate to Get Started screen and clear stack
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () {},
              child: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.orange, fontSize: 14),
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
    );
  }

  void _openScreen(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderDetailScreen(title: title)),
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
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: special ? colors.primary : colors.onSurface),
      title: Text(title, style: TextStyle(color: colors.onSurface)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}

class PlaceholderDetailScreen extends StatelessWidget {
  final String title;
  const PlaceholderDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: const TextStyle(fontSize: 24))),
    );
  }
}
