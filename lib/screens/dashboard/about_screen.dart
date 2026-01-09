import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/models/old_screen_models.dart';
import 'package:temple_app/widgets/translated_text.dart';
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
  final Color primaryOrange = const Color(0xFFF26B2C);
  final Color softGrey = const Color(0xFFF7F7F7);
  final Color textDark = const Color(0xFF1C1C1C);
  final Color textMuted = const Color(0xFF7A7A7A);

  // ---------------- SECTIONS DATA (UNCHANGED) ----------------
  // All sections data
  final List<TempleSection> _sections = [
    TempleSection(
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
              'Launch of annadanam (free food distribution) and education schemes for underprivileged children. Regular spiritual discourses and Vedic classes began.',
        ),
        TimelineEvent(
          year: '2020',
          title: 'Major Renovation',
          details:
              'Complete renovation of Gopuram (tower) and Mandapam (hall). Installation of new vigrahas (deities) with proper Agamic rituals.',
        ),
      ],
      hasAudio: true,
      audioUrl: '',
      hasDownload: true,
      downloadUrl: '',
      content: '''
A concise narrated history follows the founding of the temple, local legends, and important milestones.

The Marakatha Sri Lakshmi Ganapathi Devalayam was established in 2017 under the divine guidance of Dr. M. Satyanarayana Shastry Garu. The temple follows strict Agamic traditions and Vedic rituals.

Local legends speak of divine visions that led to the selection of this sacred site. The temple has become a spiritual hub for devotees seeking blessings of Lord Ganesha and Goddess Lakshmi.

Important milestones include the mahakumbhabhishekam in 2020 and the establishment of various community service programs.
''',
    ),
    TempleSection(
      id: 1,
      title: 'Deities & Sub-Shrines',
      icon: Icons.temple_hindu_rounded,
      color: const Color(0xFF8E44AD), // Purple
      subtitle: 'Details of the main deity, sub-shrines and important rituals.',
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
      content: '''
Details of the main deity, sub-shrines and important rituals.

**Sri Laxmi Ganapathi**
The main deity of the temple is a unique form of Lord Ganesha with Goddess Lakshmi seated on His lap. This rare form symbolizes prosperity, wisdom, and removal of obstacles. The deity is carved from sacred black stone and measures 3 feet in height.

**Sri Anjaneya Swamy**
Located to the south of the main shrine, this deity of Lord Hanuman is 4 feet tall and faces south (as Dakshinamukhi Anjaneya). Special pujas are performed on Tuesdays and Saturdays.

**Sri Navagraha**
The nine planetary deities are installed in a separate shrine facing east. Each deity is represented with their respective vahanas (vehicles) and weapons. Special homams are performed for planetary peace and prosperity.

**Other Sub-Shrines:**
- Sri Durga Devi
- Sri Satyanarayana Swamy
- Sri Subramanya Swamy with Valli and Deivanai
- Nandeeswara and Mahalakshmi

**Important Rituals:**
1. Daily: Panchamritabhishekam, Rudrabhishekam
2. Monthly: Sankatahara Chaturthi, Ekadashi
3. Annual: Ganesha Chaturthi, Diwali, Maha Shivaratri
''',
      deities: [
        Deity(
          name: 'Sri Laxmi Ganapathi',
          description:
              'Main deity, guardian of prosperity and remover of obstacles',
          icon: '🕉️',
        ),
        Deity(
          name: 'Sri Anjaneya Swamy',
          description: 'Protector and obstacle remover, south-facing deity',
          icon: '🐒',
        ),
        Deity(
          name: 'Sri Navagraha',
          description:
              'Celestial influence and remedies for planetary positions',
          icon: '☀️',
        ),
      ],
    ),
    TempleSection(
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
      content: '''
Photographs and descriptions highlight the Gopuram, Mandapam, Dwajasthambham and temple tank.

**Architectural Style:**
The temple follows the Dravidian architectural style as prescribed in the Agama Shastras. The entire structure is aligned according to Vastu principles with the main deity facing East.

**Key Architectural Features:**

1. **Gopuram (Tower):**
   - 5-tier Rajagopuram at the entrance
   - Height: 45 feet
   - Features sculptures of Dasavatara (10 incarnations of Vishnu)
   - Kalasam (golden pinnacle) at the top

2. **Mandapam (Halls):**
   - **Maha Mandapam:** Main hall for rituals (40x40 feet)
   - **Artha Mandapam:** Antechamber before sanctum
   - **Kalyana Mandapam:** For wedding ceremonies
   - **Ranga Mandapam:** For cultural performances

3. **Dwajasthambham (Flag Post):**
   - 25-foot tall copper flag post
   - Weekly flag hoisting on Fridays
   - Nandi statue facing the sanctum

4. **Temple Tank (Pushkarini):**
   - 60x40 feet sacred water tank
   - Steps on all four sides
   - Used for ritual purification

5. **Prakaram (Circumambulation Path):**
   - Outer corridor: 150 feet circumference
   - Inner corridor: 80 feet circumference
   - Stone flooring with carved designs

**Vastu Considerations:**
- Main entrance faces East for prosperity
- Kitchen located in Southeast
- Water storage in Northeast
- Administration office in Northwest
''',
    ),
    TempleSection(
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
      content: '''
Details of the management, governance policies, and contact points for administrative queries.

**Trust Board Structure:**
The temple is managed by Sri Marakatha Lakshmi Ganapathi Trust, registered under the Societies Registration Act.

**Key Administrative Positions:**

1. **Chairman:** Dr. M. Satyanarayana Shastry
   - Overall spiritual and administrative guidance
   - Final authority on ritual matters

2. **Managing Trustee:** Sri R. Krishna Kumar
   - Day-to-day administration
   - Financial management
   - Staff supervision

3. **Secretary:** Smt. Lakshmi Devi
   - Record keeping
   - Event coordination
   - Donor relations

4. **Treasurer:** Sri S. Rajagopal
   - Financial accounting
   - Audit compliance
   - Budget management

**Governance Policies:**
- Monthly trust meetings
- Annual financial audit by CA firm
- Transparent donation system
- Quarterly newsletter to devotees
- Grievance redressal committee

**Contact Information:**
- Email: admin@marakathatemple.org
- Phone: +91-9876543210
- Address: Sri Marakatha Lakshmi Ganapathi Devalayam, Temple Street, Vijayawada, Andhra Pradesh - 520001

**Office Hours:**
- Monday to Saturday: 8:00 AM to 12:00 PM, 4:00 PM to 8:00 PM
- Sunday: 8:00 AM to 1:00 PM
''',
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
      ],
    ),
    TempleSection(
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
          details: 'Completed advanced studies in Vedas, Agamas, and Shastras.',
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
      content: '''
Dr. M. Satyanarayana Shastry Garu is a highly respected Vedic scholar, spiritual mentor, and steadfast upholder of Sanatana Dharma.

**Early Life & Education:**
Born into a traditional Vedic family, Shastry Garu was immersed in spiritual learning from a young age. Under the guidance of eminent gurus, he received rigorous training in Vedic scriptures, Agamas, temple rituals, and sacred traditions. His deep scholarship, combined with strict spiritual discipline and daily sadhana, laid a strong foundation for his lifelong commitment to Dharma and divine service.

**Academic Qualifications:**
- Vedavishaarada in Rigveda
- Agama Shastra Visharada
- PhD in Vedic Studies from Sampurnanand Sanskrit University
- Author of 15 books on Vedic rituals and temple architecture

**Contribution to the Temple:**
Dr. M. Satyanarayana Shastry Garu\'s divine vision and leadership were instrumental in the conception and development of Marakatha Sri Lakshmi Ganapathi Devalayam. He guided every aspect of the temple—its Agamic architecture, ritual procedures, daily worship, festivals, and spiritual programs—ensuring strict adherence to Vedic and Agamic principles.

**Spiritual Philosophy:**
Shastry Garu emphasizes:
1. **Bhakti Marga:** Path of devotion through regular worship
2. **Jnana Marga:** Spiritual knowledge through Vedic study
3. **Seva:** Selfless service to society
4. **Samskaras:** Preserving traditional rituals

**Other Contributions:**
- Established Veda Patashala for young students
- Regular spiritual discourses across India
- Guidance for temple construction and restoration
- Mentorship to hundreds of priests and scholars

Through his inspiration, the Devalayam has become not only a place of worship but also a vibrant spiritual and cultural center, nurturing devotion, tradition, and service among devotees.
''',
    ),
  ];

  // ------------------------------------------------------------

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
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
              itemCount: _sections.length,
              separatorBuilder: (_, __) => SizedBox(width: 10.w),
              itemBuilder: (context, index) {
                final section = _sections[index];
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
                      color: isSelected ? primaryOrange : softGrey,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          section.icon,
                          size: 18.sp,
                          color: isSelected ? Colors.white : textMuted,
                        ),
                        SizedBox(width: 6.w),
                        TranslatedText(
                          // _getShortTitle(section.title),
                          (section.title),
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : textMuted,
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
              _sections[_currentIndex].subtitle,
              style: TextStyle(
                fontSize: 13.sp,
                color: textMuted,
                fontFamily: 'aBeeZee',
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getShortTitle(String title) {
    final words = title.split(' ');
    return words.length > 2 ? words.take(2).join(' ') : title;
  }

  // ---------------- SECTION CONTENT ----------------

  Widget _buildSectionContent(TempleSection section) {
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
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            _authCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
              ),
            ),

            if (section.id == 0) _buildDetailedTimeline(section),
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

  Widget _authCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ---------------- TIMELINE ----------------

  Widget _buildDetailedTimeline(TempleSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historical Timeline',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        SizedBox(height: 12.h),
        ...section.timelineEvents.map(
          (e) => _authCard(child: _timelineTile(e)),
        ),
      ],
    );
  }

  Widget _timelineTile(TimelineEvent event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.year,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: primaryOrange,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          event.title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          event.details,
          style: TextStyle(fontSize: 13.sp, color: textMuted),
        ),
      ],
    );
  }

  // ---------------- DEITIES ----------------

  Widget _buildDeitiesGrid(List<Deity> deities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deities',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: textDark,
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
            return _authCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(d.icon, style: TextStyle(fontSize: 30.sp)),
                  SizedBox(height: 8.h),
                  Text(
                    d.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    d.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, color: textMuted),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------- TRUSTEES ----------------

  Widget _buildTrusteesList(List<Trustee> trustees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trust Board',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        SizedBox(height: 12.h),
        ...trustees.map(
          (t) => _authCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: softGrey,
                child: const Icon(Icons.person),
              ),
              title: Text(
                t.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(t.position),
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

  // ---------------- AUDIO / DOWNLOAD ----------------

  Widget _buildAudioCard() => _authCard(
    child: ElevatedButton.icon(
      style: _primaryButtonStyle(),
      onPressed: _playAudio,
      icon: const Icon(Icons.play_arrow),
      label: const Text('Play Audio'),
    ),
  );

  Widget _buildDownloadCard() => _authCard(
    child: ElevatedButton.icon(
      style: _primaryButtonStyle(),
      onPressed: _downloadPDF,
      icon: const Icon(Icons.download),
      label: const Text('Download PDF'),
    ),
  );

  ButtonStyle _primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryOrange,
      minimumSize: Size(double.infinity, 48.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    );
  }

  // ---------------- ACTIONS ----------------

  void _playAudio() => _snack('Playing audio...');
  void _downloadPDF() => _snack('Downloading PDF...');
  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  void _sendEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ---------------- BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'About Us',
          style: TextStyle(color: textDark, fontSize: 16.sp),
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/main_bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildSectionSelector(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _sections.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                    _animationController.forward(from: 0);
                  });
                },
                itemBuilder: (_, i) => _buildSectionContent(_sections[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:temple_app/models/old_screen_models.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AboutScreen extends StatefulWidget {
//   const AboutScreen({super.key});

//   @override
//   State<AboutScreen> createState() => _AboutScreenState();
// }

// class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
//   int _currentIndex = 0;
//   final PageController _pageController = PageController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   int _hoverIndex = -1;
  
//   // All sections data
//   final List<TempleSection> _sections = [
//     TempleSection(
//       id: 0,
//       title: 'History & Legend',
//       icon: Icons.history_rounded,
//       color: const Color(0xFFD35400), // Orange
//       subtitle: 'A concise narrated history follows the founding of the temple, local legends, and important milestones.',
//       timelineEvents: [
//         TimelineEvent(
//           year: '2017',
//           title: 'Temple Founded',
//           details: 'Founding and early years with traditional patronage. The temple was established with blessings from Dr. M. Satyanarayana Shastry Garu and support from local devotees.',
//         ),
//         TimelineEvent(
//           year: '2019',
//           title: 'Community Programs',
//           details: 'Launch of annadanam (free food distribution) and education schemes for underprivileged children. Regular spiritual discourses and Vedic classes began.',
//         ),
//         TimelineEvent(
//           year: '2020',
//           title: 'Major Renovation',
//           details: 'Complete renovation of Gopuram (tower) and Mandapam (hall). Installation of new vigrahas (deities) with proper Agamic rituals.',
//         ),
//       ],
//       hasAudio: true,
//       audioUrl: '',
//       hasDownload: true,
//       downloadUrl: '',
//       content: '''
// A concise narrated history follows the founding of the temple, local legends, and important milestones.

// The Marakatha Sri Lakshmi Ganapathi Devalayam was established in 2017 under the divine guidance of Dr. M. Satyanarayana Shastry Garu. The temple follows strict Agamic traditions and Vedic rituals.

// Local legends speak of divine visions that led to the selection of this sacred site. The temple has become a spiritual hub for devotees seeking blessings of Lord Ganesha and Goddess Lakshmi.

// Important milestones include the mahakumbhabhishekam in 2020 and the establishment of various community service programs.
// ''',
//     ),
//     TempleSection(
//       id: 1,
//       title: 'Deities & Sub-Shrines',
//       icon: Icons.temple_hindu_rounded,
//       color: const Color(0xFF8E44AD), // Purple
//       subtitle: 'Details of the main deity, sub-shrines and important rituals.',
//       timelineEvents: [
//         TimelineEvent(
//           year: 'Daily',
//           title: 'Morning Pooja',
//           details: 'Suprabhatam at 6 AM, followed by Abhishekam and Archana. Morning rituals conclude with Maha Naivedyam.',
//         ),
//         TimelineEvent(
//           year: 'Weekly',
//           title: 'Special Abhishekam',
//           details: 'Friday: Sri Lakshmi Ganapathi special puja. Saturday: Sri Anjaneya Swamy homam. Sunday: Navagraha shanti puja.',
//         ),
//         TimelineEvent(
//           year: 'Yearly',
//           title: 'Brahmotsavam',
//           details: '10-day annual festival during Vinayaka Chaturthi with processions, cultural programs, and special rituals.',
//         ),
//       ],
//       hasAudio: false,
//       audioUrl: '',
//       hasDownload: false,
//       downloadUrl: '',
//       content: '''
// Details of the main deity, sub-shrines and important rituals.

// **Sri Laxmi Ganapathi**
// The main deity of the temple is a unique form of Lord Ganesha with Goddess Lakshmi seated on His lap. This rare form symbolizes prosperity, wisdom, and removal of obstacles. The deity is carved from sacred black stone and measures 3 feet in height.

// **Sri Anjaneya Swamy**
// Located to the south of the main shrine, this deity of Lord Hanuman is 4 feet tall and faces south (as Dakshinamukhi Anjaneya). Special pujas are performed on Tuesdays and Saturdays.

// **Sri Navagraha**
// The nine planetary deities are installed in a separate shrine facing east. Each deity is represented with their respective vahanas (vehicles) and weapons. Special homams are performed for planetary peace and prosperity.

// **Other Sub-Shrines:**
// - Sri Durga Devi
// - Sri Satyanarayana Swamy
// - Sri Subramanya Swamy with Valli and Deivanai
// - Nandeeswara and Mahalakshmi

// **Important Rituals:**
// 1. Daily: Panchamritabhishekam, Rudrabhishekam
// 2. Monthly: Sankatahara Chaturthi, Ekadashi
// 3. Annual: Ganesha Chaturthi, Diwali, Maha Shivaratri
// ''',
//       deities: [
//         Deity(
//           name: 'Sri Laxmi Ganapathi',
//           description: 'Main deity, guardian of prosperity and remover of obstacles',
//           icon: '🕉️',
//         ),
//         Deity(
//           name: 'Sri Anjaneya Swamy',
//           description: 'Protector and obstacle remover, south-facing deity',
//           icon: '🐒',
//         ),
//         Deity(
//           name: 'Sri Navagraha',
//           description: 'Celestial influence and remedies for planetary positions',
//           icon: '☀️',
//         ),
//       ],
//     ),
//     TempleSection(
//       id: 2,
//       title: 'Architecture & Sacred Places',
//       icon: Icons.architecture_rounded,
//       color: const Color(0xFF27AE60), // Green
//       subtitle: 'Photographs and descriptions highlight the Gopuram, Mandapam, Dwajasthambham and temple tank.',
//       timelineEvents: [
//         TimelineEvent(
//           year: 'East',
//           title: 'Main Gopuram',
//           details: '5-tier Rajagopuram built in Dravidian style with intricate sculptures depicting various deities.',
//         ),
//         TimelineEvent(
//           year: 'Center',
//           title: 'Maha Mandapam',
//           details: 'Main hall with 16 pillars, each carved with different avataras of Lord Vishnu.',
//         ),
//         TimelineEvent(
//           year: 'West',
//           title: 'Temple Tank',
//           details: 'Sacred pushkarini (water tank) used for ritual baths and theertham distribution.',
//         ),
//       ],
//       hasAudio: false,
//       audioUrl: '',
//       hasDownload: false,
//       downloadUrl: '',
//       content: '''
// Photographs and descriptions highlight the Gopuram, Mandapam, Dwajasthambham and temple tank.

// **Architectural Style:**
// The temple follows the Dravidian architectural style as prescribed in the Agama Shastras. The entire structure is aligned according to Vastu principles with the main deity facing East.

// **Key Architectural Features:**

// 1. **Gopuram (Tower):**
//    - 5-tier Rajagopuram at the entrance
//    - Height: 45 feet
//    - Features sculptures of Dasavatara (10 incarnations of Vishnu)
//    - Kalasam (golden pinnacle) at the top

// 2. **Mandapam (Halls):**
//    - **Maha Mandapam:** Main hall for rituals (40x40 feet)
//    - **Artha Mandapam:** Antechamber before sanctum
//    - **Kalyana Mandapam:** For wedding ceremonies
//    - **Ranga Mandapam:** For cultural performances

// 3. **Dwajasthambham (Flag Post):**
//    - 25-foot tall copper flag post
//    - Weekly flag hoisting on Fridays
//    - Nandi statue facing the sanctum

// 4. **Temple Tank (Pushkarini):**
//    - 60x40 feet sacred water tank
//    - Steps on all four sides
//    - Used for ritual purification

// 5. **Prakaram (Circumambulation Path):**
//    - Outer corridor: 150 feet circumference
//    - Inner corridor: 80 feet circumference
//    - Stone flooring with carved designs

// **Vastu Considerations:**
// - Main entrance faces East for prosperity
// - Kitchen located in Southeast
// - Water storage in Northeast
// - Administration office in Northwest
// ''',
//     ),
//     TempleSection(
//       id: 3,
//       title: 'Temple Administration',
//       icon: Icons.admin_panel_settings_rounded,
//       color: const Color(0xFF2980B9), // Blue
//       subtitle: 'Details of the management, governance policies, and contact points for administrative queries.',
//       timelineEvents: [
//         TimelineEvent(
//           year: '2017',
//           title: 'Trust Formed',
//           details: 'Initial trust board formation with 5 members under chairmanship of Dr. M. Satyanarayana Shastry.',
//         ),
//         TimelineEvent(
//           year: '2019',
//           title: 'Governance Charter',
//           details: 'Formal governance policies and financial systems established.',
//         ),
//         TimelineEvent(
//           year: '2022',
//           title: 'Digital Transformation',
//           details: 'Implementation of online donation systems and digital record keeping.',
//         ),
//       ],
//       hasAudio: false,
//       audioUrl: '',
//       hasDownload: true,
//       downloadUrl: '',
//       content: '''
// Details of the management, governance policies, and contact points for administrative queries.

// **Trust Board Structure:**
// The temple is managed by Sri Marakatha Lakshmi Ganapathi Trust, registered under the Societies Registration Act.

// **Key Administrative Positions:**

// 1. **Chairman:** Dr. M. Satyanarayana Shastry
//    - Overall spiritual and administrative guidance
//    - Final authority on ritual matters

// 2. **Managing Trustee:** Sri R. Krishna Kumar
//    - Day-to-day administration
//    - Financial management
//    - Staff supervision

// 3. **Secretary:** Smt. Lakshmi Devi
//    - Record keeping
//    - Event coordination
//    - Donor relations

// 4. **Treasurer:** Sri S. Rajagopal
//    - Financial accounting
//    - Audit compliance
//    - Budget management

// **Governance Policies:**
// - Monthly trust meetings
// - Annual financial audit by CA firm
// - Transparent donation system
// - Quarterly newsletter to devotees
// - Grievance redressal committee

// **Contact Information:**
// - Email: admin@marakathatemple.org
// - Phone: +91-9876543210
// - Address: Sri Marakatha Lakshmi Ganapathi Devalayam, Temple Street, Vijayawada, Andhra Pradesh - 520001

// **Office Hours:**
// - Monday to Saturday: 8:00 AM to 12:00 PM, 4:00 PM to 8:00 PM
// - Sunday: 8:00 AM to 1:00 PM
// ''',
//       trustees: [
//         Trustee(
//           name: 'Dr. M. Satyanarayana Shastry',
//           position: 'Chairman & Chief Priest',
//           contact: 'chairman@marakathatemple.org',
//         ),
//         Trustee(
//           name: 'Sri R. Krishna Kumar',
//           position: 'Managing Trustee',
//           contact: 'trustee@marakathatemple.org',
//         ),
//         Trustee(
//           name: 'Smt. Lakshmi Devi',
//           position: 'Secretary',
//           contact: 'secretary@marakathatemple.org',
//         ),
//         Trustee(
//           name: 'Sri S. Rajagopal',
//           position: 'Treasurer',
//           contact: 'treasurer@marakathatemple.org',
//         ),
//       ],
//     ),
//     TempleSection(
//       id: 4,
//       title: 'About Dr. M Satyanarayana Shastry',
//       icon: Icons.person_rounded,
//       color: const Color(0xFFC0392B), // Red
//       subtitle: 'Spiritual mentor and guiding force behind the temple.',
//       timelineEvents: [
//         TimelineEvent(
//           year: '1975',
//           title: 'Early Education',
//           details: 'Born into traditional Vedic family, began Vedic studies at age 5.',
//         ),
//         TimelineEvent(
//           year: '1995',
//           title: 'Vedic Scholarship',
//           details: 'Completed advanced studies in Vedas, Agamas, and Shastras.',
//         ),
//         TimelineEvent(
//           year: '2017',
//           title: 'Temple Foundation',
//           details: 'Led establishment of Marakatha Sri Lakshmi Ganapathi Devalayam.',
//         ),
//       ],
//       hasAudio: false,
//       audioUrl: '',
//       hasDownload: false,
//       downloadUrl: '',
//       content: '''
// Dr. M. Satyanarayana Shastry Garu is a highly respected Vedic scholar, spiritual mentor, and steadfast upholder of Sanatana Dharma.

// **Early Life & Education:**
// Born into a traditional Vedic family, Shastry Garu was immersed in spiritual learning from a young age. Under the guidance of eminent gurus, he received rigorous training in Vedic scriptures, Agamas, temple rituals, and sacred traditions. His deep scholarship, combined with strict spiritual discipline and daily sadhana, laid a strong foundation for his lifelong commitment to Dharma and divine service.

// **Academic Qualifications:**
// - Vedavishaarada in Rigveda
// - Agama Shastra Visharada
// - PhD in Vedic Studies from Sampurnanand Sanskrit University
// - Author of 15 books on Vedic rituals and temple architecture

// **Contribution to the Temple:**
// Dr. M. Satyanarayana Shastry Garu\'s divine vision and leadership were instrumental in the conception and development of Marakatha Sri Lakshmi Ganapathi Devalayam. He guided every aspect of the temple—its Agamic architecture, ritual procedures, daily worship, festivals, and spiritual programs—ensuring strict adherence to Vedic and Agamic principles.

// **Spiritual Philosophy:**
// Shastry Garu emphasizes:
// 1. **Bhakti Marga:** Path of devotion through regular worship
// 2. **Jnana Marga:** Spiritual knowledge through Vedic study
// 3. **Seva:** Selfless service to society
// 4. **Samskaras:** Preserving traditional rituals

// **Other Contributions:**
// - Established Veda Patashala for young students
// - Regular spiritual discourses across India
// - Guidance for temple construction and restoration
// - Mentorship to hundreds of priests and scholars

// Through his inspiration, the Devalayam has become not only a place of worship but also a vibrant spiritual and cultural center, nurturing devotion, tradition, and service among devotees.
// ''',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _shareOnWhatsApp() async {
//     final url = 'https://wa.me/?text=${Uri.encodeComponent('Check out Marakatha Sri Lakshmi Ganapathi Devalayam App!')}';
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     }
//   }

//   Widget _buildAppBar() {
//     return AppBar(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.temple_hindu_rounded, color: Colors.orange),
//           const SizedBox(width: 8),
//           const Text(
//             'Marakatha Temple',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search, color: Colors.black54),
//           onPressed: () {},
//         ),
//         IconButton(
//           icon: const Icon(Icons.headphones, color: Colors.black54),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildTimelineNav() {
//     return Container(
//       height: _currentIndex == 0 ? 140 : 110,
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         border: Border(
//           bottom: BorderSide(color: Colors.grey[200]!, width: 1),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Section Tabs
//           SizedBox(
//             height: 60,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _sections.length,
//               itemBuilder: (context, index) {
//                 final section = _sections[index];
//                 return _buildSectionTab(section, index);
//               },
//             ),
//           ),
          
//           const SizedBox(height: 8),
          
//           // Current section subtitle
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               _sections[_currentIndex].subtitle,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//                 fontStyle: FontStyle.italic,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
          
//           // Timeline Visualization (only for sections with timeline)
//           if (_sections[_currentIndex].timelineEvents.isNotEmpty) ...[
//             const SizedBox(height: 8),
//             _buildTimelineVisualization(),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTab(TempleSection section, int index) {
//     final isSelected = _currentIndex == index;
//     final isHovered = _hoverIndex == index;
    
//     return MouseRegion(
//       onEnter: (_) => setState(() => _hoverIndex = index),
//       onExit: (_) => setState(() => _hoverIndex = -1),
//       child: GestureDetector(
//         onTap: () {
//           _pageController.animateToPage(
//             index,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeInOut,
//           );
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           decoration: BoxDecoration(
//             color: isSelected 
//                 ? section.color.withOpacity(0.15)
//                 : (isHovered ? section.color.withOpacity(0.05) : Colors.transparent),
//             borderRadius: BorderRadius.circular(25),
//             border: Border.all(
//               color: isSelected ? section.color : Colors.grey[300]!,
//               width: isSelected ? 2 : 1,
//             ),
//             boxShadow: isSelected 
//                 ? [
//                     BoxShadow(
//                       color: section.color.withOpacity(0.2),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     )
//                   ]
//                 : [],
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 section.icon,
//                 color: isSelected ? section.color : Colors.grey[600],
//                 size: 18,
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 _getShortTitle(section.title),
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   color: isSelected ? section.color : Colors.grey[700],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _getShortTitle(String title) {
//     final words = title.split(' ');
//     if (words.length > 3) {
//       return words.take(2).join(' ');
//     }
//     return title;
//   }

//   Widget _buildTimelineVisualization() {
//     final currentSection = _sections[_currentIndex];
    
//     return SizedBox(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: currentSection.timelineEvents.length,
//         itemBuilder: (context, index) {
//           final event = currentSection.timelineEvents[index];
//           return _buildTimelineNode(event, index, currentSection);
//         },
//       ),
//     );
//   }

//   Widget _buildTimelineNode(TimelineEvent event, int index, TempleSection section) {
//     return GestureDetector(
//       onTap: () {
//         // Show event details in a dialog
//         _showEventDetails(event);
//       },
//       child: Container(
//         width: 100,
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         child: Column(
//           children: [
//             // Timeline line and dot
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 2,
//                     color: Colors.grey[300],
//                   ),
//                 ),
//                 Container(
//                   width: 12,
//                   height: 12,
//                   decoration: BoxDecoration(
//                     color: section.color,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: section.color.withOpacity(0.5),
//                         blurRadius: 4,
//                         offset: const Offset(0, 1),
//                       )
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     height: 2,
//                     color: Colors.grey[300],
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 4),
            
//             // Year and title
//             Column(
//               children: [
//                 Text(
//                   event.year,
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: section.color,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   event.title.length > 15 
//                       ? '${event.title.substring(0, 15)}...' 
//                       : event.title,
//                   style: const TextStyle(
//                     fontSize: 9,
//                     color: Colors.grey,
//                   ),
//                   textAlign: TextAlign.center,
//                   maxLines: 1,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEventDetails(TimelineEvent event) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(event.title),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Chip(
//                 label: Text(
//                   event.year,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 backgroundColor: _sections[_currentIndex].color,
//               ),
//               const SizedBox(height: 12),
//               Text(event.details),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionContent(TempleSection section) {
//     return FadeTransition(
//       opacity: _fadeAnimation,
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Section Header
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: section.color.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(section.icon, color: section.color, size: 28),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       section.title,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: section.color,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 20),
              
//               // Section-specific content
//               _buildSectionSpecificContent(section),
              
//               const SizedBox(height: 30),
              
//               // Additional widgets based on section type
//               if (section.deities != null) _buildDeitiesGrid(section.deities!),
//               if (section.trustees != null) _buildTrusteesList(section.trustees!),
              
//               // Audio Player
//               if (section.hasAudio) _buildAudioPlayer(),
              
//               // Download Button
//               if (section.hasDownload) _buildDownloadButton(section),
              
//               // Share Button
//               _buildShareButton(),
              
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionSpecificContent(TempleSection section) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Main content
//         Text(
//           section.content,
//           style: const TextStyle(
//             fontSize: 14,
//             height: 1.6,
//             color: Colors.black87,
//           ),
//         ),
        
//         const SizedBox(height: 20),
        
//         // Detailed timeline for history section
//         if (section.id == 0) _buildDetailedTimeline(section),
        
//         // Virtual tour for architecture section
//         if (section.id == 2) _buildVirtualTourButton(),
//       ],
//     );
//   }

//   Widget _buildDetailedTimeline(TempleSection section) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Historical Timeline',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...section.timelineEvents.map((event) => _buildTimelineCard(event, section)),
//         const SizedBox(height: 16),
//         ElevatedButton.icon(
//           onPressed: () {
//             // Download historical notes
//             _downloadPDF();
//           },
//           icon: const Icon(Icons.download_rounded, size: 18),
//           label: const Text('Download Historical Notes (PDF)'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: section.color,
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimelineCard(TimelineEvent event, TempleSection section) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: section.color.withOpacity(0.2), width: 1),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: section.color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: section.color.withOpacity(0.3)),
//               ),
//               child: Text(
//                 event.year,
//                 style: TextStyle(
//                   color: section.color,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     event.title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     event.details,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Colors.black54,
//                       height: 1.4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDeitiesGrid(List<Deity> deities) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Deities',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 1.2,
//           ),
//           itemCount: deities.length,
//           itemBuilder: (context, index) {
//             final deity = deities[index];
//             return _buildDeityCard(deity);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDeityCard(Deity deity) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               deity.icon,
//               style: const TextStyle(fontSize: 32),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               deity.name,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               deity.description,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTrusteesList(List<Trustee> trustees) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Trust Board Members',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ...trustees.map((trustee) => _buildTrusteeCard(trustee)),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: () {
//             // Download reports
//             _downloadReports();
//           },
//           child: const Text('Download Annual Reports'),
//         ),
//       ],
//     );
//   }

//   Widget _buildTrusteeCard(Trustee trustee) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: _sections[_currentIndex].color.withOpacity(0.1),
//           child: Icon(
//             Icons.person_rounded,
//             color: _sections[_currentIndex].color,
//           ),
//         ),
//         title: Text(
//           trustee.name,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(trustee.position),
//             Text(
//               trustee.contact,
//               style: const TextStyle(fontSize: 11, color: Colors.blue),
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.email_rounded, size: 20),
//           onPressed: () {
//             _sendEmail(trustee.contact);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildVirtualTourButton() {
//     return Center(
//       child: ElevatedButton.icon(
//         onPressed: () {
//           // Start virtual tour
//           _startVirtualTour();
//         },
//         icon: const Icon(Icons.visibility_rounded),
//         label: const Text('Start Virtual 360° Tour'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _sections[_currentIndex].color,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(25),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAudioPlayer() {
//     return Card(
//       color: Colors.orange[50],
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Listen to the Legend',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Audio narration available in Telugu',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Play audio
//                 _playAudio();
//               },
//               icon: const Icon(Icons.play_arrow_rounded),
//               label: const Text('Play Audio'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDownloadButton(TempleSection section) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Download Resources',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'PDF documents and reports',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//             ElevatedButton.icon(
//               onPressed: () {
//                 _downloadPDF();
//               },
//               icon: const Icon(Icons.download_rounded),
//               label: const Text('Download'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: section.color,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildShareButton() {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Share with Devotees',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Spread the divine message',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: Image.asset(
//                 'assets/whatsapp.png', // Add WhatsApp icon to assets
//                 width: 32,
//                 height: 32,
//               ),
//               onPressed: _shareOnWhatsApp,
//             ),
//             IconButton(
//               icon: const Icon(Icons.share_rounded, color: Colors.green),
//               onPressed: _shareOnWhatsApp,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _downloadPDF() async {
//     // Simulate download
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Downloading PDF...'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _downloadReports() async {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Downloading annual reports...'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _playAudio() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Playing audio narration...'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _startVirtualTour() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Starting virtual tour...'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _sendEmail(String email) async {
//     final url = 'mailto:$email';
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('About Us'),
//       ),
//       body: Column(
//         children: [
//           // Horizontal Timeline Navigation
//           _buildTimelineNav(),
          
//           // Main Content Area with PageView
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               itemCount: _sections.length,
//               onPageChanged: (index) {
//                 setState(() {
//                   _currentIndex = index;
//                   _animationController.reset();
//                   _animationController.forward();
//                 });
//               },
//               itemBuilder: (context, index) {
//                 return _buildSectionContent(_sections[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//       // Floating action button for quick actions
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Quick actions menu
//           _showQuickActions();
//         },
//         backgroundColor: _sections[_currentIndex].color,
//         child: const Icon(Icons.menu_rounded, color: Colors.white),
//       ),
//     );
//   }

//   void _showQuickActions() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.directions_rounded, color: _sections[_currentIndex].color),
//                 title: const Text('Get Directions'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _getDirections();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.schedule_rounded, color: _sections[_currentIndex].color),
//                 title: const Text('Temple Timings'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showTempleTimings();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.event_rounded, color: _sections[_currentIndex].color),
//                 title: const Text('Upcoming Events'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showUpcomingEvents();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.volunteer_activism_rounded, color: _sections[_currentIndex].color),
//                 title: const Text('Donate'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _openDonation();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _getDirections() {
//     // Open maps
//   }

//   void _showTempleTimings() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Temple Timings'),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Morning: 6:00 AM - 12:00 PM'),
//             Text('Evening: 4:00 PM - 8:00 PM'),
//             SizedBox(height: 12),
//             Text('Special Days:'),
//             Text('• Fridays: 5:30 AM - 9:00 PM'),
//             Text('• Festivals: 4:30 AM - 10:00 PM'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showUpcomingEvents() {
//     // Show events dialog
//   }

//   void _openDonation() {
//     // Open donation page
//   }
// }