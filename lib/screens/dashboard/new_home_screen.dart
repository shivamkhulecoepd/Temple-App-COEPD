import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/models/petal.model.dart';
import 'package:mslgd/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:mslgd/screens/navigation/accommodation_screen.dart';
import 'package:mslgd/screens/navigation/donation_prasadam_screen.dart';
import 'package:mslgd/screens/navigation/festivals_screen.dart';
import 'package:mslgd/screens/navigation/gallery_screen.dart';
import 'package:mslgd/screens/navigation/guide_screen.dart';
import 'package:mslgd/widgets/layout_screen.dart';
import 'package:mslgd/widgets/translated_text.dart';

class TempleHomeScreen extends StatefulWidget {
  const TempleHomeScreen({super.key});

  @override
  State<TempleHomeScreen> createState() => _TempleHomeScreenState();
}

class _TempleHomeScreenState extends State<TempleHomeScreen> {
  int _selectedIndex = 0;

  static const Color primaryOrange = Color(0xFFE07B2A);
  static const Color lightBg = Color(0xFFFDF6EE);

  // Hero Section Images
  final List<String> _heroImages = [
    'assets/images/dashboard/bg 2.webp',
    'assets/images/dashboard/bg2.jpg',
    'assets/images/dashboard/bg3.jpg',
  ];

  // Petal Logic
  final List<Petal> _petals = [];
  late Timer _petalSpawnTimer;
  late Timer _petalUpdateTimer;
  final List<String> _petalAssets = [
    "assets/images/dashboard/flower.png",
    "assets/images/dashboard/rose1.png",
    "assets/images/dashboard/rose3.png",
    "assets/images/dashboard/rose4.png",
  ];

  bool _isDisposed = false;
  // Image Transition Logic
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _imageTimer;

  void _spawnPetal() {
    if (_isDisposed || !mounted) return;
    final random = math.Random();
    if (mounted) {
      setState(() {
        _petals.add(
          Petal(
            image: _petalAssets[random.nextInt(_petalAssets.length)],
            top: -50, // Start above screen
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            size: random.nextDouble() * 12 + 12,
            speed: random.nextDouble() * 0.8 + 0.7, // Slower falling speed
            rotationSpeed: random.nextDouble() * 0.1,
            horizontalSway: random.nextDouble() * 2 - 1, // Slight drift
          ),
        );
      });
    }
  }

  void _updatePetals() {
    if (_isDisposed || !mounted) return;
    setState(() {
      for (var petal in _petals) {
        petal.top += petal.speed;
        petal.left += petal.horizontalSway;
        petal.rotation += petal.rotationSpeed;
      }
      // Remove petals that fall off the 250px height hero section (earlier removal for less density)
      _petals.removeWhere((p) => p?.top != null && p.top > 200);
    });
  }

  @override
  void initState() {
    super.initState();
    // 1. Image Change Timer
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_isDisposed || !mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _heroImages.length;
      });
    });

    // 2. Petal Spawner (Reduced frequency - every 600ms instead of 300ms)
    _petalSpawnTimer = Timer.periodic(const Duration(milliseconds: 600), (
      timer,
    ) {
      if (_isDisposed || !mounted) return;
      _spawnPetal();
    });

    // 3. Petal Physics Update (60 FPS)
    _petalUpdateTimer = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      if (_isDisposed || !mounted) return;
      _updatePetals();
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // Set flag first
    _timer?.cancel();
    _imageTimer?.cancel();
    _petalSpawnTimer.cancel();
    _petalUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'OCTOBER 24TH, 2023 | 8:30 AM',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Color(0xFF333333),
              ),
            ),
            Text(
              'Open: 6:00 AM - 9:00 PM',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          _iconButton(Icons.volume_up_outlined),
          _iconButton(Icons.language),
        ],
      ),
      body: Column(
        children: [
          // _buildTopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildHeroSection(),
                  _buildFestivalBanner(),
                  _buildQuickAccess(),
                  _buildLatestNewsTicker(),
                  _buildBookDarshan(),
                  _buildOnlineSevaAndDonation(),
                  // _buildSpiritualCorner(),
                  // _buildUpcomingEvents(),
                  _buildDailyWisdomCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'OCTOBER 24TH, 2023 | 8:30 AM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                'Open: 6:00 AM - 9:00 PM',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          _iconButton(Icons.volume_up_outlined),
          const SizedBox(width: 8),
          _iconButton(Icons.language),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryOrange,
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: primaryOrange, width: 1.5),
      ),
      child: Icon(icon, size: 16, color: primaryOrange),
    );
  }

  Widget _buildHeader() {
    return Container(
      // color: Colors.white,
      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.85),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/images/about/temple_logo.png',
              width: 200,
              // height: 80,
            ),
          ),
          const SizedBox(height: 12),
          TranslatedText(
            "Marakatha Sri Lakshmi",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TranslatedText(
            "Ganapathi Devasthanam",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TranslatedText(
            "Kanajiguda, Secunderabad, Telangana",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyWisdomCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: primaryOrange, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote, color: primaryOrange, size: 28),
          const SizedBox(height: 6),
          const Text(
            '"The mind is everything. What you think you become. May Lord Ganesha clear all obstacles from your path today."',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Color(0xFF333333),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '— DAILY WISDOM',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // Add circular border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        // Add ClipRRect to clip the content to rounded corners
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: Stack(
            children: [
              // 1. IMAGE TRANSITION (Ease-In Fade)
              // We use AnimatedSwitcher to swap between images with a cross-fade
              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 4500,
                ), // Adjust fade speed here
                switchInCurve:
                    Curves.easeIn, // <--- Your requested Ease-In animation
                // switchOutCurve: Curves.easeOut, // Smoothly remove the old image
                layoutBuilder:
                    (Widget? currentChild, List<Widget> previousChildren) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                child: Image.asset(
                  _heroImages[_currentIndex],
                  key: ValueKey<int>(
                    _currentIndex,
                  ), // Essential for the animation to trigger
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
              ),

              // 2. Falling Petals Layer (The script replication)
              ..._petals.map((petal) {
                return Positioned(
                  top: petal.top,
                  left: petal.left,
                  child: Transform.rotate(
                    angle: petal.rotation,
                    child: Image.asset(
                      petal.image,
                      width: petal.size,
                      height: petal.size,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFestivalBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB8860B), Color(0xFF5C3A00)],
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFD4AF37).withOpacity(0.4),
                    const Color(0xFF8B4513).withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                Icons.temple_hindu,
                size: 120,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryOrange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'UPCOMING FESTIVAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sankashti Chaturthi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Special Maha Pooja & Live Darshan',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Row(
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: i == 0 ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == 0 ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccess() {
    final items = [
      // {'icon': Icons.confirmation_number_outlined, 'label': 'Darshan'},
      // {'icon': Icons.volunteer_activism_outlined, 'label': 'Donations'},
      // {'icon': Icons.spa_outlined, 'label': 'Seva/Pooja'},
      // {'icon': Icons.play_circle_outline, 'label': 'Live Stream'},
      // {'icon': Icons.photo_library_outlined, 'label': 'Gallery'},
      // {'icon': Icons.shopping_bag_outlined, 'label': 'E-Shop'},
      // {'icon': Icons.shopping_bag_outlined, 'label': 'Accomodation'},
      // {'icon': Icons.shopping_bag_outlined, 'label': 'E-Shop'},
      {
        "icon": "assets/images/dashboard/DarshanBooking.png",
        "label": "Darshan Booking",
        // "route": SevaLiveDarshanScreen(),
        "route": LayoutScreen(index: 1),
      },
      {
        "icon": "assets/images/dashboard/Festivals.png",
        "label": "Festivals",
        "route": FestivalsScreen(),
      },
      {
        "icon": "assets/images/dashboard/Ehundi_Donations.png",
        "label": "E-Hundi",
        "route": DonationsPrasadamScreen(
          initialSection: DonationSection.eHundi,
        ),
      },
      {
        "icon": "assets/images/dashboard/double-bed.png",
        "label": "Accommodation",
        "route": AccommodationScreen(
          initialSection: AccommodationSection.accommodationBooking,
        ),
      },
      {
        "icon": "assets/images/dashboard/Livestraming.png",
        "label": "Live Stream",
        "route": SevaLiveDarshanScreen(),
      },
      {
        "icon": "assets/images/dashboard/eventcalander.png",
        "label": "Calendar",
        "route": FestivalsScreen(
          initialSection: FestivalsSection.annualFestivals,
        ),
      },
      {
        "icon": "assets/images/dashboard/Annadanam.png",
        "label": "Annadanam",
        "route": DonationsPrasadamScreen(
          initialSection: DonationSection.nityaAnna,
        ),
      },
      {
        "icon": "assets/images/dashboard/MediaGallery.png",
        "label": "Gallery",
        "route": GalleryScreen(),
      },
      {
        "icon": "assets/images/dashboard/VisitorsGuide.png",
        "label": "Guide",
        "route": GuideScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK ACCESS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
            children: items
                .map(
                  // (item) => _buildQuickAccessItem(
                  //   item['icon'] as IconData,
                  //   item['label'] as String,
                  // ),
                  (item) => _buildQuickAccessItem(
                    item['icon'] as String,
                    item['label'] as String,
                    item['route'] as Widget,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // Widget _buildQuickAccessItem(IconData icon, String label) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 6,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(icon, color: primaryOrange, size: 28),
  //         const SizedBox(height: 8),
  //         Text(
  //           label,
  //           style: const TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //             color: Color(0xFF333333),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildQuickAccessItem(String icon, String label, Widget route) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, color: primaryOrange, width: 36, height: 36),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestNewsTicker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active,
            color: primaryOrange,
            size: 16,
          ),
          const SizedBox(width: 6),
          const Text(
            'Latest News: ',
            style: TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Expanded(
            child: Text(
              'Temple will remain closed on Monday for maintenance...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookDarshan() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book Darshan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Skip the queue with online pre-booking.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryOrange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.confirmation_number_outlined,
            size: 70,
            color: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineSevaAndDonation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: _buildServiceCard(
              'Online Seva',
              'Sponsor a ritual in your name.',
              'Get Started →',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildServiceCard(
              'Donation',
              "Support the temple's charity works.",
              'Donate ♥',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String subtitle, String action) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            action,
            style: const TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpiritualCorner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SPIRITUAL CORNER',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Color(0xFF333333),
                ),
              ),
              Text(
                'VIEW ALL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    child: const Icon(
                      Icons.cookie_outlined,
                      size: 32,
                      color: Color(0xFFB8860B),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PRASADAM OF THE DAY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Modak & Sheera',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const Text(
                        'Traditional coconut modak and almond semolina pudding.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          height: 1.4,
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
    );
  }

  Widget _buildUpcomingEvents() {
    final events = [
      {
        'month': 'OCT',
        'day': '28',
        'name': 'Kojagiri Purnima',
        'sub': 'Night Celebration',
      },
      {
        'month': 'NOV',
        'day': '01',
        'name': 'Karwa Chauth',
        'sub': 'Morning Rituals',
      },
      {
        'month': 'NOV',
        'day': '12',
        'name': 'Diwali Pooja',
        'sub': 'Festival of Li...',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: events
            .map(
              (e) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e['month']!,
                        style: const TextStyle(
                          color: primaryOrange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        e['day']!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e['name']!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        e['sub']!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
