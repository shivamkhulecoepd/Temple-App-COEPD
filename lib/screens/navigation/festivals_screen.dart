import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';

// Define enum for different sections
enum FestivalsSection {
  annualFestivals,
  dailyRituals,
  upcomingEvents,
  liveStreaming,
  membershipSubscription,
}

class FestivalsScreen extends StatefulWidget {
  final FestivalsSection? initialSection;
  const FestivalsScreen({super.key, this.initialSection});

  @override
  State<FestivalsScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalsScreen> {
  late FestivalsSection _currentSection;

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection ?? FestivalsSection.annualFestivals;
  }

  String liveUrl = 'https://www.youtube.com/watch?v=IL-72PQszxg';

  Future<void> _launchYouTube(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TranslatedText('Could not open YouTube')),
      );
    }
  }

  void _selectSection(FestivalsSection section) {
    Navigator.pop(context);
    if (section == _currentSection) return;
    setState(() => _currentSection = section);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? theme.scaffoldBackgroundColor
              : Colors.white,
          appBar: AppBar(
            title: TranslatedText(
              'Festival & Events',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'aBeeZee',
              ),
            ),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          drawer: _buildDrawer(theme, isDark),
          body: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background/main_bg1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Black overlay in dark mode
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.8)
                      : Colors.transparent,
                ),
              ),
              // Main Content
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: _buildSection(theme, isDark),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- DRAWER ----------------
  Drawer _buildDrawer(ThemeData theme, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? theme.cardColor : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: // Festival Spotlight Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  'Festival Spotlight',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.white : Colors.blue[800],
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                TranslatedText(
                  'Next: Vinayaka Chavithi',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.white : Colors.blue[700],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                TranslatedText(
                  '- Sep 17, 2026',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.grey[300] : Colors.blue[600],
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                ElevatedButton(
                  onPressed: () {
                    // Handle register for spotlight
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: TranslatedText(
                          'Register for Spotlight clicked',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: TranslatedText(
                    'Register for Spotlight',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Drawer Items
          _drawerItem(
            'Annual Festivals',
            FestivalsSection.annualFestivals,
            theme,
            isDark,
          ),
          _drawerItem(
            'Daily Rituals and timings',
            FestivalsSection.dailyRituals,
            theme,
            isDark,
          ),
          _drawerItem(
            'Upcoming Events Calendar',
            FestivalsSection.upcomingEvents,
            theme,
            isDark,
          ),
          _drawerItem(
            'Live Streaming',
            FestivalsSection.liveStreaming,
            theme,
            isDark,
          ),
          _drawerItem(
            'Membership & Subscription',
            FestivalsSection.membershipSubscription,
            theme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    String title,
    FestivalsSection section,
    ThemeData theme,
    bool isDark,
  ) {
    final isActive = _currentSection == section;

    return ListTile(
      tileColor: isActive ? theme.primaryColor : null,
      title: TranslatedText(
        title,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          color: isActive
              ? Colors.white
              : (isDark ? Colors.white : Colors.black),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => _selectSection(section),
    );
  }

  // ---------------- SECTION SWITCH ----------------
  Widget _buildSection(ThemeData theme, bool isDark) {
    switch (_currentSection) {
      case FestivalsSection.annualFestivals:
        return _annualFestivalsSection(theme, isDark);
      case FestivalsSection.dailyRituals:
        return _dailyRitualsSection(theme, isDark);
      case FestivalsSection.upcomingEvents:
        return _upcomingEventsSection(theme, isDark);
      case FestivalsSection.liveStreaming:
        return _liveStreamingSection(theme, isDark);
      case FestivalsSection.membershipSubscription:
        return _membershipSubscriptionSection(theme, isDark);
    }
  }

  // ---------------- SECTION UIs ----------------
  Widget _annualFestivalsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Annual Festival',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Major festivals are celebrated at the temple with rituals, cultural programmes, and sevas.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Festival Cards
        Column(
          spacing: 16.h,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _festivalCard(
              'Temple Calendar 2026',
              'Grand celebration with special sevas and homams',
              '09-02-2026',
              theme,
              isDark,
              'View Details',
              'Register',
            ),
            _festivalCard(
              'Navratri',
              'Nine days of cultural programs and worship',
              '10-09-2026',
              theme,
              isDark,
              'View Details',
              'Register',
            ),
          ],
        ),
      ],
    );
  }

  Widget _dailyRitualsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Daily Rituals and Timings',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Daily schedule of temple rituals and seva timings',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Horizontal scrollable table for rituals
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[800]!.withValues(alpha: 0.6)
                : Colors.grey[100]!.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: TranslatedText(
                    'Ritual',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: TranslatedText(
                    'Time',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: TranslatedText(
                    'Notes',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      TranslatedText(
                        'Suprabhatam',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        '06:00 am',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        'Morning invocation',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      TranslatedText(
                        'Abhishekam',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        '07:30 am',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        'Special offerings',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      TranslatedText(
                        'Archana',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        '09:00 am',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        'Open to devotees',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: <DataCell>[
                    DataCell(
                      TranslatedText(
                        'Evening Aarathi',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        '06:30 pm',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        'All Devotees welcome',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: () {
            // Handle download schedule
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: TranslatedText('Download Schedule clicked'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: TranslatedText(
            'Download Schedule (PDF)',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _upcomingEventsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Upcoming Events',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Click an event to see details',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // List of events
        Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eventItem(
              '20 Dec',
              'suvarn pushanjali',
              '9:00 am - 5:00pm',
              theme,
              isDark,
            ),
            _eventItem('02 Jan', 'suvarn push test', '6 am', theme, isDark),
            _eventItem('15 Jan', 'makara sankranthi', '5:00 Am', theme, isDark),
            _eventItem('08 Feb', 'demooo', '6:00 Am to 9:00 Am', theme, isDark),
          ],
        ),
      ],
    );
  }

  Widget _liveStreamingSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Live Streaming',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Watch live rituals and festivals from anywhere in the world',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Live streaming video placeholder
        Column(
          spacing: 16.h,
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/dashboard/bg 2.webp'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    HapticFeedback.heavyImpact();
                    await _launchYouTube(liveUrl, context);
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.yellow[50]!.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    'Upcoming Live Sessions',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '• Vinayaka Chavithi Pooja – Sep 17, 2025',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[300] : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '• Navratri Kalakshetra – Sep 17, 2025',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[300] : Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      // Handle subscribe for reminder
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: TranslatedText(
                            'Subscribe for reminder clicked',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: TranslatedText(
                      'Subscribe for reminder',
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _membershipSubscriptionSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Membership & Subscription',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Become a member for exclusive access and perks',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Membership plans
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            _membershipPlan(
              'Monthly',
              '₹ 200',
              'Live stream early access\nMonthly Blessings',
              theme,
              isDark,
            ),
            _membershipPlan(
              'Quarterly',
              '₹ 500',
              'Priority Booking\nExclusive Content',
              theme,
              isDark,
            ),
            _membershipPlan(
              'Yearly',
              '₹ 1800',
              'All Perks\nSpecial Recognition',
              theme,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- COMMON WIDGETS ----------------
  Widget _festivalCard(
    String title,
    String subtitle,
    String date,
    ThemeData theme,
    bool isDark,
    String viewDetailsText,
    String registerText,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          SizedBox(height: 8.h),
          TranslatedText(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
          ),
          SizedBox(height: 12.h),
          TranslatedText(
            date,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade400 : Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle view details
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: TranslatedText('View Details clicked'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: TranslatedText(
                  viewDetailsText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'aBeeZee',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle register
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: TranslatedText('Register clicked')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: TranslatedText(
                  registerText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'aBeeZee',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eventItem(
    String date,
    String title,
    String time,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            date,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              TranslatedText(
                time,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _membershipPlan(
    String period,
    String price,
    String description,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TranslatedText(
            period,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          TranslatedText(
            price,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          TranslatedText(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              // Handle download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: TranslatedText('Download clicked')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: TranslatedText(
              'Download',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'aBeeZee',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
