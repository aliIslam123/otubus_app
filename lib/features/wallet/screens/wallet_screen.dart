import 'package:flutter/material.dart';

void main() {
  runApp(const OtubusWalletDemo());
}

class OtubusWalletDemo extends StatelessWidget {
  const OtubusWalletDemo({super.key});

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

      home: const WalletScreen(),
    );
  }
}

// ---------------- MODEL ----------------
class WalletTransactionModel {
  final String title;
  final String routeName;
  final String date;
  final double amount;
  final String status;
  final String method;
  final String transactionId;
  final IconData icon;

  WalletTransactionModel({
    required this.title,
    required this.routeName,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
    required this.transactionId,
    required this.icon,
  });
}

// ---------------- SCREEN ----------------
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double balance = 120.00;

  int currentIndex = 3; // Wallet active

  final List<String> paymentMethods = ["VISA ending in 1234", "Vodafone Cash"];

  final List<WalletTransactionModel> transactions = [
    WalletTransactionModel(
      title: "Ticket Payment",
      routeName: "OTU - Alexandria",
      date: "21 Apr 2026",
      amount: -80,
      status: "Completed",
      method: "VISA ending in 1234",
      transactionId: "TXN-200948",
      icon: Icons.confirmation_number_outlined,
    ),
    WalletTransactionModel(
      title: "Refund",
      routeName: "OTU - Alexandria",
      date: "20 Apr 2026",
      amount: 80,
      status: "Pending",
      method: "Wallet Balance",
      transactionId: "TXN-200811",
      icon: Icons.currency_exchange,
    ),
    WalletTransactionModel(
      title: "Ticket Payment",
      routeName: "OTU - Maadi",
      date: "18 Apr 2026",
      amount: -120,
      status: "Failed",
      method: "Vodafone Cash",
      transactionId: "TXN-200700",
      icon: Icons.bus_alert_outlined,
    ),
  ];

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
          "Wallet",
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
            // ---------------- BALANCE CARD ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [colors.primary, colors.primary.withOpacity(0.75)],
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: colors.primary.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "EGP ${balance.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Last updated: Today",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: _SmallActionButton(
                          text: "Top Up",
                          icon: Icons.add_circle_outline,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Top Up (Placeholder)"),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SmallActionButton(
                          text: "Refund Request",
                          icon: Icons.currency_exchange,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Refund Request (Placeholder)"),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- PAYMENT METHODS ----------------
            Text(
              "Payment Methods",
              style: TextStyle(
                color: colors.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            Column(
              children: [
                ...paymentMethods.map((method) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          method.contains("VISA")
                              ? Icons.credit_card
                              : Icons.phone_android,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            method,
                            style: TextStyle(
                              color: colors.onBackground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  );
                }),

                // Add New Method Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Add New Method (Placeholder)"),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colors.primary.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: colors.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Add New Method",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: colors.primary),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ---------------- TRANSACTIONS ----------------
            Text(
              "Recent Transactions",
              style: TextStyle(
                color: colors.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              itemCount: transactions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return _TransactionTile(
                  transaction: tx,
                  onTap: () => _showTransactionDetails(context, tx),
                );
              },
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      // ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: OtubusBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Navigate to index: $index (Placeholder)")),
          );
        },
        onCenterTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Center + Button (Placeholder)")),
          );
        },
      ),
    );
  }

  void _showTransactionDetails(
    BuildContext context,
    WalletTransactionModel tx,
  ) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 90,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: colors.primary.withOpacity(0.15),
                    child: Icon(tx.icon, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tx.title,
                      style: TextStyle(
                        color: colors.onBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _StatusBadge(status: tx.status),
                ],
              ),

              const SizedBox(height: 20),

              _DetailRow("Transaction ID", tx.transactionId),
              _DetailRow("Payment Method", tx.method),
              _DetailRow("Route", tx.routeName),
              _DetailRow("Date", tx.date),
              _DetailRow(
                "Amount",
                "${tx.amount > 0 ? "+" : "-"}EGP ${tx.amount.abs().toStringAsFixed(0)}",
                highlight: true,
                color: tx.amount > 0 ? Colors.green : Colors.red,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Download Receipt (Placeholder)"),
                      ),
                    );
                  },
                  child: const Text(
                    "Download Receipt",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class OtubusBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCenterTap;

  const OtubusBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 90, // 👈 زودنا الارتفاع
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // الخلفية بتاعة البار
          Container(
            height: 75,
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ), // 👈 نزّلنا الايقونات لتحت
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home,
                    label: "Home",
                    isActive: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _NavItem(
                    icon: Icons.confirmation_number_outlined,
                    label: "Tickets",
                    isActive: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),

                  const SizedBox(width: 70), // مساحة للزرار اللي في النص

                  _NavItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: "Wallet",
                    isActive: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    label: "Profile",
                    isActive: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),

          // زرار الـ +
          Positioned(
            top: -28, // 👈 رفعناه لفوق أكتر
            child: GestureDetector(
              onTap: onCenterTap,
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? colors.primary : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? colors.primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- WIDGETS ----------------
class _SmallActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SmallActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransactionModel transaction;
  final VoidCallback onTap;

  const _TransactionTile({required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final amountText =
        "${transaction.amount > 0 ? "+" : "-"}EGP ${transaction.amount.abs().toStringAsFixed(0)}";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
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
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colors.primary.withOpacity(0.12),
              child: Icon(transaction.icon, color: colors.primary),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: TextStyle(
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.date,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  style: TextStyle(
                    color: transaction.amount > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                _StatusBadge(status: transaction.status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;

    switch (status.toLowerCase()) {
      case "completed":
        bg = Colors.green.withOpacity(0.15);
        textColor = Colors.green;
        break;
      case "pending":
        bg = Colors.orange.withOpacity(0.15);
        textColor = Colors.orange;
        break;
      case "failed":
        bg = Colors.red.withOpacity(0.15);
        textColor = Colors.red;
        break;
      default:
        bg = Colors.grey.withOpacity(0.15);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color? color;

  const _DetailRow(
    this.label,
    this.value, {
    this.highlight = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight
                  ? (color ?? colors.primary)
                  : colors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
