import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'student_information_screen.dart';
import 'booking_progress_bar.dart'; // استدعاء الـ Progress Bar

class SelectBoardingAreaScreen extends StatefulWidget {
  // --- 1. استقبال الداتا من صفحة الأيام ---
  final double price;
  final String busName;
  final String route;
  final String fromTo;
  final int ticketsCount;
  final String? busImagePath;

  const SelectBoardingAreaScreen({
    super.key,
    this.price = 10.00,
    this.busName = 'OTUBUS Express',
    this.route = 'Route 402',
    this.fromTo = 'Downtown → OTU',
    this.ticketsCount = 1,
    this.busImagePath,
  });

  @override
  State<SelectBoardingAreaScreen> createState() => _SelectBoardingAreaScreenState();
}

class _SelectBoardingAreaScreenState extends State<SelectBoardingAreaScreen> {
  String? selectedStopTitle;

  final List<Map<String, dynamic>> _stops = [
    {
      'title': 'North Plaza',
      'subtitle': 'University Main Entrance',
      'icon': Icons.map_outlined,
      'isPopular': true,
    },
    {
      'title': 'Downtown',
      'subtitle': 'Central Station Loop',
      'icon': Icons.location_on_outlined,
      'isPopular': false,
    },
    {
      'title': 'Tech Hub',
      'subtitle': 'Engineering & IT Complex',
      'icon': Icons.biotech_outlined,
      'isPopular': false,
    },
    {
      'title': 'East Terminal',
      'subtitle': 'Student Housing Area B',
      'icon': Icons.directions_bus_outlined,
      'isPopular': false,
    },
  ];

  Future<void> _openGoogleMaps() async {
    final String query = Uri.encodeComponent("October Technological University");
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    try {
      await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomAppBar(theme, isDark),

            // --- إضافة الـ Progress Bar للخطوة 3 ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: BookingProgressBar(currentStep: 3),
            ),
            // ----------------------------------------

            const SizedBox(height: 8),
            _buildSearchBar(theme, isDark),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'RECOMMENDED STOPS',
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                physics: const BouncingScrollPhysics(),
                itemCount: _stops.length + 1,
                itemBuilder: (context, index) {
                  if (index == _stops.length) {
                    return _buildMapViewCard(theme, isDark);
                  }
                  return _buildStopCard(_stops[index], theme, isDark);
                },
              ),
            ),

            _buildBottomActionPanel(theme, isDark),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(theme, isDark),
    );
  }

  Widget _buildCustomAppBar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 24.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23232A) : const Color(0xFFE8EEF5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? theme.colorScheme.secondary : theme.primaryColor,
                  size: 20
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Select Boarding Area',
            style: TextStyle(
              color: isDark ? Colors.white : theme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: TextField(
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: Colors.grey.shade500),
            hintText: 'Search campus locations...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildStopCard(Map<String, dynamic> stop, ThemeData theme, bool isDark) {
    bool isSelected = selectedStopTitle == stop['title'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? theme.primaryColor.withValues(alpha: 0.2) : theme.primaryColor.withValues(alpha: 0.05))
            : (isDark ? const Color(0xFF23232A) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? theme.primaryColor : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : (isDark ? theme.primaryColor : const Color(0xFFE8EEF5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            stop['icon'],
            color: isSelected ? Colors.white : (isDark ? theme.colorScheme.secondary : theme.primaryColor),
            size: 24,
          ),
        ),
        // ==========================================
        // التعديل هنا: استخدمنا Wrap بدل Row
        // ==========================================
        title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8, // مسافة أفقية بين الاسم والبادج
            runSpacing: 4, // لو نزلوا سطر ياخدوا مسافة رأسية
            children: [
              Text(
                stop['title'],
                style: TextStyle(
                  color: isDark ? Colors.white : theme.primaryColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              if (stop['isPopular'])
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'MOST POPULAR',
                    style: TextStyle(color: Color(0xFF0A0A5A), fontSize: 8, fontWeight: FontWeight.w900),
                  ),
                ),
            ],
          ),
        ),
        subtitle: Text(
          stop['subtitle'],
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: theme.primaryColor)
            : Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
        onTap: () {
          setState(() {
            selectedStopTitle = stop['title'];
          });
        },
      ),
    );
  }

  Widget _buildMapViewCard(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 24.0),
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? Colors.grey.shade800 : const Color(0xFF8B93AF),
        image: const DecorationImage(
          image: AssetImage('assets/images/map_bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
        ),
      ),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _openGoogleMaps,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? theme.colorScheme.secondary : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          icon: Icon(
              Icons.map_outlined,
              color: isDark ? Colors.black : theme.primaryColor,
              size: 18
          ),
          label: Text(
            'Open Map View',
            style: TextStyle(
              color: isDark ? Colors.black : theme.primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionPanel(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedStopTitle == null
                  ? null
                  : () {
                // --- 2. تمرير الداتا لصفحة بيانات الطالب ---
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => StudentInformationScreen(
                      price: widget.price,
                      busName: widget.busName,
                      route: widget.route,
                      fromTo: '$selectedStopTitle → OTU',
                      ticketsCount: widget.ticketsCount,
                      busImagePath: widget.busImagePath,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text(
                  'Continue to Details',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(ThemeData theme, bool isDark) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: isDark ? theme.colorScheme.secondary : theme.primaryColor,
      unselectedItemColor: Colors.grey.shade500,
      currentIndex: 1,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Routes'),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_outlined), label: 'Tickets'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}