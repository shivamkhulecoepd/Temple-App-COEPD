import 'package:flutter/material.dart';

class TempleCalendarScreen extends StatefulWidget {
  const TempleCalendarScreen({super.key});

  @override
  State<TempleCalendarScreen> createState() => _TempleCalendarScreenState();
}

class _TempleCalendarScreenState extends State<TempleCalendarScreen> {
  // Start with December 2024 to see the Vaikuntha Ekadashi festival
  DateTime _selectedDate = DateTime(2024, 12, 16);

  final Map<String, List<Festival>> _festivalsData = {
    '2024-12-16': [
      Festival(
        name: 'Vaikuntha Ekadashi',
        description:
            'Vaikuntha Ekadashi is a sacred Hindu festival dedicated to Lord Vishnu. It is believed that the gates of Vaikuntha (Lord Vishnu\'s abode) remain open on this day.',
        timing: 'Early Morning 4:00 AM to Evening 8:00 PM',
        significance:
            'Observing fast on this day is believed to grant liberation and open the gates of Vaikuntha.',
      ),
    ],
    '2024-12-25': [
      Festival(
        name: 'Christmas',
        description: 'Christmas is celebrated as the birth of Jesus Christ.',
        timing: 'Whole Day',
        significance: 'Special prayers and celebrations in the temple.',
      ),
    ],
    '2025-01-14': [
      Festival(
        name: 'Makar Sankranti',
        description:
            'Makar Sankranti marks the transition of the Sun into the zodiac sign of Capricorn.',
        timing: 'Morning 6:00 AM to Evening 6:00 PM',
        significance: 'Special Pooja and Prasadam distribution.',
      ),
    ],
    '2025-01-26': [
      Festival(
        name: 'Republic Day',
        description:
            'Indian Republic Day celebration with special prayers for the nation.',
        timing: 'Morning 8:00 AM to 12:00 PM',
        significance: 'National flag hoisting and special prayers.',
      ),
    ],
    '2025-02-14': [
      Festival(
        name: 'Maha Shivaratri',
        description:
            'Great night of Lord Shiva, observed with night-long vigil and prayers.',
        timing: 'Evening 6:00 PM to Next Day 6:00 AM',
        significance: 'Special Abhishekam and Rudrabhishekam performed.',
      ),
    ],
  };

  List<Festival> get _selectedDateFestivals {
    final String dateKey =
        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
    return _festivalsData[dateKey] ?? [];
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _showFestivalDetails(Festival festival) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          festival.name,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                festival.description,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 12),
              _buildFestivalDetailRow('Timing:', festival.timing),
              const SizedBox(height: 8),
              _buildFestivalDetailRow('Significance:', festival.significance),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to booking screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Book Pooja'),
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(value, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Temple Calendar',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Selected Date Display - Fixed at top
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Column(
              children: [
                Text(
                  'Selected Date',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Festivals found: ${_selectedDateFestivals.length}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _selectedDateFestivals.isNotEmpty
                        ? Colors.green
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content below the fixed header
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Calendar Section
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Month and Year Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month - 1,
                                    1,
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.chevron_left,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month + 1,
                                    1,
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Calendar Days
                        _buildCalendar(),
                      ],
                    ),
                  ),

                  // Festivals Section
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Festivals on ${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Quick navigation to festival dates
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildQuickDateButton(
                                '16 Dec 2024',
                                DateTime(2024, 12, 16),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickDateButton(
                                '25 Dec 2024',
                                DateTime(2024, 12, 25),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickDateButton(
                                '14 Jan 2025',
                                DateTime(2025, 1, 14),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickDateButton(
                                '26 Jan 2025',
                                DateTime(2025, 1, 26),
                              ),
                              const SizedBox(width: 8),
                              _buildQuickDateButton(
                                '14 Feb 2025',
                                DateTime(2025, 2, 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (_selectedDateFestivals.isEmpty)
                          _buildNoFestivals()
                        else
                          _buildFestivalsList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateButton(String label, DateTime date) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDate = date;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade100,
        foregroundColor: Colors.orange.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    );
    final startingWeekday = firstDayOfMonth.weekday;

    return Column(
      children: [
        // Weekday Headers
        const Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Sun',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Mon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Tue',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Wed',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Thu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Fri',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Sat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Calendar Days Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.2,
          ),
          itemCount: 42, // 6 weeks × 7 days
          itemBuilder: (context, index) {
            final day = index - startingWeekday + 1;
            final isCurrentMonth = day > 0 && day <= lastDayOfMonth.day;

            if (!isCurrentMonth) {
              return const SizedBox.shrink();
            }

            final currentDate = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              day,
            );
            final isSelected =
                currentDate.year == _selectedDate.year &&
                currentDate.month == _selectedDate.month &&
                currentDate.day == _selectedDate.day;

            final String dateKey =
                '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
            final hasFestival = _festivalsData.containsKey(dateKey);

            return GestureDetector(
              onTap: () => _onDateSelected(currentDate),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.orange.shade700
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.orange.shade400, width: 2)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (hasFestival)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.orange.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoFestivals() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No Festivals Today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected date has no scheduled festivals',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Tap the quick buttons above to jump to festival dates',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestivalsList() {
    return Column(
      children: [
        const SizedBox(height: 8),
        ..._selectedDateFestivals
            .map(
              (festival) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.festival,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    festival.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    festival.timing,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _showFestivalDetails(festival),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Details',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}

class Festival {
  final String name;
  final String description;
  final String timing;
  final String significance;

  Festival({
    required this.name,
    required this.description,
    required this.timing,
    required this.significance,
  });
}
