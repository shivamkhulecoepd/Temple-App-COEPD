import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle, Uint8List;
import 'package:open_filex/open_filex.dart'; // optional
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mslgd/models/temple.model.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';

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
      AppSnackbar.info(
        context,
        'Audio not ready yet...\nPlease wait for a second...',
      );
      return;
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer
          .resume(); // or .play() if you want to restart from beginning
      // If you want to always start from beginning when pressing play:
      // await _audioPlayer.play(AssetSource('audio/mslg_song_3.mp3'));
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
            // _snack('Storage permission denied');
            AppSnackbar.error(context, 'Storage permission denied');
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
    } catch (e) {
      // _snack('Error: ${e.toString()}');
      AppSnackbar.error(context, 'Error: ${e.toString()}');
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
      // _snack('Saved but cannot open automatically: ${result.message}');
      AppSnackbar.warning(
        context,
        'Saved but cannot open automatically: ${result.message}',
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PdfViewerScreen()),
    );
  }

  Future<void> _handleShareOnWhatsAppAction() async {
    launchUrl(
      Uri.parse(
        'https://wa.me/?text=Download%20the%20Historical%20Notes%20PDF:%20https://marakatasrilaxmiganapathi.org/assets/pdf/Temple_history.pdf',
      ),
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
    try {
      _audioPlayer.stop();
      _audioPlayer.dispose();
    } catch (e) {
      debugPrint('Error disposing audio player: $e');
    }
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
          style: TextStyle(fontFamily: 'aBeeZee'),
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
                  itemCount: 6, // Changed to hardcoded count
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
                  6, // Changed to hardcoded count since we removed the list
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
              year: '1',
              title: 'Sacred Origins ~200 Years Ago',
              details:
                  'The site was once agricultural land with a sacred step-well containing Goddess Mahalakshmi. Farmers worshipped Her annually during Deepavali for health and prosperity..',
            ),
            TimelineEvent(
              year: '2',
              title: 'Divine Vision & Temple Construction 2016',
              details:
                  'Following a divine vision of Goddess Lalita Parameswari to Sri Satyanarayana Shastri Garu, the temple was constructed at this holy site and the idol was consecrated by a revered Peethadhipati.',
            ),
            TimelineEvent(
              year: '3',
              title: 'Spiritual Significance Present Day',
              details:
                  'Devotees perform 16 and 108 pradakshinas, Abhishekam, and Homam for wish fulfillment. Worship here is believed to reduce planetary afflictions and bring success, prosperity, marriage blessings, career growth, and spiritual merit.',
            ),
          ],
          hasAudio: true,
          audioUrl: '',
          hasDownload: true,
          hasWhatsApp: true,
          downloadUrl: '',
          content: '''
Marakata Lakshmi Ganapati Temple, Kanajiguda, Secunderabad, is a rare and sacred shrine housing the divine Emerald (Marakata) Lakshmi Ganapati along with Navagrahas with their consorts and vehicles. The deity represents Omkara, removes obstacles, and grants prosperity, wisdom, and spiritual upliftment.''',
        );
      case 1:
        return TempleSection(
          id: 1,
          title: 'Sacred Narrative & Significance',
          icon: Icons.book_rounded,
          color: const Color(0xFF9B59B6), // Purple
          subtitle:
              'The divine story of Sri Lakshmi Ganapati and the sacred significance of worship.',
          timelineEvents: [
            TimelineEvent(
              year: 'The Curse of Sage Durvasa',
              title:
                  'Sage Durvasa received a divine Parijata garland from Lord Vishnu and later offered it to Indra. Due to pride, Indra disrespected the sacred garland, leading to Durvasa’s curse that the gods would lose their power and prosperity.',
              details: '',
            ),
            TimelineEvent(
              year: 'Divine Guidance',
              title:
                  'The gods prayed to Lord Vishnu, who advised them to worship Lord Ganapati — the Supreme Primordial Form — to regain strength and fortune.',
              details: '',
            ),
            TimelineEvent(
              year: 'Churning of the Ocean',
              title:
                  'During the churning of the Milk Ocean, many divine treasures emerged, including Kamadhenu, Kalpavriksha, Airavata, the Moon, Halahala poison, and Dhanvantari with nectar. Finally, Goddess Mahalakshmi manifested in divine glory.',
              details: '',
            ),
            TimelineEvent(
              year: 'Manifestation of Lakshmi Ganapati',
              title:
                  'From Mahalakshmi’s divine essence, one aspect united with Mahavishnu and another empowered Maha Ganapati, who manifested as Sri Lakshmi Ganapati — the embodiment of prosperity and cosmic energy.',
              details: '',
            ),
          ],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content:
              'This sacred narrative reveals the divine grace of Sri Lakshmi Ganapati, the primordial remover of obstacles and bestower of prosperity.',
        );
      case 2:
        return TempleSection(
          id: 2,
          title: 'Deities & Sub-Shrines',
          icon: Icons.temple_hindu_rounded,
          color: const Color(0xFF8E44AD), // Purple
          subtitle:
              'Details of the main deity, sub-shrines and important rituals.',
          timelineEvents: [
            TimelineEvent(
              year:
                  'https://marakatasrilaxmiganapathi.org/assets/img/navagrahallu.jpeg',
              title: 'Sri Navgrahallu',
              details: 'Celestial influence and remedies',
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
              description: 'Main deity, guardian of prosperity',
              imageUrl:
                  'https://marakatasrilaxmiganapathi.org/assets/img/mslgidol1.jpeg', // Lakshmi Ganesh beautiful murti
            ),
            Deity(
              name: 'Lakshmi',
              description: 'Invoke the grace of Maa Laxmi Devi',
              imageUrl:
                  'https://marakatasrilaxmiganapathi.org/assets/img/laxmi.jpeg', // Classic Hanuman photo
            ),
            Deity(
              name: 'Sivalingam',
              description: 'Where devotion meets divinity',
              imageUrl:
                  'https://marakatasrilaxmiganapathi.org/assets/img/shivalingam.jpeg', // Navagraha realistic
            ),
          ],
        );
      case 3:
        return TempleSection(
          id: 3,
          title: 'Architecture & Sacred Places',
          icon: Icons.architecture_rounded,
          color: const Color(0xFF27AE60), // Green
          subtitle:
              'Photographs and descriptions highlight the Gopuram, Mandapam, Dwajasthambham and temple tank.',
          timelineEvents: [],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content:
              'Photographs and descriptions highlight the Gopuram, Mandapam, Dwajasthambham and temple tank. Architectural notes explain you vastu consideration.',
          images: [
            TempleImageInfo(
              url:
                  'https://marakatasrilaxmiganapathi.org/assets/img/templepic2.jpeg',
              caption: 'Main Gopuram',
            ),
            TempleImageInfo(
              url:
                  'https://marakatasrilaxmiganapathi.org/assets/img/templepic1.jpeg',
              caption: 'Temple Architecture',
            ),
          ],
        );
      case 4:
        return TempleSection(
          id: 4,
          title: 'Temple Administration',
          icon: Icons.admin_panel_settings_rounded,
          color: const Color(0xFF2980B9), // Blue
          subtitle:
              'Details of the management, governance policies, and contact points for administrative queries.',
          timelineEvents: [],
          hasAudio: false,
          audioUrl: '',
          hasDownload: true,
          downloadUrl: '',
          content: '',
          trustees: [
            Trustee(
              name: 'Dr. Mothkuru Sathyanarayana Shastri',
              position: 'Founder and Chairman ',
              contact: 'chairman@marakathatemple.org',
            ),
            Trustee(
              name: 'Mothkuru Aramjyothi',
              position: 'Treasurer',
              contact: 'trustee@marakathatemple.org',
            ),
            Trustee(
              name: 'Dr. Mothkuru Sriyah Koumudi',
              position: 'Trustee',
              contact: 'secretary@marakathatemple.org',
            ),
          ],
        );
      case 5:
        return TempleSection(
          id: 5,
          title: 'About Dr. M Satyanarayana Shastry',
          icon: Icons.person_rounded,
          color: const Color(0xFFC0392B), // Red
          subtitle: 'Spiritual mentor and guiding force behind the temple.',
          timelineEvents: [],
          hasAudio: false,
          audioUrl: '',
          hasDownload: false,
          downloadUrl: '',
          content:
              'Dr. M. Satyanarayana Shastry Garu is a highly respected Vedic scholar, spiritual mentor, and steadfast upholder of Sanātana Dharma. With profound knowledge in Vedas, Agamas, and Shastras, he has dedicated his life to spiritual teaching, divine worship, and selfless service to society. He is the guiding force and spiritual inspiration behind the establishment of Marakatha Sri Lakshmi Ganapathi Devasthanam, shaping it into a center of devotion, discipline, and dharmic values.',
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
                  'Dr. M. Satyanarayana Shastry Garu’s divine vision and leadership were instrumental in the conception and development of Marakatha Sri Lakshmi Ganapathi Devasthanam. He guided every aspect of the temple—its Agamic architecture, ritual procedures, daily worship, festivals, and spiritual programs—ensuring strict adherence to Vedic and Agamic principles. Through his inspiration, the Devasthanam has become not only a place of worship but also a vibrant spiritual and cultural center, nurturing devotion, tradition, and service among devotees.',
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
      case 1: // Sacred Narrative & Significance
        return _buildSacredNarrativeContent(section);
      case 2: // Deities & Sub-Shrines
        return _buildDeitiesContent(section);
      case 3: // Architecture & Sacred Places
        return _buildArchitectureContent(section);
      case 4: // Temple Administration
        return _buildAdministrationContent(section);
      case 5: // About Dr. M Satyanarayana Shastry
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
            }),

            if (section.hasAudio) _buildAudioCard(),
            if (section.hasDownload) _buildDownloadCard(),
            if (section.hasWhatsApp!) _buildShareOnWhatsAppCard(),
          ],
        ),
      ),
    );
  }

  // Unique UI for Sacred Narrative & Significance section
  Widget _buildSacredNarrativeContent(TempleSection section) {
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
                    Color(0xFF9B59B6).withValues(alpha: 0.1),
                    Color(0xFF8E44AD).withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Color(0xFF9B59B6).withValues(alpha: 0.5),
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
                      color: Color(0xFF9B59B6),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TranslatedText(
                    'The divine story of Sri Lakshmi Ganapati',
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
              'Sacred Narrative',
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
                      color: Color(0xFF9B59B6).withValues(alpha: 0.3),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        event.year,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9B59B6),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TranslatedText(
                        event.title,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 12.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white60
                              : textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            SizedBox(height: 20.h),
            TranslatedText(
              'Blessings of Worship',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]!.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Color(0xFF9B59B6).withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              child: Column(
                children: [
                  _buildBlessingItem('Success and fulfillment of goals'),
                  SizedBox(height: 8.h),
                  _buildBlessingItem('Health and long life'),
                  SizedBox(height: 8.h),
                  _buildBlessingItem('Wealth and prosperity'),
                  SizedBox(height: 8.h),
                  _buildBlessingItem('Mental peace and spiritual growth'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for blessing items
  Widget _buildBlessingItem(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: Color(0xFF9B59B6), size: 16.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: TranslatedText(
            text,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 13.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
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
                        // Container(
                        //   width: 100.w,
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFF8E44AD).withValues(alpha: 0.1),
                        //     borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(12.r),
                        //       bottomLeft: Radius.circular(12.r),
                        //       topRight: Radius.circular(12.r),
                        //       bottomRight: Radius.circular(12.r),
                        //     ),
                        //     image: DecorationImage(
                        //       image: NetworkImage(deity.imageUrl!),
                        //       fit: BoxFit.cover,
                        //     ),
                        //   ),
                        // )
                        Container(
                          width: 100.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF8E44AD).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.network(
                              deity.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF8E44AD),
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
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
            ...section.timelineEvents.map(
              (event) => Container(
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
                  spacing: 4.h,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      child: Image.network(
                        event.year,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80.h,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF8E44AD),
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    TranslatedText(
                      event.title,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TranslatedText(
                      event.details,
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 12.sp,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white60
                            : textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
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
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            imageInfo.url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200.h,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  color: const Color(0xFF27AE60),
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: TranslatedText(
                            imageInfo.caption,
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 18.sp,
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
            ExpansionTile(
              title: TranslatedText(
                'Read More',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: Border(),
              children: [
                Column(
                  spacing: 16.h,
                  children: [
                    _buildReadMoreCard(
                      "About Sri Mothkuru Satyanarayana Shastri Garu",
                      "Sri Sri Sri Vedamurti Mothkuru Satyanarayana Shastri (b. 26-12-1968) is a revered Vedic scholar, Devi upasaka, Lalata Shastra expert, educator, and social servant. Born into a traditional Vedic family to Late Sri Rama Shastri & Smt. Ramulamma, he overcame severe poverty through faith and discipline.\n\nA Sanskrit Lecturer at Railway Junior College, Secunderabad, he completed multiple postgraduate degrees from Osmania University, earned 4 Gold Medals, 2 distinctions, and a Ph.D. He was honored with titles such as “Vachaspati”, Dharma Sarvabhouma, Seva Ratna, and Honorary Doctorate.\n\nGuided by divine vision, he established the Marakata Lakshmi Ganapati Temple (2016) and leads spiritual, cultural, annadanam, and charitable service initiatives.",
                    ),
                    _buildReadMoreCard(
                      "Lalata Rekha Shastram",
                      "Lalata Rekha Shastram is a rare spiritual science that studies forehead structure, lines, and sacred markings to understand life tendencies.\n\nUnlike horoscope-based systems, this method does not require date of birth. By observing forehead patterns, guidance can be given regarding health, career, mental peace, family matters, and life obstacles.\n\nClear and well-formed lines indicate leadership, intelligence, and success, while disturbed lines suggest challenges requiring spiritual remedies.",
                    ),
                    _buildReadMoreCard(
                      "Marakata Ganapati Locket – Significance",
                      "The sacred Marakata (Emerald) Lakshmi Ganapati represents prosperity, knowledge, planetary harmony, and divine protection.\n\nDevotees who participate in Abhishekam and wear the Marakata Ganapati locket are believed to receive success in education, business, career, marriage, and foreign opportunities.\n\nEspecially beneficial for certain stars, zodiac signs, and those facing planetary afflictions, it is believed to promote courage, clarity, recognition, and mental peace.",
                    ),
                    _buildReadMoreCard(
                      "Service & Contact",
                      "Through the Marakata Lakshmi Ganapati Trust and associated charities, large-scale annadanam (feeding thousands daily), medical camps, educational support, and COVID relief services are conducted.",
                      guidingPrinciple:
                          '“Service to Humanity is Service to God.”\n“Serving Living Beings is Serving the Divine Mother."',
                      contact:
                          'For Locket, Annadanam participation, or Lalata Rekha consultation:\n  📞 99490 60885 | 95503 17277 | 94409 87638',
                    ),
                  ],
                ),
              ],
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
                    d.icon!,
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
                style: const TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: TranslatedText(
                t.position,
                style: const TextStyle(fontFamily: 'aBeeZee'),
              ),
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

  // ---------------- SHASHTRI READ MORE CONTENT ----------------
  Widget _buildReadMoreCard(
    String title,
    String content, {
    String? guidingPrinciple,
    String? contact,
  }) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          TranslatedText(
            content,
            style: TextStyle(fontFamily: 'aBeeZee', fontSize: 14.sp),
          ),
          if (guidingPrinciple != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  'Guiding Principle:',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TranslatedText(
                  guidingPrinciple,
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (contact != null)
            TranslatedText(
              contact,
              style: TextStyle(fontFamily: 'aBeeZee', fontSize: 14.sp),
            ),
        ],
      ),
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
            label: TranslatedText(
              _isPlaying ? 'Pause Audio' : 'Play Audio',
              style: TextStyle(fontFamily: 'aBeeZee'),
            ),
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
                  TranslatedText(
                    _formatDuration(_position),
                    style: TextStyle(fontFamily: 'aBeeZee'),
                  ),
                  TranslatedText(
                    _formatDuration(_duration),
                    style: TextStyle(fontFamily: 'aBeeZee'),
                  ),
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
          style: TextStyle(fontFamily: 'aBeeZee'),
        ),
      ),
    );
  }

  Widget _buildShareOnWhatsAppCard() {
    return _buildAuthCard(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: _handleShareOnWhatsAppAction,
        icon: const Icon(FontAwesomeIcons.whatsapp),
        label: TranslatedText(
          'Share on WhatsApp',
          style: TextStyle(fontFamily: 'aBeeZee'),
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
      appBar: AppBar(
        title: const TranslatedText(
          'Historical Notes',
          style: TextStyle(fontFamily: 'aBeeZee'),
        ),
      ),
      body: SfPdfViewer.asset(
        'assets/pdfs/historical_notes.pdf',
        canShowPaginationDialog: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
