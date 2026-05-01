import 'package:flutter/material.dart';

class BookingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps = 5;

  const BookingProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // الألوان بناءً على الثيم
    final Color progressColor = isDark ? const Color(0xFF3B82F6) : const Color(0xFF0A0A8A);
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color trackBg = isDark ? const Color(0xFF222534) : const Color(0xFFE5E7EB);

    // حساب نسبة العرض بناءً على الخطوة الحالية
    // لو الخطوة 1 من 5 -> هيملا 20%، 2 من 5 -> هيملا 40%، وهكذا
    double fillPercentage = currentStep / totalSteps;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // أنيميشن تغيير الرقم بنعومة (Fade Animation)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Text(
                'STEP $currentStep OF $totalSteps',
                key: ValueKey<int>(currentStep), // عشان فلاتر يعرف إن الرقم اتغير ويعمل الأنيميشن
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: progressColor, letterSpacing: 0.5),
              ),
            ),
            Text('Booking Flow', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textMain)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // الخط الرمادي (الخلفية)
            Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(color: trackBg, borderRadius: BorderRadius.circular(2))
            ),
            // الخط الأزرق اللي بيعمل أنيميشن التعبئة (Fill Animation)
            LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedContainer(
                      duration: const Duration(milliseconds: 600), // سرعة تعبئة الخط
                      curve: Curves.easeOutCubic,
                      height: 4,
                      width: constraints.maxWidth * fillPercentage,
                      decoration: BoxDecoration(color: progressColor, borderRadius: BorderRadius.circular(2))
                  );
                }
            ),
          ],
        ),
      ],
    );
  }
}