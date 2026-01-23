import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/screens/dashboard/donations_screen.dart';
import 'package:mslgd/screens/dashboard/seva_livedarshan_screen.dart';
import 'package:mslgd/screens/navigation/accommodation_screen.dart';
import 'package:mslgd/screens/navigation/donation_prasadam_scree.dart';
import 'package:mslgd/screens/user/booking_history_screen.dart';
import 'package:mslgd/screens/user/my_donations_screen.dart';
import 'package:mslgd/screens/user/user_profile_screen.dart';
import 'package:mslgd/widgets/translated_text.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => UserDashboardState();
}

class UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? theme.scaffoldBackgroundColor
              : const Color(0xFFF0F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFF8B0000), // Deep red from image
            title: TranslatedText(
              'Devotee Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'aBeeZee',
              ),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white, size: 24.w),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            elevation: 0,
          ),
          drawer: _buildDrawer(theme, isDark),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDark ? theme.cardColor : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TranslatedText(
                              'Welcome, Shivam Khule 🙏',
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF8B0000),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        TranslatedText(
                          'This is your devotee dashboard. From here, you can view your profile, check your pooja bookings, and manage your temple activities.',
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Cards Grid - Responsive Wrap for mobile
                  Wrap(
                    spacing: 16.w,
                    runSpacing: 16.h,
                    children: [
                      _buildDashboardCard(
                        title: 'Seva & Darshan',
                        subtitle: 'Book temple seva and darshan slot',
                        buttonText: 'Book Now',
                        buttonColor: const Color(0xFF8B0000),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SevaLiveDarshanScreen(),
                            ),
                          );
                        },
                        theme: theme,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: 'Accommodation',
                        subtitle: 'Book temple accommodation facilities',
                        buttonText: 'Book Now',
                        buttonColor: const Color(0xFF8B0000),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => AccommodationScreen(initialSection: AccommodationSection.accommodationBooking)));
                        },
                        theme: theme,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: 'Donation',
                        subtitle: 'Support temple activities and services',
                        buttonText: 'Donate Now',
                        buttonColor: const Color(0xFF8B0000),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DonationsScreen(),
                            ),
                          );
                        },
                        theme: theme,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: 'Publication',
                        subtitle: 'Subscribe to temple publications',
                        buttonText: 'Subscribe',
                        buttonColor: const Color(0xFF8B0000),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DonationsPrasadamScreen(
                                initialSection: DonationSection.publications,
                              ),
                            ),
                          );
                        },
                        theme: theme,
                        isDark: isDark,
                      ),
                      _buildDashboardCard(
                        title: 'E-Hundi',
                        subtitle: 'Offer your donations online',
                        buttonText: 'Donate Now',
                        buttonColor: const Color(0xFF8B0000),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DonationsPrasadamScreen(
                                initialSection: DonationSection.eHundi,
                              ),
                            ),
                          );
                        },
                        theme: theme,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Drawer (Sidebar for mobile)
  Drawer _buildDrawer(ThemeData theme, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? theme.cardColor : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: const Color(0xFF8B0000)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/about/temple_logo.png',
                  height: 70.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.h),
                TranslatedText(
                  'Devotee Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'aBeeZee',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _drawerItem(
            'Dashboard',
            Icons.dashboard,
            () => Navigator.pop(context),
          ),
          _drawerItem('Profile', Icons.person, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserProfileScreen()),
            );
          }),
          _drawerItem('Booking History', Icons.history, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookingHistoryScreen()),
            );
          }),
          _drawerItem('My Donations', Icons.monetization_on, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserDonationsScreen()),
            );
          }),
          const Divider(),
          _drawerItem('Logout', Icons.logout, () {
            Navigator.pop(context);
            // AuthService.logout(context);
          }),
        ],
      ),
    );
  }

  ListTile _drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B0000)),
      title: TranslatedText(
        title,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required Color buttonColor,
    required VoidCallback onPressed,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      width: (ScreenUtil().screenWidth - 48.w) / 2, // 2-column grid on mobile
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            '$title\n',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF8B0000),
            ),
            maxLines: 2,
          ),
          SizedBox(height: 8.h),
          TranslatedText(
            '$subtitle\n',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 13.sp,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 2,
              ),
              child: TranslatedText(
                buttonText,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
