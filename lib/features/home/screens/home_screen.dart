import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomeScreen(),
    );
  }
}

// ================= COLOR SYSTEM =================
// Light
const lNavy = Color(0xFF000080);
const lSlate = Color(0xFF64748B);
const lCool = Color(0xFF94A3B8);
const lBg = Color(0xFFF5F5F8);
const lCard = Color(0xFFFFFFFF);
const lGold = Color(0xFFD4AF37);
const lGreen = Color(0xFF059669);
const lOrange = Color(0xFFEA580C);

// Dark
const dBg = Color(0xFF0F0F14);
const dCard = Color(0xFF1E1E2D);
const dNavy = Color(0xFF334155);
const dBlueGray = Color(0xFF64748B);
const dCool = Color(0xFF94A3B8);
const dGold = Color(0xFFD4AF37);
const dGreen = Color(0xFF34D399);
const dOrange = Color(0xFFFB923C);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: lBg,
  fontFamily: 'SF',
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: dBg,
  fontFamily: 'SF',
);

// ================= HOME =================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(isDark: isDark),
            _LocationCard(isDark: isDark),
            _DateSection(isDark: isDark),
            _AvailableHeader(isDark: isDark),
            _BusList(isDark: isDark),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _Fab(isDark: isDark),
      bottomNavigationBar: _BottomBar(isDark: isDark),
    );
  }
}

// ================= HEADER =================
class _Header extends StatelessWidget {
  final bool isDark;
  const _Header({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? dGold : lGold, width: 2),
            ),
            child: const CircleAvatar(radius: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(color: isDark ? dCool : lSlate),
                ),
                Text(
                  'Hello,Ali',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : lNavy,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.white10 : Colors.black12,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.notifications_none,
              color: isDark ? Colors.white : lNavy,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= LOCATION =================
class _LocationCard extends StatelessWidget {
  final bool isDark;
  const _LocationCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? dCard : lCard,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: isDark ? dGold : lNavy),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CURRENT LOCATION', style: TextStyle(fontSize: 12)),
                Text('Downtown Campus Residence'),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}

// ================= DATE =================
class _DateSection extends StatefulWidget {
  final bool isDark;
  const _DateSection({required this.isDark});

  @override
  State<_DateSection> createState() => _DateSectionState();
}

class _DateSectionState extends State<_DateSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Select Date', style: TextStyle(fontSize: 18)),
              Text('October', style: TextStyle(color: lGold)),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (_, i) {
              final selected = i == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 16),
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: selected
                        ? (isDark ? dNavy : lNavy)
                        : (isDark ? Colors.white10 : Colors.white),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][i],
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey,
                        ),
                      ),
                      Text(
                        '${21 + i}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ================= AVAILABLE =================
class _AvailableHeader extends StatelessWidget {
  final bool isDark;
  const _AvailableHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Available Buses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            '14 Routes Found',
            style: TextStyle(color: isDark ? dCool : lSlate),
          ),
        ],
      ),
    );
  }
}

// ================= BUS LIST =================
class _BusList extends StatelessWidget {
  final bool isDark;
  const _BusList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _BusCard(isDark: isDark, premium: true),
          _BusCard(isDark: isDark),
          _BusCard(isDark: isDark, disabled: true),
        ],
      ),
    );
  }
}

class _BusCard extends StatelessWidget {
  final bool isDark;
  final bool premium;
  final bool disabled;

  const _BusCard({
    required this.isDark,
    this.premium = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? dCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (premium)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark ? dGold : lGold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'PREMIUM EXPRESS',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),

          // Timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.circle_outlined,
                    size: 14,
                    color: isDark ? Colors.white : lNavy,
                  ),
                  Container(
                    width: 2,
                    height: 30,
                    color: isDark ? dCool : lCool,
                  ),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: isDark ? dGold : lNavy,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('07:30 AM'),
                    SizedBox(height: 4),
                    Text('Downtown Station'),
                    SizedBox(height: 10),
                    Text('08:45 AM'),
                    SizedBox(height: 4),
                    Text('OTU Main Gate'),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 6),
                  const Text('1h 15m'),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: disabled
                          ? Colors.grey.withOpacity(0.2)
                          : (isDark
                                ? dGreen.withOpacity(0.2)
                                : lGreen.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      disabled ? 'Fully Booked' : '12 seats left',
                      style: TextStyle(
                        color: disabled
                            ? Colors.grey
                            : (isDark ? dGreen : lGreen),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: disabled
                      ? Colors.grey
                      : (isDark ? dNavy : lNavy),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: disabled ? null : () {},
                child: Text(disabled ? 'Sold Out' : 'Book Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ================= FAB =================
class _Fab extends StatelessWidget {
  final bool isDark;
  const _Fab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: isDark ? dNavy : lNavy,
      onPressed: () {},
      child: const Icon(Icons.add_circle_outline, size: 28),
    );
  }
}

// ================= BOTTOM =================
class _BottomBar extends StatelessWidget {
  final bool isDark;
  const _BottomBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'Home', true, isDark),
            _navItem(Icons.confirmation_num, 'Tickets', false, isDark),
            const SizedBox(width: 40),
            _navItem(Icons.account_balance_wallet, 'Wallet', false, isDark),
            _navItem(Icons.person, 'Profile', false, isDark),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active, bool isDark) {
    final color = active
        ? (isDark ? Colors.white : lNavy)
        : (isDark ? dCool : lSlate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
