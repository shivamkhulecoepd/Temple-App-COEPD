import 'dart:developer';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/db_functions.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:excel/excel.dart';

// Define enum for different sections
enum FestivalsSection {
  annualFestivals,
  dailyRituals,
  upcomingEvents,
  liveStreaming,
  membershipSubscription,
}

class FestivalsScreen extends StatefulWidget {
  final FestivalsSection? initialSection;
  const FestivalsScreen({super.key, this.initialSection});

  @override
  State<FestivalsScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalsScreen> {
  late FestivalsSection _currentSection;
  List<dynamic> _events = [];
  Map<String, dynamic>? _liveStreamData;
  bool _isLoading = true;

  List<dynamic> eventsForDownload = [];
  bool isLoadingEventsForDownload = true;

  // Daily rituals data
  final List<Map<String, String>> _dailyRituals = [
    {
      'ritual': 'Suprabhata & Ashtottara Seva',
      'time': '05:00 AM',
      'notes':
          'Daily (Sun & Sankashti). Benefits: Education, employment, health, wealth, success.',
    },
    {
      'ritual': 'Vastralankarana & 32 Dravya Abhishekam',
      'time': '05:00 – 05:30 AM',
      'notes': 'Divine grace, longevity, prosperity, wealth gain.',
    },
    {
      'ritual': 'Chaturavritti Tarpanam',
      'time': '07:00 AM',
      'notes':
          'Protection, disease relief, career & political growth, prosperity.',
    },
    {
      'ritual': 'Sahasranama Archana',
      'time': '07:00 – 08:00 AM',
      'notes':
          'Mon, Tue, Thu, Fri, Chaturthi & Sat. Removes poverty, debts, improves growth.',
    },
    {
      'ritual': 'Durva Yugma Puja',
      'time': '08:00 – 09:00 AM',
      'notes': 'Mental peace, job stability, business & wealth growth.',
    },
    {
      'ritual': 'Homam Sevas',
      'time': '08:00 AM',
      'notes':
          'Includes Ganapati Atharvashirsha, Lakshmi Ganapati Mantra, Sri Sukta. Benefits: Career, marriage, progeny, prosperity.',
    },
    {
      'ritual': 'Friday Special Sevas',
      'time': '10:00 AM & 11:00 AM',
      'notes':
          'Suvarna Pushparchana & Odi Gantla Seva. Lakshmi blessings & prosperity.',
    },
    {
      'ritual': 'Navagraha Abhishekam (Saturday)',
      'time': '05:00 AM',
      'notes':
          'Panchamrita, Shani Taila, Sesame donation & Homam. Relieves planetary doshas.',
    },
    {
      'ritual': 'Durva Puja (Noon)',
      'time': '12:00 PM',
      'notes': 'Daily special puja for peace, political & career growth.',
    },
    {
      'ritual': 'Rajopachara Puja & Donor Blessings',
      'time': 'Select Days',
      'notes':
          'Darbar Seva & Vedic blessings for Annadanam donors. Removes financial & vastu issues.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection ?? FestivalsSection.annualFestivals;
    _fetchData();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      log('Loading upcoming events...');
      final fetched = await DBFunctions().fetchUpcomingEvents();
      log('Events fetched. Count: ${fetched.length}, Data: $fetched');
      setState(() {
        eventsForDownload = fetched;
        isLoadingEventsForDownload = false;
      });
      log('Events state updated. eventsForDownload length: ${eventsForDownload.length}');
    } catch (e) {
      log('Error loading events: $e');
      setState(() => isLoadingEventsForDownload = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events: $e')),
        );
      }
    }
  }

  Future<void> _downloadAsXls() async {
    if (eventsForDownload.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: TranslatedText('No events to download')),
        );
      }
      return;
    }

    // Request storage permissions for Android
    if (Platform.isAndroid) {
      log('Requesting storage permissions for Android');
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission required to save files')),
          );
        }
        return;
      }
      
      // For Android 11+, also request manage external storage
      if (await Permission.manageExternalStorage.isDenied) {
        final manageStatus = await Permission.manageExternalStorage.request();
        log('Manage external storage permission: ${manageStatus.isGranted}');
      }
    }

    try {
      log('Starting XLSX generation. Events count: ${eventsForDownload.length}');
      log('Events data: $eventsForDownload');
      
      // Create Excel file with explicit cell creation
      var excel = Excel.createExcel();
      Sheet sheet = excel['Upcoming Events'];
      log('Excel sheet created');

      // Add header row with explicit cell creation
      sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Title');
      sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Date');
      sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Time');
      sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue('Description');
      log('Header row added with explicit cell creation');

      // Add event rows with explicit cell creation
      for (int i = 0; i < eventsForDownload.length; i++) {
        final event = eventsForDownload[i];
        log('Processing event $i: $event');
        final title = event['title'] ?? 'N/A';
        final date = event['date'] ?? 'N/A';
        final time = event['time'] ?? 'N/A';
        final description = (event['description'] ?? '').replaceAll('\n', ' ').trim();
        
        log('Event data - Title: $title, Date: $date, Time: $time, Description: $description');
        
        final row = i + 2; // Start from row 2 (A2, B2, C2, D2)
        sheet.cell(CellIndex.indexByString('A$row')).value = TextCellValue(title);
        sheet.cell(CellIndex.indexByString('B$row')).value = TextCellValue(date);
        sheet.cell(CellIndex.indexByString('C$row')).value = TextCellValue(time);
        sheet.cell(CellIndex.indexByString('D$row')).value = TextCellValue(description);
        
        // Verify cell values were set
        final testTitle = sheet.cell(CellIndex.indexByString('A$row')).value;
        log('Cell A$row value set to: $testTitle');
        
        log('Added event data to row $row');
      }
      
      log('Total events processed: ${eventsForDownload.length}');
      log('Sheet maxRows: ${sheet.maxRows}');
      log('Sheet rows length: ${sheet.rows.length}');
      
      // Verify specific cells have data
      if (eventsForDownload.isNotEmpty) {
        final testCell = sheet.cell(CellIndex.indexByString('A2')).value;
        log('Test cell A2 value: $testCell');
      }

      // Encode to bytes
      final bytes = excel.encode();
      log('Excel encoded. Bytes length: ${bytes?.length ?? 0}');
      
      if (bytes == null) {
        throw Exception('Failed to generate Excel file - encoding returned null');
      }
      
      if (bytes.isEmpty) {
        throw Exception('Failed to generate Excel file - encoded bytes are empty');
      }
      


      // Save to system Downloads directory
      String downloadsPath;
      
      if (Platform.isAndroid) {
        // For Android, use the standard Downloads directory
        downloadsPath = '/storage/emulated/0/Download';
        log('Using Android Downloads path: $downloadsPath');
      } else {
        // For other platforms, use application documents
        final appDir = await getApplicationDocumentsDirectory();
        downloadsPath = '${appDir.path}/Downloads';
        log('Using app documents path: $downloadsPath');
      }
      
      Directory downloadsDir = Directory(downloadsPath);
      
      // Check if Downloads directory exists
      if (!await downloadsDir.exists()) {
        log('Downloads directory does not exist, trying to create');
        try {
          await downloadsDir.create(recursive: true);
          log('Downloads directory created successfully');
        } catch (e) {
          log('Failed to create Downloads directory: $e');
          // Fallback to app documents
          final appDir = await getApplicationDocumentsDirectory();
          downloadsPath = '${appDir.path}/Downloads';
          downloadsDir = Directory(downloadsPath);
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
        }
      }
      
      final fileName = 'Upcoming_Events_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final path = '${downloadsDir.path}/$fileName';
      log('Full file path: $path');
      
      final file = File(path);
      await file.writeAsBytes(bytes);
      
      // Verify file was created
      final fileExists = await file.exists();
      final fileSize = await file.length();
      log('File created successfully. Exists: $fileExists, Size: $fileSize bytes');
      
      // Additional verification - read back a small portion
      if (fileExists && fileSize > 0) {
        try {
          final content = await file.readAsBytes();
          log('File content verification - First 100 bytes: ${content.sublist(0, content.length > 100 ? 100 : content.length)}');
          
          // Verify the file starts with the correct Excel signature
          if (content.length >= 4) {
            final signature = String.fromCharCodes(content.take(4));
            log('File signature: $signature');
          }
        } catch (readError) {
          log('Error reading file for verification: $readError');
        }
      }

      // Show success message with file location
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const TranslatedText(
                  'Events downloaded as XLSX!',
                ),
                Text(
                  Platform.isAndroid 
                    ? 'Saved to system Downloads folder' 
                    : 'Saved to app Downloads folder',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'File size: $fileSize bytes',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  path,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Open File',
              onPressed: () {
                // Try to open the file
                _openFileLocation(path);
              },
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      log('Failed to create XLS file: $e');
      log('Stack trace: $stackTrace');
      String errorMessage = 'Failed to create XLS file: ${e.toString()}';
      
      // Provide more specific error messages for common issues
      if (e.toString().contains('Permission')) {
        errorMessage = 'Storage permission denied. Please grant permission to save files.';
      } else if (e.toString().contains('Directory')) {
        errorMessage = 'Unable to access Downloads folder. Please check storage permissions.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 8),
          ),
        );
      }
    }
  }

  Future<void> _downloadPdf() async {
    try {
      // Check and request storage permissions
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          if (mounted) {
            AppSnackbar.error(
              context,
              'Storage permission is required to download files',
            );
          }
          return;
        }

        // For Android 11+ also check manage external storage
        if (await Permission.manageExternalStorage.isDenied) {
          final manageStatus = await Permission.manageExternalStorage.request();
          if (!manageStatus.isGranted && mounted) {
            AppSnackbar.info(
              context,
              'Some features may be limited without full storage access',
            );
          }
        }
      }

      // Show initial download starting message
      if (mounted) {
        AppSnackbar.info(context, 'Starting PDF download...');
      }

      final url =
          'https://marakatasrilaxmiganapathi.org/assets/pdf/poojadetails.pdf';

      // Use direct download for better performance
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/pdf',
              'User-Agent': 'Mozilla/5.0 (compatible; Flutter App)',
            },
          )
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/poojadetails.pdf');

        // Show writing file message
        if (mounted) {
          AppSnackbar.info(context, 'Saving PDF file...');
        }

        await file.writeAsBytes(response.bodyBytes);

        // Show completion message
        if (mounted) {
          AppSnackbar.info(context, 'Download complete, opening file...');
        }

        // Open the downloaded file
        if (Platform.isAndroid) {
          // For Android, we need to use open_filex package which handles FileProvider properly
          await OpenFilex.open(file.path);
        } else {
          // For iOS and other platforms, use url_launcher
          await launchUrl(
            Uri.file(file.path),
            mode: LaunchMode.externalApplication,
          );
        }

        if (mounted) {
          AppSnackbar.success(context, 'PDF downloaded successfully');
        }
      } else {
        if (mounted) {
          AppSnackbar.error(
            context,
            'Failed to download PDF (Status: ${response.statusCode})',
          );
        }
      }
    } on TimeoutException {
      if (mounted) {
        AppSnackbar.error(
          context,
          'Download timeout - please check your connection',
        );
      }
    } catch (e) {
      log('Error downloading PDF: $e');
      if (mounted) {
        AppSnackbar.error(
          context,
          'Error downloading PDF: ${e.toString().split(':').first}',
        );
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      final results = await Future.wait([
        DBFunctions().fetchActiveEvents(),
        DBFunctions().fetchLiveStreamSettings(),
      ], eagerError: true);

      if (!mounted) return;

      setState(() {
        _events = results[0] as List<dynamic>;
        _liveStreamData = results[1] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      log('Error fetching festival data: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String get liveUrl =>
      _liveStreamData?['embed_code'] ??
      'https://www.youtube.com/watch?v=IL-72PQszxg';

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return 'Date not available';
    }
  }

  Future<void> _launchYouTube(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        AppSnackbar.error(context, 'Could not open YouTube');
      }
    }
  }

  Future<void> _openFileLocation(String filePath) async {
    try {
      log('Attempting to open file location: $filePath');
      final file = File(filePath);
      if (await file.exists()) {
        log('File exists, attempting to open');
        if (Platform.isAndroid) {
          // For Android, try to open the file directly first
          try {
            final result = await OpenFilex.open(filePath);
            log('OpenFilex result: ${result.message}');
            if (result.type != ResultType.done) {
              // If direct file opening fails, open parent directory
              await OpenFilex.open(file.parent.path);
            }
          } catch (openError) {
            log('OpenFilex failed: $openError, trying parent directory');
            await OpenFilex.open(file.parent.path);
          }
        } else {
          // For other platforms, open the file directly
          await launchUrl(
            Uri.file(filePath),
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        log('File does not exist: $filePath');
        if (mounted) {
          AppSnackbar.error(context, 'File not found at: $filePath');
        }
      }
    } catch (e) {
      log('Error opening file location: $e');
      if (mounted) {
        AppSnackbar.error(context, 'Could not open file location: ${e.toString()}');
      }
    }
  }
  


  void _selectSection(FestivalsSection section) {
    Navigator.pop(context);
    if (section == _currentSection) return;
    setState(() => _currentSection = section);
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
              : Colors.white,
          appBar: AppBar(
            title: TranslatedText(
              'Festival & Events',
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
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: _buildSection(theme, isDark),
                ),
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
      backgroundColor: isDark ? theme.cardColor : Colors.white,
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
                'Temple Festivals',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Drawer Items
          _drawerItem(
            'Annual Festivals',
            FestivalsSection.annualFestivals,
            theme,
            isDark,
          ),
          _drawerItem(
            'Daily Rituals and timings',
            FestivalsSection.dailyRituals,
            theme,
            isDark,
          ),
          _drawerItem(
            'Upcoming Events Calendar',
            FestivalsSection.upcomingEvents,
            theme,
            isDark,
          ),
          _drawerItem(
            'Live Streaming',
            FestivalsSection.liveStreaming,
            theme,
            isDark,
          ),
          _drawerItem(
            'Membership & Subscription',
            FestivalsSection.membershipSubscription,
            theme,
            isDark,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  'Festival Spotlight',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.white : Colors.blue[800],
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                TranslatedText(
                  'Next: Vinayaka Chavithi',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.white : Colors.blue[700],
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                TranslatedText(
                  '- Sep 17, 2026',
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.grey[300] : Colors.blue[600],
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 4.h),
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
                    'Register for Spotlight',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
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
    FestivalsSection section,
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
      case FestivalsSection.annualFestivals:
        return _annualFestivalsSection(theme, isDark);
      case FestivalsSection.dailyRituals:
        return _dailyRitualsSection(theme, isDark);
      case FestivalsSection.upcomingEvents:
        return _upcomingEventsSection(theme, isDark);
      case FestivalsSection.liveStreaming:
        return _liveStreamingSection(theme, isDark);
      case FestivalsSection.membershipSubscription:
        return _membershipSubscriptionSection(theme, isDark);
    }
  }

  // ---------------- SECTION UIs ----------------
  Widget _annualFestivalsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Annual Festival',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Major festivals are celebrated with special rituals, alankarams, and cultural programs.',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Festival Cards
        Column(
          spacing: 16.h,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _festivalCard(
              'Marakata Lakshmi Ganapati – Devi Sharannavarathrulu',
              "In every Manvantara, Kalpa, and Yuga, whenever negative forces grow and trouble the worlds, the Supreme Divine Power manifests. The great Ganapati’s divine Shakti appears in feminine form as the Goddess — manifesting as Mahakali, Mahalakshmi, and Mahasaraswati — and destroys powerful demons such as Madhu–Kaitabha, Mahishasura, Shumbha-Nishumbha, Chanda–Munda, Durgamasura, and others.\n\nDuring Sharannavarathri, the Goddess is worshipped in multiple Lakshmi forms including Adi Lakshmi, Dhanya Lakshmi, Dhairya Lakshmi, Gaja Lakshmi, Santana Lakshmi, Vijaya Lakshmi, Vidya Lakshmi, Dhana Lakshmi, and Marakata Lakshmi.\n\nBy worshipping these forms with devotion, devotees obtain Ashta Aishwarya, health, removal of enemy troubles, and success in all directions.",
              'Ashwayuja Shukla Padyami – Dashami',
              theme,
              isDark,
              'Register',
            ),
            _festivalCard(
              'Marakata Lakshmi Ganapati Swamy – Brahmotsavam',
              'Marakata Lakshmi Ganapati Swamy is described as the embodiment of the primordial Pranava (Om), the supreme leader of the three worlds, and the all-pervading divine presence in the universe.\n\nEvery year, from Chaitra Shuddha Vidiya to Panchami, the grand Brahmotsavam festival is celebrated with Rathotsavam, Homams, Maha Poornahuti, Shanti Kalyanam, and sacred rituals.\n\nParticipation is believed to remove Navagraha doshas, reduce afflictions, remove obstacles, grant wealth, prosperity,success, and overall auspiciousness.',
              'Chaitra Shuddha Vidiya – Panchami',
              theme,
              isDark,
              'Register',
            ),
            _festivalCard(
              'Marakata Lakshmi Ganapati Swamy – Brahmotsavams',
              'Marakata Lakshmi Ganapati Swamy is described as the embodiment of the primordial Pranava (Om), the supreme leader of the three worlds, and the all-pervading divine presence in the universe.\n\nEvery year, from Chaitra Shuddha Vidiya to Panchami, the grand Brahmotsavam festival is celebrated with Rathotsavam, Homams, Maha Poornahuti, Shanti Kalyanam, and sacred rituals.\n\nParticipation is believed to remove Navagraha doshas, reduce afflictions, remove obstacles, grant wealth, prosperity, success, and overall auspiciousness.',
              'Chaitra Shuddha Vidiya – Panchami',
              theme,
              isDark,
              'Register',
            ),
          ],
        ),
      ],
    );
  }

  Widget _dailyRitualsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Daily Rituals and Timings',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Daily schedule of temple rituals and seva timings',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Horizontal scrollable table for rituals
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[800]!.withValues(alpha: 0.6)
                : Colors.grey[100]!.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: <DataColumn>[
                DataColumn(
                  label: TranslatedText(
                    'Ritual',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: TranslatedText(
                    'Time',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                DataColumn(
                  label: TranslatedText(
                    'Notes',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
              rows: _dailyRituals.map((ritual) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      TranslatedText(
                        ritual['ritual']!,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        ritual['time']!,
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      TranslatedText(
                        ritual['notes']!,
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
        ),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: _downloadPdf,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: TranslatedText(
            'Download Schedule (PDF)',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _upcomingEventsSection(ThemeData theme, bool isDark) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      color: theme.colorScheme.secondary,
      backgroundColor: theme.primaryColor,
      onRefresh: () async {
        try {
          final results = await Future.wait([
            DBFunctions().fetchActiveEvents(),
          ], eagerError: true);

          if (!mounted) return;

          setState(() {
            _events = results[0];
            _isLoading = false;
          });
        } catch (e) {
          log('Error fetching festival data for upcoming/active events: $e');
          if (!mounted) return;
          setState(() => _isLoading = false);
        }
      },
      child: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                'Upcoming Events',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : null,
                ),
              ),
              SizedBox(height: 8.h),
              TranslatedText(
                'Click an event to see details',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'aBeeZee',
                  color: isDark ? Colors.grey.shade300 : null,
                ),
              ),
              SizedBox(height: 20.h),

              // List of events
              if (_events.isEmpty)
                Center(
                  child: TranslatedText(
                    'No upcoming events',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 16.sp,
                      color: isDark ? Colors.grey[300] : Colors.black,
                    ),
                  ),
                )
              else ...[
                Column(
                  spacing: 16.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _events.map((event) {
                    return _eventItem(
                      _formatDate(event['event_date'] ?? ''),
                      event['event_title'] ?? '',
                      event['event_time'] ?? '',
                      theme,
                      isDark,
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h), // Add some padding at the end
              ],
            ],
          ),
          SizedBox(height: 20.h),
          if (eventsForDownload.isNotEmpty)
            ElevatedButton.icon(
              onPressed: _downloadAsXls,
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const TranslatedText('Download XLS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _liveStreamingSection(ThemeData theme, bool isDark) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      color: theme.colorScheme.secondary,
      backgroundColor: theme.primaryColor,
      onRefresh: () async {
        try {
          final results = await Future.wait([
            DBFunctions().fetchLiveStreamSettings(),
          ], eagerError: true);

          if (!mounted) return;

          setState(() {
            _liveStreamData = results[0];
            _isLoading = false;
          });
        } catch (e) {
          log('Error fetching live stream data: $e');
          if (!mounted) return;
          setState(() => _isLoading = false);
        }
      },
      child: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                'Live Streaming',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : null,
                ),
              ),
              SizedBox(height: 8.h),
              TranslatedText(
                'Watch live rituals and festivals from anywhere in the world',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'aBeeZee',
                  color: isDark ? Colors.grey.shade300 : null,
                ),
              ),
              SizedBox(height: 20.h),

              // Live streaming video placeholder
              Column(
                spacing: 16.h,
                children: [
                  Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/dashboard/bg 2.webp'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
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
                    child: Center(
                      child: InkWell(
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          await _launchYouTube(liveUrl, context);
                        },
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 36.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.yellow[50]!.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12.r),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TranslatedText(
                          'Upcoming Live Sessions',
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TranslatedText(
                          '• Vinayaka Chavithi Pooja – Sep 17, 2025',
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                        TranslatedText(
                          '• Navratri Kalakshetra – Sep 17, 2025',
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[300] : Colors.black,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () async {
                            await _launchYouTube(
                              "https://www.youtube.com/@mslgdevasthanam",
                              context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: TranslatedText(
                            'Subscribe for reminder',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h), // Add padding at the end
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _membershipSubscriptionSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          'Membership & Subscription',
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          'Become a member for exclusive access and perks',
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),

        // Membership plans
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: [
            _membershipPlan(
              'Monthly',
              '₹ 200',
              'Live stream early access\nMonthly Blessings',
              theme,
              isDark,
            ),
            _membershipPlan(
              'Quarterly',
              '₹ 500',
              'Priority Booking\nExclusive Content',
              theme,
              isDark,
            ),
            _membershipPlan(
              'Yearly',
              '₹ 1800',
              'All Perks\nSpecial Recognition',
              theme,
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- COMMON WIDGETS ----------------
  Widget _festivalCard(
    String title,
    String subtitle,
    String date,
    ThemeData theme,
    bool isDark,
    String registerText,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        // color: isDark
        //     ? Colors.white.withValues(alpha: 0.1)
        //     : Colors.white.withValues(alpha: 0.9),
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
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
          SizedBox(height: 8.h),
          TranslatedText(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
          ),
          SizedBox(height: 12.h),
          TranslatedText(
            date,
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade400 : Colors.grey[600],
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              // Handle register
              // AppSnackbar.info(context, 'Register clicked');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: TranslatedText(
              registerText,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'aBeeZee',
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventItem(
    String date,
    String title,
    String time,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            date,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          SizedBox(height: 4.h),
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              TranslatedText(
                time,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _membershipPlan(
    String period,
    String price,
    String description,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TranslatedText(
            period,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          TranslatedText(
            price,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          TranslatedText(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () {
              // Handle download
              AppSnackbar.info(context, 'Download clicked');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: TranslatedText(
              'Download',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'aBeeZee',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
