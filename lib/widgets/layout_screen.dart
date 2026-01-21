import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/screens/dashboard/contact_info_screen.dart';
import 'package:temple_app/screens/dashboard/donations_screen.dart';
import 'package:temple_app/screens/dashboard/home_screen.dart';
import 'package:temple_app/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:temple_app/screens/dashboard/user_dashbaord_screen.dart';
import 'package:temple_app/widgets/translated_text.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  // 1. Define the PageController
  late PageController _pageController;

  // List of pages to display for each tab
  final List<Widget> _pages = [
    // const Center(child: Text('Home Content')),
    const HomeScreen(),
    // const Center(child: Text('Donations Content')),
    const DonationsScreen(),
    // const Center(child: Text('Live Content')),
    const SevaLiveDarshanScreen(),
    // const Center(child: Text('Contact Content')),
    const ContactScreen(),
    // const Center(child: Text('Profile Content')),
    const UserDashboard(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Always dispose controllers
    super.dispose();
  }

  // 2. Handle Tap (Sync Bar -> Page)
  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // 3. Replace IndexedStack with PageView
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // 4. Handle Swipe (Sync Page -> Bar)
          setState(() => _selectedIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: _buildEnhancedBottomBar(),
    );
  }

  Widget _buildEnhancedBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final items = [
            (Icons.home_rounded, "Home", 0),
            (Icons.volunteer_activism_rounded, "Donations", 1),
            (Icons.live_tv_rounded, "Live Stream", 2),
            (Icons.quick_contacts_mail_rounded, "Contact", 3),
            (Icons.person_rounded, "Profile", 4),
          ];

          final (icon, label, idx) = items[index];

          return Expanded(child: _buildNavItem(idx, icon, label));
        }),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.orange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.orange : Colors.grey[400],
              size: isSelected ? 26.r : 24.r,
            ),
            SizedBox(height: 3.h),
            TranslatedText(
              label,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 10.5.sp, // ← slightly smaller helps a lot
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.orange : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
