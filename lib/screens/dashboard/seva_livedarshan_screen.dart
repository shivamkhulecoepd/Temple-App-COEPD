import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SevaLiveDarshanScreen extends StatefulWidget {
  const SevaLiveDarshanScreen({super.key});

  @override
  State<SevaLiveDarshanScreen> createState() => _SevaLiveDarshanScreenState();
}

class _SevaLiveDarshanScreenState extends State<SevaLiveDarshanScreen> {
  String? liveUrl;
  String? title;
  String? description;

  List<Map<String, dynamic>> timings = [];
  List<Map<String, dynamic>> upcomingEvents = [];
  List<Map<String, dynamic>> pastVideos = [];
  List<Map<String, dynamic>> sevas = [];

  YoutubePlayerController? _controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      liveUrl = 'https://www.youtube.com/watch?v=IL-72PQszxg';
      title = 'Daily Divine Darshan';
      description = 'Live from MSLGD temple, Secunderabad';

      timings = [
        {
          'title': 'Morning Darshan',
          'time': '5:00 AM - 12:00 PM',
          'icon': Icons.wb_sunny_outlined,
        },
        {
          'title': 'Evening Darshan',
          'time': '4:00 PM - 9:00 PM',
          'icon': Icons.nightlight_outlined,
        },
      ];

      upcomingEvents = [
        {'title': 'Special Pooja', 'date': 'Nov 20, 2025 | 6:00 AM'},
        {'title': 'Festival Celebration', 'date': 'Nov 22, 2025 | 7:00 PM'},
        {'title': 'Monthly Ritual', 'date': 'Nov 25, 2025 | 5:30 AM'},
      ];

      pastVideos = [
        {
          'title': 'Past Darshan 1',
          'date': 'Oct 15, 2025',
          'url': 'https://www.youtube.com/shorts/yNBh5-arDaw',
        },
        {
          'title': 'Past Darshan 2',
          'date': 'Oct 10, 2025',
          'url': 'https://www.youtube.com/shorts/5ksioZM5NC8',
        },
        {
          'title': 'Past Darshan 2',
          'date': 'Oct 10, 2025',
          'url': 'https://www.youtube.com/shorts/-jWu9VS2Xls',
        },
      ];

      sevas = [
        {
          'name': 'Daily Seva',
          'imageUrl': 'assets/images/live_seva/seva1.jpg',
          'description':
              'Participate in the morning rituals including lighting lamps and offering fresh flowers to the deity as part of the everyday worship routine.',
          'price': 100,
        },
        {
          'name': 'Special Seva',
          'imageUrl': 'assets/images/live_seva/seva2.jpg',
          'description':
              'Exclusive access to inner sanctum for personalized darshan and blessings during peak festival hours with priority entry.',
          'price': 200,
        },
        {
          'name': 'Abhishekam Seva',
          'imageUrl': 'assets/images/live_seva/seva3.jpg',
          'description':
              'Sacred bathing ceremony of the deity using milk, honey, curd, ghee, and holy water while chanting Vedic mantras for divine purification.',
          'price': 500,
        },
        {
          'name': 'Archana Seva',
          'imageUrl': 'assets/images/live_seva/seva4.jpg',
          'description':
              'Devotional offering of flowers, fruits, and leaves accompanied by chanting the 108 sacred names of the deity for personal wishes.',
          'price': 150,
        },
        {
          'name': 'Lakshmi Kalyanam',
          'imageUrl': 'assets/images/live_seva/seva1.jpg',
          'description':
              'Elaborate celestial wedding ceremony reenacting the divine marriage of Goddess Lakshmi and Lord Vishnu with rituals, music, and feasts.',
          'price': 1000,
        },
      ];
    });

    if (liveUrl != null) {
      final videoId = YoutubePlayer.convertUrlToId(liveUrl!);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            forceHD: true,
          ),
        )..addListener(_playerListener);
        setState(() {});
      }
    }
  }

  void _playerListener() {
    if (!mounted) return;
    final value = _controller?.value;
    if (value == null) return;

    if (value.isReady != isReady) {
      setState(() {
        isReady = value.isReady;
      });
    }
  }

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

  @override
  void dispose() {
    _controller?.removeListener(_playerListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        if (liveUrl == null) {
          // Show shimmer loading instead of full screen loader
          return Scaffold(
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              title: TranslatedText(
                'Live Darshan',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
              centerTitle: true,
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background/main_bg1.jpg',
                      ),
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Shimmer for video player area
                      SizedBox(
                        height: 240.h,
                        width: double.infinity,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Shimmer for content
                      _buildShimmerContent(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final bool showPlayer = _controller != null;

        return Scaffold(
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            title: TranslatedText(
              'Live Darshan',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
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
              // Main content
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 240.h,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (!showPlayer)
                            Image.asset(
                              'assets/images/about/abt2.1.jpg',
                              fit: BoxFit.cover,
                            ),
                          if (showPlayer)
                            YoutubePlayer(
                              controller: _controller!,
                              showVideoProgressIndicator: true,
                            ),
                          Positioned(
                            top: 12.h,
                            left: 12.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: TranslatedText(
                                'LIVE',
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12.h,
                            right: 12.w,
                            child: FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white,
                              onPressed: () =>
                                  _launchYouTube(liveUrl!, context),
                              child: Icon(Icons.open_in_new, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      color: Theme.of(context).cardColor.withValues(alpha: 0.1),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TranslatedText(
                            title ?? '',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.titleLarge?.color,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TranslatedText(
                            description ?? '',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPastVideos(),
                    _buildSevas(),
                    // SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerContent() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity * 0.6,
              height: 16.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // Shimmer for past videos section
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 270.h,
                  child: ListView.builder(
                    padding: EdgeInsets.only(right: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 240.w,
                        margin: EdgeInsets.only(left: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            SizedBox(
                              height: 140.h,
                              width: double.infinity,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 80.w,
                                      height: 14.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    width: double.infinity,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Shimmer for seva bookings section
          Container(
            padding: EdgeInsets.all(16.w),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 140.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 14.h,
                    childAspectRatio: 0.60.r,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 100.h,
                            color: Colors.orange.shade100,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                12.w,
                                12.h,
                                12.w,
                                6.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: 60.w,
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastVideos() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: TranslatedText(
              'Past Darshans',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 275.h,
            child: ListView.builder(
              padding: EdgeInsets.only(right: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: pastVideos.length,
              itemBuilder: (context, index) {
                final v = pastVideos[index];
                return _buildPastVideoItem(v['title'], v['date'], v['url']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSevas() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            'Seva Bookings',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Important!
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 14.h,
              childAspectRatio:
                  0.56 *
                  MediaQuery.of(context).size.height *
                  0.00125, // ← tune this (smaller = taller cards)
            ),
            itemCount: sevas.length,
            itemBuilder: (context, index) {
              final seva = sevas[index];
              return _buildSevaCard(
                name: seva['name'],
                imageUrl: seva['imageUrl'],
                description: seva['description'],
                price: seva['price'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSevaCard({
    required String name,
    required String imageUrl,
    required String description,
    required int price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior:
          Clip.hardEdge, // Important for rounded image + bottom button
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image (placeholder - replace with real asset/network image)
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              color: Colors.orange.shade100,
              child: Stack(
                children: [
                  // You can replace with real image
                  Center(child: Image.asset(imageUrl, fit: BoxFit.cover)),
                  // Optional: gradient overlay
                  // Container(
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //       colors: [
                  //         Colors.transparent,
                  //         Colors.black.withValues(alpha: 0.25),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    name,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // SizedBox(height: 4.h),
                  TranslatedText(
                    description,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  TranslatedText(
                    '₹ $price',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Book Now Button - attached to bottom with rounded corners
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.r),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.r),
                ),
                onTap: () {
                  _showBookingBottomSheet(context, {
                    'name': name,
                    'description': description,
                    'price': price,
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Center(
                    child: TranslatedText(
                      'Book Now',
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildPastVideoItem(String title, String date, String videoUrl) {
    return Container(
      width: 240.w,
      margin: EdgeInsets.only(left: 16.w),
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
                height: 140.h,
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

  Widget _buildSevaItem(String name, String description, int price) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.book_online, color: Colors.orange),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  name,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TranslatedText(
                  description,
                  style: TextStyle(fontFamily: 'aBeeZee', fontSize: 14.sp),
                ),
                TranslatedText(
                  '₹$price',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _showBookingBottomSheet(context, {
              'name': name,
              'description': description,
              'price': price,
            }),
            child: TranslatedText('Book'),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(
    BuildContext context,
    Map<String, dynamic> seva,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BookingBottomSheet(seva: seva),
    );
  }
}

/* ================= VIDEO PLAYER SCREEN ================= */

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final id = YoutubePlayer.convertUrlToId(widget.url)!;
    _controller = YoutubePlayerController(initialVideoId: id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(
          'Watch Video',
          style: TextStyle(fontFamily: 'aBeeZee'),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: YoutubePlayer(controller: _controller),
    );
  }
}

/* ================= BOOKING BOTTOM SHEET ================= */

class BookingBottomSheet extends StatefulWidget {
  final Map<String, dynamic> seva;
  const BookingBottomSheet({super.key, required this.seva});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  int currentStep = 0;

  // Controllers (you should use these in real app)
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  // Sample state variables (expand as needed)
  String? selectedPayment = 'UPI';
  String? selectedDelivery = 'In person';
  DateTime? selectedDate;
  String? selectedTimeSlot = 'Morning';
  bool inPerson = false;
  bool proxyPriest = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.94,
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
              child: Row(
                children: [
                  TranslatedText(
                    "Book Seva",
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stepper(
                type: StepperType.vertical,
                currentStep: currentStep,
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Row(
                      children: [
                        if (currentStep > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: details.onStepCancel,
                            child: TranslatedText("Back"),
                          ),
                        SizedBox(width: 12.w),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: details.onStepContinue,
                          child: TranslatedText(
                            currentStep == 2 ? "Confirm Booking" : "Next",
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onStepContinue: () {
                  bool isValid = true;

                  if (currentStep == 0) {
                    isValid = _formKey1.currentState?.validate() ?? false;
                  } else if (currentStep == 1) {
                    isValid = _formKey2.currentState?.validate() ?? false;
                  } else if (currentStep == 2) {
                    isValid = _formKey3.currentState?.validate() ?? false;
                  }

                  if (isValid) {
                    if (currentStep < 2) {
                      setState(() => currentStep++);
                    } else {
                      // Final confirmation
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: TranslatedText("Booking Confirmed! 🎉"),
                        ),
                      );
                    }
                  }
                },
                onStepCancel: currentStep > 0
                    ? () => setState(() => currentStep--)
                    : null,
                steps: [
                  // Step 1: Seva + Devotee Details
                  Step(
                    title: TranslatedText("Details"),
                    content: Form(
                      key: _formKey1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Book a Seva"),
                            TextFormField(
                              initialValue: widget.seva['name'] ?? '',
                              decoration: InputDecoration(
                                labelText: "Seva Name",
                                border: OutlineInputBorder(),
                              ),
                              enabled: false,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                            ),
                            SizedBox(height: 16.h),

                            _buildSectionTitle("Devotee Details"),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Full Name",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                              validator: (v) => v?.trim().isEmpty ?? true
                                  ? "Full Name Required"
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Gotram",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Nakshatram",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Mobile Number(with country code)",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                              validator: (v) =>
                                  v?.length != 10 ? "Enter valid number" : null,
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email ID",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                              validator: (v) {
                                // 1. Check if the field is empty
                                if (v == null || v.isEmpty) {
                                  return "Email is required";
                                }
                                // 2. Regular Expression for email validation
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                // 3. Validate the input against the regex
                                if (!emailRegex.hasMatch(v)) {
                                  return "Enter a valid email address";
                                }
                                return null; // Return null if the input is valid
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Step 2: Scheduling + Sankalpam
                  Step(
                    title: TranslatedText("Schedule"),
                    content: Form(
                      key: _formKey2,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Seva Scheduling Details"),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Date (dd-mm-yyyy)",
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  setState(() => selectedDate = date);
                                }
                              },
                              controller: TextEditingController(
                                text: selectedDate == null
                                    ? ""
                                    : "${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year}",
                              ),
                            ),
                            SizedBox(height: 16.h),

                            _buildSectionTitle("Time Slot"),
                            DropdownButtonFormField<String>(
                              initialValue: selectedTimeSlot,
                              items: [
                                DropdownMenuItem(
                                  value: "Morning",
                                  child: TranslatedText(
                                    "Morning",
                                    style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Afternoon",
                                  child: TranslatedText(
                                    "Afternoon",
                                    style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Evening",
                                  child: TranslatedText(
                                    "Evening",
                                    style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => selectedTimeSlot = v),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(fontFamily: 'aBeeZee'),
                            ),
                            SizedBox(height: 16.h),

                            Column(
                              children: [
                                CheckboxListTile(
                                  title: TranslatedText("In Person"),
                                  value: inPerson,
                                  onChanged: (v) =>
                                      setState(() => inPerson = v ?? false),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                                CheckboxListTile(
                                  title: TranslatedText("Proxy (Priest)"),
                                  value: proxyPriest,
                                  onChanged: (v) =>
                                      setState(() => proxyPriest = v ?? false),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),
                            _buildSectionTitle("Sankalpam Details"),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Sankalpam Name",
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(fontFamily: 'aBeeZee'),
                            ),
                            SizedBox(height: 12.h),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Purpose/Prayer",
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                              style: TextStyle(fontFamily: 'aBeeZee'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Step 3: Prasadam + Payment
                  Step(
                    title: TranslatedText("Payment"),
                    content: Form(
                      key: _formKey3,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Prasadam & Delivery"),
                            RadioListTile<String>(
                              title: TranslatedText("In Person"),
                              value: "In person",
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              // ignore: deprecated_member_use
                              groupValue: selectedDelivery,
                              // ignore: deprecated_member_use
                              onChanged: (v) =>
                                  setState(() => selectedDelivery = v),
                            ),
                            RadioListTile<String>(
                              title: TranslatedText("Courier (Paid)"),
                              value: "Courier",
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              // ignore: deprecated_member_use
                              groupValue: selectedDelivery,
                              // ignore: deprecated_member_use
                              onChanged: (v) =>
                                  setState(() => selectedDelivery = v),
                            ),
                            if (selectedDelivery == "Courier") ...[
                              SizedBox(height: 12.h),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Your Address",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                style: TextStyle(fontFamily: 'aBeeZee'),
                              ),
                              SizedBox(height: 12.h),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Pincode",
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontFamily: 'aBeeZee'),
                              ),
                            ],

                            SizedBox(height: 24.h),
                            _buildSectionTitle("Payment Method"),
                            RadioListTile<String>(
                              title: TranslatedText("UPI"),
                              value: "UPI",
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              // ignore: deprecated_member_use
                              groupValue: selectedPayment,
                              // ignore: deprecated_member_use
                              onChanged: (v) =>
                                  setState(() => selectedPayment = v),
                            ),
                            RadioListTile<String>(
                              title: TranslatedText("Debit / Credit Card"),
                              value: "Card",
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              // ignore: deprecated_member_use
                              groupValue: selectedPayment,
                              // ignore: deprecated_member_use
                              onChanged: (v) =>
                                  setState(() => selectedPayment = v),
                            ),
                            RadioListTile<String>(
                              title: TranslatedText("Net Banking"),
                              value: "Net Banking",
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              // ignore: deprecated_member_use
                              groupValue: selectedPayment,
                              // ignore: deprecated_member_use
                              onChanged: (v) =>
                                  setState(() => selectedPayment = v),
                            ),

                            Divider(height: 40.h),
                            _buildPriceRow(
                              "Seva Amount",
                              "₹${widget.seva['price'] ?? 100}",
                            ),
                            if (selectedDelivery == "Courier")
                              _buildPriceRow("Courier Charge", "₹150"),
                            _buildPriceRow(
                              "Total",
                              "₹${(widget.seva['price'] ?? 100) + (selectedDelivery == "Courier" ? 150 : 0)}",
                              isBold: true,
                            ),

                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TranslatedText(
        title,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: Colors.deepOrange,
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TranslatedText(
            label,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 15.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          TranslatedText(
            amount,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? Colors.deepOrange : null,
            ),
          ),
        ],
      ),
    );
  }
}
