import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'digital_ticket_screen.dart'; // تأكد إن ده مسار الملف الصح عندك
import '../../../main_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final double price;
  final String busName;
  final String route;
  final String fromTo;
  final int ticketsCount;
  final String? busImagePath;
  final String seatNumber;

  final String bookingId = "OTU-992834";

  const BookingConfirmationScreen({
    super.key,
    required this.price,
    required this.busName,
    required this.route,
    required this.fromTo,
    required this.ticketsCount,
    this.busImagePath,
    this.seatNumber = "12A (Window)",
  });

  Future<void> _openGoogleMaps(BuildContext context) async {
    final String query = Uri.encodeComponent(fromTo.split(' → ')[0]);
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  // ==========================================
  // دالة إظهار تنبيه الخروج (Exit Dialog)
  // ==========================================
  Future<bool> _showExitDialog(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161824) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Exit Confirmation', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to exit? Your booking is already secured.', style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[700])),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // لو داس لا، يقفل المربع ويرجع false
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0A8A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(context).pop(true), // لو داس آه، يرجع true
            child: const Text('Yes, Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ) ?? false; // لو ضغط بره المربع، يرجع false
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color scaffoldBg = isDark ? const Color(0xFF0C0E17) : const Color(0xFFF9FAFB);
    final Color cardBg = isDark ? const Color(0xFF161824) : Colors.white;
    final Color primaryBlue = isDark ? const Color(0xFF000080) : const Color(0xFF0A0A8A);
    final Color textMain = isDark ? Colors.white : const Color(0xFF0A0A5A);
    final Color textGrey = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final Color highlightGold = isDark ? const Color(0xFFFFD700) : const Color(0xFFD4AF37);

    final now = DateTime.now();
    final String dynamicDate = DateFormat('MMM dd, yyyy').format(now);
    final String dynamicTime = DateFormat('hh:mm a').format(now);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('CONFIRMATION',
            style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(color: highlightGold.withValues(alpha: 0.1), shape: BoxShape.circle),
                  ),
                  Container(
                    width: 75, height: 75,
                    decoration: BoxDecoration(
                      color: highlightGold,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: highlightGold.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 5)],
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Booking\nConfirmed!',
                textAlign: TextAlign.center,
                style: TextStyle(color: textMain, fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)),
            const SizedBox(height: 16),
            Text('Pack your bags! Your journey with OTUBUS\nis secured.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textGrey, fontSize: 14, fontWeight: FontWeight.w600, height: 1.5)),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTicketInfo('SERVICE TIER', busName, highlightGold, isDark),
                      _buildTicketInfo('BOOKING ID', bookingId, textMain, isDark, alignEnd: true),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(color: Colors.grey, thickness: 0.2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTicketInfo('BUS ID', 'OTU-GOLD-102', textMain, isDark),
                      _buildTicketInfo('SEAT', seatNumber, textMain, isDark, alignEnd: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTicketInfo('DATE', dynamicDate, textMain, isDark),
                      _buildTicketInfo('TIME', dynamicTime, textMain, isDark, alignEnd: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BOARDING POINT', style: TextStyle(color: highlightGold, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: highlightGold, size: 16),
                              const SizedBox(width: 6),
                              Text(fromTo.split(' → ')[0], style: TextStyle(color: textMain, fontSize: 14, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            GestureDetector(
              onTap: () => _openGoogleMaps(context),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/map_bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black87 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.explore_outlined, color: Color(0xFFD4AF37), size: 16),
                        const SizedBox(width: 8),
                        Text('View on Map', style: TextStyle(color: textMain, fontSize: 12, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // زرار View Ticket (بيبعت الداتا كلها)
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => DigitalTicketScreen(
                        price: price,
                        busName: busName,
                        route: route,
                        fromTo: fromTo,
                        ticketsCount: ticketsCount,
                        busImagePath: busImagePath,
                        seatNumber: seatNumber, // بعتنا الكرسي
                        bookingId: bookingId,   // بعتنا رقم الحجز
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutQuart;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(position: animation.drive(tween), child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.confirmation_num_outlined, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('View Ticket', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ==========================================
            // زرار Return to Home (مع تنبيه قبل الخروج)
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 60,
              child: TextButton(
                onPressed: () async {
                  // إظهار التنبيه أولاً
                  bool shouldExit = await _showExitDialog(context);

                  // لو وافق على الخروج
                  if (shouldExit && context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                          (route) => false,
                    );
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F4F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Return to Home', style: TextStyle(color: textMain, fontSize: 16, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value, Color valueColor, bool isDark, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: valueColor, fontSize: 15, fontWeight: FontWeight.w900)),
      ],
    );
  }
}