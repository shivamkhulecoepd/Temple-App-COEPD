import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/db_functions.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:shimmer/shimmer.dart';

typedef MenuEntry = DropdownMenuEntry<String>;

enum NewsNoticesSection {
  latestNews,
  noticesAnnouncements,
  circularsDownloads,
  pressReleases,
}

class NewsNoticesScreeen extends StatefulWidget {
  final NewsNoticesSection initialSection;

  const NewsNoticesScreeen({super.key, required this.initialSection});

  @override
  NewsNoticesScreeenState createState() => NewsNoticesScreeenState();
}

class NewsNoticesScreeenState extends State<NewsNoticesScreeen> {
  late NewsNoticesSection _currentSection;
  List<dynamic>? latestNews;
  List<dynamic> noticesAnnouncements = [];
  bool _isLoading = true;

  Future<void> _fetchData() async {
    log('Refresh triggered!');
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        DBFunctions().fetchLatestBanner(),
        DBFunctions().fetchNotices(),
      ], eagerError: true);
      log("fetchLatestBanner :- ${results[0]}");

      if (!mounted) return;

      setState(() {
        // Handle the new API response format - now returns a list of banners
        List<dynamic>? bannerList = results[0];
        // Take the first banner if available, otherwise null
        latestNews = bannerList;
        // log("Latest news fetched: $latestNews");
        noticesAnnouncements = results[1] as List<dynamic>;
        // log("Notices fetched: ${noticesAnnouncements.length} items");
        _isLoading = false;
      });
      log('Data refresh completed successfully');
    } catch (e) {
      log('Error fetching news data: $e');
      if (!mounted) return;
      setState(() {
        latestNews = null;
        noticesAnnouncements = [];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;
    _fetchData();
  }

  void _selectSection(NewsNoticesSection section) {
    setState(() => _currentSection = section);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: TranslatedText(
              'News and Notices',
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
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                child: _buildSection(theme, isDark),
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
      backgroundColor: isDark ? theme.cardColor : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dashboard/gallery5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: TranslatedText(
                'News & Notices',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _drawerItem(
            'Latest News',
            NewsNoticesSection.latestNews,
            theme,
            isDark,
          ),
          _drawerItem(
            'Notices & Announcements',
            NewsNoticesSection.noticesAnnouncements,
            theme,
            isDark,
          ),
          _drawerItem(
            'Circulars & Downloads',
            NewsNoticesSection.circularsDownloads,
            theme,
            isDark,
          ),
          _drawerItem(
            'Press Releases',
            NewsNoticesSection.pressReleases,
            theme,
            isDark,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TranslatedText(
                  'Subscribe to our Newsletter',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.white : Colors.blue[800],
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
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
                    'Subscribe',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    NewsNoticesSection section,
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
      case NewsNoticesSection.latestNews:
        return _latestNewsSection(theme, isDark);
      case NewsNoticesSection.noticesAnnouncements:
        return _noticesAnnouncementsSection(theme, isDark);
      case NewsNoticesSection.circularsDownloads:
        return _circularsDownloadsSection(theme, isDark);
      case NewsNoticesSection.pressReleases:
        return _pressReleasesSection(theme, isDark);
    }
  }

  // ---------------- SECTION UIs ----------------

  Widget _latestNewsSection(ThemeData theme, bool isDark) {
    return RefreshIndicator.adaptive(
      onRefresh: _fetchData,
      color: theme.colorScheme.secondary,
      backgroundColor: theme.colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      'Latest & News',
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : null,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TranslatedText(
                      'Daily updates and announcements from the temple',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'aBeeZee',
                        color: isDark ? Colors.grey.shade300 : null,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _isLoading
                        ? _buildLatestNewsShimmer(theme, isDark)
                        : latestNews != null && latestNews!.isNotEmpty
                        ? _buildLatestNewsCard(
                            context,
                            theme: theme,
                            isDark: isDark,
                          )
                        : Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: _cardDecoration(theme, isDark),
                            child: Center(
                              child: TranslatedText(
                                'No latest news available',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 16.sp,
                                  color: isDark ? Colors.grey.shade300 : null,
                                ),
                              ),
                            ),
                          ),
                    // Add flexible space to ensure scrollable content
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _noticesAnnouncementsSection(ThemeData theme, bool isDark) {
    return RefreshIndicator.adaptive(
      onRefresh: _fetchData,
      color: theme.colorScheme.secondary,
      backgroundColor: theme.colorScheme.primary,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      'Notices & Announcements',
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : null,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TranslatedText(
                      'Official announcement channel for all updates and notices',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'aBeeZee',
                        color: isDark ? Colors.grey.shade300 : null,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _isLoading
                        ? _buildNoticesShimmer(theme, isDark)
                        : noticesAnnouncements.isNotEmpty
                        ? _noticesAnnouncementsCardSection(
                            noticesAnnouncements,
                            theme,
                            isDark,
                          )
                        : Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: _cardDecoration(theme, isDark),
                            child: Center(
                              child: TranslatedText(
                                'No notices available',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 16.sp,
                                  color: isDark ? Colors.grey.shade300 : null,
                                ),
                              ),
                            ),
                          ),
                    // Add flexible space to ensure scrollable content
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _circularsDownloadsSection(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            'Circulars & Downloads',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          SizedBox(height: 6.h),
          TranslatedText(
            'Official circulars and notification for download',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
          ),
          SizedBox(height: 20.h),
          _circularsDownloadsCard(theme, isDark),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {},
            child: TranslatedText(
              'View full list',
              style: TextStyle(fontFamily: 'aBeeZee'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pressReleasesSection(ThemeData theme, bool isDark) {
    const List<String> yearsList = <String>['2025', '2024', '2023'];
    final List<MenuEntry> yearsListMenuEntries =
        UnmodifiableListView<MenuEntry>(
          yearsList.map<MenuEntry>(
            (String name) => MenuEntry(value: name, label: name),
          ),
        );

    const List<String> topicsList = <String>[
      'All topics',
      'Pooja',
      'Events',
      'Announcements',
    ];
    final List<MenuEntry> topicsListMenuEntries =
        UnmodifiableListView<MenuEntry>(
          topicsList.map<MenuEntry>(
            (String name) => MenuEntry(value: name, label: name),
          ),
        );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            'Press Releases',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          SizedBox(height: 6.h),
          TranslatedText(
            'Latest press releases from temple committee.',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
          ),
          SizedBox(height: 20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10.w,
              children: [
                DropdownMenu<String>(
                  initialSelection: yearsList.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {});
                  },
                  dropdownMenuEntries: yearsListMenuEntries,
                ),
                DropdownMenu<String>(
                  initialSelection: topicsList.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {});
                  },
                  dropdownMenuEntries: topicsListMenuEntries,
                ),
                DropdownMenu<String>(
                  initialSelection: 'Newest',
                  showTrailingIcon: false,
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry<String>(value: 'Newest', label: 'Newest'),
                  ],
                ),
              ],
            ),
          ),
          _isLoading
              ? _buildPressReleasesShimmer(theme, isDark)
              : Column(
                  children: [
                    _pressReleasesCard(
                      theme,
                      title: "Bhooodanam Seva is now live..",
                      description:
                          "Bhooodanam Seva is now live. Devotees who wish to participate may register through the temple office or the designated online portal. Contributions support the preparation and distribution of daily prasadam.",
                      imageUrl:
                          'https://marakatasrilaxmiganapathi.org/assets/img/press1.jpg',
                      onReadMorePressed: () {},
                      isDark: isDark,
                    ),
                    _pressReleasesCard(
                      theme,
                      title: "Visheshesh Swamy Archana Schedule",
                      description:
                          "The Visheshesh Swamy Archana will be conducted monthly as part of the temple's special puja offerings. Devotees are requested to note the schedule:\n"
                          "• Date: 15th of every month\n"
                          "• Morning Session",
                      imageUrl:
                          'https://marakatasrilaxmiganapathi.org/assets/img/press2.jpg',
                      buttonText: 'Know More',
                      onReadMorePressed: () {},
                      isDark: isDark,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // ---------------- COMMON WIDGETS ----------------

  Widget _buildLatestNewsCard(
    BuildContext context, {
    required ThemeData theme,
    required bool isDark,
  }) {
    // Additional safety check
    if (latestNews == null || latestNews!.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: _cardDecoration(theme, isDark),
        child: Center(
          child: TranslatedText(
            'No latest news available',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 16.sp,
              color: isDark ? Colors.grey.shade300 : null,
            ),
          ),
        ),
      );
    }

    // Create separate individual cards for each banner
    return Column(
      children: List.generate(latestNews!.length, (index) {
        Map<String, dynamic> banner = latestNews![index];
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: _cardDecoration(theme, isDark),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Large image header
                AspectRatio(
                  aspectRatio: 16 / 9, // Maintain aspect ratio for images
                  child: Image.network(
                    banner['banner_image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 60.sp,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: isDark
                            ? Colors.grey[800]!
                            : Colors.grey[300]!,
                        highlightColor: isDark
                            ? Colors.grey[700]!
                            : Colors.grey[100]!,
                        child: Container(
                          height: 20.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Content area
                Container(
                  padding: EdgeInsets.all(12.r),
                  color: Theme.of(
                    context,
                  ).cardColor, // Ensure consistent background color
                  child: Column(
                    spacing: 6.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        banner['heading'] ?? 'No title',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      TranslatedText(
                        '${banner['event_date'] ?? ''}  ⦿  ${banner['event_time'] ?? ''}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                          fontFamily: 'aBeeZee',
                        ),
                      ),
                      TranslatedText(
                        banner['content'] ?? 'No content available',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          height: 1.4,
                          color: isDark ? Colors.grey.shade300 : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _noticesAnnouncementsCardSection(
    List<dynamic> items,
    ThemeData theme,
    bool isDark,
  ) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: items.map((item) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(6.r),
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
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                item['title'],
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.w400,
                  fontSize: 18.sp,
                ),
              ),
              TranslatedText(
                item['date_short'],
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: isDark ? Colors.grey : theme.primaryColor,
                ),
              ),
              TranslatedText(
                item['content'],
                style: TextStyle(fontFamily: 'aBeeZee', fontSize: 13.sp),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _circularsDownloadsCard(ThemeData theme, bool isDark) {
    final List<Map<String, String>> donors = [
      {'name': 'Rajesh Reddy', 'gotra': 'Kasyap', 'donation': '₹12,000'},
      {'name': 'Sravani Goud', 'gotra': 'Haritasa', 'donation': '₹8,500'},
      {'name': 'Mahesh Kumar', 'gotra': 'Bharadwaj', 'donation': '₹15,000'},
      {'name': 'Deepika Rani', 'gotra': 'Vasishta', 'donation': '₹5,200'},
      {'name': 'Anil Chakravarthy', 'gotra': 'Koundinya', 'donation': '₹9,800'},
      {'name': 'Lavanaya Reddy', 'gotra': 'Kasyap', 'donation': '₹7,000'},
      {'name': 'Krishna Chaitanya', 'gotra': 'Gautam', 'donation': '₹13,500'},
      {'name': 'Swathi Priya', 'gotra': 'Jamadagni', 'donation': '₹6,300'},
      {'name': 'Sandeep Rao', 'gotra': 'Haritasa', 'donation': '₹4,000'},
      {'name': 'Prathyusha Devi', 'gotra': 'Vasishta', 'donation': '₹4,900'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20.w,
          horizontalMargin: 16.w,
          columns: <DataColumn>[
            DataColumn(
              label: TranslatedText(
                'Darbharu Seva',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: TranslatedText(
                'Gotra',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: TranslatedText(
                'Donation',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
          rows: donors.map((donor) {
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  TranslatedText(
                    donor['name']!,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  TranslatedText(
                    donor['gotra']!,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[300] : Colors.black,
                    ),
                  ),
                ),
                DataCell(
                  TranslatedText(
                    donor['donation']!,
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
    );
  }

  Widget _pressReleasesCard(
    ThemeData theme, {
    required String title,
    required String description,
    required String imageUrl,
    String buttonText = 'Read More',
    VoidCallback? onReadMorePressed,
    bool isDark = false,
    double borderRadius = 16,
    double imageWidth = 100,
    double imageHeight = 100,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TranslatedText(
                    title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee', // ← your font
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Description
                  TranslatedText(
                    description,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      height: 1.35,
                      color: isDark ? Colors.grey[300] : Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Read More button
                  if (onReadMorePressed != null)
                    GestureDetector(
                      onTap: onReadMorePressed,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.blueGrey[700]
                              : theme.primaryColor,
                          // color: isDark
                          //     ? Colors.blueGrey[700]
                          //     : const Color.fromARGB(255, 33, 150, 243),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: TranslatedText(
                          buttonText,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Right image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: imageUrl.startsWith('https')
                  ? Image.network(
                      imageUrl,
                      width: imageWidth.w,
                      height: imageHeight.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _placeholderImage(),
                    )
                  : Image.asset(
                      imageUrl,
                      width: imageWidth.w,
                      height: imageHeight.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _placeholderImage(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple placeholder when image fails to load
  Widget _placeholderImage() {
    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  // Shimmer effect for latest news card
  Widget _buildLatestNewsShimmer(ThemeData theme, bool isDark) {
    return Container(
      decoration: _cardDecoration(theme, isDark),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image shimmer
            Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
              child: Container(height: 200.h, color: Colors.white),
            ),

            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                spacing: 6.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  Shimmer.fromColors(
                    baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    highlightColor: isDark
                        ? Colors.grey[700]!
                        : Colors.grey[100]!,
                    child: Container(
                      height: 24.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  // Date shimmer
                  Shimmer.fromColors(
                    baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    highlightColor: isDark
                        ? Colors.grey[700]!
                        : Colors.grey[100]!,
                    child: Container(
                      height: 16.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),

                  // Content shimmer
                  Shimmer.fromColors(
                    baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    highlightColor: isDark
                        ? Colors.grey[700]!
                        : Colors.grey[100]!,
                    child: Column(
                      children: [
                        Container(
                          height: 16.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 16.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer effect for notices cards
  Widget _buildNoticesShimmer(ThemeData theme, bool isDark) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(6.r),
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
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  height: 20.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),

              // Date shimmer
              Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  height: 14.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),

              // Content shimmer
              Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Column(
                  children: [
                    Container(
                      height: 14.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 14.h,
                      width: 250.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer effect for press releases cards
  Widget _buildPressReleasesShimmer(ThemeData theme, bool isDark) {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          margin: EdgeInsets.only(top: 16.h),
          decoration: BoxDecoration(
            color: isDark
                ? theme.cardColor
                : const Color.fromARGB(
                    255,
                    202,
                    229,
                    250,
                  ).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left content shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title shimmer
                      Shimmer.fromColors(
                        baseColor: isDark
                            ? Colors.grey[800]!
                            : Colors.grey[300]!,
                        highlightColor: isDark
                            ? Colors.grey[700]!
                            : Colors.grey[100]!,
                        child: Container(
                          height: 20.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Description shimmer
                      Shimmer.fromColors(
                        baseColor: isDark
                            ? Colors.grey[800]!
                            : Colors.grey[300]!,
                        highlightColor: isDark
                            ? Colors.grey[700]!
                            : Colors.grey[100]!,
                        child: Column(
                          children: [
                            Container(
                              height: 16.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 16.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              height: 16.h,
                              width: 180.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Button shimmer
                      Shimmer.fromColors(
                        baseColor: isDark
                            ? Colors.grey[800]!
                            : Colors.grey[300]!,
                        highlightColor: isDark
                            ? Colors.grey[700]!
                            : Colors.grey[100]!,
                        child: Container(
                          height: 32.h,
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16.w),

                // Right image shimmer
                Shimmer.fromColors(
                  baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  highlightColor: isDark
                      ? Colors.grey[700]!
                      : Colors.grey[100]!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(ThemeData theme, bool isDark) {
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
