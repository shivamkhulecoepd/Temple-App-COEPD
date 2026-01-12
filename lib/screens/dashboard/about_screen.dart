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
              _getSectionByIndex(_currentIndex).subtitle,
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
              imageUrl:
                  'https://images.unsplash.com/photo-1613483836768-66fbfc8d3b6d?w=800', // Lakshmi Ganesh beautiful murti
            ),
            Deity(
              name: 'Sri Anjaneya Swamy',
              description: 'Protector and obstacle remover, south-facing deity',
              icon: '🐒',
              imageUrl:
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800', // Classic Hanuman photo
            ),
            Deity(
              name: 'Sri Navagraha',
              description:
                  'Celestial influence and remedies for planetary positions',
              icon: '☀️',
              imageUrl:
                  'https://i.imgur.com/0mK9v7v.jpg', // Navagraha realistic
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
          images: [
            TempleImageInfo(
              url:
                  'https://images.unsplash.com/photo-1580130718646-9f694209b207?w=1200',
              caption: 'Main Rajagopuram - South Indian style',
            ),
            TempleImageInfo(
              url:
                  'https://images.unsplash.com/photo-1599669454699-248893623440?w=1200',
              caption: 'Maha Mandapam with carved pillars',
            ),
            TempleImageInfo(
              url:
                  'https://images.unsplash.com/photo-1620736686487-4e8d0a7d3b5a?w=800',
              caption: 'Sacred Temple Pushkarini (Tank)',
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
          images: [
            TempleImageInfo(
              url:
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
              caption: 'Vedic scholar performing traditional rituals',
            ),
            TempleImageInfo(
              url:
                  'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
              caption: 'Spiritual discourse with devotees',
            ),
            TempleImageInfo(
              url:
                  'https://images.unsplash.com/photo-1584553421349-355a77773a3e?w=800',
              caption: 'Priest during important temple ceremony',
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
                    section.color.withOpacity(0.1),
                    section.color.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: section.color.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: section.color,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'A journey through time and tradition',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            _buildAuthCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              'Historical Timeline',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.asMap().entries.map((entry) {
              int index = entry.key;
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
                        child: Text(
                          event.year,
                          style: TextStyle(
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
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.r),
                            bottomLeft: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),
                          ),
                          border: Border.all(
                            color: section.color.withOpacity(0.3),
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: textDark,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              event.details,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: textMuted,
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
                    Color(0xFF8E44AD).withOpacity(0.1),
                    Color(0xFF9B59B6).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Color(0xFF8E44AD).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8E44AD),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Sacred forms of divinity',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            _buildAuthCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              'Sacred Deities',
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
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFF8E44AD).withOpacity(0.3),
                      width: 1.w,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        // Show deity image if available, otherwise show the icon
                        if (deity.imageUrl != null &&
                            deity.imageUrl!.isNotEmpty)
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Color(0xFF8E44AD).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF8E44AD),
                                width: 1.w,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(deity.imageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Color(0xFF8E44AD).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF8E44AD),
                                width: 1.w,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                deity.icon,
                                style: TextStyle(fontSize: 30.sp),
                              ),
                            ),
                          ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                deity.name,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                deity.description,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: textMuted,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 16.h),
            Text(
              'Daily Rituals',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.map(
              (event) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFF8E44AD).withOpacity(0.3),
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
                            color: Color(0xFF8E44AD).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Color(0xFF8E44AD),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            event.year,
                            style: TextStyle(
                              color: Color(0xFF8E44AD),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      event.details,
                      style: TextStyle(fontSize: 12.sp, color: textMuted),
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
                    Color(0xFF27AE60).withOpacity(0.1),
                    Color(0xFF2ECC71).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Color(0xFF27AE60).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Sacred architecture and spiritual spaces',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            _buildAuthCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
              ),
            ),

            // Show images if available
            if (section.images != null && section.images!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Architectural Highlights',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              SizedBox(height: 12.h),
              ...section.images!.map(
                (imageInfo) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFF27AE60).withOpacity(0.3),
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
                            image: DecorationImage(
                              image: NetworkImage(imageInfo.url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Text(
                            imageInfo.caption,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: textDark,
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
            Text(
              'Architectural Features',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.map(
              (feature) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFF27AE60).withOpacity(0.3),
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
                        Text(
                          feature.title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: textDark,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      feature.year,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFF27AE60),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text(
                          feature.details,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: textMuted,
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
                    Color(0xFF2980B9).withOpacity(0.1),
                    Color(0xFF3498DB).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Color(0xFF2980B9).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2980B9),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Management and governance',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            _buildAuthCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              'Trust Board Members',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.trustees!.map(
              (trustee) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFF2980B9).withOpacity(0.3),
                    width: 1.w,
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF2980B9).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF2980B9), width: 1.w),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF2980B9),
                      size: 24.sp,
                    ),
                  ),
                  title: Text(
                    trustee.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: textDark,
                    ),
                  ),
                  subtitle: Text(
                    trustee.position,
                    style: TextStyle(fontSize: 12.sp, color: textMuted),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.email,
                      color: Color(0xFF2980B9),
                      size: 20.sp,
                    ),
                    onPressed: () => _sendEmail(trustee.contact),
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
                    Color(0xFFC0392B).withOpacity(0.1),
                    Color(0xFFE74C3C).withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Color(0xFFC0392B).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  TranslatedText(
                    section.title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC0392B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Spiritual mentor and guiding force',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Show images if available
            if (section.images != null && section.images!.isNotEmpty) ...[
              ...section.images!.map(
                (imageInfo) => Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Color(0xFFC0392B).withOpacity(0.3),
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
                            image: DecorationImage(
                              image: NetworkImage(imageInfo.url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Text(
                            imageInfo.caption,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
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
                  color: Color(0xFFC0392B).withOpacity(0.1),
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

            _buildAuthCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              'Academic Journey',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            ...section.timelineEvents.map(
              (milestone) => Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Color(0xFFC0392B).withOpacity(0.3),
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
                        color: Color(0xFFC0392B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Color(0xFFC0392B),
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        milestone.year,
                        style: TextStyle(
                          color: Color(0xFFC0392B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      milestone.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      milestone.details,
                      style: TextStyle(fontSize: 12.sp, color: textMuted),
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
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            SizedBox(height: 12.h),

            _buildAuthCard(
              child: Text(
                section.content,
                style: TextStyle(fontSize: 14.sp, height: 1.6, color: textDark),
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

  // ---------------- DEITIES GRID FOR DEFAULT CONTENT ----------------

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
            return _buildAuthCard(
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

  // ---------------- TRUSTEES LIST FOR DEFAULT CONTENT ----------------

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
          (t) => _buildAuthCard(
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

  // ---------------- AUDIO / DOWNLOAD CARDS ----------------

  Widget _buildAudioCard() => _buildAuthCard(
    child: ElevatedButton.icon(
      style: _primaryButtonStyle(),
      onPressed: _playAudio,
      icon: const Icon(Icons.play_arrow),
      label: const Text('Play Audio'),
    ),
  );

  Widget _buildDownloadCard() => _buildAuthCard(
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
      ),
    );
  }
}
