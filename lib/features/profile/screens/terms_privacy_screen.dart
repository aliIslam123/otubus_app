import 'package:flutter/material.dart';

class TermsPrivacyScreen extends StatefulWidget {
  final bool isPrivacy;

  const TermsPrivacyScreen({super.key, this.isPrivacy = false});

  @override
  State<TermsPrivacyScreen> createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.isPrivacy) {
      _tabController.index = 1;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          "Terms & Privacy",
          style: TextStyle(
            color: colors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colors.primary,
          labelColor: colors.primary,
          unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
          tabs: const [
            Tab(text: "Terms of Service"),
            Tab(text: "Privacy Policy"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Terms of Service Tab
          _buildContentTab(colors, _termsContent()),
          // Privacy Policy Tab
          _buildContentTab(colors, _privacyContent()),
        ],
      ),
    );
  }

  Widget _buildContentTab(ColorScheme colors, String content) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        content,
        style: TextStyle(
          color: colors.onBackground,
          fontSize: 14,
          height: 1.6,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  String _termsContent() {
    return """TERMS OF SERVICE

Last Updated: January 2024

1. ACCEPTANCE OF TERMS
By accessing and using the OTUBUS application ("the App"), you accept and agree to be bound by the terms and provision of this agreement.

2. USE LICENSE
OTUBUS grants you a limited, non-exclusive, revocable license to use the App for personal, non-commercial purposes. You agree not to:
• Reproduce, duplicate, or copy any content for commercial purposes
• Attempt to gain unauthorized access to the App
• Use the App in any way that infringes upon the rights of others
• Transmit obscene or offensive content

3. BOOKING & PAYMENT
• All bookings are subject to availability
• Prices are subject to change without notice
• Payment must be completed to confirm booking
• Cancellation policy is available in the App
• Refunds will be processed according to the cancellation policy

4. USER ACCOUNTS
• You are responsible for maintaining the security of your account
• You agree to provide accurate information during registration
• You are responsible for all activities that occur under your account
• You must notify us immediately of unauthorized access

5. LIMITATION OF LIABILITY
OTUBUS shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use the App.

6. MODIFICATIONS
OTUBUS reserves the right to modify these terms at any time. Your continued use of the App following the posting of revised terms means that you accept and agree to the changes.

7. GOVERNING LAW
These terms are governed by and construed in accordance with the laws of the jurisdiction where OTUBUS operates.

8. CONTACT US
If you have questions about these terms, please contact us at support@otubus.com""";
  }

  String _privacyContent() {
    return """PRIVACY POLICY

Last Updated: January 2024

1. INFORMATION WE COLLECT
We collect the following information:
• Personal identification information (name, email, phone number)
• Payment information
• Location data (with your permission)
• Device information
• Usage statistics and analytics

2. HOW WE USE YOUR INFORMATION
We use the information we collect to:
• Process bookings and payments
• Provide customer support
• Improve our services
• Send notifications about bookings and promotions
• Comply with legal obligations
• Prevent fraud and ensure security

3. DATA SECURITY
We implement industry-standard security measures to protect your personal information. However, no method of transmission over the Internet is 100% secure.

4. THIRD-PARTY SERVICES
We may use third-party services for:
• Payment processing
• Analytics
• Cloud storage
• Customer support

These third parties are contractually obligated to use your information only as necessary to provide services to us.

5. COOKIES & TRACKING
Our App may use cookies and similar technologies to enhance your experience and collect usage data.

6. YOUR PRIVACY RIGHTS
You have the right to:
• Access your personal data
• Correct inaccurate data
• Delete your account and data
• Opt-out of marketing communications
• Request a copy of your data

7. CHILDREN'S PRIVACY
Our App is not intended for children under 18. If we become aware that a child under 18 has provided us personal information, we will delete such information.

8. CHANGES TO THIS POLICY
We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy in the App.

9. CONTACT US
If you have questions about this privacy policy, please contact us at privacy@otubus.com""";
  }
}
