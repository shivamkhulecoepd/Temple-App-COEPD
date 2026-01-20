import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrasadamBasketScreen extends StatefulWidget {
  const PrasadamBasketScreen({super.key});

  @override
  State<PrasadamBasketScreen> createState() => _PrasadamBasketScreenState();
}

class _PrasadamBasketScreenState extends State<PrasadamBasketScreen> {
  final List<PrasadamItem> _cartItems = [
    PrasadamItem(
      id: 1,
      name: 'Laddu',
      description: 'Sweet round offering',
      price: 25.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 2,
    ),
    PrasadamItem(
      id: 2,
      name: 'Pongal',
      description: 'Rice and lentil dish',
      price: 30.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 1,
    ),
    PrasadamItem(
      id: 3,
      name: 'Vada',
      description: 'Savory fried snack',
      price: 15.0,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c1/Laddu_Sweet.JPG',
      quantity: 3,
    ),
  ];

  double get _subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get _deliveryCharge {
    return _subtotal > 0 ? 20.0 : 0.0; // Fixed delivery charge
  }

  double get _totalAmount {
    return _subtotal + _deliveryCharge;
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _addMoreItems() {
    Navigator.pop(context); // Go back to prasadam menu
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your basket is empty'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to checkout screen
    print('Proceeding to checkout with ${_cartItems.length} items');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
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
          'Prasadam Basket',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Cart Items List
          Expanded(
            child: _cartItems.isEmpty
                ? _buildEmptyBasket()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCartItemCard(_cartItems[index], index),
                      );
                    },
                  ),
          ),

          // Price Summary and Buttons
          if (_cartItems.isNotEmpty) _buildPriceSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyBasket() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Your basket is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some delicious prasadam items',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _addMoreItems,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Add Prasadam Items'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(PrasadamItem item, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            Container(
              width: 100.sp,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),
                  Text(
                    '₹${item.price.toStringAsFixed(2)} × ${item.quantity} = ₹${(item.price * item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Quantity Controls and Remove
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remove Button
                IconButton(
                  onPressed: () => _removeItem(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 22.sp,
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
                          color: item.quantity > 1
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
                        style: TextStyle(
                          fontSize: 14.sp,
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
                        constraints: BoxConstraints(
                          minWidth: 32.sp,
                          minHeight: 32.sp,
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
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Price Breakdown
          _buildPriceRow('Subtotal', _subtotal),
          const SizedBox(height: 8),
          _buildPriceRow('Delivery Charges', _deliveryCharge),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          _buildPriceRow('Total Amount', _totalAmount, isTotal: true),
          const SizedBox(height: 20),

          // Buttons
          Row(
            children: [
              // Add More Button
              Expanded(
                child: OutlinedButton(
                  onPressed: _addMoreItems,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange.shade700,
                    side: BorderSide(color: Colors.orange.shade700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Add More',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Proceed to Checkout Button
              Expanded(
                child: ElevatedButton(
                  onPressed: _proceedToCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade700,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.orange : Colors.black,
          ),
        ),
      ],
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
