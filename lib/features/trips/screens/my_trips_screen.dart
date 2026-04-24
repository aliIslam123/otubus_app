import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const BusTicketApp());
}

// THEME PROVIDER

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

//  APP THEMES

class AppThemes {
  static const Color primaryBlue = Color(0xFF00008B);
  static const Color gold = Color(0xFFD4AF37);
  static const Color errorRed = Color(0xFFE74C3C);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: const Color(0xFFF2F2F7),
    fontFamily: 'SF Pro Display',
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: gold,
      surface: Colors.white,
      background: Color(0xFFF2F2F7),
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1A1A2E),
      onBackground: Color(0xFF1A1A2E),
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF2F2F7),
      foregroundColor: Color(0xFF1A1A2E),
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.white,
      labelColor: primaryBlue,
      unselectedLabelColor: Colors.grey,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: const Color(0xFF0A0A1A),
    fontFamily: 'SF Pro Display',
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: gold,
      surface: Color(0xFF141428),
      background: Color(0xFF0A0A1A),
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0A0A1A),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFF141428),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF0A0A1A),
      selectedItemColor: gold,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.white,
      labelColor: Color(0xFF0A0A1A),
      unselectedLabelColor: Colors.grey,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF0A0A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
    ),
  );
}

//  MAIN APP

class BusTicketApp extends StatefulWidget {
  const BusTicketApp({super.key});

  @override
  State<BusTicketApp> createState() => _BusTicketAppState();
}

class _BusTicketAppState extends State<BusTicketApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Bus Tickets',
          debugShowCheckedModeBanner: false,
          themeMode: _themeProvider.themeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          home: MainNavigationScreen(themeProvider: _themeProvider),
        );
      },
    );
  }
}

//  DATA MODELS

class Trip {
  final String id;
  final String title;
  final DateTime date;
  final String time;
  final String seat;
  final String seatClass;
  final String busNumber;
  final String status;
  final Color accentColor;
  final String qrData;

  Trip({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.seat,
    required this.seatClass,
    required this.busNumber,
    required this.status,
    required this.accentColor,
    required this.qrData,
  });
}

//  MAIN NAVIGATION

class MainNavigationScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const MainNavigationScreen({super.key, required this.themeProvider});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const SizedBox(),
    const SizedBox(),
    const MyTripsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 'HOME', 0),
                _buildNavItem(Icons.search_outlined, 'SEARCH', 1),
                _buildNavItem(Icons.confirmation_number_outlined, 'TICKETS', 2),
                _buildNavItem(Icons.person_outline, 'PROFILE', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? AppThemes.gold : AppThemes.primaryBlue;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : Colors.grey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  MY TRIPS SCREEN

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isUpcoming = true;

  final List<Trip> upcomingTrips = [
    Trip(
      id: '1',
      title: 'Downtown to OTU',
      date: DateTime(2026, 10, 21),
      time: '08:30 AM',
      seat: '12A',
      seatClass: 'Premium',
      busNumber: 'OTU-402',
      status: 'CONFIRMED',
      accentColor: const Color(0xFF00008B),
      qrData: 'TRIP-DT-OTU-001',
    ),
    Trip(
      id: '2',
      title: 'Airport Express to OTU',
      date: DateTime(2026, 10, 28),
      time: '02:15 PM',
      seat: '04C',
      seatClass: 'Standard',
      busNumber: 'OTU-881',
      status: 'CONFIRMED',
      accentColor: const Color(0xFFD4AF37),
      qrData: 'TRIP-AE-OTU-002',
    ),
  ];

  final List<Trip> pastTrips = [
    Trip(
      id: '3',
      title: 'OTU to Downtown',
      date: DateTime(2026, 4, 15),
      time: '10:00 AM',
      seat: '05B',
      seatClass: 'Standard',
      busNumber: 'OTU-105',
      status: 'COMPLETED',
      accentColor: Colors.grey,
      qrData: 'TRIP-OTU-DT-003',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _isUpcoming = _tabController.index == 0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: isDark ? Colors.white : const Color(0xFF00008B),
                      ),
                    ),
                  ),

                  Text(
                    'My Trips',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? AppThemes.gold.withOpacity(0.15) : const Color(0xFFC7C7DC),
                      boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 18,
                      color: isDark ? AppThemes.gold : const Color(0xFF00008B),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFE8E8ED),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: isDark ? Colors.black : const Color(0xFF00008B),
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTripsList(upcomingTrips, true),
                  _buildTripsList(pastTrips, false),
                ],
              ),
            ),

            if (_isUpcoming)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                child: _buildPromoBanner(isDark),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsList(List<Trip> trips, bool isUpcoming) {
    if (trips.isEmpty) {
      return const Center(
        child: Text(
          'No trips found',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: TripCard(trip: trips[index], isUpcoming: isUpcoming),
        );
      },
    );
  }

  Widget _buildPromoBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF00008B), const Color(0xFF1A1A3E)]
              : [const Color(0xFF00008B), const Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00008B).withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EXCLUSIVE OFFER',
                  style: TextStyle(
                    color: AppThemes.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Book 5 trips and get 1 free!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Learn More',
                    style: TextStyle(
                      color: AppThemes.primaryBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.card_giftcard_outlined,
            size: 48,
            color: Colors.white.withOpacity(0.12),
          ),
        ],
      ),
    );
  }
}

//  TRIP CARD

class TripCard extends StatelessWidget {
  final Trip trip;
  final bool isUpcoming;

  const TripCard({super.key, required this.trip, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF141428) : Colors.white;
    final iconColor = isUpcoming
        ? (isDark ? AppThemes.gold : trip.accentColor)
        : Colors.grey;

    return GestureDetector(
      onTap: () => _showTicketDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: isUpcoming ? trip.accentColor : Colors.grey.shade300,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip.status,
                              style: TextStyle(
                                color: isUpcoming
                                    ? (isDark ? AppThemes.gold : const Color(0xFFD4AF37))
                                    : Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),

                            if (isUpcoming)
                              Icon(
                                Icons.qr_code_2,
                                size: 26,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          trip.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF00008B),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                Icons.calendar_today_outlined,
                                'DATE',
                                _formatDate(trip.date),
                                iconColor,
                                isDark,
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                Icons.access_time_outlined,
                                'TIME',
                                trip.time,
                                iconColor,
                                isDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                Icons.event_seat_outlined,
                                'SEAT',
                                '${trip.seat} (${trip.seatClass})',
                                iconColor,
                                isDark,
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                Icons.directions_bus_outlined,
                                'BUS NO.',
                                trip.busNumber,
                                iconColor,
                                isDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Container(
                          width: double.infinity,
                          height: 1,
                          color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200,
                        ),

                        const SizedBox(height: 10),

                        if (isUpcoming) ...[
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00008B).withOpacity(0.35),
                                        blurRadius: 12,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => _showTicketDetails(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00008B),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'View Ticket',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: TextButton(
                                  onPressed: () => _showCancelDialog(context),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFFE74C3C),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: const Color(0xFFE74C3C).withOpacity(0.25),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text(
                                'Trip Completed',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]},${date.day},${date.year}';
  }

  Widget _buildDetailItem(IconData icon, String label, String value, Color color, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 13, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTicketDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TicketDetailSheet(trip: trip),
    );
  }

  void _showCancelDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Cancel Trip?',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Are you sure you want to cancel "${trip.title}"?',
          style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Keep',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Trip cancelled successfully'),
                  backgroundColor: Color(0xFF00008B),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel Trip'),
          ),
        ],
      ),
    );
  }
}

//  TICKET DETAIL BOTTOM SHEET

class TicketDetailSheet extends StatelessWidget {
  final Trip trip;

  const TicketDetailSheet({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.colorScheme.background;
    final cardColor = isDark ? const Color(0xFF141428) : Colors.white;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        QrImageView(
                          data: trip.qrData,
                          version: QrVersions.auto,
                          size: 200,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          trip.qrData,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  _buildDetailRow('Passenger', 'Name', isDark),
                  _buildDetailRow('Route', trip.title, isDark),
                  _buildDetailRow('Date', '${trip.date.day}/${trip.date.month}/${trip.date.year}', isDark),
                  _buildDetailRow('Time', trip.time, isDark),
                  _buildDetailRow('Seat', '${trip.seat} (${trip.seatClass})', isDark),
                  _buildDetailRow('Bus Number', trip.busNumber, isDark),
                  _buildDetailRow('Status', trip.status, isDark),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Ticket downloaded to gallery'),
                            backgroundColor: isDark ? AppThemes.gold : const Color(0xFF000000),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Download Ticket'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppThemes.gold : const Color(0xFF000000),
                        foregroundColor: isDark ? const Color(0xFF0A0A1A) : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
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

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
//  PLACEHOLDER SCREENS

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile Screen',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final appState = context.findAncestorStateOfType<_BusTicketAppState>();
                appState?._themeProvider.toggleTheme();
              },
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              label: Text(isDark ? 'Switch to Light' : 'Switch to Dark'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemes.primaryBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}