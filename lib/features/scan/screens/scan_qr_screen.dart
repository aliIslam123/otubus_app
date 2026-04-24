import 'package:flutter/material.dart';

void main() {
  runApp(const QRScannerApp());
}


class QRScannerApp extends StatefulWidget {
  const QRScannerApp({super.key});

  @override
  State<QRScannerApp> createState() => _QRScannerAppState();
}

class _QRScannerAppState extends State<QRScannerApp> {
  bool _isDark = false;

  void toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: QRScannerScreen(
        isDark: _isDark,
        onToggleTheme: toggleTheme,
      ),
    );
  }
}

class QRScannerScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const QRScannerScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? Colors.black : Colors.white;
    final titleColor = isDark ? const Color(0xFF9FA8DA) : const Color(0xFF3949AB);
    final navyBlue = const Color(0xFF000080);
    final qrGray = const Color(0xFF78909C);
    final backBtnBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
    final backBtnIcon = isDark ? Colors.white : const Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: backBtnBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: backBtnIcon,
                            size: 20,
                          ),
                        ),
                       
                        GestureDetector(
                          onTap: onToggleTheme,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: backBtnBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isDark ? Icons.wb_sunny : Icons.nightlight_round,
                              color: backBtnIcon,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Text(
                          'Scan QR Code',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'related to the bus',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

              
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                     
                        Positioned(top: 0, left: 0, child: _cornerBracket(navyBlue, true, true)),
                        Positioned(top: 0, right: 0, child: _cornerBracket(navyBlue, false, true)),
                        Positioned(bottom: 0, left: 0, child: _cornerBracket(navyBlue, true, false)),
                        Positioned(bottom: 0, right: 0, child: _cornerBracket(navyBlue, false, false)),

                    
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _qrPositionPattern(qrGray, isDark, true),
                                const SizedBox(width: 14),
                                _qrPositionPattern(qrGray, isDark, false),
                              ],
                            ),
                            const SizedBox(height: 10),
                  
                            Container(
                              width: 180,
                              height: 3,
                              decoration: BoxDecoration(
                                color: navyBlue,
                                boxShadow: [
                                  BoxShadow(
                                    color: navyBlue.withOpacity(0.6),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _qrPositionPattern(qrGray, isDark, true),
                                const SizedBox(width: 14),
                                _qrDataModules(qrGray),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32, top: 32),
                    child: Container(
                      width: 180,
                      height: 50,
                      decoration: BoxDecoration(
                        color: navyBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: _scanIcon(),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Scan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cornerBracket(Color color, bool isLeft, bool isTop) {
    return CustomPaint(
      size: const Size(45, 45),
      painter: CornerBracketPainter(color: color, isLeft: isLeft, isTop: isTop),
    );
  }

  Widget _qrPositionPattern(Color color, bool isDark, bool isCircle) {
    final innerBg = isDark ? Colors.black : Colors.white;
    return Container(
      width: 60,
      height: 60,
      color: color,
      child: Center(
        child: Container(
          width: 38,
          height: 38,
          color: innerBg,
          child: Center(
            child: isCircle
                ? Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(
                    width: 14,
                    height: 14,
                    color: color,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _qrDataModules(Color color) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 17, height: 17, color: color),
              const SizedBox(width: 4),
              Container(width: 17, height: 17, color: color),
              const SizedBox(width: 4),
              Container(width: 17, height: 17, color: Colors.transparent),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 17, height: 17, color: Colors.transparent),
              const SizedBox(width: 4),
              Container(width: 17, height: 17, color: color),
              const SizedBox(width: 4),
              Container(width: 17, height: 17, color: color),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 17, height: 17, color: color),
              const SizedBox(width: 4),
              Container(width: 17, height: 17, color: Colors.transparent),
              const SizedBox(width: 4),
              Container(width: 17, height: 17, color: color),
            ],
          ),
        ],
      ),
    );
  }
  Widget _scanIcon() {
    return Stack(
      children: [
        Positioned(top: 0, left: 0, child: Container(width: 7, height: 2, color: Colors.white)),
        Positioned(top: 0, left: 0, child: Container(width: 2, height: 7, color: Colors.white)),
        Positioned(top: 0, right: 0, child: Container(width: 7, height: 2, color: Colors.white)),
        Positioned(top: 0, right: 0, child: Container(width: 2, height: 7, color: Colors.white)),
        Positioned(bottom: 0, left: 0, child: Container(width: 7, height: 2, color: Colors.white)),
        Positioned(bottom: 0, left: 0, child: Container(width: 2, height: 7, color: Colors.white)),
        Positioned(bottom: 0, right: 0, child: Container(width: 7, height: 2, color: Colors.white)),
        Positioned(bottom: 0, right: 0, child: Container(width: 2, height: 7, color: Colors.white)),
      ],
    );
  }
}

class CornerBracketPainter extends CustomPainter {
  final Color color;
  final bool isLeft;
  final bool isTop;

  CornerBracketPainter({
    required this.color,
    required this.isLeft,
    required this.isTop,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final extent = size.width * 0.65;

    if (isLeft && isTop) {
      path.moveTo(0, extent);
      path.lineTo(0, 0);
      path.lineTo(extent, 0);
    } else if (!isLeft && isTop) {
      path.moveTo(size.width - extent, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, extent);
    } else if (isLeft && !isTop) {
      path.moveTo(0, size.height - extent);
      path.lineTo(0, size.height);
      path.lineTo(extent, size.height);
    } else {
      path.moveTo(size.width - extent, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, size.height - extent);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter) => false;
}