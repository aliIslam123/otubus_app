import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otubus_app/core/providers/theme_provider.dart';
import 'package:otubus_app/core/providers/session_provider.dart';
import 'package:otubus_app/features/auth/screens/get_started_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = "English";

  bool enableNotifications = true;
  bool tripAlerts = true;
  bool promotions = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: colors.onSurface,
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
            _sectionTitle("ACCOUNT"),
            _sectionCard(
              context,
              children: [
                _settingTile(
                  context,
                  icon: Icons.person_outline,
                  title: "Edit Profile",
                  onTap: () => _showEditProfileDialog(),
                ),
                _divider(isDark),
                _settingTile(
                  context,
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  onTap: () => _showChangePasswordDialog(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _sectionTitle("PREFERENCES"),
            _sectionCard(
              context,
              children: [
                _settingTile(
                  context,
                  icon: Icons.language,
                  title: "Language",
                  trailingText: selectedLanguage,
                  onTap: () => _showLanguageDialog(),
                ),
                _divider(isDark),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return _switchTile(
                      context,
                      icon: Icons.dark_mode_outlined,
                      title: "Dark Mode",
                      value: themeProvider.isDarkMode,
                      onChanged: (val) => themeProvider.toggleTheme(),
                    );
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
                  onChanged: (val) => setState(() => enableNotifications = val),
                ),
                _divider(isDark),
                _switchTile(
                  context,
                  icon: Icons.directions_bus_outlined,
                  title: "Trip Alerts",
                  subtitle: "Bus arrival reminders",
                  value: tripAlerts,
                  onChanged: (val) => setState(() => tripAlerts = val),
                ),
                _divider(isDark),
                _switchTile(
                  context,
                  icon: Icons.local_offer_outlined,
                  title: "Promotions",
                  subtitle: "Offers & discounts",
                  value: promotions,
                  onChanged: (val) => setState(() => promotions = val),
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
                  onTap: () {},
                ),
                _divider(isDark),
                _settingTile(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                _divider(isDark),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "App Version",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text("v1.0.0"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure?"),
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
                    final sessionProvider = context.read<SessionProvider>();
                    await sessionProvider.logout();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 🔥 EDIT PROFILE
  // =========================================================
  void _showEditProfileDialog() {
    final colors = Theme.of(context).colorScheme;

    final nameController = TextEditingController(text: "Student");
    final emailController = TextEditingController(text: "email@university.edu");

    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Edit Profile",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: nameController,
                        validator: (v) =>
                            v == null || v.isEmpty ? "Required" : null,
                      ),

                      const SizedBox(height: 10),

                      TextFormField(controller: emailController),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;

                                  setState(() => isLoading = true);
                                  await Future.delayed(
                                    const Duration(seconds: 1),
                                  );

                                  if (!mounted) return;

                                  setState(() => isLoading = false);
                                  Navigator.pop(context);
                                },
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // 🔥 CHANGE PASSWORD
  // =========================================================
  void _showChangePasswordDialog() {
    final colors = Theme.of(context).colorScheme;

    final current = TextEditingController();
    final newPass = TextEditingController();
    final confirm = TextEditingController();

    final formKey = GlobalKey<FormState>();

    bool obscure1 = true;
    bool obscure2 = true;
    bool obscure3 = true;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      TextFormField(
                        controller: current,
                        obscureText: obscure1,
                        decoration: InputDecoration(
                          labelText: "Current Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => obscure1 = !obscure1),
                          ),
                        ),
                      ),

                      TextFormField(
                        controller: newPass,
                        obscureText: obscure2,
                        validator: (v) =>
                            v != null && v.length < 6 ? "Too short" : null,
                      ),

                      TextFormField(
                        controller: confirm,
                        obscureText: obscure3,
                        validator: (v) => v != newPass.text ? "Mismatch" : null,
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;

                                setState(() => isLoading = true);
                                await Future.delayed(
                                  const Duration(seconds: 1),
                                );

                                if (!mounted) return;

                                setState(() => isLoading = false);
                                Navigator.pop(context);
                              },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // 🔥 LANGUAGE FIX (ERROR SOLVED)
  // =========================================================
  void _showLanguageDialog() {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: colors.surface,
          title: const Text("Choose Language"),
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
      title: Text(lang),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colors.primary)
          : const Icon(Icons.circle_outlined),
    );
  }

  // =========================================================
  // UI HELPERS
  // =========================================================
  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 6, bottom: 10),
    child: Text(title),
  );

  Widget _sectionCard(BuildContext context, {required List<Widget> children}) =>
      Container(child: Column(children: children));

  Widget _divider(bool isDark) =>
      Divider(height: 0, color: isDark ? Colors.white10 : Colors.grey);

  Widget _settingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}
