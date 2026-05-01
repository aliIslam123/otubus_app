import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DigitalTicketScreen extends StatefulWidget {
  final double price;
  final String busName;
  final String route;
  final String fromTo;
  final int ticketsCount;
  final String? busImagePath;
  final String seatNumber;
  final String bookingId;

  const DigitalTicketScreen({
    super.key,
    required this.price,
    required this.busName,
    required this.route,
    required this.fromTo,
    required this.ticketsCount,
    this.busImagePath,
    this.seatNumber = "12A (Window)",
    this.bookingId = "OTU-992834",
  });

  @override
  State<DigitalTicketScreen> createState() => _DigitalTicketScreenState();
}

class _DigitalTicketScreenState extends State<DigitalTicketScreen> {
  final String travelTime = "08:30 AM";
  final String terminal = "Main Gate 4";

  // --- المتحكم الخاص بالتقاط الصورة (Screenshot) ---
  final ScreenshotController screenshotController = ScreenshotController();

  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
            const SizedBox(width: 16),
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 16),
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 16),
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  // ==========================================
  // 1. دالة الشير كصورة (Screenshot) فعلية
  // ==========================================
  Future<void> _shareTicket() async {
    _showLoadingSnackBar('Capturing Ticket Image...');

    try {
      final imageBytes = await screenshotController.capture(delay: const Duration(milliseconds: 10));

      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/otubus_ticket.png').create();

        await imagePath.writeAsBytes(imageBytes);

        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        await Share.shareXFiles(
            [XFile(imagePath.path)],
            text: 'Here is my Digital Ticket for ${widget.busName}!\nRoute: ${widget.route}\nSeat: ${widget.seatNumber}'
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showErrorSnackBar('Failed to share ticket image.');
    }
  }

  // ==========================================
  // 2. دالة حفظ PDF (محدثة لتطابق التصميم بالمللي)
  // ==========================================
  Future<void> _saveAsPDF() async {
    _showLoadingSnackBar('Generating PDF Document...');
    try {
      // 1. التقاط نفس الصورة اللي بنستخدمها في الشير
      final imageBytes = await screenshotController.capture(delay: const Duration(milliseconds: 10));

      if (imageBytes == null) {
        throw Exception("Failed to capture ticket image");
      }

      // 2. إنشاء ملف الـ PDF
      final pdf = pw.Document();

      // 3. تحويل الصورة لصيغة يقبلها ملف الـ PDF
      final image = pw.MemoryImage(imageBytes);

      // 4. وضع الصورة بكامل تفاصيلها وألوانها داخل صفحة الـ PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // فتح نافذة الحفظ/الطباعة
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save(), name: 'OTUBUS_Ticket.pdf');

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showErrorSnackBar('Failed to generate PDF.');
    }
  }

  Future<void> _addAppleWallet() async {
    _showLoadingSnackBar('Opening Apple Wallet...');
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _showSuccessSnackBar('Wallet integration coming soon!');
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
    final Color highlightCarrier = isDark ? const Color(0xFF222534) : const Color(0xFF0A0A8A);

    final String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textMain, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('DIGITAL TICKET', style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: textMain, size: 20),
            onPressed: _shareTicket,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ==========================================
            // تغليف التذكرة بـ Screenshot عشان نصورها
            // ==========================================
            Screenshot(
              controller: screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    // --- رأس التذكرة الأزرق ---
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: highlightCarrier,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: highlightGold, borderRadius: BorderRadius.circular(20)),
                              child: const Text('STUDENT PASS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 45, height: 45,
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: widget.busImagePath != null
                                    ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.asset(widget.busImagePath!, fit: BoxFit.cover))
                                    : Icon(Icons.directions_bus, color: highlightCarrier, size: 24),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('OPERATOR', style: TextStyle(color: highlightGold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                                  Text(widget.busName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // حل مشكلة المساحة (Overflow) باستخدام Expanded
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildPassengerInfo('PASSENGER', 'Eiar Mohamed', textMain, isDark),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: _buildSeatInfo('SEAT', widget.seatNumber, highlightGold),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(color: Colors.grey, thickness: 0.2)),

                    // --- بيانات الرحلة ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTripInfo('ROUTE', widget.route, textMain),
                          _buildTripInfo('TERMINAL', terminal, textMain, alignEnd: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTripInfo('DATE', formattedDate, textMain),
                          _buildTripInfo('DEPARTURE', travelTime, textMain, alignEnd: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- رمز الاستجابة السريعة ---
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF222534) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: QrImageView(
                            data: 'TXN-${widget.bookingId}',
                            version: QrVersions.auto,
                            size: 140,
                            gapless: false,
                          ),
                        ),
                        Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.directions_bus, color: highlightCarrier, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('TXN-${widget.bookingId}', style: TextStyle(color: textGrey, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    const SizedBox(height: 20),
                    const DottedLineDecorator(),
                    const SizedBox(height: 20),

                    // --- التحقق ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 16),
                              const SizedBox(width: 8),
                              Text('VERIFIED BOOKING', style: TextStyle(color: textGrey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                            ],
                          ),
                          Text('VALID FOR 1 ENTRY', style: TextStyle(color: highlightCarrier, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // ==========================================
            // نهاية جزء التصوير
            // ==========================================

            const SizedBox(height: 32),

            // --- أزرار الإجراءات السفلية ---
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _addAppleWallet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF222534) : Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text('Add to Apple Wallet', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: TextButton(
                onPressed: _saveAsPDF,
                style: TextButton.styleFrom(
                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F4F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.download_for_offline_outlined, color: primaryBlue, size: 20),
                    const SizedBox(width: 12),
                    Text('Download Ticket (PDF)', style: TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text('Please present this QR code to the driver upon boarding. Ensure your screen brightness is set to maximum for faster scanning.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textGrey, fontSize: 12, fontWeight: FontWeight.w600, height: 1.5)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // حل مشكلة الخط الكبير باستخدام FittedBox
  // ==========================================
  Widget _buildPassengerInfo(String label, String value, Color valueColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: isDark ? const Color(0xFFFFD700) : const Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildSeatInfo(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(value, textAlign: TextAlign.end, style: TextStyle(color: valueColor, fontSize: 24, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildTripInfo(String label, String value, Color valueColor, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class DottedLineDecorator extends StatelessWidget {
  const DottedLineDecorator({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color lineColor = isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
    final Color circleColor = isDark ? const Color(0xFF161824) : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: List.generate(
              30,
                  (index) => Expanded(
                child: Container(
                  width: 4, height: 4,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: lineColor, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: Container(
              width: 16, height: 32,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(30)),
                border: Border.all(color: lineColor),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              width: 16, height: 32,
              decoration: BoxDecoration(
                color: circleColor,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(30)),
                border: Border.all(color: lineColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}