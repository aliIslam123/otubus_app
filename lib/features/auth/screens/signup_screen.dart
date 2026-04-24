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
      themeMode: ThemeMode.system,

      // ---------------- LIGHT THEME ----------------
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFE2E8F0),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF000080),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF000080),
              secondary: const Color(0xFFD4AF37),
              background: const Color(0xFFE2E8F0),
              surface: const Color(0xFFF5F5F8),
              onBackground: const Color(0xFF0F172A),
            ),
      ),

      // ---------------- DARK THEME ----------------
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1E),
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF4A6CF7),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF4A6CF7),
              secondary: const Color(0xFFE5B97F),
              background: const Color(0xFF1A1A1E),
              surface: const Color(0xFF1E293B),
              onBackground: Colors.white,
            ),
      ),

      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscure = true;
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF252529).withOpacity(0.4)
                      : colors.primary.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 18,
                      color: isDark
                          ? const Color(0xFFCBD5E1)
                          : const Color(0xFF475569),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "OTUBUS",
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                  ],
                ),

                const SizedBox(height: 20),

                /// TITLE
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Join the October Technological University transit network.",
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 25),

                _label("Full Name", isDark),
                _input(hint: "FirstName LastName", isDark: isDark),

                const SizedBox(height: 15),

                _label("University Email", isDark),
                _input(hint: "student@otu.edu.eg", isDark: isDark),

                const SizedBox(height: 15),

                _label("Password", isDark),
                _passwordInput(isDark),

                const SizedBox(height: 25),

                /// BUTTON
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.primary.withOpacity(isDark ? 0.9 : 0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withOpacity(isDark ? 0.4 : 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFD1D5DB),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or continue with",
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFD1D5DB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// APPLE
                Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF252529) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFD1D5DB),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.apple,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Continue with Apple",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// TERMS
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "By signing up, you agree to our ",
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                      children: [
                        TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        "Log In",
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF0F172A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _input({String? hint, required bool isDark}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252529) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.transparent,
        ),
      ),
      child: TextField(
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _passwordInput(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252529) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.transparent,
        ),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: obscure,
        obscuringCharacter: '•',
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: passwordController.text.isEmpty ? "••••••••" : null,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF94A3B8),
            ),
            onPressed: () {
              setState(() => obscure = !obscure);
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }
}
