import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const DriverProjectApp());

class AlertSetting {
  final String id;
  final String title;
  final String subtitle;
  bool isEnabled;
  AlertSetting({required this.id, required this.title, required this.subtitle, required this.isEnabled});
}

class AppState extends ChangeNotifier {
  double walletBalance = 1544.00;
  double todayRevenue = 244.00;
  int todayRides = 14;
  List<AlertSetting> alerts = [
    AlertSetting(id: '1', title: 'Over Speeding', subtitle: 'High Speed Alert Feature', isEnabled: true),
    AlertSetting(id: '2', title: 'Harsh Braking', subtitle: 'Harsh Braking Warning Alert', isEnabled: false),
    AlertSetting(id: '3', title: 'Vehicle\'s Engine', subtitle: 'Vehicle Engine Warning Alert', isEnabled: true),
    AlertSetting(id: '4', title: 'Car Idling', subtitle: 'Car Idling Fuel Consumption Alert', isEnabled: false),
    AlertSetting(id: '5', title: 'Engine Oil Pressure', subtitle: 'Engine Oil Pressure Warning Alert', isEnabled: true),
  ];
  void toggleAlert(int index) {
    alerts[index].isEnabled = !alerts[index].isEnabled;
    notifyListeners();
  }
  void withdraw(double amount) {
    if (walletBalance >= amount) {
      walletBalance -= amount;
      notifyListeners();
    }
  }
}

class DriverProjectApp extends StatelessWidget {
  const DriverProjectApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1A1A40),
          scaffoldBackgroundColor: const Color(0xFFF5F6FA),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1A1A40), foregroundColor: Colors.white, centerTitle: true),
        ),
        home: const MainNavigationHolder(),
      ),
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
  final List<Widget> _screens = [const DashboardScreen(), const AlertSettingsScreen(), const WalletScreen(), const ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A1A40),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Stack(
      children: [
        Container(color: const Color(0xFFDEDAF4), child: const Center(child: Icon(Icons.map, size: 100, color: Colors.black12))),
        SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Today", style: TextStyle(color: Colors.grey)),
                      Text("\$ ${state.todayRevenue}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ]),
                    Text("${state.todayRides} Rides", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              _buildOngoingTripCard(),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildOngoingTripCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ongoing Trip", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Row(
            children: [
              const CircleAvatar(radius: 25, backgroundColor: Colors.blueGrey),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text("Megan Fox", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text("⭐ 4.8", style: TextStyle(color: Colors.orange))])),
              const Icon(Icons.chat_bubble, color: Color(0xFF1A1A40)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A40), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
            child: const Text("Navigation"),
          )
        ],
      ),
    );
  }
}

class AlertSettingsScreen extends StatelessWidget {
  const AlertSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text("Alert Settings")),
      body: ListView.builder(
        itemCount: state.alerts.length,
        itemBuilder: (context, index) {
          final alert = state.alerts[index];
          return SwitchListTile(
            title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(alert.subtitle),
            value: alert.isEnabled,
            activeColor: const Color(0xFF1A1A40),
            onChanged: (_) => state.toggleAlert(index),
          );
        },
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text("Wallet")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Last 1 Month", style: TextStyle(color: Colors.grey)),
            const Text("\$ 12,491.22", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildChart(),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF1A1A40), borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text("Wallet Balance", style: TextStyle(color: Colors.white70)),
                    Text("\$ ${state.walletBalance}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ]),
                  ElevatedButton(
                    onPressed: () => state.withdraw(100),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF1A1A40)),
                    child: const Text("Withdrawal"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildChart() {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [80.0, 120.0, 60.0, 90.0, 110.0, 70.0, 100.0].map((h) => Container(width: 12, height: h, decoration: BoxDecoration(color: const Color(0xFF1A1A40), borderRadius: BorderRadius.circular(5)))).toList(),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(radius: 50, backgroundColor: Colors.indigo, child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 15),
          const Text("Richard Beck", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Heavy Vehicle Driving", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          _item(Icons.phone, "+91 99999 88888"),
          _item(Icons.email, "richardbeck@gmail.com"),
          _item(Icons.location_on, "81 Washington Walk, New York"),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Scan Student QR"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A40), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 55)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _item(IconData icon, String text) => ListTile(leading: Icon(icon, color: const Color(0xFF1A1A40)), title: Text(text));
}
