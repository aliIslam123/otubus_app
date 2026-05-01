import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'booking_progress_bar.dart';
import 'booking_confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double price;
  final String busName;
  final String route;
  final String fromTo;
  final int ticketsCount;
  final String? busImagePath;

  const CheckoutScreen({
    super.key,
    this.price = 10.00,
    this.busName = 'OTUBUS Express',
    this.route = 'Route 402',
    this.fromTo = 'Downtown → OTU',
    this.ticketsCount = 1,
    this.busImagePath,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isApplePay = false;
  bool saveCard = true;
  bool isProcessing = false;

  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expiry = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  final TextEditingController _name = TextEditingController();

  String? _nameError;
  String? _expiryError;

  @override
  void initState() {
    super.initState();
    _cardNumber.addListener(_updateState);
    _cvv.addListener(_updateState);

    _name.addListener(() {
      String text = _name.text;
      if (text.isNotEmpty && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(text)) {
        _nameError = 'Letters and spaces only';
      } else {
        _nameError = null;
      }
      _updateState();
    });

    _expiry.addListener(() {
      String text = _expiry.text;
      if (text.length == 5) {
        List<String> parts = text.split('/');
        int month = int.tryParse(parts[0]) ?? 0;
        int year = int.tryParse(parts[1]) ?? 0;

        if (month < 1 || month > 12) {
          _expiryError = 'Invalid month';
        } else if (year < 24) {
          _expiryError = 'Card expired';
        } else {
          _expiryError = null;
        }
      } else {
        _expiryError = null;
      }
      _updateState();
    });
  }

  @override
  void dispose() {
    _cardNumber.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _name.dispose();
    super.dispose();
  }

  void _updateState() => setState(() {});

  bool get _isFormValid {
    if (isApplePay) return true;
    return _cardNumber.text.length == 19 &&
        _name.text.trim().isNotEmpty && _nameError == null &&
        _expiry.text.length == 5 && _expiryError == null &&
        _cvv.text.length == 3;
  }

  Widget _getCardLogo() {
    String text = _cardNumber.text.replaceAll(' ', '');
    if (text.isEmpty) return Icon(Icons.credit_card, color: Colors.grey.withValues(alpha: 0.5), size: 24);

    if (text.startsWith('4')) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text('VISA', style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, fontSize: 16)),
      );
    }
    if (text.startsWith(RegExp(r'^5[1-5]'))) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: Colors.red.withValues(alpha: 0.8), size: 16),
            Transform.translate(offset: const Offset(-6, 0), child: Icon(Icons.circle, color: Colors.orange.withValues(alpha: 0.8), size: 16)),
          ],
        ),
      );
    }
    if (text.startsWith('50') || text.startsWith('97') || text.startsWith('6')) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text('ميزة', style: TextStyle(color: Colors.purple.shade800, fontWeight: FontWeight.w900, fontSize: 16)),
      );
    }

    return Icon(Icons.credit_card, color: Colors.grey.withValues(alpha: 0.5), size: 24);
  }

  void _showProcessingSnackBar(bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)),
            ),
            const SizedBox(width: 16),
            const Text('Processing payment...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            const Text('Payment Successful!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _processPayment(bool isDark) async {
    setState(() => isProcessing = true);

    _showProcessingSnackBar(isDark);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    _showSuccessSnackBar(isDark);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() => isProcessing = false);

    // --- بنبعت الداتا لصفحة التأكيد (الجديدة) ---
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BookingConfirmationScreen(
          price: widget.price,
          busName: widget.busName,
          route: widget.route,
          fromTo: widget.fromTo,
          ticketsCount: widget.ticketsCount,
          busImagePath: widget.busImagePath,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.easeInOutQuart));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color scaffoldBg = isDark ? const Color(0xFF0C0E17) : const Color(0xFFF9FAFB);
    final Color cardBg = isDark ? const Color(0xFF161824) : Colors.white;
    final Color primaryBlue = isDark ? const Color(0xFF000080) : const Color(0xFF0A0A8A);
    final Color textMain = isDark ? Colors.white : const Color(0xFF0A0A5A);
    final Color textGrey = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new, color: textMain, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Checkout', style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.w900)),
        actions: [IconButton(icon: Icon(Icons.more_horiz, color: textMain), onPressed: () {})],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), child: BookingProgressBar(currentStep: 5)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripSummaryCard(isDark, cardBg, textMain, textGrey),
                    const SizedBox(height: 32),

                    _buildAnimatedToggle(isDark, primaryBlue),
                    const SizedBox(height: 32),

                    if (!isApplePay) ...[
                      _buildInputLabel('Card Number', textMain),
                      _buildTextField(
                        controller: _cardNumber,
                        hint: '0000 0000 0000 0000',
                        isDark: isDark,
                        suffixWidget: _getCardLogo(),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16), _CardFormatter()],
                      ),
                      const SizedBox(height: 12),

                      _buildInputLabel('Cardholder Name', textMain),
                      _buildTextField(
                        controller: _name,
                        hint: 'Name on card',
                        isDark: isDark,
                        isShiftedUp: true,
                        textAlign: TextAlign.start, // محاذاة للشمال
                        errorText: _nameError,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputLabel('Expiry Date', textMain),
                                _buildTextField(
                                  controller: _expiry,
                                  hint: 'MM/YY',
                                  isDark: isDark,
                                  isShiftedUp: true,
                                  textAlign: TextAlign.start, // محاذاة للشمال
                                  errorText: _expiryError,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), _ExpiryFormatter()],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInputLabel('CVV', textMain),
                                _buildTextField(
                                  controller: _cvv,
                                  hint: '***',
                                  isDark: isDark,
                                  textAlign: TextAlign.start, // محاذاة للشمال
                                  obscureText: true,
                                  suffixWidget: Icon(Icons.help_outline, size: 20, color: Colors.grey.withValues(alpha: 0.5)),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSaveCardSwitch(isDark, textMain, primaryBlue),
                    ] else ...[
                      _buildApplePayPlaceholder(isDark, textGrey),
                    ],

                    const SizedBox(height: 40),
                    _buildPayButton(primaryBlue, isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummaryCard(bool isDark, Color bg, Color textMain, Color textGrey) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? const Color(0xFF222534) : Colors.transparent),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CURRENT TRIP', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(widget.busName, style: TextStyle(color: textMain, fontSize: 22, fontWeight: FontWeight.w900)),
                ],
              ),
              Container(
                width: 45, height: 45,
                decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF222534) : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: widget.busImagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(widget.busImagePath!, fit: BoxFit.cover),
                      )
                    : Icon(Icons.directions_bus, color: textMain, size: 24),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.route, color: Color(0xFF3B82F6), size: 22),
              const SizedBox(width: 12),
              Text(widget.route, style: TextStyle(color: textMain, fontWeight: FontWeight.w700, fontSize: 16)),
              const Spacer(),
              Text('EGP ${widget.price.toStringAsFixed(2)}', style: TextStyle(color: textMain, fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 34),
              Text(widget.fromTo, style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${widget.ticketsCount} Ticket${widget.ticketsCount > 1 ? 's' : ''}', style: TextStyle(color: textGrey, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedToggle(bool isDark, Color blue) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161824) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: isDark ? const Color(0xFF222534) : const Color(0xFFE5E7EB)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: isApplePay ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isApplePay = false),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card, color: !isApplePay ? Colors.white : Colors.grey, size: 18),
                        const SizedBox(width: 8),
                        Text('Card', style: TextStyle(color: !isApplePay ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => isApplePay = true),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apple, color: isApplePay ? Colors.white : Colors.grey, size: 18),
                        const SizedBox(width: 8),
                        Text('Apple Pay', style: TextStyle(color: isApplePay ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(text, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    Widget? suffixWidget,
    bool obscureText = false,
    TextAlign textAlign = TextAlign.start,
    String? errorText,
    List<TextInputFormatter>? inputFormatters,
    bool isShiftedUp = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161824) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: errorText != null ? Colors.red.shade400 : (isDark ? const Color(0xFF222534) : const Color(0xFFE5E7EB))),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            cursorColor: isDark ? Colors.white : const Color(0xFF0A0A8A),
            textAlign: textAlign,
            textAlignVertical: isShiftedUp ? TextAlignVertical.top : TextAlignVertical.center,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: obscureText ? 2.0 : null,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
              contentPadding: isShiftedUp ? const EdgeInsets.fromLTRB(16, 10, 16, 0) : const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
              suffixIcon: suffixWidget != null ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [suffixWidget]) : null,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Text(errorText, style: TextStyle(color: Colors.red.shade400, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildSaveCardSwitch(bool isDark, Color textMain, Color primaryBlue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Save card for future trips', style: TextStyle(color: textMain, fontWeight: FontWeight.w800, fontSize: 13)),
        Switch(
          value: saveCard,
          onChanged: (v) => setState(() => saveCard = v),
          activeThumbColor: isDark ? const Color(0xFFFFD700) : primaryBlue,
          activeTrackColor: isDark ? const Color(0xFF9CA3AF) : primaryBlue.withValues(alpha: 0.2),
          inactiveThumbColor: Colors.grey.shade400,
          inactiveTrackColor: isDark ? const Color(0xFF222534) : const Color(0xFFE5E7EB),
        )
      ],
    );
  }

  Widget _buildPayButton(Color primaryBlue, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isFormValid && !isProcessing ? () => _processPayment(isDark) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          disabledBackgroundColor: isDark ? const Color(0xFF222534) : const Color(0xFFDCE0E5),
          shape: const StadiumBorder(),
          elevation: _isFormValid ? 8 : 0,
          shadowColor: primaryBlue.withValues(alpha: 0.4),
        ),
        child: isProcessing
            ? const SizedBox(
            height: 24, width: 24,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Pay EGP ${widget.price.toStringAsFixed(2)}',
                style: TextStyle(
                    color: _isFormValid ? Colors.white : (isDark ? const Color(0xFF6B7280) : const Color(0xFFA0A5B1)),
                    fontSize: 18,
                    fontWeight: FontWeight.w900
                )
            ),
            const SizedBox(width: 12),
            Icon(
                Icons.lock_outline,
                color: _isFormValid ? Colors.white : (isDark ? const Color(0xFF6B7280) : const Color(0xFFA0A5B1)),
                size: 20
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplePayPlaceholder(bool isDark, Color textGrey) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apple, size: 60, color: isDark ? Colors.white : Colors.black),
          const SizedBox(height: 16),
          Text('Double-click side button to pay', style: TextStyle(color: textGrey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// --- كلاسات الفورمات ---
class _CardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var newString = '';
    for (int i = 0; i < text.length; i++) {
      newString += text[i];
      if ((i + 1) % 4 == 0 && i != text.length - 1) newString += ' ';
    }
    return newValue.copyWith(text: newString, selection: TextSelection.collapsed(offset: newString.length));
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    var newString = '';
    for (int i = 0; i < text.length; i++) {
      newString += text[i];
      if (i == 1 && text.length > 2) newString += '/';
    }
    return newValue.copyWith(text: newString, selection: TextSelection.collapsed(offset: newString.length));
  }
}
