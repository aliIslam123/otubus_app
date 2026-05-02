import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'seat_selection_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _selectedFilter = 'Time'; // الفلتر النشط

  String? _selectedTime;
  String? _selectedPrice;
  String? _selectedAvailability;

  final List<Map<String, dynamic>> trips = [
    {
      'isPremium': true,
      'tag': 'RECOMMENDED',
      'operator': 'Otubus Gold',
      'type': 'Executive',
      'amenities': 'Luxury Suite • AC • WiFi',
      'price': 'EGP 12.50',
      'duration': '1h 05m',
      'departureTime': '07:30',
      'departureLocation': 'HYPER ONE',
      'arrivalTime': '08:35',
      'arrivalLocation': 'OTU',
      'imagePath': 'assets/images/bus1.png',
    },
    {
      'isPremium': false,
      'tag': null,
      'operator': 'OTUBUS EXPRESS',
      'type': 'Standard Semi-Suite',
      'amenities': 'Direct',
      'price': 'EGP 5.00',
      'duration': '30m',
      'departureTime': '08:00',
      'departureLocation': 'ARKAN MALL',
      'arrivalTime': '8:30',
      'arrivalLocation': 'OTU',
      'seatsLeft': '14 Seats left',
      'imagePath': 'assets/images/bus2.png',
    },
    {
      'isPremium': false,
      'tag': null,
      'operator': 'OTUBUS NIGHT OWL',
      'type': 'Sleeper Coach',
      'amenities': 'Direct',
      'price': 'EGP 22.00',
      'duration': '2h 45m',
      'departureTime': '04:00',
      'departureLocation': 'ZAYED PLAZA',
      'arrivalTime': '06:45',
      'arrivalLocation': 'OTU',
      'seatsLeft': '8 Sleepers left',
      'imagePath': 'assets/images/bus3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(context, theme, isDark),
            _buildFiltersRow(theme, isDark),
            _buildSubHeader(theme, isDark),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                itemCount: _getFilteredTrips().length,
                itemBuilder: (context, index) {
                  return _buildTripCard(context, _getFilteredTrips()[index], theme, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTrips() {
    List<Map<String, dynamic>> result = List.from(trips);

    if (_selectedTime != null && _selectedTime != 'All Times') {
      if (_selectedTime == 'Morning (6am-12pm)') {
        result = result.where((t) => _getHour(t['departureTime']) >= 6 && _getHour(t['departureTime']) < 12).toList();
      } else if (_selectedTime == 'Night (12am-6am)') {
        result = result.where((t) => _getHour(t['departureTime']) >= 0 && _getHour(t['departureTime']) < 6).toList();
      }
    }

    if (_selectedPrice == 'Low to High') {
      result.sort((a, b) => _extractPrice(a['price']).compareTo(_extractPrice(b['price'])));
    } else if (_selectedPrice == 'High to Low') {
      result.sort((a, b) => _extractPrice(b['price']).compareTo(_extractPrice(a['price'])));
    }

    if (_selectedAvailability == 'Available Only') {
      result = result.where((t) {
        if (t['seatsLeft'] != null) {
          return !t['seatsLeft'].toString().contains('0 ');
        }
        return true;
      }).toList();
    }

    return result;
  }

  int _getHour(String time) {
    return int.tryParse(time.split(':')[0]) ?? 0;
  }

  double _extractPrice(String price) {
    return double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }

  Widget _buildCustomAppBar(BuildContext context, ThemeData theme, bool isDark) {
    final String dynamicDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : const Color(0xFFE8EEF5),
                shape: BoxShape.circle
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : const Color(0xFF0A0A5A), size: 20),
              onPressed: () {},
            ),
          ),
          Column(
            children: [
              Text('Zayed to OTU', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0A0A5A), fontSize: 18, fontWeight: FontWeight.w900)),
              Text('$dynamicDate • 1 Passenger', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : const Color(0xFFE8EEF5),
                shape: BoxShape.circle
            ),
            child: IconButton(
              icon: Icon(Icons.tune, color: isDark ? Colors.white : const Color(0xFF0A0A5A), size: 20),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          _buildFilterChip('Time', _selectedTime ?? 'Time', true, theme, isDark),
          const SizedBox(width: 10),
          _buildFilterChip('Price', _selectedPrice ?? 'Price', true, theme, isDark),
          const SizedBox(width: 10),
          _buildFilterChip('Availability', _selectedAvailability ?? 'Availability', true, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterType, String displayLabel, bool hasDropdown, ThemeData theme, bool isDark) {
    bool isSelected = _selectedFilter == filterType;

    return GestureDetector(
      onTap: () {
        if (filterType == 'Time') {
          _showTimeBottomSheet(theme, isDark);
        } else if (filterType == 'Price') {
          _showPriceBottomSheet(theme, isDark);
        } else if (filterType == 'Availability') {
          _showAvailabilityBottomSheet(theme, isDark);
        } else {
          setState(() => _selectedFilter = filterType);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? theme.primaryColor : (isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16),
            if (isSelected) const SizedBox(width: 4),
            if (filterType == 'Time' && !isSelected) const Icon(Icons.access_time, color: Colors.grey, size: 16),
            if (filterType == 'Time' && !isSelected) const SizedBox(width: 4),
            if (filterType == 'Price' && !isSelected) const Icon(Icons.attach_money, color: Colors.grey, size: 16),
            if (filterType == 'Price' && !isSelected) const SizedBox(width: 4),
            if (filterType == 'Availability' && !isSelected) const Icon(Icons.event_seat, color: Colors.grey, size: 16),
            if (filterType == 'Availability' && !isSelected) const SizedBox(width: 4),
            Text(
              displayLabel,
              style: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0A0A5A)),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (hasDropdown) const SizedBox(width: 4),
            if (hasDropdown)
              Icon(Icons.keyboard_arrow_down, color: isSelected ? Colors.white : (isDark ? Colors.white : const Color(0xFF0A0A8A)), size: 16),
          ],
        ),
      ),
    );
  }

  // --- Bottom Sheets للخيارات ---

  void _showTimeBottomSheet(ThemeData theme, bool isDark) {
    final List<String> options = ['All Times', 'Morning (6am-12pm)', 'Night (12am-6am)'];
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return _buildBottomSheetContent('Select Time', options, _selectedTime, theme, isDark, (selected) {
          setState(() {
            _selectedTime = selected == 'All Times' ? null : selected;
            _selectedFilter = 'Time';
          });
          Navigator.pop(context);
        });
      },
    );
  }

  void _showPriceBottomSheet(ThemeData theme, bool isDark) {
    final List<String> options = ['Any Price', 'Low to High', 'High to Low'];
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return _buildBottomSheetContent('Select Price Order', options, _selectedPrice, theme, isDark, (selected) {
          setState(() {
            _selectedPrice = selected == 'Any Price' ? null : selected;
            _selectedFilter = 'Price';
          });
          Navigator.pop(context);
        });
      },
    );
  }

  void _showAvailabilityBottomSheet(ThemeData theme, bool isDark) {
    final List<String> options = ['Any', 'Available Only'];
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return _buildBottomSheetContent('Select Availability', options, _selectedAvailability, theme, isDark, (selected) {
          setState(() {
            _selectedAvailability = selected == 'Any' ? null : selected;
            _selectedFilter = 'Availability';
          });
          Navigator.pop(context);
        });
      },
    );
  }

  // ويدجت مساعدة عشان ترسم محتوى الـ Bottom Sheet بشكل موحد
  Widget _buildBottomSheetContent(String title, List<String> options, String? currentValue, ThemeData theme, bool isDark, Function(String) onSelect) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(title, style: TextStyle(color: isDark ? Colors.white : theme.primaryColor, fontSize: 18, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 16),
          ...options.map((option) {
            bool isCurrent = currentValue == option || (currentValue == null && option.startsWith('All')) || (currentValue == null && option.startsWith('Any'));
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              title: Text(option, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
              trailing: isCurrent ? Icon(Icons.check_circle, color: theme.colorScheme.secondary) : null,
              onTap: () => onSelect(option),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ------------------------------

  Widget _buildSubHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${_getFilteredTrips().length} AVAILABLE COACHES', style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : const Color(0xFFE8EEF5),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Text('Sort: Earliest', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0A0A5A), fontSize: 12, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String imagePath, String tag) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.8),
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Hero(
                tag: tag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.9,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 200, height: 200,
                      decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(16)),
                      child: Icon(Icons.directions_bus, color: Colors.grey.shade500, size: 80),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip, ThemeData theme, bool isDark) {
    bool isPremium = trip['isPremium'];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 24.0, top: isPremium ? 12.0 : 0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
                color: isPremium ? theme.colorScheme.secondary : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                width: isPremium ? 2 : 1
            ),
            boxShadow: [
              if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showFullImage(context, trip['imagePath'], trip['operator']),
                      child: Hero(
                        tag: trip['operator'],
                        child: ClipOval(
                          child: Image.asset(
                            trip['imagePath'],
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: Colors.grey.shade800, shape: BoxShape.circle),
                              child: Icon(Icons.directions_bus, color: Colors.grey.shade500, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(trip['operator'], style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0A0A5A), fontSize: 16, fontWeight: FontWeight.w900)),
                          Text(trip['type'], style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                          if (trip['amenities'] != 'Direct') const SizedBox(height: 2),
                          if (trip['amenities'] != 'Direct') Text(trip['amenities'], style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(trip['price'], style: TextStyle(color: theme.colorScheme.secondary, fontSize: 18, fontWeight: FontWeight.w900)),
                        const Text('per seat', style: TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                  ],
                ),

                Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade100, thickness: 1.5, height: 32),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildTimeLocation(trip['departureTime'], trip['departureLocation'], true, isDark),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            Text(trip['duration'], style: const TextStyle(color: Colors.grey, fontSize: 10)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isDark ? Colors.white : const Color(0xFF0A0A5A), width: 1.5))),
                                Expanded(child: Container(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                                if (isPremium) Icon(Icons.directions_bus, color: isDark ? Colors.white : const Color(0xFF0A0A5A), size: 14),
                                if (!isPremium) const Text('Direct', style: TextStyle(color: Colors.grey, fontSize: 10)),
                                Expanded(child: Container(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),
                                Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.white : const Color(0xFF0A0A5A))),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildTimeLocation(trip['arrivalTime'], trip['arrivalLocation'], false, isDark),
                      ),
                    ),
                  ],
                ),

                Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade100, thickness: 1.5, height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isPremium)
                      Row(
                        children: [
                          _buildOverlappingAvatar('JC', isDark ? Colors.grey.shade800 : const Color(0xFFE8EEF5), isDark ? Colors.white : const Color(0xFF0A0A5A), theme),
                          _buildOverlappingAvatar('MS', theme.primaryColor, Colors.white, theme),
                          _buildOverlappingAvatar('+8', isDark ? Colors.grey.shade800 : const Color(0xFFE8EEF5), isDark ? Colors.white : const Color(0xFF0A0A5A), theme),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(Icons.airline_seat_recline_normal, color: Colors.grey.shade500, size: 16),
                          const SizedBox(width: 4),
                          Text(trip['seatsLeft'], style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),

                    InkWell(
                      onTap: () {
                        final priceText = trip['price'] as String;
                        final priceValue = double.tryParse(priceText.replaceAll('EGP ', '').replaceAll('\$', '')) ?? 0.0;
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => SelectSeatScreen(baseTicketPrice: priceValue),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOutQuart;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              return SlideTransition(position: animation.drive(tween), child: child);
                            },
                            transitionDuration: const Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: isPremium
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(24)),
                        child: const Text('Select Seat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      )
                          : Text('View Details \u003e', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0A0A5A), fontWeight: FontWeight.w900, fontSize: 14)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        if (isPremium)
          Positioned(
            top: 0,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: theme.colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
              child: const Text('RECOMMENDED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeLocation(String time, String location, bool isLeft, bool isDark) {
    return Column(
      crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(time, style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0A0A5A), fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOverlappingAvatar(String text, Color bgColor, Color textColor, ThemeData theme) {
    return Align(
      widthFactor: 0.7,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.surface, width: 2)
        ),
        child: Center(
          child: Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

}