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
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF00008B),
          secondary: const Color(0xFFF0F2F9),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00008B),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const MainNavigationHolder(),
    );
  }
}

class MainNavigationHolder extends StatefulWidget {
  const MainNavigationHolder({super.key});

  @override
  State<MainNavigationHolder> createState() => _MainNavigationHolderState();
}

class _MainNavigationHolderState extends State<MainNavigationHolder> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Scaffold(body: Center(child: Text("Home"))),
    Scaffold(body: Center(child: Text("Alerts"))),
    Scaffold(body: Center(child: Text("Wallet"))),
    Scaffold(body: Center(child: Text("Profile"))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
