import 'package:flutter/material.dart';

void main() {
  runApp(const OtubusSettingsDemo());
}

class OtubusSettingsDemo extends StatelessWidget {
  const OtubusSettingsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,

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
              surface: Colors.white,
              background: const Color(0xFFF5F5F8),
              onBackground: const Color(0xFF0F172A),
            ),
      ),

      // ---------------- DARK THEME ----------------
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
              secondary: const Color(0xFFC5A059),
              surface: const Color(0xFF1E1E32),
              background: const Color(0xFF0F0F23),
              onBackground: const Color(0xFFF1F5F9),
            ),
      ),

      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = "English";

  bool darkModeUI = false; // UI فقط (مش مربوط بالThemeMode هنا)
  bool enableNotifications = true;
  bool tripAlerts = true;
  bool promotions = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: colors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("PREFERENCES"),
            _sectionCard(
              context,
              children: [
                _settingTile(
                  context,
                  icon: Icons.language,
                  title: "Language",
                  trailingText: selectedLanguage,
                  onTap: () => _showLanguageDialog(context),
                ),
                _divider(isDark),
                _switchTile(
                  context,
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  value: darkModeUI,
                  onChanged: (val) {
                    setState(() => darkModeUI = val);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("NOTIFICATIONS"),
            _sectionCard(
              context,
              children: [
                _switchTile(
                  context,
                  icon: Icons.notifications_active_outlined,
                  title: "Enable Notifications",
                  value: enableNotifications,
                  onChanged: (val) {
                    setState(() => enableNotifications = val);
                  },
                ),
                _divider(isDark),
                _switchTile(
                  context,
                  icon: Icons.directions_bus_outlined,
                  title: "Trip Alerts",
                  subtitle: "Bus arrival reminders",
                  value: tripAlerts,
                  onChanged: (val) {
                    setState(() => tripAlerts = val);
                  },
                ),
                _divider(isDark),
                _switchTile(
                  context,
                  icon: Icons.local_offer_outlined,
                  title: "Promotions",
                  subtitle: "Offers & discounts",
                  value: promotions,
                  onChanged: (val) {
                    setState(() => promotions = val);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("SUPPORT"),
            _sectionCard(
              context,
              children: [
                _settingTile(
                  context,
                  icon: Icons.help_outline,
                  title: "Help Center",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Help Center Placeholder")),
                    );
                  },
                ),
                _divider(isDark),
                _settingTile(
                  context,
                  icon: Icons.mail_outline,
                  title: "Contact Us",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Contact Us Placeholder")),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("ABOUT"),
            _sectionCard(
              context,
              children: [
                _settingTile(
                  context,
                  icon: Icons.description_outlined,
                  title: "Terms & Conditions",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Terms Placeholder")),
                    );
                  },
                ),
                _divider(isDark),
                _settingTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Privacy Placeholder")),
                    );
                  },
                ),
                _divider(isDark),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: colors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "App Version",
                          style: TextStyle(
                            color: colors.onBackground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Text(
                        "v1.0.0",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout Placeholder")),
                  );
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

            const SizedBox(height: 18),

            const Center(
              child: Text(
                "OTUBUS • SETTINGS",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------- LANGUAGE DIALOG ----------------
  void _showLanguageDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: colors.surface,
          title: Text(
            "Choose Language",
            style: TextStyle(
              color: colors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_languageOption("English"), _languageOption("Arabic")],
          ),
        );
      },
    );
  }

  Widget _languageOption(String lang) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = selectedLanguage == lang;

    return ListTile(
      onTap: () {
        setState(() => selectedLanguage = lang);
        Navigator.pop(context);
      },
      title: Text(
        lang,
        style: TextStyle(
          color: colors.onBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colors.primary)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
    );
  }

  // ---------------- UI HELPERS ----------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _sectionCard(BuildContext context, {required List<Widget> children}) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 0,
      thickness: 1,
      color: isDark ? Colors.white10 : Colors.grey.shade200,
    );
  }

  Widget _settingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: ListTile(
        onTap: disabled ? null : onTap,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: colors.primary.withOpacity(0.12),
          child: Icon(icon, color: colors.primary, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colors.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Colors.grey))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null)
              Text(trailingText, style: const TextStyle(color: Colors.grey)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final colors = Theme.of(context).colorScheme;

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: colors.primary,
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primary.withOpacity(0.12),
            child: Icon(icon, color: colors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colors.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Text(subtitle, style: const TextStyle(color: Colors.grey)),
            )
          : null,
    );
  }
}
