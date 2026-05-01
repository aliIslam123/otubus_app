import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'booking_progress_bar.dart';
import 'checkout_screen.dart';

class StudentInformationScreen extends StatefulWidget {
  // --- 1. استقبال الداتا من الصفحة السابقة ---
  final double price;
  final String busName;
  final String route;
  final String fromTo;
  final int ticketsCount;
  final String? busImagePath;

  const StudentInformationScreen({
    super.key,
    this.price = 10.00,
    this.busName = 'OTUBUS Express',
    this.route = 'Route 402',
    this.fromTo = 'Downtown → OTU',
    this.ticketsCount = 1,
    this.busImagePath,
  });

  @override
  State<StudentInformationScreen> createState() => _StudentInformationScreenState();
}

class _StudentInformationScreenState extends State<StudentInformationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController(text: '01');

  String? _selectedGender;
  bool _isProcessing = false; // لمنع الضغط المتكرر أثناء الأنيميشن

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateState);
    _ageController.addListener(_updateState);

    _mobileController.addListener(() {
      String text = _mobileController.text;
      if (!text.startsWith('01')) {
        _mobileController.text = '01';
        _mobileController.selection = TextSelection.fromPosition(const TextPosition(offset: 2));
      }
      _updateState();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  String? get _nameError {
    String text = _nameController.text;
    if (text.isEmpty) return null;
    if (text.trim().isEmpty) return 'Name cannot be just spaces';
    if (!RegExp(r'^[\u0600-\u06FFa-zA-Z\s]+$').hasMatch(text)) {
      return 'Only letters and spaces are allowed';
    }
    return null;
  }

  String? get _ageError {
    String text = _ageController.text;
    if (text.isEmpty) return null;
    int? age = int.tryParse(text);
    if (age == null) return 'Invalid age';
    if (age < 16) return 'Minimum age is 16 for university students';
    return null;
  }

  String? get _mobileError {
    String text = _mobileController.text;
    if (text.length < 3) return null;

    String thirdDigit = text[2];
    if (!['0', '1', '2', '5'].contains(thirdDigit)) {
      return 'carrier_error';
    }
    if (text.length < 11) {
      return 'Missing ${11 - text.length} digits for a valid number';
    }
    return null;
  }

  bool get _isFormValid {
    return _nameError == null &&
        _nameController.text.trim().isNotEmpty &&
        _ageError == null &&
        _ageController.text.trim().isNotEmpty &&
        _selectedGender != null &&
        _mobileError == null &&
        _mobileController.text.length == 11;
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
      initialDatePickerMode: DatePickerMode.year,
      builder: (themeContext, child) { // غيرنا الاسم هنا عشان ميتداخلش مع السياق الأساسي
        final bool isDark = Theme.of(themeContext).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(themeContext).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(primary: Colors.white, onPrimary: Colors.black, surface: Color(0xFF1E1E28))
                : const ColorScheme.light(primary: Color(0xFF0A0A8A)),
          ),
          child: child!,
        );
      },
    );

    if (!context.mounted) return;

    if (picked != null) {
      int age = now.year - picked.year;
      if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
        age--;
      }

      if (age < 16) {
        _showErrorSnackBar('Invalid Age! You must be at least 16 years old.');
      } else {
        setState(() {
          _ageController.text = age.toString();
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showVerifyingSnackBar(BuildContext context, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Verifying Details...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    Text('Please wait a moment.', style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showProfessionalSuccess(BuildContext context, bool isDark) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Success!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    Text('All details verified.\nRedirecting to payment...', style: TextStyle(fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        elevation: 10,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color scaffoldBg = isDark ? const Color(0xFF0C0E17) : const Color(0xFFF9FAFB);
    final Color primaryBlue = isDark ? const Color(0xFF000080) : const Color(0xFF0A0A8A);
    final Color textMain = isDark ? Colors.white : const Color(0xFF111827);
    final Color textGrey = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    final Color inputBg = isDark ? const Color(0xFF161824) : Colors.white;
    final Color inputBorder = isDark ? const Color(0xFF222534) : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark, isDark ? Colors.white : primaryBlue, textMain),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: BookingProgressBar(currentStep: 4),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter details', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textMain)),
                    const SizedBox(height: 8),
                    Text(
                      'Please provide accurate student information for your travel insurance and boarding pass.',
                      style: TextStyle(fontSize: 14, height: 1.5, color: textGrey),
                    ),
                    const SizedBox(height: 32),

                    _buildInputLabel('FULL NAME', isDark ? Colors.white : primaryBlue, isDark),
                    _buildNameField(inputBg, inputBorder, isDark),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('AGE', isDark ? Colors.white : primaryBlue, isDark),
                              _buildAgeField(inputBg, inputBorder, isDark, primaryBlue),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInputLabel('GENDER', isDark ? Colors.white : primaryBlue, isDark),
                              _buildGenderToggle(primaryBlue, inputBg, inputBorder, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildInputLabel('MOBILE NUMBER', isDark ? Colors.white : primaryBlue, isDark),
                    _buildMobileField(inputBg, inputBorder, isDark, isDark ? Colors.white : primaryBlue),

                    const SizedBox(height: 32),
                    _buildInfoBox(isDark, isDark ? const Color(0xFFEAB308) : primaryBlue),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isFormValid && !_isProcessing ? () async {
                          setState(() => _isProcessing = true);

                          _showVerifyingSnackBar(context, isDark);
                          await Future.delayed(const Duration(seconds: 2));
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          await Future.delayed(const Duration(milliseconds: 350));
                          if (!context.mounted) return;

                          _showProfessionalSuccess(context, isDark);
                          await Future.delayed(const Duration(seconds: 2));
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          await Future.delayed(const Duration(milliseconds: 350));
                          if (!context.mounted) return;

                          setState(() => _isProcessing = false);

                          // --- 2. تمرير الداتا لصفحة الدفع ---
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => CheckoutScreen(
                                price: widget.price,
                                busName: widget.busName,
                                route: widget.route,
                                fromTo: widget.fromTo,
                                ticketsCount: widget.ticketsCount,
                                busImagePath: widget.busImagePath,
                              ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOutQuart;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return SlideTransition(position: animation.drive(tween), child: child);
                              },
                              transitionDuration: const Duration(milliseconds: 600),
                            ),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          disabledBackgroundColor: isDark ? const Color(0xFF222534) : const Color(0xFFDCE0E5),
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                _isProcessing ? 'Processing...' : 'Continue to Payment',
                                style: TextStyle(
                                    color: _isFormValid ? Colors.white : (isDark ? const Color(0xFF6B7280) : const Color(0xFFA0A5B1)),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            const SizedBox(width: 8),
                            if (!_isProcessing)
                              Icon(
                                  Icons.arrow_forward,
                                  color: _isFormValid ? Colors.white : (isDark ? const Color(0xFF6B7280) : const Color(0xFFA0A5B1)),
                                  size: 18
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isDark, isDark ? Colors.white : primaryBlue),
    );
  }

  Widget _buildAppBar(bool isDark, Color titleColor, Color textMain) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: titleColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Text(
                  'STUDENT INFORMATION',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: titleColor, letterSpacing: 1.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text, Color textColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textColor, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildNameField(Color inputBg, Color inputBorder, bool isDark) {
    bool hasError = _nameError != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: inputBg,
              border: Border.all(color: hasError ? Colors.red.shade400 : inputBorder, width: hasError ? 1.5 : 1.0),
              borderRadius: BorderRadius.circular(4)
          ),
          child: TextField(
            controller: _nameController,
            cursorColor: isDark ? Colors.white : const Color(0xFF0A0A8A),
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF111827), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'e.g. Eiar Mohamed',
              hintStyle: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF6B7280), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.error_outline, color: Colors.red.shade400, size: 14),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _nameError!,
                    style: TextStyle(color: Colors.red.shade400, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAgeField(Color inputBg, Color inputBorder, bool isDark, Color primaryBlue) {
    bool hasError = _ageError != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: inputBg,
              border: Border.all(color: hasError ? Colors.red.shade400 : inputBorder),
              borderRadius: BorderRadius.circular(4)),
          child: TextField(
            controller: _ageController,
            cursorColor: isDark ? Colors.white : const Color(0xFF0A0A8A),
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF111827), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'e.g. 20',
              hintStyle: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
              prefixIcon: IconButton(
                icon: Icon(Icons.calendar_today_rounded, color: isDark ? const Color(0xFF3B82F6) : primaryBlue, size: 22),
                onPressed: () => _selectDateOfBirth(context),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(_ageError!, style: TextStyle(color: Colors.red.shade400, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }

  Widget _buildGenderToggle(Color primaryBlue, Color inputBg, Color inputBorder, bool isDark) {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: inputBg, border: Border.all(color: inputBorder), borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedGender = 'Male');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _selectedGender == 'Male' ? (isDark ? Colors.white : primaryBlue) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'Male',
                    style: TextStyle(
                      color: _selectedGender == 'Male' ? (isDark ? Colors.black : Colors.white) : const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedGender = 'Female');
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _selectedGender == 'Female' ? (isDark ? Colors.white : primaryBlue) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'Female',
                    style: TextStyle(
                      color: _selectedGender == 'Female' ? (isDark ? Colors.black : Colors.white) : const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileField(Color inputBg, Color inputBorder, bool isDark, Color textColor) {
    bool hasError = _mobileError != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 54,
          decoration: BoxDecoration(
              color: inputBg,
              border: Border.all(color: hasError ? Colors.red.shade400 : inputBorder, width: 1.0),
              borderRadius: BorderRadius.circular(4)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android_outlined, color: Color(0xFF6B7280), size: 20),
                    const SizedBox(width: 8),
                    Text('+20', style: TextStyle(color: textColor, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              Container(width: 1, height: 24, color: inputBorder),
              Expanded(
                child: TextField(
                  controller: _mobileController,
                  cursorColor: isDark ? Colors.white : const Color(0xFF0A0A8A),
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      if (newValue.text.length >= 3) {
                        String third = newValue.text[2];
                        if (!['0', '1', '2', '5'].contains(third) && newValue.text.length > 3) {
                          return oldValue;
                        }
                      }
                      return newValue;
                    }),
                  ],
                  style: TextStyle(color: isDark ? Colors.white : const Color(0xFF111827), fontWeight: FontWeight.w600, letterSpacing: 1.5),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 16, bottom: 4),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 14),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _mobileError == 'carrier_error'
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, height: 1.4),
                          children: [
                            const TextSpan(text: 'Use '),
                            TextSpan(text: '010 For Vodafone', style: TextStyle(color: isDark ? const Color(0xFFFF6B6B) : const Color(0xFFE60000))),
                            const TextSpan(text: ', '),
                            TextSpan(text: '011 For e&', style: TextStyle(color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF00A63F))),
                            const TextSpan(text: ', '),
                            TextSpan(text: '012 For Orange', style: TextStyle(color: isDark ? const Color(0xFFFB923C) : const Color(0xFFFF7900))),
                            const TextSpan(text: ' , or '),
                            TextSpan(text: '015 For We', style: TextStyle(color: isDark ? const Color(0xFFC084FC) : const Color(0xFF5C2D91))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Typing blocked: Invalid carrier code.',
                        style: TextStyle(color: Colors.red.shade400, fontSize: 11, fontWeight: FontWeight.w800, fontStyle: FontStyle.italic),
                      ),
                    ],
                  )
                      : Text(
                    _mobileError!,
                    style: TextStyle(color: Colors.red.shade400, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoBox(bool isDark, Color highlightColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1A12) : const Color(0xFFFEFCE8),
        border: Border.all(color: isDark ? const Color(0xFF423518) : const Color(0xFFFEF08A)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: highlightColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151), fontSize: 13, height: 1.5),
                children: [
                  const TextSpan(text: 'A valid '),
                  TextSpan(text: 'Student ID', style: TextStyle(fontWeight: FontWeight.bold, color: highlightColor)),
                  const TextSpan(text: ' will be required during boarding to verify your discount eligibility.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDark, Color activeColor) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? const Color(0xFF0C0E17) : Colors.white,
      selectedItemColor: activeColor,
      unselectedItemColor: const Color(0xFF6B7280),
      currentIndex: 1,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_num_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.circle, size: 8), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}