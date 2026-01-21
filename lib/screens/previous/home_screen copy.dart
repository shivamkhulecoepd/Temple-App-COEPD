import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl: ^0.19.0 to pubspec.yaml

class TopInfoBar extends StatefulWidget {
  const TopInfoBar({super.key});

  @override
  State<TopInfoBar> createState() => _TopInfoBarState();
}

class _TopInfoBarState extends State<TopInfoBar> {
  // Time and Date variables
  late String _timeString;
  late Timer _clockTimer;

  // State variables for toggles
  bool _isMuted = true;
  String _selectedLanguage = 'English';

  // Simulated API data
  Future<String>? _templeTimingFuture;

  @override
  void initState() {
    super.initState();
    // Initialize Clock
    _timeString = _formatDateTime(DateTime.now());
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );

    // Initialize API fetch
    _templeTimingFuture = _fetchTempleTimings();
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

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

  Future<String> _fetchTempleTimings() async {
    // Simulate API Delay
    await Future.delayed(const Duration(seconds: 2));
    return "6:00 AM – 12:30 PM | 4:00 PM – 8:00 PM";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF00333D), // Dark teal from your image
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Column(
        children: [
          // 1. DATE AND TIME
          Text(
            _timeString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),

          // 2. SOCIAL ICONS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.camera_alt_outlined, "https://instagram.com"),
              const SizedBox(width: 15),
              _socialIcon(Icons.facebook, "https://facebook.com"),
              const SizedBox(width: 15),
              _socialIcon(Icons.close, "https://x.com"), // X icon placeholder
              const SizedBox(width: 15),
              _socialIcon(Icons.play_circle_outline, "https://youtube.com"),
            ],
          ),
          const SizedBox(height: 12),

          // 3. TEMPLE TIMING (with FutureBuilder for API simulation)
          FutureBuilder<String>(
            future: _templeTimingFuture,
            builder: (context, snapshot) {
              String timingText = "Temple Timing: Loading...";
              if (snapshot.hasData) {
                timingText = "Temple Timing: ${snapshot.data}";
              } else if (snapshot.hasError) {
                timingText = "Temple Timing: 6:00 AM – 8:00 PM (Fallback)";
              }

              return RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  children: [
                    const TextSpan(
                      text: "Temple Timing: ",
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: timingText.replaceAll("Temple Timing: ", ""),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 15),

          // 4. BOTTOM ACTION ROW
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: [
              // Sound/Mute Toggle
              IconButton(
                onPressed: () => setState(() => _isMuted = !_isMuted),
                icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                color: Colors.white,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),

              // Language Dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: const Color(0xFF00333D),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (String? newValue) {
                    if (newValue != null)
                      setState(() => _selectedLanguage = newValue);
                  },
                  items: <String>['English', 'Telugu', 'Hindi']
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      })
                      .toList(),
                ),
              ),

              // Login Button
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Login",
                  style: TextStyle(fontFamily: 'aBeeZee',color: Colors.white, fontSize: 14),
                ),
              ),

              // Contact Us Button
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Colors.white, size: 16),
                label: const Text(
                  "Contact Us",
                  style: TextStyle(fontFamily: 'aBeeZee',color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => print("Redirect to $url"),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   // Image Transition Logic
//   int _currentIndex = 0;
//   late Timer _timer;
//   Timer? _imageTimer;

//   final List<String> _heroImages = [
//     'assets/images/dashboard/bg 2.webp',
//     'assets/images/dashboard/bg2.jpg',
//     'assets/images/dashboard/bg3.jpg',
//   ];

//   // Swaying Animation Logic
//   late AnimationController _animationController;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();
//     // 1. Image Change Timer
//     _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % _heroImages.length;
//       });
//     });

//     // 2. Setup Leaf Swaying Animation
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);

//     _rotationAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _imageTimer?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFCF6EF),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // _buildHeader(),
//               _buildNavBar(),
//               _buildHeroSection(),
//               // _buildQuickActionGrid(),
//               // _buildAboutSection(),
//               // _buildMarqueeBar(),
//               // _buildEventBanners(),
//               // _buildGallerySection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 1. HEADER SECTION
//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.centerRight,
//           end: Alignment.centerLeft,
//           colors: [Color(0xFF990000), Color(0xFFE46600)],
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(
//             'assets/img/footer-logo.jpg',
//             height: 70,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(width: 10),
//           const Expanded(
//             child: Column(
//               children: [
//                 Text(
//                   "Marakatha Sri Lakshmi Ganapathi Devalayam",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'JainiPurva',
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   "Kanajiguda, Secunderabad, Telangana",
//                   style: TextStyle(
//                     fontFamily: 'Roboto',
//                     fontSize: 13,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 2. NAV BAR
//   Widget _buildNavBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: const BoxDecoration(
//         color: Color(0xFFFFF8F2),
//         border: Border(top: BorderSide(color: Color(0xFFE3340D), width: 4)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _navItem(Icons.home, "Home"),
//               const SizedBox(width: 15),
//               _navItem(Icons.temple_hindu, "About Temple"),
//               const SizedBox(width: 15),
//               _navItem(Icons.currency_rupee, "Donations"),
//             ],
//           ),
//           ElevatedButton(
//             onPressed: () {},
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFE65C23),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//             child: const Text(
//               "DONATE NOW",
//               style: TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _navItem(IconData icon, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 20, color: Colors.brown),
//         Text(label, style: const TextStyle(fontSize: 10, color: Colors.brown)),
//       ],
//     );
//   }

//   // 3. HERO SECTION (Stack)
//   Widget _buildHeroSection() {
//     return SizedBox(
//       height: 250,
//       child: Stack(
//         children: [
//           // 1. IMAGE TRANSITION (Ease-In Fade)
//           // We use AnimatedSwitcher to swap between images with a cross-fade
//           AnimatedSwitcher(
//             duration: const Duration(
//               milliseconds: 4500,
//             ), // Adjust fade speed here
//             switchInCurve:
//                 Curves.easeIn, // <--- Your requested Ease-In animation
//             // switchOutCurve: Curves.easeOut, // Smoothly remove the old image
//             layoutBuilder:
//                 (Widget? currentChild, List<Widget> previousChildren) {
//                   return Stack(
//                     alignment: Alignment.center,
//                     children: <Widget>[
//                       ...previousChildren,
//                       if (currentChild != null) currentChild,
//                     ],
//                   );
//                 },
//             child: Image.asset(
//               _heroImages[_currentIndex],
//               key: ValueKey<int>(
//                 _currentIndex,
//               ), // Essential for the animation to trigger
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 250,
//             ),
//           ),

//           // 2. Radial Glow Overlay
//           IgnorePointer(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   colors: [Colors.yellow.withValues(alpha: 0.2), Colors.transparent],
//                   radius: 0.8,
//                 ),
//               ),
//             ),
//           ),

//           // 3. Left Swaying Leaf
//           Positioned(
//             bottom: -25,
//             left: -40,
//             child: AnimatedBuilder(
//               animation: _rotationAnimation,
//               builder: (context, child) {
//                 return Transform.rotate(
//                   // Pivot from bottom left
//                   alignment: Alignment.bottomLeft,
//                   angle: _rotationAnimation.value,
//                   child: child,
//                 );
//               },
//               child: Image.asset(
//                 'assets/images/dashboard/leaf_left.png',
//                 width: 120,
//               ),
//             ),
//           ),

//           // 4. Right Swaying Leaf
//           Positioned(
//             bottom: -25,
//             right: -40,
//             child: AnimatedBuilder(
//               animation: _rotationAnimation,
//               builder: (context, child) {
//                 return Transform.rotate(
//                   // Pivot from bottom right
//                   alignment: Alignment.bottomRight,
//                   // We use negative value to sway in the opposite direction
//                   angle: -_rotationAnimation.value,
//                   child: child,
//                 );
//               },
//               child: Image.asset(
//                 'assets/images/dashboard/leaf-right.png',
//                 width: 120,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 4. QUICK ACTION GRID
//   Widget _buildQuickActionGrid() {
//     final List<Map<String, String>> items = [
//       {"icon": "assets  /img/DarshanBooking.png", "label": "Darshan Booking"},
//       {"icon": "assets/img/Festivals.png", "label": "Festivals"},
//       {"icon": "assets/img/Ehundi_Donations.png", "label": "E-Hundi"},
//       {"icon": "assets/img/double-bed.png", "label": "Accommodation"},
//       {"icon": "assets/img/Livestraming.png", "label": "Live Stream"},
//       {"icon": "assets/img/eventcalander.png", "label": "Calendar"},
//       {"icon": "assets/img/Annadanam.png", "label": "Annadanam"},
//       {"icon": "assets/img/MediaGallery.png", "label": "Gallery"},
//       {"icon": "assets/img/VisitorsGuide.png", "label": "Guide"},
//     ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 18,
//           crossAxisSpacing: 18,
//         ),
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           return Column(
//             children: [
//               Expanded(child: Image.asset(items[index]['icon']!)),
//               const SizedBox(height: 5),
//               Text(
//                 items[index]['label']!,
//                 style: const TextStyle(fontSize: 11),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // 5. ABOUT SECTION
//   Widget _buildAboutSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Image.asset('assets/img/gurujia.jpg'),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               "Shri. Dr. M. Satyanarayan Shastriji\n(Founder and Administrator)",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//           ),
//           const Text(
//             "ABOUT MSLG DEVALAYAM",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.orange,
//               fontSize: 18,
//             ),
//           ),
//           const Text(
//             "Marakatha Sri Lakshmi Ganapathi Devalayam, located in Kanajiguda...",
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   // 6. MARQUEE BAR
//   Widget _buildMarqueeBar() {
//     return Container(
//       color: Colors.orange.shade800,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: const Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Text(
//               "Temple News:",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Text(
//                 "Special Pooja at 6:00 PM • New Seva Bookings Open • Anniversary Celebrations coming soon! • ",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 7. EVENT BANNERS
//   Widget _buildEventBanners() {
//     return Container(
//       height: 120,
//       margin: const EdgeInsets.symmetric(vertical: 15),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 3,
//         itemBuilder: (context, index) => Container(
//           width: 300,
//           margin: const EdgeInsets.only(left: 15),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//           ),
//           child: Row(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(10),
//                   bottomLeft: Radius.circular(10),
//                 ),
//                 child: Image.asset(
//                   'assets/img/b1.jpg',
//                   width: 100,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Text(
//                     "Upcoming Festival Event Details",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 8. GALLERY SECTION
//   Widget _buildGallerySection() {
//     return Column(
//       children: [
//         const Text(
//           "Sri Devi Sharan Navratri 2025",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: Wrap(
//             spacing: 10,
//             runSpacing: 10,
//             children: [
//               _galleryImage('assets/img/b1.jpg'),
//               _galleryImage('assets/img/gallery4.jpg'),
//               _galleryImage('assets/img/b3.jpg'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _galleryImage(String path) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Image.asset(path, width: 100, height: 100, fit: BoxFit.cover),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:provider/provider.dart';
// // import 'package:temple_app/screens/dashboard/book_pooja.dart';
// // import 'package:temple_app/screens/dashboard/donation_screen.dart';
// // import 'package:temple_app/screens/dashboard/livedarshan_screen.dart';
// // import 'package:temple_app/screens/dashboard/panchangan_screen.dart';
// // import 'package:temple_app/screens/dashboard/prasadammenu_screen.dart';
// // import 'package:temple_app/screens/dashboard/templecalender_screen.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   void _navigateToLiveDarshan() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => LiveDarshanScreen()),
// //     );
// //   }

// //   void _navigateToLivebookpooja() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => BookPoojaScreen()),
// //     );
// //   }

// //   void _navigateToprasadamitems() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => PrasadamMenuScreen()),
// //     );
// //   }

// //   // TempleCalendarScreen(),
// //   void _navigatecalender() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => TempleCalendarScreen()),
// //     );
// //   }

// //   void _navigatedonation() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => DonationScreen()),
// //     );
// //   }

// //   void _navigatepanchangan() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(builder: (context) => PanchangamScreen()),
// //     );
// //   }

// //   List<ServiceItem> get _serviceItems => [
// //     ServiceItem(
// //       image: 'assets/images/tv.png',
// //       title: 'Daily Darshan',
// //       subtitle: 'Live temple view',
// //       ontap: _navigateToLiveDarshan,
// //     ),
// //     ServiceItem(
// //       image: 'assets/images/kalasha.png',
// //       title: 'Book Pooja',
// //       subtitle: 'Schedule a ritual',
// //       ontap: _navigateToLivebookpooja,
// //     ),
// //     ServiceItem(
// //       image: 'assets/images/kindness.png',
// //       title: 'Book Seva',
// //       subtitle: 'Offer a service',
// //     ),
// //     ServiceItem(
// //       image: 'assets/images/cutlery.png',
// //       title: 'Prasadam',
// //       subtitle: 'Order blessed food',
// //       ontap: _navigateToprasadamitems,
// //     ),
// //     ServiceItem(
// //       image: 'assets/images/donation.png',
// //       title: 'Donation',
// //       subtitle: 'Contribute to temple',
// //       ontap: _navigatedonation,
// //     ),
// //     ServiceItem(
// //       image: 'assets/images/calendar.png',
// //       title: 'Calendar',
// //       subtitle: 'Important dates',
// //       ontap: _navigatecalender,
// //     ),
// //     ServiceItem(
// //       image: 'assets/images/anahata.png',
// //       title: 'Panchangam',
// //       subtitle: 'Vedic almanac',
// //       ontap: _navigatepanchangan,
// //     ),
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color.fromARGB(
// //         255,
// //         214,
// //         210,
// //         210,
// //       ).withValues(alpha: 0.999),
// //       appBar: AppBar(
// //         backgroundColor: Colors.amberAccent.withValues(alpha: 0.4),
// //         foregroundColor: Color.fromARGB(255, 77, 7, 5),
// //         title: Text(
// //           'Deva Seva',
// //           style: TextStyle(
// //             fontSize: 20.sp,
// //             color: Color.fromARGB(255, 77, 7, 5),
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         elevation: 0,
// //         actions: [
// //           IconButton(
// //             icon: Icon(
// //               Icons.person_outline,
// //               size: 24.sp,
// //               color: Color.fromARGB(255, 77, 7, 5),
// //             ),
// //             onPressed: () {
// //               // Navigate to profile screen
// //             },
// //           ),
// //           SizedBox(width: 10.w),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.all(20.w),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               // Om Namah Shivay Text
// //               Center(
// //                 child: Text(
// //                   'Om Namah Shivaya',
// //                   style: TextStyle(
// //                     fontSize: 32.sp,
// //                     color: Color.fromARGB(255, 77, 7, 5),
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                   textAlign: TextAlign.center,
// //                 ),
// //               ),
// //               SizedBox(height: 30.h),
// //               // GridView of Service Items
// //               GridView.builder(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                   crossAxisCount: 2,
// //                   crossAxisSpacing: 16.w,
// //                   mainAxisSpacing: 16.h,
// //                   childAspectRatio: 0.9,
// //                 ),
// //                 itemCount: _serviceItems.length,
// //                 itemBuilder: (context, index) {
// //                   return _buildServiceCard(_serviceItems[index]);
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildServiceCard(ServiceItem item) {
// //     return GestureDetector(
// //       onTap: item.ontap,
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: const Color.fromARGB(255, 248, 239, 218),
// //           borderRadius: BorderRadius.circular(12),
// //           border: Border.all(color: Color.fromARGB(255, 187, 182, 182)),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.grey.withValues(alpha: 0.3),
// //               blurRadius: 10,
// //               spreadRadius: 2,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Padding(
// //           padding: EdgeInsets.all(16.h),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               // Image instead of Icon
// //               Image.asset(
// //                 item.image,
// //                 height: 40.h,
// //                 width: 40.w,
// //                 color: Color.fromARGB(255, 77, 7, 5), // You
// //               ),
// //               SizedBox(height: 12.h),
// //               // Title
// //               Text(
// //                 item.title,
// //                 style: TextStyle(
// //                   fontSize: 16.sp,
// //                   color: Color.fromARGB(255, 77, 7, 5),
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //                 textAlign: TextAlign.center,
// //                 maxLines: 1,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //               SizedBox(height: 6.h),
// //               // Subtitle
// //               Text(
// //                 item.subtitle,
// //                 style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
// //                 textAlign: TextAlign.center,
// //                 maxLines: 2,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class ServiceItem {
// //   final String image;
// //   final String title;
// //   final String subtitle;
// //   final VoidCallback? ontap;

// //   ServiceItem({
// //     required this.image,
// //     required this.title,
// //     required this.subtitle,
// //     this.ontap,
// //   });
// // }
