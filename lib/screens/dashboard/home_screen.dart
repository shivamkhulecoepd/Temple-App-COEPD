import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:temple_app/screens/dashboard/book_pooja.dart';
import 'package:temple_app/screens/dashboard/donation_screen.dart';
import 'package:temple_app/screens/dashboard/livedarshan_screen.dart';
import 'package:temple_app/screens/dashboard/panchangan_screen.dart';
import 'package:temple_app/screens/dashboard/prasadammenu_screen.dart';
import 'package:temple_app/screens/dashboard/templecalender_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToLiveDarshan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LiveDarshanScreen()),
    );
  }

  void _navigateToLivebookpooja() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookPoojaScreen()),
    );
  }

  void _navigateToprasadamitems() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrasadamMenuScreen()),
    );
  }

  // TempleCalendarScreen(),
  void _navigatecalender() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TempleCalendarScreen()),
    );
  }

  void _navigatedonation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DonationScreen()),
    );
  }

  void _navigatepanchangan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PanchangamScreen()),
    );
  }

  List<ServiceItem> get _serviceItems => [
    ServiceItem(
      image: 'assets/images/tv.png',
      title: 'Daily Darshan',
      subtitle: 'Live temple view',
      ontap: _navigateToLiveDarshan,
    ),
    ServiceItem(
      image: 'assets/images/kalasha.png',
      title: 'Book Pooja',
      subtitle: 'Schedule a ritual',
      ontap: _navigateToLivebookpooja,
    ),
    ServiceItem(
      image: 'assets/images/kindness.png',
      title: 'Book Seva',
      subtitle: 'Offer a service',
    ),
    ServiceItem(
      image: 'assets/images/cutlery.png',
      title: 'Prasadam',
      subtitle: 'Order blessed food',
      ontap: _navigateToprasadamitems,
    ),
    ServiceItem(
      image: 'assets/images/donation.png',
      title: 'Donation',
      subtitle: 'Contribute to temple',
      ontap: _navigatedonation,
    ),
    ServiceItem(
      image: 'assets/images/calendar.png',
      title: 'Calendar',
      subtitle: 'Important dates',
      ontap: _navigatecalender,
    ),
    ServiceItem(
      image: 'assets/images/anahata.png',
      title: 'Panchangam',
      subtitle: 'Vedic almanac',
      ontap: _navigatepanchangan,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        214,
        210,
        210,
      ).withValues(alpha: 0.999),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent.withValues(alpha: 0.4),
        foregroundColor: Color.fromARGB(255, 77, 7, 5),
        title: Text(
          'Deva Seva',
          style: TextStyle(
            fontSize: 20.sp,
            color: Color.fromARGB(255, 77, 7, 5),
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              size: 24.sp,
              color: Color.fromARGB(255, 77, 7, 5),
            ),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Om Namah Shivay Text
              Center(
                child: Text(
                  'Om Namah Shivaya',
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: Color.fromARGB(255, 77, 7, 5),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30.h),
              // GridView of Service Items
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.9,
                ),
                itemCount: _serviceItems.length,
                itemBuilder: (context, index) {
                  return _buildServiceCard(_serviceItems[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceItem item) {
    return GestureDetector(
      onTap: item.ontap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 239, 218),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromARGB(255, 187, 182, 182)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image instead of Icon
              Image.asset(
                item.image,
                height: 40.h,
                width: 40.w,
                color: Color.fromARGB(255, 77, 7, 5), // You
              ),
              SizedBox(height: 12.h),
              // Title
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color.fromARGB(255, 77, 7, 5),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              // Subtitle
              Text(
                item.subtitle,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceItem {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? ontap;

  ServiceItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.ontap,
  });
}
