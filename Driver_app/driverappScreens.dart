import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoSwitch

void main() {
  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        // Define a default color scheme for the app for consistency
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF00008B), // Dark blue
          secondary: const Color(0xFFF0F2F9), // Light greyish blue
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF5F7FB,
        ), // Light background for most screens
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00008B),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MainNavigationHolder(),
    );
  }
}

// Global shared UI components (converted from private helper functions)

class BlueHeader extends StatelessWidget {
  final String title;
  final double height;

  const BlueHeader({super.key, required this.title, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF00008B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }
}

class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class SmallActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;

  const SmallActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = const Color(0xFFF0F2F9),
    this.textColor = const Color(0xFF00008B),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// Main Navigation Holder
class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({super.key});

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AlertSettingsScreen(),
    EarningsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Alerts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: "Wallet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 1. DASHBOARD SCREEN
// ---------------------------------------------------------

class TodayCard extends StatelessWidget {
  const TodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          const Text(
            "Today",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          Text(
            "\$ 244.00",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconLabel(icon: Icons.sync, label: "14 Rides"),
              IconLabel(icon: Icons.access_time, label: "23H"),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Wallet Balance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SmallActionButton(
                label: "Withdrawal",
                onPressed: () {
                  // Handle withdrawal action
                },
              ),
            ],
          ),
          Text(
            "\$ 1544.00",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(height: 30),
          GestureDetector(
            onTap: () {
              // Handle view payment history
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "View Payment History",
                  style: TextStyle(color: Colors.grey),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OngoingTripCard extends StatelessWidget {
  const OngoingTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ongoing Trip",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SmallActionButton(
                label: "Navigation",
                onPressed: () {
                  // Handle navigation action
                },
              ),
            ],
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(backgroundColor: Colors.blueGrey),
            title: Text("Megan Fox"),
            subtitle: Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                Text(" 4.8"),
              ],
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              // Handle view upcoming trips
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming Trips (5)"),
                Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PreviousTripCard extends StatelessWidget {
  const PreviousTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Previous Trip",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 15, backgroundColor: Colors.grey),
              const SizedBox(width: 10),
              const Text(
                "Jon doe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "Total : \$500",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const BlueHeader(title: "Dashboard", height: 250),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: const [
                  TodayCard(),
                  SizedBox(height: 15),
                  WalletBalanceCard(),
                  SizedBox(height: 15),
                  OngoingTripCard(),
                  SizedBox(height: 15),
                  PreviousTripCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. ALERT SETTINGS SCREEN
// ---------------------------------------------------------

class AlertTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const AlertTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                "Alert Warning Feature",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          CupertinoSwitch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class AlertSettingsScreen extends StatefulWidget {
  const AlertSettingsScreen({super.key});

  @override
  State<AlertSettingsScreen> createState() => _AlertSettingsScreenState();
}

class _AlertSettingsScreenState extends State<AlertSettingsScreen> {
  // Initial UI data initialized in the state.
  final Map<String, bool> _settings = {
    "Over Speeding": true,
    "Harsh Braking": true,
    "Vehicle's Engine": false, // Example: Changed default to false
    "Car Idling": true,
    "Engine Oil Pressure": false, // Example: Changed default to false
    "Battery Charging": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const BlueHeader(title: "Alert Settings", height: 180),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
              children: _settings.keys.map<Widget>((String title) {
                return AlertTile(
                  title: title,
                  value: _settings[title]!,
                  onChanged: (bool newValue) {
                    setState(() {
                      _settings[title] = newValue;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. EARNINGS SCREEN
// ---------------------------------------------------------

class ChartBar extends StatelessWidget {
  final double height;
  final String label;

  const ChartBar({super.key, required this.height, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          width: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class WithdrawalHistoryTile extends StatelessWidget {
  final String date;
  final String amount;

  const WithdrawalHistoryTile({
    super.key,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.wallet, color: Theme.of(context).colorScheme.primary),
      title: Text(date, style: const TextStyle(fontSize: 13)),
      trailing: Text(
        amount,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const BlueHeader(title: "Earnings", height: 220),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  CustomCard(
                    child: Column(
                      children: [
                        const Text(
                          "Last 1 Month",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "\$ 12,491.22",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Divider(height: 30),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconLabel(icon: Icons.sync, label: "244 Rides"),
                            IconLabel(
                              icon: Icons.access_time,
                              label: "25D 12H",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Wallet Balance"),
                                Text(
                                  "\$ 1544.00",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            SmallActionButton(
                              label: "Withdrawal",
                              onPressed: () {
                                // Handle withdrawal action
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Chart representation
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ChartBar(height: 80, label: "Mo"),
                            ChartBar(height: 120, label: "Tu"),
                            ChartBar(height: 40, label: "We"),
                            ChartBar(height: 90, label: "Th"),
                            ChartBar(height: 130, label: "Fr"),
                            ChartBar(height: 50, label: "Sa"),
                            ChartBar(height: 100, label: "Su"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Withdrawal History",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "View All",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const WithdrawalHistoryTile(
                          date: "14/06/2021",
                          amount: "\$100",
                        ),
                        const WithdrawalHistoryTile(
                          date: "24/05/2021",
                          amount: "\$224",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. PROFILE SCREEN
// ---------------------------------------------------------

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 20),
          Text(text),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const BlueHeader(title: "Profile", height: 200),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
              child: Column(
                children: [
                  CustomCard(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            // Placeholder for profile image, could use Image.network
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Richard Beck",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "Heavy Vehicle Driving",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        SmallActionButton(
                          label: "Edit",
                          onPressed: () {
                            // Handle edit profile action
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomCard(
                    child: Column(
                      children: const [
                        ProfileInfoRow(
                          icon: Icons.phone,
                          text: "+91 99999 88888",
                        ),
                        Divider(indent: 50),
                        ProfileInfoRow(
                          icon: Icons.email,
                          text: "richardbeck@gmail.com",
                        ),
                        Divider(indent: 50),
                        ProfileInfoRow(
                          icon: Icons.location_on,
                          text: "81 Washington Walk, NY",
                        ),
                        Divider(indent: 50),
                        ProfileInfoRow(
                          icon: Icons.qr_code,
                          text: "Scan Student QR",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
