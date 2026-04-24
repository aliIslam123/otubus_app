import 'package:flutter/cupertino.dart';
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
      title: "OTUBUS",
      themeMode: ThemeMode.system, // ✅ Auto switch حسب الجهاز
      // ---------------- LIGHT THEME ----------------
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF000080),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF000080),
              secondary: const Color(0xFFD4AF37),
              background: const Color(0xFFF8F9FE),
              surface: Colors.white,
              onBackground: const Color(0xFF2E3A59),
            ),
      ),

      // ---------------- DARK THEME ----------------
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1219),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF5E7BFF),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF5E7BFF),
              secondary: const Color(0xFFE5B97F),
              background: const Color(0xFF0F1219),
              surface: const Color(0xFF1C1C1E),
              onBackground: Colors.white,
            ),
      ),

      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool keepSignedIn = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Logo
                _buildLogo(isDark, colors),

                const SizedBox(height: 30),

                // Welcome text
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: isDark ? 34 : 28,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Log in to manage your university\ncommute.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Email
                _buildLabel("Email Address", colors),
                _buildTextField(
                  hint: "name@university.edu",
                  icon: Icons.email_outlined,
                  isDark: isDark,
                  colors: colors,
                ),

                const SizedBox(height: 20),

                // Password
                _buildLabel("Password", colors),
                _buildTextField(
                  hint: "••••••••",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isDark: isDark,
                  colors: colors,
                ),

                const SizedBox(height: 15),

                // Keep signed in + forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 0.85,
                          child: isDark
                              ? CupertinoSwitch(
                                  value: keepSignedIn,
                                  activeColor: colors.primary,
                                  onChanged: (value) {
                                    setState(() => keepSignedIn = value);
                                  },
                                )
                              : Switch(
                                  value: keepSignedIn,
                                  activeColor: colors.primary,
                                  onChanged: (value) {
                                    setState(() => keepSignedIn = value);
                                  },
                                ),
                        ),
                        Text(
                          " Keep me signed in",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isDark ? 16 : 12),
                      ),
                      elevation: isDark ? 0 : 5,
                      shadowColor: colors.primary.withOpacity(0.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // OR
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.white12 : Colors.grey.shade300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.white12 : Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Apple Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.apple,
                      color: isDark ? Colors.white : Colors.black,
                      size: 26,
                    ),
                    label: Text(
                      "Continue with Apple",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark ? colors.surface : Colors.white,
                      side: BorderSide(
                        color: isDark
                            ? Colors.transparent
                            : Colors.grey.shade200,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isDark ? 16 : 12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark, ColorScheme colors) {
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A8E) : colors.primary,
              shape: BoxShape.circle,
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Icon(
              Icons.directions_bus_filled,
              color: isDark ? colors.secondary : Colors.white,
              size: 40,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: colors.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? colors.background : Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, ColorScheme colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          label,
          style: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required bool isDark,
    required ColorScheme colors,
    bool isPassword = false,
  }) {
    return TextField(
      obscureText: isPassword,
      style: TextStyle(color: isDark ? Colors.white : colors.onBackground),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? colors.primary : Colors.grey.shade400,
          size: 20,
        ),
        suffixIcon: isPassword
            ? Icon(
                Icons.visibility_outlined,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              )
            : null,
        filled: true,
        fillColor: isDark ? colors.surface : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
