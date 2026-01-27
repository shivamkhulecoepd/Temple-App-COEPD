import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:mslgd/screens/navigation/donation_prasadam_scree.dart';
import 'package:mslgd/screens/navigation/festivals_screen.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum GuideSection {
  howtoreach,
  pilgrimamenities,
  doesanddonts,
  localservicedirectory,
  emergencycontacts,
}

// ── TEMPORARY: In future → fetch from API / Bloc / Firebase ──
const Map<String, dynamic> contactInfo = {
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

class GuideScreen extends StatefulWidget {
  final GuideSection initialSection;

  const GuideScreen({super.key, this.initialSection = GuideSection.howtoreach});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  late GuideSection _currentSection;

  late final WebViewController _mapController;

  // Clean up iframe attributes that may cause issues in WebView
  String _getCleanMapHtml(String rawIframe) {
    // You can further sanitize if needed (remove width/height or override via CSS)
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body, html { margin:0; padding:0; height:100%; overflow:hidden; }
        iframe { width:100% !important; height:100% !important; border:0; }
      </style>
    </head>
    <body>
      $rawIframe
    </body>
    </html>
    ''';
  }

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;
    _mapController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_getCleanMapHtml(contactInfo['map_embed']));
  }

  void _selectSection(GuideSection section) {
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
              'Guide',
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
                      ? Colors.black.withValues(alpha: 0.8)
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
          _drawerItem('How to Reach', GuideSection.howtoreach, theme, isDark),
          _drawerItem(
            'Pimgrim Amenities',
            GuideSection.pilgrimamenities,
            theme,
            isDark,
          ),
          _drawerItem(
            'Do’s & Don’ts',
            GuideSection.doesanddonts,
            theme,
            isDark,
          ),
          _drawerItem(
            'Local Service Directory',
            GuideSection.localservicedirectory,
            theme,
            isDark,
          ),
          _drawerItem(
            'Emergency Contacts',
            GuideSection.emergencycontacts,
            theme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    String title,
    GuideSection section,
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
      case GuideSection.howtoreach:
        return _howToReachSection(theme, isDark);
      case GuideSection.pilgrimamenities:
        return _pilgrimAmenitiesSection(theme, isDark);
      case GuideSection.doesanddonts:
        return _doesAndDontsSection(theme, isDark);
      case GuideSection.localservicedirectory:
        return _localServiceDirectorySection(theme, isDark);
      case GuideSection.emergencycontacts:
        return _emergencyContactsSection(theme, isDark);
    }
  }

  // ── SECTIONS ──────────────────────────────────────────────────────────────

  Widget _howToReachSection(ThemeData theme, bool isDark) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'How to Reach',
          subtitle: 'Find the best routes to reach the temple',
          theme: theme,
          isDark: isDark,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            height: 240.h,
            child: WebViewWidget(controller: _mapController),
          ),
        ),
        _buildQuickActions(
          theme,
          isDark,
          false,
          Icons.food_bank,
          'Annaprasadam',
          'Contribute towards Annadanam and be a part of serving prasadam to devotees.',
          'Donate Now',
          DonationsPrasadamScreen(initialSection: DonationSection.nityaAnna),
        ),
        _buildQuickActions(
          theme,
          isDark,
          true,
          Icons.favorite,
          'Specific Donation',
          'Offer donations for specific temple services and sacred activities.',
          'Offer Donation',
          DonationsPrasadamScreen(
            initialSection: DonationSection.specificScheme,
          ),
        ),
        _buildQuickActions(
          theme,
          isDark,
          false,
          Icons.video_call,
          'Live Streaming',
          'Watch live temple sevas and special poojas from anywhere.',
          'Watch Live',
          SevaLiveDarshanScreen(),
        ),
        _buildQuickActions(
          theme,
          isDark,
          true,
          Icons.calendar_month,
          'Festival Calendar',
          'Stay updated with upcoming festivals, events, and special days.',
          'View Calendar',
          FestivalsScreen(initialSection: FestivalsSection.annualFestivals),
        ),
      ],
    );
  }

  Widget _buildQuickActions(
    ThemeData theme,
    bool isDark,
    bool isBorder,
    IconData icon,
    String title,
    String subtitle,
    String buttonText,
    Widget screen,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10.r),
        ],
        borderRadius: BorderRadius.circular(12.r),
        border: (isBorder && !isDark)
            ? Border.all(
                color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                width: 2.w,
              )
            : null,
      ),
      child: Column(
        spacing: 8.w,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  isDark
                      ? theme.colorScheme.primary.withValues(alpha: 0.7)
                      : theme.colorScheme.secondary.withValues(alpha: 0.7),
                  isDark
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary,
                ],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 36.sp),
          ),
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TranslatedText(
            subtitle,
            style: TextStyle(fontFamily: 'aBeeZee', fontSize: 16.sp),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => screen));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
            ),
            child: TranslatedText(
              buttonText,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pilgrimAmenitiesSection(ThemeData theme, bool isDark) {
    final List<Map<String, dynamic>> pilgrimAmenities = [
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
        _sectionHeader(
          title: 'Pilgrim Amenities',
          subtitle: 'Pilgrims guide for a smooth and convenient experience',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
        _amenitiesCard(pilgrimAmenities, theme, isDark),
      ],
    );
  }

  Widget _doesAndDontsSection(ThemeData theme, bool isDark) {
    List<Map<String, dynamic>> doesAndDonts = [
      {
        'title': 'Does ✅',
        'items': [
          'Follow temple dress code',
          'Maintain silence in the premises',
          'Respect the queue system',
        ],
      },
      {
        'title': 'Don\'t ❌',
        'items': [
          'No photography in sanctum',
          'No carrying prohibited items',
          'No littering inside temple',
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Do’s & Don’ts',
          subtitle: 'What to do or what to avoid for pilgrims',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 16.h),
        _buildDoesAndDontsCards(theme, isDark, doesAndDonts),
      ],
    );
  }

  Widget _localServiceDirectorySection(ThemeData theme, bool isDark) {
    final List<Map> localServiceDirectory = [
      {
        'title': 'Hotel Sri Residency',
        'category': 'Hotel',
        'locationUrl': 'https://www.google.com/maps',
      },
      {
        'title': 'ATM – State Bank',
        'category': 'Banking',
        'locationUrl': 'https://www.google.com/maps',
      },
      {
        'title': 'Medical Store',
        'category': 'Pharmacy',
        'locationUrl': 'https://www.google.com/maps',
      },
      {
        'title': 'Parking Area',
        'category': 'Facility',
        'locationUrl': 'https://www.google.com/maps',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Local Service Directory',
          subtitle: 'Discover local services for your convenience',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            for (var service in localServiceDirectory)
              localServiceDirectoryCard(theme, isDark, service),
          ],
        ),
      ],
    );
  }

  Widget _emergencyContactsSection(ThemeData theme, bool isDark) {
    final List<Map> emergencyContactList = [
      {
        'icon': Icons.emergency,
        'title': 'Ambulances',
        'contact': '+91 9635698620',
      },
      {
        'icon': Icons.local_police,
        'title': 'Police Station',
        'contact': '+91 9635698620',
      },
      {
        'icon': Icons.call,
        'title': 'Temple Helpline',
        'contact': '+91 9635698620',
      },
      {
        'icon': Icons.local_hospital,
        'title': 'Hospital',
        'contact': '+91 9635698620',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          title: 'Emergency Contacts',
          subtitle: 'Immediate Access to Key Contacts in Emergencies',
          theme: theme,
          isDark: isDark,
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            for (var contactInfo in emergencyContactList)
              emergencyContactCard(theme, isDark, contactInfo),
          ],
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

  Widget _amenitiesCard(
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

  Widget _buildDoesAndDontsCards(
    ThemeData theme,
    bool isDark,
    List<Map<String, dynamic>> doesAndDonts,
  ) {
    return Column(
      children: doesAndDonts.map((section) {
        bool isDoes = section['title'].toString().contains('Does');

        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            // Subtle green for Does, subtle red for Donts
            color: isDoes
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDoes
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header for the specific container
              TranslatedText(
                section['title'],
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: isDoes ? Colors.green : Colors.redAccent,
                ),
              ),
              Divider(
                color: isDoes
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
              ),
              SizedBox(height: 8.h),

              // Map the items inside this specific container
              ...(section['items'] as List<String>).map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isDoes
                            ? Icons.check_circle_outline
                            : Icons.highlight_off,
                        color: isDoes ? Colors.green : Colors.redAccent,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TranslatedText(
                          item,
                          style: TextStyle(fontFamily: 'aBeeZee', height: 1.4, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget localServiceDirectoryCard(ThemeData theme, bool isDark, Map data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(theme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            data['title'],
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          TranslatedText(
            data['category'],
            style: TextStyle(fontFamily: 'aBeeZee', fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TranslatedText(
                    'View on Map for :- ${data['title']}',
                  ),
                ),
              );
            },
            child: TranslatedText('View on Map'),
          ),
        ],
      ),
    );
  }

  Widget emergencyContactCard(ThemeData theme, bool isDark, Map data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: _cardDecoration(theme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10.w,
            children: [
              Icon(
                data['icon'],
                size: 24.r,
                color: theme.colorScheme.secondary,
              ),
              TranslatedText(
                data['title'],
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          TranslatedText(
            data['contact'],
            style: TextStyle(fontFamily: 'aBeeZee', fontSize: 14.sp),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: TranslatedText(
                    'View on Map for :- ${data['title']}',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0)
            ),
            child: TranslatedText('Call', style: TextStyle(fontFamily: 'aBeeZee',fontSize: 16.sp, fontWeight: FontWeight.bold),),
          ),
        ],
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
