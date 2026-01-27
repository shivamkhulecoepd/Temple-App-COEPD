import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import 'package:mslgd/blocs/language/language_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/core/services/db_functions.dart';
import 'package:mslgd/models/petal.model.dart';
import 'package:mslgd/screens/authentication/auth_screen.dart';
import 'package:mslgd/screens/dashboard/contact_info_screen.dart';
import 'package:mslgd/screens/navigation/about_screen.dart';
import 'package:mslgd/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:mslgd/screens/navigation/accommodation_screen.dart';
import 'package:mslgd/screens/navigation/donation_prasadam_scree.dart';
import 'package:mslgd/screens/navigation/festivals_screen.dart';
import 'package:mslgd/screens/navigation/gallery_screen.dart';
import 'package:mslgd/screens/navigation/guide_screen.dart';
import 'package:mslgd/services/theme_service.dart';
import 'package:mslgd/widgets/common/gallery_widget.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/layout_screen.dart';
import 'package:mslgd/widgets/theme_toggle_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Image Transition Logic
  int _currentIndex = 0;
  Timer? _timer;
  Timer? _imageTimer;

  List<String> apiNews = [
    "Special Pooja at 6:00 PM",
    "New Seva Bookings Open",
    "Anniversary Celebrations coming soon!",
  ];

  final List<Map<String, String>> myBanners = [
    {
      'image':
          'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/29/7d/4e/42/birla-temple-from-outside.jpg?w=900&h=500&s=1',
      'title': 'Maha Shivaratri Celebrations',
      'description':
          'Join us for the grand evening Aarti and Prasad distribution.',
      'date': '10 Jan 2024, 5:34 PM',
    },
    {
      'image':
          'https://t4.ftcdn.net/jpg/04/52/13/29/360_F_452132945_BTyoGgK22zxk1uPCvGi8fsoHLUcSXj1q.jpg',
      'title': 'Annual Temple Fair',
      'description': 'A week-long celebration with cultural programs.',
      'date': '15 Jan 2024, 10:00 AM',
    },
    {
      'image':
          'https://cdn.britannica.com/67/269167-050-B4A8ED78/Hindu-priests-perform-Aarati-Maha-Shivratri-festival-shiva-Pashupatinath-Temple-Kathmandu-Nepal.jpg',
      'title': 'Evening Aarti Ritual',
      'description':
          'Experience the serene and devotional evening Aarti ceremony.',
      'date': '20 Jan 2026, 6:00 PM',
    },
    {
      'image':
          'https://www.baps.org/Data/Sites/1/Media/GalleryImages/29522/WebImages/MahaShivaratri_AbuDhabi_2024__18_.jpg',
      'title': 'Shivaratri Puja',
      'description': 'Special puja and celebrations honoring Lord Shiva.',
      'date': '08 Feb 2026, 7:00 PM',
    },
    {
      'image':
          'https://cdn.britannica.com/81/143381-050-FB55A78C/Ganga-Aarti-ritual-Hindu-Ganges-River-Uttar.jpg',
      'title': 'Grand Ganga Aarti',
      'description': 'Witness the mesmerizing Ganga Aarti by the river.',
      'date': '25 Jan 2026, 5:30 PM',
    },
    {
      'image':
          'https://www.tourmyindia.com/blog//wp-content/uploads/2016/03/Puri-Rath-Yatra-Odissa.jpg',
      'title': 'Temple Chariot Procession',
      'description':
          'Join the vibrant chariot festival with thousands of devotees.',
      'date': '02 Feb 2026, 9:00 AM',
    },
    {
      'image':
          'https://images.theconversation.com/files/642200/original/file-20250114-15-oucsvl.jpg?ixlib=rb-4.1.0&rect=367%2C12%2C3371%2C2245&q=50&auto=format&w=768&h=512&fit=crop&dpr=2',
      'title': 'Kumbh Mela Gathering',
      'description': 'Massive pilgrimage and fair at the holy confluence.',
      'date': '14 Jan 2026, All Day',
    },
    {
      'image':
          'https://htccwa.org/images/htcc/720x540/cultural-registration.jpg',
      'title': 'Cultural Dance Program',
      'description': 'Enjoy traditional dances and performances at the temple.',
      'date': '30 Jan 2026, 4:00 PM',
    },
    {
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/8/8c/Birla_Mandir%2C_Delhi%2C_views_at_night3.JPG',
      'title': 'Temple Illuminated at Night',
      'description': 'Beautiful night view of the temple during festivities.',
      'date': '05 Feb 2026, 7:00 PM',
    },
  ];

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

  // Swaying Animation Logic
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  // Time and Date variables
  late String _timeString;
  late Timer _clockTimer;

  // State variables for toggles
  bool _isMuted = true;

  // Static variables to persist data across widget recreations
  static bool _firstLoad = true;
  static List<String> _staticMarqueeNews = [];
  static List<Map<String, dynamic>> _staticBanners = [];
  static String _staticTimings = 'Loading...';

  // Local state variables (will be set from static in initState)
  List<String> marqueeNews = [];
  List<Map<String, dynamic>> banners = [];
  bool _isLoading = true;

  String timings = 'Loading...';

  void _spawnPetal() {
    final random = math.Random();
    if (mounted) {
      setState(() {
        _petals.add(
          Petal(
            image: _petalAssets[random.nextInt(_petalAssets.length)],
            top: -50, // Start above screen
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            size: random.nextDouble() * 25 + 20,
            speed: random.nextDouble() * 2 + 2, // Falling speed
            rotationSpeed: random.nextDouble() * 0.1,
            horizontalSway: random.nextDouble() * 2 - 1, // Slight drift
          ),
        );
      });
    }
  }

  void _updatePetals() {
    if (!mounted) return;
    setState(() {
      for (var petal in _petals) {
        petal.top += petal.speed;
        petal.left += petal.horizontalSway;
        petal.rotation += petal.rotationSpeed;
      }
      // Remove petals that fall off the 250px height hero section
      _petals.removeWhere((p) => p.top > 250);
    });
  }

  // Related with TopInfoBar
  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Requires intl package
    return DateFormat('EEEE, d MMMM yyyy - hh:mm a').format(dateTime);
  }

  String _formatEventDateTime(String? eventDateTimeStr) {
    if (eventDateTimeStr == null || eventDateTimeStr.isEmpty) {
      return 'Date not available';
    }

    try {
      // Parse the datetime string from API (format: "YYYY-MM-DD HH:MM:SS")
      DateTime eventDateTime = DateTime.parse(eventDateTimeStr);

      // Format it to a readable display format (e.g., "Jan 22, 2026, 9:53 AM")
      return DateFormat('MMM dd, yyyy, h:mm a').format(eventDateTime);
    } catch (e) {
      // If parsing fails, try different formats or return a default
      try {
        // Some APIs might send date in different formats
        // Try DD/MM/YYYY or MM/DD/YYYY format
        String formatted = eventDateTimeStr.replaceAll(RegExp(r'[\/]'), '-');
        DateTime eventDateTime = DateTime.parse(formatted);
        return DateFormat('MMM dd, yyyy, h:mm a').format(eventDateTime);
      } catch (e2) {
        // If all parsing fails, return a user-friendly message
        return 'Date not available';
      }
    }
  }

  // DB data
  Future<void> loadData() async {
    if (!mounted) return;
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await DBFunctions().fetchMarqueeAndBanners();
      if (mounted) {
        // Update static variables
        _staticMarqueeNews = List<String>.from(data['marquee_news'] ?? []);
        // Convert API banner format to the format expected by the UI
        final bannerData = data['banners'] ?? [];
        _staticBanners = (bannerData as List)
            .map(
              (banner) => {
                'image': banner['banner_image'],
                'title': banner['heading'],
                'description': banner['content'],
                'date': _formatEventDateTime(banner['event_datetime']),
              },
            )
            .cast<Map<String, dynamic>>()
            .toList();

        // Update local state from static
        setState(() {
          marqueeNews = _staticMarqueeNews;
          banners = _staticBanners;
          _isLoading = false;
        });
      }
      log(marqueeNews.toString());
      log(banners.toString());
    } catch (e) {
      log(e.toString());
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppSnackbar.error(context, 'Failed to load data: $e');
      }
    }
  }

  Future<void> loadTimings() async {
    try {
      final fetchedTimings = await DBFunctions().fetchTempleTimings();
      log("Fetched timings: $fetchedTimings");
      // Update static
      _staticTimings = fetchedTimings;
      if (mounted) {
        setState(() => timings = _staticTimings);
      }
    } catch (_) {
      log("Failed to load timings");
      // Update static
      _staticTimings = 'Timings unavailable';
      if (mounted) {
        setState(() => timings = _staticTimings);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Set local state from static variables
    setState(() {
      marqueeNews = _staticMarqueeNews;
      banners = _staticBanners;
      timings = _staticTimings;
      _isLoading = false;
    });

    // Load data only on first app open
    if (_firstLoad) {
      loadTimings();
      loadData();
      _firstLoad = false;
    }

    // 1. Image Change Timer
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % _heroImages.length;
      });
    });

    // 2. Petal Spawner (Every 300ms like your JS)
    _petalSpawnTimer = Timer.periodic(const Duration(milliseconds: 300), (
      timer,
    ) {
      if (!mounted) return;
      _spawnPetal();
    });

    // 3. Petal Physics Update (60 FPS)
    _petalUpdateTimer = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      if (!mounted) return;
      _updatePetals();
    });

    // 4. Setup Leaf Swaying Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 5. Initialize Clock
    _timeString = _formatDateTime(DateTime.now());
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _imageTimer?.cancel();
    _petalSpawnTimer.cancel();
    _petalUpdateTimer.cancel();
    _animationController.dispose();
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator.adaptive(
            color: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
              await loadTimings();
              await loadData();
              AppSnackbar.success(context, "Data updated Successfully !!!");
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopInfoBar(),
                  _buildHeader(),
                  _buildNavBar(),
                  _buildHeroSection(),
                  _buildQuickActionGrid(),
                  _buildAboutSection(),
                  _buildMarqueeBar(marqueeNews),
                  _isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        )
                      : _buildBannerSection(
                          banners.isNotEmpty ? banners : myBanners,
                        ),
                  GalleryWidget(title: 'Sri Devi Sharan Navratri 2025'),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopInfoBar() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: 15.h, left: 6.w, right: 6.w),
      child: Column(
        children: [
          // 0. Safe Area Height
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // 1. DATE AND TIME
          TranslatedText(
            _timeString,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 8.h),

          // 2. SOCIAL ICONS
          Row(
            spacing: 26.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(
                FontAwesomeIcons.instagram,
                "https://www.instagram.com/markatha_sri_laxmi_ganpathi/",
                Colors.pink.withValues(alpha: 0.7),
              ),
              _socialIcon(
                FontAwesomeIcons.facebook,
                "https://www.facebook.com/marakathaganapathi/",
                Colors.blue.withValues(alpha: 0.7),
              ),
              _socialIcon(
                FontAwesomeIcons.xTwitter,
                "https://x.com/mslgdt",
                Colors.blue,
              ),
              _socialIcon(
                FontAwesomeIcons.youtube,
                "https://www.youtube.com/@mslgdevasthanam",
                Colors.red,
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // 3. TEMPLE TIMING (with FutureBuilder)
          RichText(
            maxLines: 2,
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'aBeeZee',
                color: Colors.white,
                fontSize: 14.sp,
              ),
              children: [
                TextSpan(
                  text: "Timing: ",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: timings,
                  style: TextStyle(fontFamily: 'aBeeZee'),
                ),
              ],
            ),
          ),
          // SizedBox(height: 10.h),

          // 4. BOTTOM ACTION ROW (Horizontal scrollable on small screens)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sound/Mute Toggle
                IconButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _isMuted = !_isMuted);
                  },
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),

                SizedBox(width: 10.w),

                // Language Dropdown - now using BlocBuilder to get real state
                BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, state) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        // Use the actual selected language from bloc
                        value: state.selectedLanguageName,
                        dropdownColor: Theme.of(context).colorScheme.primary,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            HapticFeedback.selectionClick();
                            context.read<LanguageBloc>().add(
                              ChangeLanguage(newValue),
                            );
                            // Remove the setState call - bloc will handle the update
                            // setState(() => _selectedLanguage = newValue);
                          }
                        },
                        items:
                            <String>[
                              'English',
                              'Hindi',
                              'Telugu',
                              'Kannada',
                              'Tamil',
                              'Malayalam',
                              'Marathi',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: 'aBeeZee',
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    );
                  },
                ),

                SizedBox(width: 10.w),

                // Login Button
                TextButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => AuthScreen()),
                      (route) => route.isFirst,
                    );
                  },
                  child: TranslatedText(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: 6.w),

                // Contact Us Button
                TextButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ContactScreen()),
                    );
                  },
                  icon: Icon(Icons.phone, color: Colors.white, size: 16.sp),
                  label: TranslatedText(
                    "Contact",
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
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

  Widget _socialIcon(IconData icon, String url, Color? color) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          log("Could not launch $url");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Invalid link or no browser found"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: FaIcon(icon, color: color, size: 20.sp),
    );
  }

  // 1. HEADER SECTION
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [TempleTheme.gradientStart, TempleTheme.gradientEnd],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/dashboard/footer-logo.jpg',
          //   height: 70.h,
          //   fit: BoxFit.contain,
          // ),
          // const SizedBox(width: 10.w),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Marakatha Sri Lakshmi\nGanapathi Devalayam",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Kanajiguda, Secunderabad, Telangana",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          const ThemeToggleWidget(),
        ],
      ),
    );
  }

  // 2. NAV BAR
  Widget _buildNavBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardColor, // Updated to cardColor (more standard)
        border: Border(
          top: BorderSide(color: TempleTheme.primaryOrange, width: 4.h),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 15.w,
              children: [
                _navItem(Icons.home, "Home", null),
                _navItem(
                  Icons.temple_hindu,
                  "About Temple",
                  const AboutScreen(),
                ),
                _navItem(
                  Icons.currency_rupee,
                  "Sevaa and Darshan",
                  LayoutScreen(index: 2),
                  isReplacement: true,
                ),
              ],
            ),
            SizedBox(width: 20.w),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LayoutScreen(index: 1)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TempleTheme.primaryOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
                elevation: 4,
              ),
              child: TranslatedText(
                "Donate Now",
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    Widget? screen, {
    bool? isReplacement = false,
  }) {
    return GestureDetector(
      onTap: () {
        isReplacement!
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => screen!),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen!),
              );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TempleTheme.secondaryBlue,
            ),
            child: Icon(icon, size: 20.sp, color: Colors.white),
          ),
          SizedBox(height: 6.h),
          TranslatedText(
            label,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // 3. HERO SECTION (Stack)
  Widget _buildHeroSection() {
    return SizedBox(
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

          // 3. Left Swaying Leaf
          Positioned(
            bottom: -25,
            left: -40,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  // Pivot from bottom left
                  alignment: Alignment.bottomLeft,
                  angle: _rotationAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/dashboard/leaf_left.png',
                width: 120,
              ),
            ),
          ),

          // 4. Right Swaying Leaf
          Positioned(
            bottom: -25,
            right: -40,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  // Pivot from bottom right
                  alignment: Alignment.bottomRight,
                  // We use negative value to sway in the opposite direction
                  angle: -_rotationAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/dashboard/leaf-right.png',
                width: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. QUICK ACTION GRID
  Widget _buildQuickActionGrid() {
    final List<Map<String, dynamic>> items = [
      {
        "icon": "assets/images/dashboard/DarshanBooking.png",
        "label": "Darshan Booking",
        "route": SevaLiveDarshanScreen(),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 18.h,
          crossAxisSpacing: 18.w,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      items[index]['route'] ??
                      Scaffold(body: Center(child: Text("Coming Soon"))),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    // color: Theme.of(context).dividerTheme.color ?? Colors.grey,
                    color: Theme.of(context).dividerTheme.color ?? Colors.grey,
                    blurRadius: 1.r,
                    offset: Offset(1.w, 2.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Image.asset(items[index]['icon']!),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 8.h,
                    ),
                    child: TranslatedText(
                      items[index]['label']!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: 'aBeeZee',
                        fontSize: 12.sp,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 5. ABOUT SECTION
  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.w),
            child: Image.asset('assets/images/dashboard/gurujia.jpg'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Text(
              "Shri. Dr. M. Satyanarayan Shastriji\n(Founder and Administrator)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
          TranslatedText(
            "ABOUT MSLG DEVALAYAM",
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontWeight: FontWeight.bold,
              color: TempleTheme.primaryOrange,
              fontSize: 18.sp,
            ),
          ),
          TranslatedText(
            "Marakatha Sri Lakshmi Ganapathi Devalayam, located in Kanajiguda, Secunderabad, is a sacred temple dedicated to the rare and powerful emerald idol of Sri Lakshmi Ganapati Swamy. The divine Marakata (emerald) form is known to bestow wisdom, prosperity, clarity, and spiritual upliftment. Founded under the divine vision received by Dr. M. Satyanarayana Shastri, the temple stands on the ancient site of a historic stepwell where Sri Mahalakshmi once resided. Consecrated in 2016, the temple continues the rich tradition of Vedic rituals including Abhishekam, Homam, Suprabhata Seva, and Archana. Devotees experience deep peace and fulfillment through His darshan, and the unique practice of performing 16 Pradakshinas is believed to grant wishes and bring divine blessings.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  // 6. MARQUEE BAR
  Widget _buildMarqueeBar(List<String> newsItems) {
    final String marqueeText = newsItems.isNotEmpty
        ? "${newsItems.join("        •        ")}        "
        : "Getting latest updates...";

    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Heading
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 12.h, bottom: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.campaign,
                  color: TempleTheme.primaryOrange,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                TranslatedText(
                  "Temple News",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 2. Marquee Bar (The moving part)
          Container(
            height: 35.h,
            color: TempleTheme.primaryOrange.withValues(
              alpha: 0.1,
            ), // Light background for contrast
            child: Marquee(
              text: marqueeText,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                color: TempleTheme.primaryOrange,
                fontWeight: FontWeight.w500,
              ),
              velocity: 30.0.w,
              blankSpace: 60.0.w,
            ),
          ),

          // 3. View All Button
          InkWell(
            onTap: () {
              // Navigate to news page
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.62.w,
                    child: TranslatedText(
                      "View All News",
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 7. EVENT BANNERS
  Widget _buildBannerSection(List<Map<String, dynamic>> bannerData) {
    return Column(
      children: [
        // 1. Content/aSection header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Icon(Icons.event, color: TempleTheme.primaryOrange, size: 20.sp),
              SizedBox(width: 8.w),
              TranslatedText(
                "Current Event",
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // 2. Horizontal Scrollable Banners
        SizedBox(
          height: 280.h, // Fixed height to accommodate the white content area
          child: bannerData.isEmpty
              ? Container(
                  height: 280.h,
                  child: Center(
                    child: TranslatedText(
                      "No events available",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontFamily: 'aBeeZee',
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemCount: bannerData.length,
                  itemBuilder: (context, index) {
                    final item = bannerData[index];
                    return _buildBannerItem(item);
                  },
                ),
        ),

        // 3. View All Button Below
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: OutlinedButton(
            onPressed: () {
              // Handle view all navigation
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: TempleTheme.primaryOrange),
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
                    "View All Events",
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      color: TempleTheme.primaryOrange,
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
                  color: TempleTheme.primaryOrange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build individual banner item
  Widget _buildBannerItem(Map<String, dynamic> item) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8.w,
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: _buildBannerItemContent(item),
    );
  }

  // Helper method to build banner content
  Widget _buildBannerItemContent(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Part (Top)
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Image.network(
              item['image']!,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image),
              ),
            ),
          ),
        ),

        // Content Part (Bottom White BG)
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      item['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'aBeeZee',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    TranslatedText(
                      item['description']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        fontFamily: 'aBeeZee',
                      ),
                    ),
                  ],
                ),
                // Date Row
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 14.sp,
                      color: TempleTheme.primaryOrange,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      item['date']!,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
