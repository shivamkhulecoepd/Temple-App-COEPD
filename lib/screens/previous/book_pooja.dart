import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:temple_app/screens/previous/poojadetails_screen.dart';

class BookPoojaScreen extends StatefulWidget {
  const BookPoojaScreen({super.key});

  @override
  State<BookPoojaScreen> createState() => _BookPoojaScreenState();
}

class _BookPoojaScreenState extends State<BookPoojaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Book Pooja',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [
                _buildItemContainer(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Vitthal_-_Rakhumai.jpg/250px-Vitthal_-_Rakhumai.jpg',
                  title: 'Special Pooja Package',
                  description:
                      'Complete traditional pooja with flowers, fruits, and special rituals performed by experienced priests.',
                  price: '\$49.99',
                  onBookPressed: () {
                    log('Book button pressed');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PujaDetailsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildItemContainer(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Vitthal_-_Rakhumai.jpg/250px-Vitthal_-_Rakhumai.jpg',
                  title: 'Special Pooja Package',
                  description:
                      'Complete traditional pooja with flowers, fruits, and special rituals performed by experienced priests.',
                  price: '\$49.99',
                  onBookPressed: () {
                    log('Book button pressed');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PujaDetailsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildItemContainer(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Vitthal_-_Rakhumai.jpg/250px-Vitthal_-_Rakhumai.jpg',
                  title: 'Special Pooja Package',
                  description:
                      'Complete traditional pooja with flowers, fruits, and special rituals performed by experienced priests.',
                  price: '\$49.99',
                  onBookPressed: () {
                    log('Book button pressed');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PujaDetailsScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                _buildItemContainer(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Vitthal_-_Rakhumai.jpg/250px-Vitthal_-_Rakhumai.jpg',
                  title: 'Special Pooja Package',
                  description:
                      'Complete traditional pooja with flowers, fruits, and special rituals performed by experienced priests.',
                  price: '\$49.99',
                  onBookPressed: () {
                    log('Book button pressed');
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemContainer({
    required String imageUrl,
    required String title,
    required String description,
    required String price,
    required VoidCallback onBookPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section (Half height of container)
          Container(
            height: 120.sp, // You can adjust this based on your needs
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl), // or AssetImage for local images
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20), // Description (2 lines)
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 20),
                // Price and Book Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price on left corner
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onBookPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      child: Text(
                        'Book now',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
