import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/db_functions.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
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
  List<dynamic> _events = [];
  Map<String, dynamic>? _liveStreamData;
  bool _isLoading = true;

  // Daily rituals data
  final List<Map<String, String>> _dailyRituals = [
    {
      'ritual': 'Suprabhata & Ashtottara Seva',
      'time': '05:00 AM',
      'notes': 'Daily (Sun & Sankashti). Benefits: Education, employment, health, wealth, success.'
    },
    {
      'ritual': 'Vastralankarana & 32 Dravya Abhishekam',
      'time': '05:00 – 05:30 AM',
      'notes': 'Divine grace, longevity, prosperity, wealth gain.'
    },
    {
      'ritual': 'Chaturavritti Tarpanam',
      'time': '07:00 AM',
      'notes': 'Protection, disease relief, career & political growth, prosperity.'
    },
    {
      'ritual': 'Sahasranama Archana',
      'time': '07:00 – 08:00 AM',
      'notes': 'Mon, Tue, Thu, Fri, Chaturthi & Sat. Removes poverty, debts, improves growth.'
    },
    {
      'ritual': 'Durva Yugma Puja',
      'time': '08:00 – 09:00 AM',
      'notes': 'Mental peace, job stability, business & wealth growth.'
    },
    {
      'ritual': 'Homam Sevas',
      'time': '08:00 AM',
      'notes': 'Includes Ganapati Atharvashirsha, Lakshmi Ganapati Mantra, Sri Sukta. Benefits: Career, marriage, progeny, prosperity.'
    },
    {
      'ritual': 'Friday Special Sevas',
      'time': '10:00 AM & 11:00 AM',
      'notes': 'Suvarna Pushparchana & Odi Gantla Seva. Lakshmi blessings & prosperity.'
    },
    {
      'ritual': 'Navagraha Abhishekam (Saturday)',
      'time': '05:00 AM',
      'notes': 'Panchamrita, Shani Taila, Sesame donation & Homam. Relieves planetary doshas.'
    },
    {
      'ritual': 'Durva Puja (Noon)',
      'time': '12:00 PM',
      'notes': 'Daily special puja for peace, political & career growth.'
    },
    {
      'ritual': 'Rajopachara Puja & Donor Blessings',
      'time': 'Select Days',
      'notes': 'Darbar Seva & Vedic blessings for Annadanam donors. Removes financial & vastu issues.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection ?? FestivalsSection.annualFestivals;
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        DBFunctions().fetchActiveEvents(),
        DBFunctions().fetchLiveStreamSettings(),
      ], eagerError: true);

      if (!mounted) return;

      setState(() {
        _events = results[0] as List<dynamic>;
        _liveStreamData = results[1] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      log('Error fetching festival data: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String get liveUrl =>
      _liveStreamData?['embed_code'] ??
      'https://www.youtube.com/watch?v=IL-72PQszxg';

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return 'Date not available';
    }
  }

  Future<void> _launchYouTube(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackbar.error(context, 'Could not open YouTube');
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dashboard/gallery5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              width: double.infinity,
              height: double.infinity,
              child: TranslatedText(
                'Temple Festivals',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          Divider(),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: Column(
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
                    AppSnackbar.info(context, 'Register for Spotlight clicked');
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
          'Major festivals are celebrated with special rituals, alankarams, and cultural programs.',
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
              'Marakata Lakshmi Ganapati – Devi Sharannavarathrulu',
              "In every Manvantara, Kalpa, and Yuga, whenever negative forces grow and trouble the worlds, the Supreme Divine Power manifests. The great Ganapati’s divine Shakti appears in feminine form as the Goddess — manifesting as Mahakali, Mahalakshmi, and Mahasaraswati — and destroys powerful demons such as Madhu–Kaitabha, Mahishasura, Shumbha-Nishumbha, Chanda–Munda, Durgamasura, and others.\n\nDuring Sharannavarathri, the Goddess is worshipped in multiple Lakshmi forms including Adi Lakshmi, Dhanya Lakshmi, Dhairya Lakshmi, Gaja Lakshmi, Santana Lakshmi, Vijaya Lakshmi, Vidya Lakshmi, Dhana Lakshmi, and Marakata Lakshmi.\n\nBy worshipping these forms with devotion, devotees obtain Ashta Aishwarya, health, removal of enemy troubles, and success in all directions.",
              'Ashwayuja Shukla Padyami – Dashami',
              theme,
              isDark,
              'Register',
            ),
            _festivalCard(
              'Marakata Lakshmi Ganapati Swamy – Brahmotsavam',
              'Marakata Lakshmi Ganapati Swamy is described as the embodiment of the primordial Pranava (Om), the supreme leader of the three worlds, and the all-pervading divine presence in the universe.\n\nEvery year, from Chaitra Shuddha Vidiya to Panchami, the grand Brahmotsavam festival is celebrated with Rathotsavam, Homams, Maha Poornahuti, Shanti Kalyanam, and sacred rituals.\n\nParticipation is believed to remove Navagraha doshas, reduce afflictions, remove obstacles, grant wealth, prosperity,success, and overall auspiciousness.',
              'Chaitra Shuddha Vidiya – Panchami',
              theme,
              isDark,
              'Register',
            ),
            _festivalCard(
              'Marakata Lakshmi Ganapati Swamy – Brahmotsavams',
              'Marakata Lakshmi Ganapati Swamy is described as the embodiment of the primordial Pranava (Om), the supreme leader of the three worlds, and the all-pervading divine presence in the universe.\n\nEvery year, from Chaitra Shuddha Vidiya to Panchami, the grand Brahmotsavam festival is celebrated with Rathotsavam, Homams, Maha Poornahuti, Shanti Kalyanam, and sacred rituals.\n\nParticipation is believed to remove Navagraha doshas, reduce afflictions, remove obstacles, grant wealth, prosperity, success, and overall auspiciousness.',
              'Chaitra Shuddha Vidiya – Panchami',
              theme,
              isDark,
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
              rows: _dailyRituals.map((ritual) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      TranslatedText(
                        ritual['ritual']!,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        ritual['time']!,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        ritual['notes']!,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: () {
            // Handle download schedule
            AppSnackbar.info(context, 'Download Schedule clicked');
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
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      color: theme.colorScheme.secondary,
      backgroundColor: theme.primaryColor,
      onRefresh: () async {
        try {
          final results = await Future.wait([
            DBFunctions().fetchActiveEvents(),
          ], eagerError: true);

          if (!mounted) return;

          setState(() {
            _events = results[0];
            _isLoading = false;
          });
        } catch (e) {
          log('Error fetching festival data for upcoming/active events: $e');
          if (!mounted) return;
          setState(() => _isLoading = false);
        }
      },
      child: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Column(
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
              if (_events.isEmpty)
                Center(
                  child: TranslatedText(
                    'No upcoming events',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 16.sp,
                      color: isDark ? Colors.grey[300] : Colors.black,
                    ),
                  ),
                )
              else ...[
                Column(
                  spacing: 16.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _events.map((event) {
                    return _eventItem(
                      _formatDate(event['event_date'] ?? ''),
                      event['event_title'] ?? '',
                      event['event_time'] ?? '',
                      theme,
                      isDark,
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h), // Add some padding at the end
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _liveStreamingSection(ThemeData theme, bool isDark) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      color: theme.colorScheme.secondary,
      backgroundColor: theme.primaryColor,
      onRefresh: () async {
        try {
          final results = await Future.wait([
            DBFunctions().fetchLiveStreamSettings(),
          ], eagerError: true);

          if (!mounted) return;

          setState(() {
            _liveStreamData = results[0];
            _isLoading = false;
          });
        } catch (e) {
          log('Error fetching live stream data: $e');
          if (!mounted) return;
          setState(() => _isLoading = false);
        }
      },
      child: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Column(
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
                        if (_events.isEmpty)
                          TranslatedText(
                            'No upcoming live sessions',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 14.sp,
                              color: isDark ? Colors.grey[300] : Colors.black,
                            ),
                          )
                        else ...[
                          for (var i = 0; i < _events.length && i < 2; i++)
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: TranslatedText(
                                '• ${_events[i]['event_title']} – ${_formatDate(_events[i]['event_date'] ?? '')}',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 14.sp,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.black,
                                ),
                              ),
                            ),
                        ],
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            // Handle subscribe for reminder
                            AppSnackbar.info(
                              context,
                              'Subscribe for reminder clicked',
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
                  SizedBox(height: 20.h), // Add padding at the end
                ],
              ),
            ],
          ),
        ],
      ),
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
          ElevatedButton(
            onPressed: () {
              // Handle register
              // AppSnackbar.info(context, 'Register clicked');
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
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
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
              AppSnackbar.info(context, 'Download clicked');
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
