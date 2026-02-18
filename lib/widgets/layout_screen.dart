import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/screens/dashboard/contact_info_screen.dart';
import 'package:mslgd/screens/dashboard/donations_screen.dart';
import 'package:mslgd/screens/dashboard/home_screen.dart';
import 'package:mslgd/screens/dashboard/new_home_screen.dart';
import 'package:mslgd/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:mslgd/screens/dashboard/user_dashbaord_screen.dart';
import 'package:mslgd/widgets/translated_text.dart';

class LayoutScreen extends StatefulWidget {
  final int? index;
  const LayoutScreen({super.key, this.index});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  // 1. Define the PageController
  late PageController _pageController;
  bool _isDisposed = false; // Add disposed flag

  // List of pages to display for each tab
  final List<Widget> _pages = [
    // const HomeScreen(),
    const TempleHomeScreen(),
    const DonationsScreen(),
    const SevaLiveDarshanScreen(),
    const ContactScreen(),
    const UserDashboard(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _isDisposed = true; // Set flag first
    _pageController.dispose(); // Always dispose controllers
    super.dispose();
  }

  // 2. Handle Tap (Sync Bar -> Page)
  void _onTap(int index) {
    if (_isDisposed) return; // Check if disposed
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink(); // Return empty widget if disposed
    }

    return Scaffold(
      extendBody: true,
      // 3. Replace IndexedStack with PageView
      body: SafeArea(
        top: false,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // 4. Handle Swipe (Sync Page -> Bar)
            if (!_isDisposed) {
              setState(() => _selectedIndex = index);
            }
          },
          children: _pages,
        ),
      ),
      bottomNavigationBar: _buildEnhancedBottomBar(),
    );
  }

  Widget _buildEnhancedBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6.h.clamp(4.0, 12.0),
        horizontal: 8.w.clamp(4.0, 16.0),
      ),
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
        padding: EdgeInsets.symmetric(
          horizontal: 4.w.clamp(2.0, 8.0),
          vertical: 6.h.clamp(4.0, 10.0),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r.clamp(8.0, 20.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey[400],
              size: (isSelected ? 26.r : 24.r).clamp(20.0, 30.0),
            ),
            SizedBox(height: 3.h.clamp(2.0, 6.0)),
            TranslatedText(
              label,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 10.5.sp.clamp(9.0, 12.0),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey[600],
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
