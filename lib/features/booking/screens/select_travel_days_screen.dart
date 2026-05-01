import 'package:flutter/material.dart';
import 'select_boarding_area_screen.dart';
import 'booking_progress_bar.dart'; // استدعاء شريط التقدم

class SelectTravelDaysScreen extends StatefulWidget {
  // --- 1. ضفنا المتغيرات دي عشان نستقبل السعر والبيانات من صفحة الكراسي ---
  final double price;
  final String busName;
  final String route;
  final String fromTo;
  final int ticketsCount;
  final String? busImagePath;

  const SelectTravelDaysScreen({
    super.key,
    required this.price,
    required this.busName,
    required this.route,
    required this.fromTo,
    required this.ticketsCount,
    this.busImagePath,
  });

  @override
  State<SelectTravelDaysScreen> createState() => _SelectTravelDaysScreenState();
}

class _SelectTravelDaysScreenState extends State<SelectTravelDaysScreen> {
  // اللستة ضفنا فيها يوم الأحد في الأول
  final List<String> _weekDays = ['Saturday','Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

  // اللستة بتبدأ فاضية عشان اليوزر يختار براحته والحسبة تظبط
  final Set<String> _selectedDays = {};

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // الحسبة الصحيحة للأيام
    final daysPerWeek = _selectedDays.length;
    final totalDays = daysPerWeek * 4;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : theme.primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Travel Days',
          style: TextStyle(
            color: isDark ? Colors.white : theme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [

            // --- إضافة الـ Progress Bar للخطوة 2 ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: BookingProgressBar(currentStep: 2),
            ),
            // ----------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Commute',
                      style: TextStyle(
                        color: isDark ? Colors.white : theme.primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select the days of the week you will be\ncommuting to campus for your monthly\npass.',
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // أزرار الأيام
                    ..._weekDays.map((day) => _buildDayButton(day, theme, isDark)),

                    const SizedBox(height: 16),

                    // صندوق الملاحظة
                    _buildInfoBox(theme, isDark),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // الجزء الثابت تحت بالديزاين الجديد
            _buildBottomSummary(daysPerWeek, totalDays, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : const Color(0xFFE8EEF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: isDark ? Colors.grey.shade400 : theme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Monthly passes are calculated based on a 4-week cycle for the selected days.',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
                fontSize: 12,
                height: 1.4,
                fontWeight: isDark ? FontWeight.normal : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayButton(String day, ThemeData theme, bool isDark) {
    bool isSelected = _selectedDays.contains(day);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => _toggleDay(day),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : (isDark ? theme.colorScheme.surface : Colors.white),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: isSelected ? theme.primaryColor : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
              width: 1.5,
            ),
            boxShadow: [
              if (!isDark && isSelected)
                BoxShadow(color: theme.primaryColor.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKDAY',
                    style: TextStyle(
                      color: isSelected ? theme.colorScheme.secondary : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? theme.colorScheme.secondary : (isDark ? Colors.white : Colors.black87),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Icon(
                isSelected ? Icons.check_circle_outline : Icons.radio_button_unchecked,
                color: isSelected ? theme.colorScheme.secondary : Colors.grey.shade400,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary(int daysPerWeek, int totalDays, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0, top: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
              color: isDark ? theme.colorScheme.surface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('MONTHLY COMMITMENT', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.2)),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('$daysPerWeek Days Per Week', style: TextStyle(color: isDark ? Colors.white : theme.primaryColor, fontSize: 16, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(width: 1, height: 30, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),

                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('TOTAL DAYS', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.2)),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('$totalDays Days', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: daysPerWeek > 0
                  ? () {
                // --- 2. أنيميشن الزحلقة وبنبعت الداتا كلها للصفحة اللي بعدها ---
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SelectBoardingAreaScreen(
                      price: widget.price,               // الداتا بتكمل سفرها
                      busName: widget.busName,
                      route: widget.route,
                      fromTo: widget.fromTo,
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
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Continue to Location',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}