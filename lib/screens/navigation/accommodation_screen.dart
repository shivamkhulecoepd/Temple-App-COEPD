import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/language/language_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum AccommodationSection {
  accommodationBooking,
  pilgrimAmenities,
  howToReach,
  localServiceDirectory,
  volunteering,
}

class AccommodationScreen extends StatefulWidget {
  final AccommodationSection initialSection;

  const AccommodationScreen({super.key, required this.initialSection});

  @override
  _AccommodationScreenState createState() => _AccommodationScreenState();
}

class _AccommodationScreenState extends State<AccommodationScreen> {
  late AccommodationSection _currentSection;

  static const Map<String, dynamic> contactInfo = {
    "id": "1",
    "address":
        "Plot 6, Military Dairy Farm Road, Sai Nagar, Kanajiguda, Secunderabad - 5000",
    "phone1": "9550317277",
    "phone2": "9949060885",
    "email": "info@ganapathitemple.org",
    "map_embed":
        "<iframe src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3805.465338810557!2d78.49195257383163!3d17.485286299980125!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bcb9a93ed4c27cf%3A0x841315cfc51aa611!2sMarakatha%20Sri%20Lakshmi%20Ganapathi%20Temple!5e0!3m2!1sen!2sin!4v1766726802785!5m2!1sen!2sin\" width=\"600\" height=\"450\" style=\"border:0;\" allowfullscreen=\"\" loading=\"lazy\" referrerpolicy=\"no-referrer-when-downgrade\"></iframe>",
    "updated_at": "2025-12-27 11:50:29",
  };

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;
  }

  void _selectSection(AccommodationSection section) {
    setState(() => _currentSection = section);
    Navigator.pop(context);
  }

  // String get _title {
  //   switch (_currentSection) {
  //     case AccommodationSection.accommodationBooking:
  //       return 'Accommodation Booking';
  //     case AccommodationSection.pilgrimAmenities:
  //       return 'Pilgrim Amenities';
  //     case AccommodationSection.howToReach:
  //       return 'How to Reach';
  //     case AccommodationSection.localServiceDirectory:
  //       return 'Local Service Directory';
  //     case AccommodationSection.volunteering:
  //       return 'Volunteering';
  //   }
  // }

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
              'Temple Facilities',
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

  // ---------------- DRAWER ----------------
  Drawer _buildDrawer(ThemeData theme, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? theme.cardColor : null,
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
                'Temple Facilities',
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
            'Accommodation Booking',
            AccommodationSection.accommodationBooking,
            theme,
            isDark,
          ),
          _drawerItem(
            'Pilgrim Amenities',
            AccommodationSection.pilgrimAmenities,
            theme,
            isDark,
          ),
          _drawerItem(
            'How to Reach',
            AccommodationSection.howToReach,
            theme,
            isDark,
          ),
          _drawerItem(
            'Local Service Directory',
            AccommodationSection.localServiceDirectory,
            theme,
            isDark,
          ),
          _drawerItem(
            'Volunteering',
            AccommodationSection.volunteering,
            theme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    String title,
    AccommodationSection section,
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
      case AccommodationSection.accommodationBooking:
        return _accommodationBookingSection(theme, isDark);
      case AccommodationSection.pilgrimAmenities:
        return _pilgrimAmenitiesSection(theme, isDark);
      case AccommodationSection.howToReach:
        return _howToReachSection(theme, isDark);
      case AccommodationSection.localServiceDirectory:
        return _localServiceDirectorySection(theme, isDark);
      case AccommodationSection.volunteering:
        return _volunteeringSection(theme, isDark);
    }
  }

  // ---------------- SECTION UIs ----------------

  Widget _accommodationBookingSection(ThemeData theme, bool isDark) {
    final List<Map<String, dynamic>> accommodations = [
      {
        'title': 'Non AC Rooms',
        'desc': 'Simple rooms with basic facilities',
        'price': '₹500/Night',
        'image':
            'https://www.asenseinterior.com/assets/uploads/1a72a898a8e3ba146ceb7b1fccb39ff2.jpg',
      },
      {
        'title': 'AC Rooms',
        'desc': 'Comfortable AC Rooms for family',
        'price': '₹1200/Night',
        'image':
            'https://thumbs.dreamstime.com/b/simple-basic-hotel-room-wood-flooring-29782828.jpg',
      },
      {
        'title': 'Dormitory',
        'desc': 'Shared Accommodation for Groups',
        'price': '₹200/Night',
        'image':
            'https://q-xx.bstatic.com/xdata/images/hotel/max500/477241897.jpg?k=c1cd6c8cc9165213911c5e551a3fe0c7eba7048f46d0b886feee8aacc9d17211&o=',
      },
      {
        'title': 'Guest House',
        'desc': 'Spacious rooms with premium facilities',
        'price': '₹2500/Night',
        'image':
            'https://smartscalehousedesign.com/wp-content/uploads/2025/03/f744b1dc-8db7-4df7-bda1-d047ce9845f3.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Accommodation Booking',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          'Book your stay near the temple with comfortable accommodation options.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        Column(
          children: accommodations
              .map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: _buildAccommodationCard(
                    context,
                    title: item['title']!,
                    desc: item['desc']!,
                    price: item['price']!,
                    imageUrl: item['image']!,
                    theme: theme,
                    isDark: isDark,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _pilgrimAmenitiesSection(ThemeData theme, bool isDark) {
    final List<Map<String, dynamic>> amenities = [
      {
        'title': 'Lockers',
        'image':
            'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDI1LTA2L3NyLWltYWdlLTE4MDUyNS1iYWExMi1zLTA4NS5qcGc.jpg',
      },
      {
        'title': 'Food/Annadanam',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLTzK_7hGPMVE_l3Gfgmlu_GRSzsmK76ul9w&s',
      },
      {
        'title': 'Medical Aid',
        'image':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRimxzJKMVP-2CmOy_jzMwzhNoR57ONAkTQXw&s',
      },
      {
        'title': 'Toilets & Hygiene',
        'image':
            'https://housing.com/news/wp-content/uploads/2023/04/modular-bathroom-shutterstock_609094331-1200x700-compressed.jpg',
      },
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Pilgrim Amenities',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          'We offer drinking water, cloak rooms, resting halls, medical assistance, and more. Contact the office for special arrangements.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        _amenitiesCardSection(amenities, theme, isDark),
      ],
    );
  }

  Widget _howToReachSection(ThemeData theme, bool isDark) {
    // Extract coordinates from your map_embed (hardcoded for simplicity)
    const double templeLat = 17.485286;
    const double templeLng = 78.491953;

    // Build directions URL (opens Google Maps app with directions from current location)
    final Uri directionsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$templeLat,$templeLng&destination_place_id=ChIJzyfM7ZObOzoR4a6x1c8VGEiB&travelmode=driving',
    );

    // Alternative deeper URL for Android (google.navigation scheme)
    // final Uri directionsUri = Uri.parse('google.navigation:q=$templeLat,$templeLng');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'How to Reach',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          'Nearest railway station: Secunderabad. Nearest airport: Rajiv Gandhi Intl. Airport. Bus services available from the main junction. Detailed directions and maps can be provided on request.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Interactive Map Embed
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(directionsUri)) {
              await launchUrl(
                directionsUri,
                mode:
                    LaunchMode.externalApplication, // opens in Google Maps app
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: TranslatedText('Could not open Google Maps'),
                ),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: 240.h, // taller for better visibility
            decoration: BoxDecoration(
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
            clipBehavior: Clip.antiAlias,
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadHtmlString('''
                <!DOCTYPE html>
                <html>
                  <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                      body, html { margin:0; padding:0; height:100%; overflow:hidden; }
                      iframe { border:0; width:100%; height:100%; }
                    </style>
                  </head>
                  <body>
                    ${contactInfo['map_embed']}
                  </body>
                </html>
                '''),
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Optional: small hint text
        Center(
          child: TranslatedText(
            'Tap the map to get live directions',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 13.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),

        SizedBox(height: 24.h),

        _transportCard(
          'Train',
          'Nearest Railway Station: Secunderabad (8 km)',
          Icons.train,
          theme,
          isDark,
        ),
        SizedBox(height: 12.h),
        _transportCard(
          'Flight',
          'Nearest Airport: Rajiv Gandhi Intl. Airport (40 km)',
          Icons.flight,
          theme,
          isDark,
        ),
        SizedBox(height: 12.h),
        _transportCard(
          'Bus',
          'Bus Connectivity: Frequent buses from City Centre',
          Icons.directions_bus,
          theme,
          isDark,
        ),
      ],
    );
  }

  Widget _localServiceDirectorySection(ThemeData theme, bool isDark) {
    final List<Map<String, dynamic>> services = [
      {
        'title': 'Hotel Sri Residency',
        'type': 'Hotel',
        'contact': 'Contact: 9876543210',
        'icon': Icons.hotel,
      },
      {
        'title': 'ATM - State Bank',
        'type': 'Banking',
        'contact': 'Contact: Nearby',
        'icon': Icons.atm,
      },
      {
        'title': 'Medical Store',
        'type': 'Pharmacy',
        'contact': 'Contact: 9876543210',
        'icon': Icons.local_pharmacy,
      },
      {
        'title': 'Parking Area',
        'type': 'Facility',
        'contact': 'Contact: Temple ground',
        'icon': Icons.local_parking,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Local Service Directory',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          'Nearby hotels, travel agents, medical clinics, taxi services, ATMs, parking & more with contact details.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildServiceCard(
                context,
                title: service['title']!,
                type: service['type']!,
                contact: service['contact']!,
                icon: service['icon'] as IconData,
                theme: theme,
                isDark: isDark,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _volunteeringSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Volunteering',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          'Register as a volunteer and support temple service',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: _cardDecoration(theme, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTranslatedTextField('Full Name', theme, isDark),
              SizedBox(height: 16.h),
              _buildTranslatedTextField('Email', theme, isDark),
              SizedBox(height: 16.h),
              _buildTranslatedTextField('Mobile Number', theme, isDark),
              SizedBox(height: 16.h),
              _buildDropdownField(theme, isDark),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.volunteer_activism, size: 22),
                  label: TranslatedText(
                    'Submit Application',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTranslatedTextField(
    String labelText,
    ThemeData theme,
    bool isDark,
  ) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return FutureBuilder<String>(
          future: context.read<LanguageBloc>().getTranslation(labelText),
          builder: (context, snapshot) {
            String displayText = snapshot.data ?? labelText;
            return TextField(
              decoration: InputDecoration(
                labelText: displayText,
                labelStyle: TextStyle(color: theme.colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 2,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ---------------- COMMON WIDGETS ----------------

  Widget _buildAccommodationCard(
    BuildContext context, {
    required String title,
    required String desc,
    required String price,
    required String imageUrl,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      decoration: _cardDecoration(theme, isDark),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Large image header
            Container(
              height: 180.h,
              margin: EdgeInsets.only(left: 10.r, right: 10.r, top: 10.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  imageUrl,
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
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TranslatedText(
                    desc,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 15.sp,
                      height: 1.4,
                      color: isDark ? Colors.grey.shade300 : null,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TranslatedText(
                          price,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: TranslatedText(
                                  'Booking confirmed for $title',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.green,
                                action: SnackBarAction(
                                  label: 'Cancel',
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 22.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: TranslatedText(
                            'Book Now',
                            style: TextStyle(
                              fontFamily: 'ABeeZee',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amenitiesCardSection(
    List<Map<String, dynamic>> items,
    ThemeData theme,
    bool isDark,
  ) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: items.map((item) {
        return Container(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: _cardDecoration(theme, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    item['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 30.sp,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              TranslatedText(
                item['title'],
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : null,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _transportCard(
    String title,
    String description,
    IconData icon,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: _cardDecoration(theme, isDark),
      child: Row(
        children: [
          Icon(icon, size: 30, color: theme.colorScheme.secondary),
          SizedBox(width: 16.w),
          Expanded(
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
                SizedBox(height: 4.h),
                TranslatedText(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.grey.shade300 : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String type,
    required String contact,
    required IconData icon,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
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
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.3),
            radius: 28.r,
            child: Icon(icon, size: 28.sp, color: theme.colorScheme.secondary),
          ),
          title: TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              TranslatedText(
                type,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey.shade300 : null,
                ),
              ),
              const SizedBox(height: 4),
              TranslatedText(
                contact,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 15.sp,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18.sp,
            color: isDark ? Colors.white : null,
          ),
          onTap: () {
            // Optional: Open dialer, map, or details page
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField(ThemeData theme, bool isDark) {
    List<String> services = [
      'Food Service',
      'Guiding Service',
      'Medical Service',
      'Cleanliness Service',
    ];

    String? _selectedService;

    return DropdownButtonFormField<String>(
      initialValue: _selectedService,
      padding: EdgeInsets.only(left: 10.w),
      hint: TranslatedText(
        'Select Service',
        style: TextStyle(
          fontFamily: 'aBeeZee',
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
        ),
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
      ),
      style: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'aBeeZee',
        color: isDark ? Colors.white : Colors.black87,
      ),
      dropdownColor: theme.cardColor,
      isExpanded: true,
      onChanged: (String? newValue) {
        setState(() {
          _selectedService = newValue!;
        });
      },
      items: services
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: TranslatedText(
                value,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          )
          .toList(),
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
