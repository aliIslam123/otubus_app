import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  MobileScannerController? _controller;
  bool _permissionDenied = false;
  String? _scannedCode;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();

    if (status.isDenied) {
      setState(() {
        _permissionDenied = true;
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _permissionDenied = true;
      });
      // Open app settings if permission is permanently denied
      openAppSettings();
    } else {
      // Permission granted, initialize scanner
      _controller = MobileScannerController();
      setState(() {
        _permissionDenied = false;
      });
    }
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (barcodes.barcodes.isNotEmpty) {
      final barcode = barcodes.barcodes.first;
      final code = barcode.rawValue;

      if (code != null && !_showResult) {
        setState(() {
          _scannedCode = code;
          _showResult = true;
        });

        // Pause scanner
        _controller?.stop();

        // Show result dialog or process
        _showScanResult(code);
      }
    }
  }

  void _showScanResult(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("QR Code Scanned"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Code:"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resumeScanning();
            },
            child: const Text("Scan Again"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _resumeScanning() {
    setState(() {
      _showResult = false;
      _scannedCode = null;
    });
    _controller?.start();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121218) : Colors.white;
    final titleColor = isDark ? const Color(0xFF9FA8DA) : const Color(0xFF3949AB);
    final navyBlue = const Color(0xFF000080);
    final backBtnBg = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
    final backBtnIcon = isDark ? Colors.white : const Color(0xFF1A237E);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
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
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              child: Column(
                children: [
                  Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'related to the bus',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scanner or Permission UI
            if (_permissionDenied)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 80,
                      color: colors.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Camera permission is required to scan QR codes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: colors.onBackground,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _initializeCamera(),
                      icon: const Icon(Icons.refresh),
                      label: const Text("Grant Permission"),
                    ),
                  ],
                ),
              )
            else if (_controller != null)
              Expanded(
                child: Stack(
                  children: [
                    // Camera feed
                    MobileScanner(
                      controller: _controller,
                      onDetect: _handleBarcode,
                      errorBuilder: (context, error, child) {
                        return Center(
                          child: Text(
                            error.toString(),
                            style: TextStyle(color: colors.error),
                          ),
                        );
                      },
                    ),
                    // Scanning frame overlay
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Corner brackets
                            Positioned(
                              top: 0,
                              left: 0,
                              child: _cornerBracket(navyBlue, true, true),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: _cornerBracket(navyBlue, false, true),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: _cornerBracket(navyBlue, true, false),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: _cornerBracket(navyBlue, false, false),
                            ),
                            // Animated scanning line
                            _buildAnimatedScanLine(navyBlue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: colors.primary,
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Scan button info
            if (_controller != null && !_permissionDenied)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: navyBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: navyBlue, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, color: navyBlue),
                      const SizedBox(width: 8),
                      Text(
                        "Point camera at QR code",
                        style: TextStyle(color: navyBlue, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
          ],
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

  Widget _buildAnimatedScanLine(Color color) {
    return Center(
      child: Container(
        width: 200,
        height: 3,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}