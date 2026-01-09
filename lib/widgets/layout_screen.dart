import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/screens/dashboard/home_screen.dart';

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
    const Center(child: Text('Seva Content')),
    const Center(child: Text('Live Content')),
    const Center(child: Text('Contact Content')),
    const Center(child: Text('Profile Content')),
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
      padding: EdgeInsets.symmetric(vertical: 8.h),
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, "Home"),
          _buildNavItem(1, Icons.auto_awesome_rounded, "Seva"),
          _buildNavItem(2, Icons.live_tv_rounded, "Live"),
          _buildNavItem(3, Icons.quick_contacts_mail_rounded, "Contact"),
          _buildNavItem(4, Icons.person_rounded, "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTap(index), // Use the new sync tap method
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
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
              size: isSelected ? 28.r : 24.r,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.orange : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:temple_app/screens/dashboard/home_screen.dart';

// class LayoutScreen extends StatefulWidget {
//   const LayoutScreen({super.key});

//   @override
//   State<LayoutScreen> createState() => _LayoutScreenState();
// }

// class _LayoutScreenState extends State<LayoutScreen> {
//   int _selectedIndex = 0;

//   // List of pages to display for each tab
//   final List<Widget> _pages = [
//     // const Center(child: Text('Home Content')),
//     const HomeScreen(),
//     const Center(child: Text('Pooja Content')),
//     const Center(child: Text('Donations Content')),
//     const Center(child: Text('Gallery Content')),
//     const Center(child: Text('Profile Content')),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true, // Crucial for the floating effect
//       body: IndexedStack(index: _selectedIndex, children: _pages),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       color: Theme.of(context).colorScheme.surface,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(0, Icons.home_rounded, "Home"),
//           _buildNavItem(1, Icons.auto_awesome_mosaic_rounded, "Pooja"),
//           _buildNavItem(2, Icons.volunteer_activism_rounded, "Donate"),
//           _buildNavItem(3, Icons.photo_library_rounded, "Gallery"),
//           _buildNavItem(4, Icons.person_rounded, "Profile"),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, IconData icon, String label) {
//     bool isSelected = _selectedIndex == index;

//     return GestureDetector(
//       onTap: () => setState(() => _selectedIndex = index),
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//         decoration: BoxDecoration(
//           // Soft highlight background for selected item
//           color: isSelected
//               ? Colors.orange.withOpacity(0.1)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.orange : Colors.grey[400],
//               size: isSelected ? 28.r : 24.r, // Subtle scaling effect
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? Colors.orange : Colors.grey[500],
//                 fontFamily: 'aBeeZee',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
