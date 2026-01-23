import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle, Uint8List;
import 'package:open_filex/open_filex.dart'; // optional

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/models/old_screen_models.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  /// Auth-style theme colors
  // final Color primaryOrange = const Color(0xFFF26B2C);
  final Color softGrey = const Color(0xFFF7F7F7);
  // final Color textDark = const Color(0xFF1C1C1C);
  final Color textMuted = const Color(0xFF7A7A7A);

  // ── Audio Player ───────────────────────────────────────────────
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isAudioInitialized = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Future<void> _initAudioPlayer() async {
    try {
      // Preload the audio (optional but recommended)
      await _audioPlayer.setSource(AssetSource('audio/mslg_song_3.mp3'));

      // Listen to player state changes
      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state == PlayerState.playing;
          });
        }
      });

      // Optional: track duration & position
      _audioPlayer.onDurationChanged.listen((d) {
        if (mounted) setState(() => _duration = d);
      });

      _audioPlayer.onPositionChanged.listen((p) {
        if (mounted) setState(() => _position = p);
      });

      _isAudioInitialized = true;
    } catch (e) {
      debugPrint('Audio initialization error: $e');
    }
  }

  Future<void> _togglePlayPause() async {
    if (!_isAudioInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TranslatedText('Audio not ready yet...')),
      );
      return;
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer
          .resume(); // or .play() if you want to restart from beginning
      // If you want to always start from beginning when pressing play:
      // await _audioPlayer.play(AssetSource('audio/mslg song 3.mp3'));
    }
  }

  // -------------------- Download PDF  -----------------------------------------

  bool _isPdfDownloading = false;

  Future<void> _handlePdfAction() async {
    setState(() => _isPdfDownloading = true);

    try {
      // Request storage permission (mainly Android)
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            _snack('Storage permission denied');
            return;
          }
        }
      }

      // Option A: View PDF inside app (recommended first step)
      // Uncomment to navigate to full-screen viewer
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) => const PdfViewerScreen()),
      // );

      // Option B: Save to device & optionally open in external viewer
      await _saveAndOpenPdf();

      _snack('PDF saved successfully!');
    } catch (e) {
      _snack('Error: ${e.toString()}');
      debugPrint('PDF error: $e');
    } finally {
      if (mounted) {
        setState(() => _isPdfDownloading = false);
      }
    }
  }

  Future<void> _saveAndOpenPdf() async {
    // Load from assets
    final byteData = await rootBundle.load('assets/pdfs/historical_notes.pdf');
    final Uint8List pdfBytes = byteData.buffer.asUint8List();

    // Get save location (Downloads or Documents)
    final directory =
        await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/historical_notes.pdf');

    // Save file
    await file.writeAsBytes(pdfBytes);

    // Optional: Open in external PDF viewer (Adobe, Google PDF, etc.)
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done) {
      _snack('Saved but cannot open automatically: ${result.message}');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PdfViewerScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : softGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: TranslatedText(
          'About Us',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontSize: 16.sp,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.foregroundColor,
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
          // Content
          Column(
            children: [
              _buildSectionSelector(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 5, // Changed to hardcoded count
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      _animationController.forward(from: 0);
                    });
                  },
                  itemBuilder: (_, i) => _buildSectionContent(
                    _getSectionByIndex(i),
                  ), // Changed to use helper method
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- TOP SECTION SELECTOR ----------------

  Widget _buildSectionSelector() {
    return Container(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Column(
        children: [
          SizedBox(
            height: 46.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount:
                  5, // Changed to hardcoded count since we removed the list
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final section = _getSectionByIndex(index);
                final isSelected = _currentIndex == index;

                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      // vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]
                          : softGrey,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          section.icon,
                          size: 18.sp,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : textMuted,
                        ),
                        SizedBox(width: 6.w),
                        TranslatedText(
                          // _getShortTitle(section.title),
                          (section.title),
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).brightness ==
                                      Brightness.dark
                                ? Colors.white70
                                : textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TranslatedText(
              _getSectionByIndex(_currentIndex).subtitle,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 13.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : textMuted,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get section by index without using the list
  TempleSection _getSectionByIndex(int index) {
    switch (index) {
      case 0:
        return TempleSection(
          id: 0,
          title: 'History & Legend',
          icon: Icons.history_rounded,
          color: const Color(0xFFD35400), // Orange
          subtitle:
              'A concise narrated history follows the founding of the temple, local legends, and important milestones.',
          timelineEvents: [
            TimelineEvent(
              year: '2017',
              title: 'Temple Founded',
              details:
                  'Founding and early years with traditional patronage. The temple was established with blessings from Dr. M. Satyanarayana Shastry Garu and support from local devotees.',
            ),
            TimelineEvent(
              year: '2019',
              title: 'Community Programs',
              details:
                  'Launch of annadanam (free food distribution) and education schemes for underprivileged children.',
            ),
            TimelineEvent(
              year: '2020',
              title: 'Major Renovation',
              details:
                  'Complete renovation of Gopuram (tower) and Mandapam (hall).',
            ),
          ],
          hasAudio: true,
          audioUrl: '',
          hasDownload: true,
          downloadUrl: '',
          content: '''
The Marakatha Sri Lakshmi Ganapathi Devalayam was established in 2017 under the divine guidance of Dr. M. Satyanarayana Shastry Garu. The temple follows strict Agamic traditions and Vedic rituals.

Visitors can explore the timeline and download scholarly notes.''',
        );
      case 1:
        return TempleSection(
          id: 1,
          title: 'Deities & Sub-Shrines',
          icon: Icons.temple_hindu_rounded,
          color: const Color(0xFF8E44AD), // Purple
          subtitle:
              'Details of the main deity, sub-shrines and important rituals.',
          timelineEvents: [
            TimelineEvent(
              year: 'Daily',
              title: 'Morning Pooja',
              details:
                  'Suprabhatam at 6 AM, followed by Abhishekam and Archana. Morning rituals conclude with Maha Naivedyam.',
            ),
            TimelineEvent(
              year: 'Weekly',
              title: 'Special Abhishekam',
              details:
                  'Friday: Sri Lakshmi Ganapathi special puja. Saturday: Sri Anjaneya Swamy homam. Sunday: Navagraha shanti puja.',
            ),
            TimelineEvent(
              year: 'Yearly',
              title: 'Brahmotsavam',
              details:
                  '10-day annual festival during Vinayaka Chaturthi with processions, cultural programs, and special rituals.',
            ),
          ],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content: '',
          deities: [
            Deity(
              name: 'Sri Laxmi Ganapathi',
              description:
                  'Main deity, guardian of prosperity and remover of obstacles',
              icon: '🕉️',
              imageUrl:
                  'assets/images/about/abt2.1.jpg', // Lakshmi Ganesh beautiful murti
            ),
            Deity(
              name: 'Sri Anjaneya Swamy',
              description: 'Protector and obstacle remover, south-facing deity',
              icon: '🐒',
              imageUrl:
                  'assets/images/about/abt2.2.jpg', // Classic Hanuman photo
            ),
            Deity(
              name: 'Sri Navagraha',
              description:
                  'Celestial influence and remedies for planetary positions',
              icon: '☀️',
              imageUrl: 'assets/images/about/abt2.3.jpg', // Navagraha realistic
            ),
          ],
        );
      case 2:
        return TempleSection(
          id: 2,
          title: 'Architecture & Sacred Places',
          icon: Icons.architecture_rounded,
          color: const Color(0xFF27AE60), // Green
          subtitle:
              'Photographs and descriptions highlight the Gopuram, Mandapam, Dwajasthambham and temple tank.',
          timelineEvents: [
            TimelineEvent(
              year: 'East',
              title: 'Main Gopuram',
              details:
                  '5-tier Rajagopuram built in Dravidian style with intricate sculptures depicting various deities.',
            ),
            TimelineEvent(
              year: 'Center',
              title: 'Maha Mandapam',
              details:
                  'Main hall with 16 pillars, each carved with different avataras of Lord Vishnu.',
            ),
            TimelineEvent(
              year: 'West',
              title: 'Temple Tank',
              details:
                  'Sacred pushkarini (water tank) used for ritual baths and theertham distribution.',
            ),
          ],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content:
              'Architectural notes explain the vastu consideration of the temple design.',
          images: [
            TempleImageInfo(
              url: 'assets/images/about/abt3.1.jpg',
              caption: 'Main Gopuram - South Indian style',
            ),
            TempleImageInfo(
              url: 'assets/images/about/abt3.2.jpg',
              caption: 'Virtual 360° Tour',
            ),
          ],
        );
      case 3:
        return TempleSection(
          id: 3,
          title: 'Temple Administration',
          icon: Icons.admin_panel_settings_rounded,
          color: const Color(0xFF2980B9), // Blue
          subtitle:
              'Details of the management, governance policies, and contact points for administrative queries.',
          timelineEvents: [
            TimelineEvent(
              year: '2017',
              title: 'Trust Formed',
              details:
                  'Initial trust board formation with 5 members under chairmanship of Dr. M. Satyanarayana Shastry.',
            ),
            TimelineEvent(
              year: '2019',
              title: 'Governance Charter',
              details:
                  'Formal governance policies and financial systems established.',
            ),
            TimelineEvent(
              year: '2022',
              title: 'Digital Transformation',
              details:
                  'Implementation of online donation systems and digital record keeping.',
            ),
          ],
          hasAudio: false,
          audioUrl: '',
          hasDownload: true,
          downloadUrl: '',
          content: '',
          trustees: [
            Trustee(
              name: 'Dr. M. Satyanarayana Shastry',
              position: 'Chairman & Chief Priest',
              contact: 'chairman@marakathatemple.org',
            ),
            Trustee(
              name: 'Sri R. Krishna Kumar',
              position: 'Managing Trustee',
              contact: 'trustee@marakathatemple.org',
            ),
            Trustee(
              name: 'Smt. Lakshmi Devi',
              position: 'Secretary',
              contact: 'secretary@marakathatemple.org',
            ),
            Trustee(
              name: 'Sri S. Rajagopal',
              position: 'Treasurer',
              contact: 'treasurer@marakathatemple.org',
            ),
            Trustee(
              name: 'Sri R. Krishna Kumar',
              position: 'Managing Trustee',
              contact: 'trustee@marakathatemple.org',
            ),
            Trustee(
              name: 'Dr. M. Satyanarayana Shastry',
              position: 'Chairman & Chief Priest',
              contact: 'chairman@marakathatemple.org',
            ),
          ],
        );
      case 4:
        return TempleSection(
          id: 4,
          title: 'About Dr. M Satyanarayana Shastry',
          icon: Icons.person_rounded,
          color: const Color(0xFFC0392B), // Red
          subtitle: 'Spiritual mentor and guiding force behind the temple.',
          timelineEvents: [
            TimelineEvent(
              year: '1975',
              title: 'Early Education',
              details:
                  'Born into traditional Vedic family, began Vedic studies at age 5.',
            ),
            TimelineEvent(
              year: '1995',
              title: 'Vedic Scholarship',
              details:
                  'Completed advanced studies in Vedas, Agamas, and Shastras.',
            ),
            TimelineEvent(
              year: '2017',
              title: 'Temple Foundation',
              details:
                  'Led establishment of Marakatha Sri Lakshmi Ganapathi Devalayam.',
            ),
          ],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content:
              'Dr. M. Satyanarayana Shastry Garu is a highly respected Vedic scholar, spiritual mentor, and steadfast upholder of Sanātana Dharma. With profound knowledge in Vedas, Agamas, and Shastras, he has dedicated his life to spiritual teaching, divine worship, and selfless service to society. He is the guiding force and spiritual inspiration behind the establishment of Marakatha Sri Lakshmi Ganapathi Devalayam, shaping it into a center of devotion, discipline, and dharmic values.',
          images: [
            TempleImageInfo(
              url: 'assets/images/dashboard/gurujia.jpg',
              title: 'Early Life & Education',
              caption:
                  'Born into a traditional Vedic family, Shastry Garu was immersed in spiritual learning from a young age. Under the guidance of eminent gurus, he received rigorous training in Vedic scriptures, Agamas, temple rituals, and sacred traditions. His deep scholarship, combined with strict spiritual discipline and daily sādhanā, laid a strong foundation for his lifelong commitment to Dharma and divine service.',
            ),
            TempleImageInfo(
              url: 'assets/images/about/bappanguru.png',
              title: 'Contribution to the Temple',
              caption:
                  'Dr. M. Satyanarayana Shastry Garu’s divine vision and leadership were instrumental in the conception and development of Marakatha Sri Lakshmi Ganapathi Devalayam. He guided every aspect of the temple—its Agamic architecture, ritual procedures, daily worship, festivals, and spiritual programs—ensuring strict adherence to Vedic and Agamic principles. Through his inspiration, the Devalayam has become not only a place of worship but also a vibrant spiritual and cultural center, nurturing devotion, tradition, and service among devotees.',
            ),
          ],
        );
      default:
        // Return the first section as default
        return TempleSection(
          id: 0,
          title: 'History & Legend',
          icon: Icons.history_rounded,
          color: const Color(0xFFD35400), // Orange
          subtitle:
              'A concise narrated history follows the founding of the temple, local legends, and important milestones.',
          timelineEvents: [],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content: 'Default content',
        );
    }
  }

  // ---------------- SECTION CONTENT WITH UNIQUE UI PER SECTION ----------------

  Widget _buildSectionContent(TempleSection section) {
    switch (section.id) {
      case 0: // History & Legend
        return _buildHistoryContent(section);
      case 1: // Deities & Sub-Shrines
        return _buildDeitiesContent(section);
      case 2: // Architecture & Sacred Places
        return _buildArchitectureContent(section);
      case 3: // Temple Administration
        return _buildAdministrationContent(section);
      case 4: // About Dr. M Satyanarayana Shastry
        return _buildScholarContent(section);
      default:
        return _buildDefaultContent(section);
    }
  }

  // Unique UI for History & Legend section
  Widget _buildHistoryContent(TempleSection section) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    section.color.withValues(alpha: 0.1),
                    section.color.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: section.color.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: section.color,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    'A journey through time and tradition',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            if (section.content.isNotEmpty)
              _buildAuthCard(
                child: TranslatedText(
                  section.content,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 14.sp,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            TranslatedText(
              'Historical Timeline',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.asMap().entries.map((entry) {
              TimelineEvent event = entry.value;
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: section.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: Center(
                        child: TranslatedText(
                          event.year,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]!.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.r),
                            bottomLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),
                          ),
                          border: Border.all(
                            color: section.color.withValues(alpha: 0.3),
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TranslatedText(
                              event.title,
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TranslatedText(
                              event.details,
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 12.sp,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white60
                                    : textMuted,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            if (section.hasAudio) _buildAudioCard(),
            if (section.hasDownload) _buildDownloadCard(),
          ],
        ),
      ),
    );
  }

  // Unique UI for Deities & Sub-Shrines section
  Widget _buildDeitiesContent(TempleSection section) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8E44AD).withValues(alpha: 0.1),
                    Color(0xFF9B59B6).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFF8E44AD).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    'Sacred forms of divinity',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            if (section.content.isNotEmpty)
              _buildAuthCard(
                child: TranslatedText(
                  section.content,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 14.sp,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            TranslatedText(
              'Sacred Deities',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: section.deities!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 3.0, // Wider cards for deity info
              ),
              itemBuilder: (_, i) {
                final deity = section.deities![i];
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]!.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFF8E44AD).withValues(alpha: 0.3),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Show deity image if available, otherwise show the icon
                      if (deity.imageUrl != null && deity.imageUrl!.isNotEmpty)
                        Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF8E44AD).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              bottomLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                            image: DecorationImage(
                              image: AssetImage(deity.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF8E44AD).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              bottomLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Color(0xFF8E44AD),
                            ),
                          ),
                        ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TranslatedText(
                                deity.name,
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              TranslatedText(
                                deity.description,
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 12.sp,
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white60
                                      : textMuted,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            TranslatedText(
              'Daily Rituals',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.map(
              (event) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFF8E44AD).withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF8E44AD).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Color(0xFF8E44AD),
                              width: 1.w,
                            ),
                          ),
                          child: TranslatedText(
                            event.year,
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              color: Color(0xFF8E44AD),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        TranslatedText(
                          event.title,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TranslatedText(
                      event.details,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white60
                            : textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Unique UI for Architecture & Sacred Places section
  Widget _buildArchitectureContent(TempleSection section) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF27AE60).withValues(alpha: 0.1),
                    Color(0xFF2ECC71).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFF27AE60).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    'Sacred architecture and spiritual spaces',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            if (section.content.isNotEmpty)
              _buildAuthCard(
                child: TranslatedText(
                  section.content,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 14.sp,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

            // Show images if available
            if (section.images != null && section.images!.isNotEmpty) ...[
              TranslatedText(
                'Architectural Highlights',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              ...section.images!.map(
                (imageInfo) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]!.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFF27AE60).withValues(alpha: 0.3),
                      width: 1.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 180.h,
                          decoration: BoxDecoration(
                            // image: DecorationImage(
                            //   image: NetworkImage(imageInfo.url),
                            //   fit: BoxFit.cover,
                            // ),
                            image: DecorationImage(
                              image: AssetImage(imageInfo.url),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: TranslatedText(
                            imageInfo.caption,
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            SizedBox(height: 16.h),
            TranslatedText(
              'Architectural Features',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.map(
              (feature) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFF27AE60).withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Color(0xFF27AE60),
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        TranslatedText(
                          feature.title,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    subtitle: TranslatedText(
                      feature.year,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 12.sp,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: TranslatedText(
                          feature.details,
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 13.sp,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white60
                                : textMuted,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (section.hasDownload) _buildDownloadCard(),
          ],
        ),
      ),
    );
  }

  // Unique UI for Temple Administration section
  Widget _buildAdministrationContent(TempleSection section) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2980B9).withValues(alpha: 0.1),
                    Color(0xFF3498DB).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFF2980B9).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    'Management and governance',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            if (section.content.isNotEmpty)
              _buildAuthCard(
                child: TranslatedText(
                  section.content,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 14.sp,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

            SizedBox(height: 16.h),
            TranslatedText(
              'Trust Board Members',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.trustees!.map(
              (trustee) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFF2980B9).withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF2980B9).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2980B9), width: 1.w),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF2980B9),
                      size: 24.sp,
                    ),
                  ),
                  title: TranslatedText(
                    trustee.name,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  subtitle: TranslatedText(
                    trustee.position,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 12.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white60
                          : textMuted,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Unique UI for About Dr. M Satyanarayana Shastry section
  Widget _buildScholarContent(TempleSection section) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFC0392B).withValues(alpha: 0.1),
                    Color(0xFFE74C3C).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFFC0392B).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC0392B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    'Spiritual mentor and guiding force',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (section.content.isNotEmpty)
              _buildAuthCard(
                child: TranslatedText(
                  section.content,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 14.sp,
                    height: 1.6,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

            // Show images if available
            if (section.images != null && section.images!.isNotEmpty) ...[
              ...section.images!.map(
                (imageInfo) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]!.withValues(alpha: 0.7)
                        : Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFFC0392B).withValues(alpha: 0.3),
                      width: 1.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150.h,
                          decoration: BoxDecoration(
                            // image: DecorationImage(
                            //   image: NetworkImage(imageInfo.url),
                            //   fit: BoxFit.cover,
                            // ),
                            image: DecorationImage(
                              image: AssetImage(imageInfo.url),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            spacing: 10.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TranslatedText(
                                imageInfo.title!,
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFC0392B),
                                ),
                              ),

                              TranslatedText(
                                imageInfo.caption,
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ] else ...[
              Container(
                width: 100.w,
                height: 100.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Color(0xFFC0392B).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFC0392B), width: 2.w),
                ),
                child: Icon(
                  Icons.person,
                  size: 50.sp,
                  color: Color(0xFFC0392B),
                ),
              ),
              SizedBox(height: 16.h),
            ],

            SizedBox(height: 16.h),
            TranslatedText(
              'Academic Journey',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.map(
              (milestone) => Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFFC0392B).withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFC0392B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Color(0xFFC0392B),
                          width: 1.w,
                        ),
                      ),
                      child: TranslatedText(
                        milestone.year,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          color: Color(0xFFC0392B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TranslatedText(
                      milestone.title,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    TranslatedText(
                      milestone.details,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white60
                            : textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Default content for any other sections
  Widget _buildDefaultContent(TempleSection section) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatedText(
              section.title,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            _buildAuthCard(
              child: TranslatedText(
                section.content,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 14.sp,
                  height: 1.6,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            if (section.deities != null) _buildDeitiesGrid(section.deities!),
            if (section.trustees != null) _buildTrusteesList(section.trustees!),

            if (section.hasAudio) _buildAudioCard(),
            if (section.hasDownload) _buildDownloadCard(),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  // ---------------- COMMON AUTH STYLE CARD ----------------

  Widget _buildAuthCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]!.withValues(alpha: 0.6)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ---------------- DEITIES GRID FOR DEFAULT CONTENT ----------------

  Widget _buildDeitiesGrid(List<Deity> deities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Deities',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: deities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (_, i) {
            final d = deities[i];
            return _buildAuthCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TranslatedText(
                    d.icon,
                    style: TextStyle(fontFamily: 'aBeeZee', fontSize: 30.sp),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    d.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TranslatedText(
                    d.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 11.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : textMuted,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------- TRUSTEES LIST FOR DEFAULT CONTENT ----------------

  Widget _buildTrusteesList(List<Trustee> trustees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Trust Board',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        ...trustees.map(
          (t) => _buildAuthCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]
                    : softGrey,
                child: const Icon(Icons.person),
              ),
              title: TranslatedText(
                t.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: TranslatedText(t.position),
              trailing: IconButton(
                icon: const Icon(Icons.email),
                onPressed: () => _sendEmail(t.contact),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- AUDIO / DOWNLOAD CARDS ----------------
  // ── Updated Audio Card ─────────────────────────────────────────
  Widget _buildAudioCard() {
    return _buildAuthCard(
      child: Column(
        children: [
          ElevatedButton.icon(
            style: _primaryButtonStyle(),
            onPressed: _togglePlayPause,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: TranslatedText(_isPlaying ? 'Pause Audio' : 'Play Audio'),
          ),

          // Optional: simple progress bar
          if (_duration != Duration.zero) ...[
            SizedBox(height: 12.h),
            Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer.seek(position);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TranslatedText(_formatDuration(_position)),
                  TranslatedText(_formatDuration(_duration)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildDownloadCard() {
    return _buildAuthCard(
      child: ElevatedButton.icon(
        style: _primaryButtonStyle(),
        onPressed: _isPdfDownloading ? null : _handlePdfAction,
        icon: _isPdfDownloading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Icon(Icons.download),
        label: TranslatedText(
          _isPdfDownloading ? 'Processing...' : 'Download Historical Notes',
        ),
      ),
    );
  }

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      minimumSize: Size(double.infinity, 48.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }

  // ---------------- ACTIONS ----------------

  void _snack(String msg) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: TranslatedText(msg)));

  void _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TranslatedText('Historical Notes')),
      body: SfPdfViewer.asset(
        'assets/pdfs/historical_notes.pdf',
        canShowPaginationDialog: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
