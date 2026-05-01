import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'select_travel_days_screen.dart'; // دي الصفحة اللي هتروحلها
import 'booking_progress_bar.dart';

class SelectSeatScreen extends StatefulWidget {
  final double baseTicketPrice;

  const SelectSeatScreen({
    super.key,
    this.baseTicketPrice = 10.00,
  });

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  final int rows = 10;

  final List<String> occupiedSeats = ['1C', '1D', '3C', '4A', '6B'];
  final List<String> premiumSeats = ['1A', '1B'];

  String? selectedSeat;
  final Color premiumGold = const Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg = isDark ? const Color(0xFF13131A) : Colors.white;
    final Color panelBg = isDark ? const Color(0xFF1C1C24) : const Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: BookingProgressBar(currentStep: 1),
            ),

            _buildLegend(isDark),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: panelBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: Column(
                  children: [
                    _buildFrontOfBusIndicator(isDark),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 10, bottom: 40),
                        physics: const BouncingScrollPhysics(),
                        itemCount: rows,
                        itemBuilder: (context, index) {
                          return _buildSeatRow(index + 1, isDark);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomPanel(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    final Color primaryBlue = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0A0A8A);
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color textGrey = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A35) : primaryBlue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : primaryBlue, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Column(
            children: [
              Text('Select Your Seat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textMain)),
              const SizedBox(height: 4),
              Text('OTUBUS Express • Route 402', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textGrey)),
            ],
          ),
          Container(
            width: 45, height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? const Color(0xFF3F3F46) : primaryBlue.withValues(alpha: 0.1), width: 2),
            ),
            child: Icon(Icons.info_outline, color: isDark ? Colors.white : primaryBlue, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    final Color primaryBlue = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0A0A8A);
    final Color textGrey = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final Color occupiedIcon = isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('AVAILABLE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textGrey)),
          Text('SELECTED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: primaryBlue)),
          Text('OCCUPIED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: occupiedIcon)),
          Text('PREMIUM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: premiumGold)),
        ],
      ),
    );
  }

  Widget _buildFrontOfBusIndicator(bool isDark) {
    final Color occupiedIcon = isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);
    final Color lineColor = isDark ? const Color(0xFF3F3F46) : const Color(0xFFE5E7EB);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        children: [
          Container(width: 50, height: 4, decoration: BoxDecoration(color: lineColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Text('FRONT OF BUS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: occupiedIcon, letterSpacing: 1.5)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: occupiedIcon, size: 20),
                  const SizedBox(width: 6),
                  Text('BUS DRIVER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: occupiedIcon)),
                ],
              ),
              Row(
                children: [
                  Text('ENTRANCE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: occupiedIcon)),
                  const SizedBox(width: 6),
                  Icon(Icons.meeting_room_outlined, color: occupiedIcon, size: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatRow(int rowIndex, bool isDark) {
    final Color textGrey = isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSeat('${rowIndex}A', isDark),
          const SizedBox(width: 12),
          _buildSeat('${rowIndex}B', isDark),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '$rowIndex',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textGrey),
              ),
            ),
          ),
          _buildSeat('${rowIndex}C', isDark),
          const SizedBox(width: 12),
          _buildSeat('${rowIndex}D', isDark),
        ],
      ),
    );
  }

  Widget _buildSeat(String seatId, bool isDark) {
    bool isOccupied = occupiedSeats.contains(seatId);
    bool isSelected = selectedSeat == seatId;
    bool isPremium = premiumSeats.contains(seatId);

    final Color primaryBlue = isDark ? const Color(0xFF1D4ED8) : const Color(0xFF0A0A8A);
    final Color availableBg = isDark ? const Color(0xFF2A2A35) : Colors.white;
    final Color availableBorder = isDark ? const Color(0xFF3F3F46) : const Color(0xFFD1D5DB);
    final Color occupiedBg = isDark ? const Color(0xFF1F1F28) : const Color(0xFFE5E7EB);
    final Color occupiedIcon = isDark ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF);
    final Color textMain = isDark ? Colors.white : const Color(0xFF1F2937);

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
        HapticFeedback.lightImpact();
        setState(() => selectedSeat = seatId);
      },
      child: AnimatedScale(
        scale: isSelected ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : (isOccupied ? occupiedBg : availableBg),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? primaryBlue
                  : (isPremium ? premiumGold : (isOccupied ? occupiedBg : availableBorder)),
              width: 1.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: primaryBlue.withValues(alpha: isDark ? 0.6 : 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                )
            ],
          ),
          child: Center(
            child: isOccupied
                ? Icon(Icons.person_outline, size: 22, color: occupiedIcon)
                : Text(
              seatId,
              style: TextStyle(
                color: isSelected ? Colors.white : (isPremium ? premiumGold : textMain),
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateTotalPrice() {
    if (selectedSeat == null) return 0.0;
    bool isPremium = premiumSeats.contains(selectedSeat);
    // لو اختار كرسي عادي بـ سعر الاتوبيس ، لو كرسي Premium هنزود عليه 2.50 دولار
    return isPremium ? widget.baseTicketPrice + 2.50 : widget.baseTicketPrice;
  }

  String _getSeatDetails() {
    if (selectedSeat == null) return '';
    bool isWindow = selectedSeat!.endsWith('A') || selectedSeat!.endsWith('D');
    String rowNum = selectedSeat!.substring(0, selectedSeat!.length - 1);
    return 'Row $rowNum, ${isWindow ? 'Window' : 'Aisle'}';
  }

  Widget _buildBottomPanel(bool isDark) {
    double totalPrice = _calculateTotalPrice();

    final Color panelBg = isDark ? const Color(0xFF13131A) : Colors.white;
    final Color topBorder = isDark ? const Color(0xFF1C1C24) : Colors.grey.shade200;
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color textGrey = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final Color primaryBlue = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0A0A8A);
    final Color btnBg = isDark ? const Color(0xFF1D4ED8) : const Color(0xFF0A0A8A);
    final Color disabledBtnBg = isDark ? const Color(0xFF2A2A35) : const Color(0xFFE5E7EB);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
      decoration: BoxDecoration(
        color: panelBg,
        border: Border(top: BorderSide(color: topBorder, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('YOUR SELECTION', style: TextStyle(color: textGrey, fontSize: 11, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                          selectedSeat ?? 'None',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: primaryBlue)
                      ),
                      if (selectedSeat != null) ...[
                        const SizedBox(width: 8),
                        Text(_getSeatDetails(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textGrey)),
                      ]
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('TOTAL PRICE', style: TextStyle(color: textGrey, fontSize: 11, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                      'EGP ${totalPrice > 0 ? totalPrice.toStringAsFixed(2) : "0.00"}',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textMain)
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: selectedSeat == null ? null : () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SelectTravelDaysScreen(
                      price: totalPrice,
                      busName: 'OTUBUS Express',
                      route: 'Route 402',
                      fromTo: 'Zayed → OTU',
                      ticketsCount: 1,
                      busImagePath: 'assets/images/bus1.png',
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: btnBg,
                disabledBackgroundColor: disabledBtnBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Confirm Seat Selection', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.8), size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
