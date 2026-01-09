import 'package:flutter/material.dart';
import 'package:temple_app/screens/previous/book_pooja.dart';
import 'package:temple_app/screens/previous/devoteesdetails_screen.dart';
import 'package:temple_app/screens/previous/donation_screen.dart';
import 'package:temple_app/screens/previous/livedarshan_screen.dart';
import 'package:temple_app/screens/previous/panchangan_screen.dart';
import 'package:temple_app/screens/previous/poojadetails_screen.dart';
import 'package:temple_app/screens/previous/prasadambasket_screen.dart';
import 'package:temple_app/screens/previous/prasadammenu_screen.dart';
import 'package:temple_app/screens/previous/templecalender_screen.dart';

class OldScreensNavigations extends StatelessWidget {
  const OldScreensNavigations({super.key});

  @override
  Widget build(BuildContext context) {
    // Mapping your files to readable titles and icons
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Book Pooja', 'icon': Icons.menu_book, 'screen': const BookPoojaScreen()},
      {'title': 'Devotee Details', 'icon': Icons.people, 'screen': const DevoteesDetailsScreen()},
      {'title': 'Donation', 'icon': Icons.volunteer_activism, 'screen': const DonationScreen()},
      {'title': 'Live Darshan', 'icon': Icons.videocam, 'screen': const LiveDarshanScreen()},
      {'title': 'Panchangam', 'icon': Icons.calendar_month, 'screen': const PanchangamScreen()},
      {'title': 'Pooja Details', 'icon': Icons.info_outline, 'screen': const PujaDetailsScreen()},
      {'title': 'Prasadam Basket', 'icon': Icons.shopping_basket, 'screen': const PrasadamBasketScreen()},
      {'title': 'Prasadam Menu', 'icon': Icons.restaurant_menu, 'screen': const PrasadamMenuScreen()},
      {'title': 'Temple Calendar', 'icon': Icons.event_note, 'screen': const TempleCalendarScreen()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Temple Services'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 buttons per row
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.1, // Adjust for button height
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => menuItems[index]['screen']),
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(menuItems[index]['icon'], size: 40, color: Colors.orange.shade800),
                    const SizedBox(height: 10),
                    Text(
                      menuItems[index]['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}