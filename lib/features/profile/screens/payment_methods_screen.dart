import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Dummy payment methods
  final List<Map<String, String>> paymentMethods = [
    {
      'type': 'visa',
      'name': 'Visa',
      'last4': '4242',
      'expiry': '12/25',
      'isDefault': 'true',
    },
    {
      'type': 'mastercard',
      'name': 'Mastercard',
      'last4': '5555',
      'expiry': '08/26',
      'isDefault': 'false',
    },
    {
      'type': 'paypal',
      'name': 'PayPal',
      'last4': 'email@gmail.com',
      'expiry': '-',
      'isDefault': 'false',
    },
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment Methods",
          style: TextStyle(
            color: colors.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Payment Methods",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            // Display payment methods
            ...paymentMethods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              final isDefault = method['isDefault'] == 'true';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDefault
                          ? colors.primary
                          : (isDark ? Colors.white10 : Colors.grey.shade200),
                      width: isDefault ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Payment method icon
                      Container(
                        width: 50,
                        height: 32,
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          method['type'] == 'visa'
                              ? Icons.credit_card
                              : method['type'] == 'mastercard'
                              ? Icons.credit_card_sharp
                              : Icons.payment,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Payment method details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${method['name']} •••• ${method['last4']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colors.onBackground,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Expires ${method['expiry']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            // Add new payment method button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Add payment method feature coming soon"),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add New Payment Method"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
