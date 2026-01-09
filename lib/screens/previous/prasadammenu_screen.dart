import 'package:flutter/material.dart';
import 'package:temple_app/screens/previous/prasadambasket_screen.dart';

class PrasadamMenuScreen extends StatefulWidget {
  const PrasadamMenuScreen({super.key});

  @override
  State<PrasadamMenuScreen> createState() => _PrasadamMenuScreenState();
}

class _PrasadamMenuScreenState extends State<PrasadamMenuScreen> {
  final List<PrasadamItem> _prasadamItems = [
    PrasadamItem(
      id: 1,
      name: 'Laddu',
      description: 'Sweet round offering',
      price: 25.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 0,
    ),
    PrasadamItem(
      id: 2,
      name: 'Pongal',
      description: 'Rice and lentil dish',
      price: 30.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 0,
    ),
    PrasadamItem(
      id: 3,
      name: 'Pulihora',
      description: 'Tamarind rice',
      price: 20.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 0,
    ),
    PrasadamItem(
      id: 4,
      name: 'Vada',
      description: 'Savory fried snack',
      price: 15.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 0,
    ),
    PrasadamItem(
      id: 5,
      name: 'Payasam',
      description: 'Sweet milk pudding',
      price: 35.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 0,
    ),
    PrasadamItem(
      id: 6,
      name: 'Appam',
      description: 'Sweet hoppers',
      price: 40.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 0,
    ),
  ];

  int _cartItemCount = 0;

  void _incrementQuantity(int index) {
    setState(() {
      _prasadamItems[index].quantity++;
      _updateCartCount();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_prasadamItems[index].quantity > 0) {
        _prasadamItems[index].quantity--;
        _updateCartCount();
      }
    });
  }

  void _updateCartCount() {
    _cartItemCount = _prasadamItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get _totalPrice {
    return _prasadamItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void _viewCart() {
    if (_cartItemCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show cart dialog or navigate to cart screen
    showDialog(context: context, builder: (context) => _buildCartDialog());
  }

  Widget _buildCartDialog() {
    return AlertDialog(
      title: const Text('Your Prasadam Cart'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Items: $_cartItemCount'),
          Text('Total Amount: ₹${_totalPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          ..._prasadamItems
              .where((item) => item.quantity > 0)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.name} (${item.quantity})'),
                      Text(
                        '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Continue Shopping'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Navigate to checkout screen
          },
          child: const Text('Proceed to Checkout'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Prasadam Menu',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Implement search functionality
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrasadamBasketScreen(),
                    ),
                  );
                },
              ),
              if (_cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _prasadamItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildHorizontalPrasadamCard(_prasadamItems[index], index),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalPrasadamCard(PrasadamItem item, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 140, // Slightly taller for better content spacing
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Content and Controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Section - Name and Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Section - Price and Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '₹${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),

                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _decrementQuantity(index),
                              icon: Icon(
                                Icons.remove,
                                color: item.quantity > 0
                                    ? Colors.orange
                                    : Colors.grey,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _incrementQuantity(index),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.orange,
                                size: 18,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrasadamItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  int quantity;

  PrasadamItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
}
