import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:mslgd/widgets/common/InlineVideoPlayer_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum GallerySection { photos, videos, liveArchives, publications }

class GalleryScreen extends StatefulWidget {
  final GallerySection initialSection;

  const GalleryScreen({super.key, this.initialSection = GallerySection.photos});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late GallerySection _currentSection;

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;
  }

  void _selectSection(GallerySection section) {
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
          backgroundColor: isDark
              ? theme.scaffoldBackgroundColor
              : const Color(0xFFFFE7B3),
          appBar: AppBar(
            title: TranslatedText(
              'Gallery',
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
              // Background
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
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.8)
                      : Colors.transparent,
                ),
              ),
              // Content
              SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: _buildSection(theme, isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── DRAWER ────────────────────────────────────────────────────────────────

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
                'Gallery',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _drawerItem('Temple Photos', GallerySection.photos, theme, isDark),
          _drawerItem('Temple Videos', GallerySection.videos, theme, isDark),
          _drawerItem(
            'Live Darshan Archives',
            GallerySection.liveArchives,
            theme,
            isDark,
          ),
          _drawerItem(
            'Publications & Downloads',
            GallerySection.publications,
            theme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    String title,
    GallerySection section,
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

  // ── SECTION SWITCH ────────────────────────────────────────────────────────

  Widget _buildSection(ThemeData theme, bool isDark) {
    switch (_currentSection) {
      case GallerySection.photos:
        return _photosSection(theme, isDark);
      case GallerySection.videos:
        return _videosSection(theme, isDark);
      case GallerySection.liveArchives:
        return _liveArchivesSection(theme, isDark);
      case GallerySection.publications:
        return _publicationsSection(theme, isDark);
    }
  }

  // ── SECTIONS ──────────────────────────────────────────────────────────────

  Widget _photosSection(ThemeData theme, bool isDark) {
    // You can load real list from assets / network / provider
    final photoAssets = [
      'https://marakatasrilaxmiganapathi.org/assets/img/seva1.jpg',
      'https://marakatasrilaxmiganapathi.org/assets/img/seva2.jpg',
      'https://marakatasrilaxmiganapathi.org/assets/img/seva3.jpg',
      'https://marakatasrilaxmiganapathi.org/assets/img/seva4.jpg',
      'https://marakatasrilaxmiganapathi.org/assets/img/seva1.jpg',
      // ...
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Temple Events & Darshan',
          subtitle: 'Capturing divine moments and sacred celebrations',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 16.h),
        ...photoAssets.map((path) => _photoItem(path, theme)),

        SizedBox(height: 16.h),
        OutlinedButton(
          onPressed: () {
            // Handle view all navigation
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            minimumSize: Size(double.infinity, 45.h),
          ),
          child: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.62.w,
                child: TranslatedText(
                  "View All",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageShimmer(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          height: 220.h,
          width: double.infinity,
          child: Shimmer.fromColors(
            baseColor: theme.colorScheme.surfaceVariant,
            highlightColor: theme.colorScheme.surface,
            child: Container(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _photoItem(String path, ThemeData theme) {
    return FutureBuilder(
      future: precacheImage(NetworkImage(path), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _imageShimmer(theme);
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(
              path,
              // height: 220.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 220.h,
                  alignment: Alignment.center,
                  color: theme.colorScheme.surfaceVariant,
                  child: const Icon(Icons.broken_image),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _videosSection(ThemeData theme, bool isDark) {
    // Dummy data – replace with real list
    final videos = [
      {'url': 'https://marakatasrilaxmiganapathi.org/assets/vd/1vd.mp4'},
      {'url': 'https://marakatasrilaxmiganapathi.org/assets/vd/2vd.mp4'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Temple Video Collection',
          subtitle:
              'Relive important rituals, festivals and daily darshan moments',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 20.h,
          children: videos
              .map(
                (v) => Container(
                  width: double.infinity,
                  decoration: _cardDecoration(theme, isDark),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: InlineVideoPlayer(videoUrl: v['url']!),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 16.h),
        OutlinedButton(
          onPressed: () {
            // Handle view all navigation
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            minimumSize: Size(double.infinity, 45.h),
          ),
          child: Row(
            spacing: 10.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.62.w,
                child: TranslatedText(
                  "View All",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _liveArchivesSection(ThemeData theme, bool isDark) {
    // Similar horizontal list style as SevaLiveDarshanScreen → Past Darshans
    final archives = [
      {
        'title': 'Vaikuntha Ekadashi 2025',
        'date': 'Dec 20, 2025',
        'url': 'https://www.youtube.com/shorts/yNBh5-arDaw',
      },
      {
        'title': 'Kartik Purnima Live',
        'date': 'Nov 15, 2025',
        'url': 'https://www.youtube.com/shorts/5ksioZM5NC8',
      },
      {
        'title': 'Diwali Special Darshan',
        'date': 'Oct 31, 2025',
        'url': 'https://www.youtube.com/shorts/-jWu9VS2Xls',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Live Darshan Archives',
          subtitle: 'Watch past live streams of important occasions',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 20.h,
          children: archives
              .map(
                (v) => _buildPastVideoItem(v['title']!, v['date']!, v['url']!),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _publicationsSection(ThemeData theme, bool isDark) {
    // Dummy publications list
    final pubs = [
      {
        'title': 'Temple Calendar 2026',
        'format': 'PDF',
        'size': '2.8 MB',
        'imageUrl': 'https://marakatasrilaxmiganapathi.org/assets/img/pub3.jpg',
        'url': 'https://example.com/calendar2026.pdf',
      },
      {
        'title': 'Festival brochure',
        'format': 'PDF',
        'size': '4.1 MB',
        'imageUrl': 'https://marakatasrilaxmiganapathi.org/assets/img/pub2.jpg',
        'url': 'https://example.com/stotram.pdf',
      },
      {
        'title': 'Devotional Booklet',
        'format': 'PDF',
        'size': '1.2 MB',
        'imageUrl': 'https://marakatasrilaxmiganapathi.org/assets/img/pub1.jpg',
        'url': 'https://example.com/seva-schedule.pdf',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Publications & Downloads',
          subtitle:
              'Spiritual books, calendars, guides and important documents',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
        ...pubs.map(
          (p) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: _publicationCard(
              title: p['title']!,
              format: p['format']!,
              size: p['size']!,
              imageUrl: p['imageUrl']!,
              url: p['url']!,
              theme: theme,
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }

  // ── COMMON WIDGETS ────────────────────────────────────────────────────────

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          title,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          subtitle,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 14.sp,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPastVideoItem(String title, String date, String videoUrl) {
    return Container(
      // width: 240.w,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 REAL VIDEO PREVIEW (NOT STATIC)
          Stack(
            children: [
              SizedBox(
                // height: 140.h,
                width: double.infinity,
                child: _pastVideoPreview(videoUrl),
              ),

              // Play overlay
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(url: videoUrl),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 38.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Text + Button
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  title,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                TranslatedText(
                  date,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchYouTube(videoUrl, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: TranslatedText('Watch Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pastVideoPreview(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId == null) {
      return Container(height: 140.h, color: Colors.grey.shade300);
    }

    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
        disableDragSeek: true,
        hideControls: true,
        enableCaption: false,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      child: YoutubePlayer(controller: controller, aspectRatio: 16 / 9),
    );
  }

  Widget _publicationCard({
    required String title,
    required String format,
    required String size,
    required String imageUrl,
    required String url,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      decoration: _cardDecoration(theme, isDark),
      child: Row(
        children: [
          Container(
            width: 90.w,
            height: 90.w, // 🔒 fixed height prevents layout jump
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,

                /// 🔹 SHIMMER UNTIL IMAGE LOADS
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Shimmer.fromColors(
                    baseColor: theme.colorScheme.surfaceVariant,
                    highlightColor: theme.colorScheme.surface,
                    child: Container(color: Colors.white),
                  );
                },

                /// 🔹 OPTIONAL ERROR STATE
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    alignment: Alignment.center,
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 28.sp,
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  title,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                TranslatedText(
                  '$format • $size',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.download_rounded,
              color: theme.colorScheme.secondary,
            ),
            onPressed: () => _launchUrl(url),
          ),
        ],
      ),
    );
  }

  Future<void> _launchYouTube(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: TranslatedText('Could not open video')),
        );
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  BoxDecoration _cardDecoration(ThemeData theme, bool isDark) {
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
