import 'dart:developer';

import 'package:flutter/material.dart';

class DevoteesDetailsScreen extends StatefulWidget {
  const DevoteesDetailsScreen({super.key});

  @override
  State<DevoteesDetailsScreen> createState() => _DevoteesDetailsScreenState();
}

class _DevoteesDetailsScreenState extends State<DevoteesDetailsScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _gotraController = TextEditingController();
  final TextEditingController _nakshatraController = TextEditingController();

  final List<FamilyMember> _familyMembers = [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _gotraController.dispose();
    _nakshatraController.dispose();
    super.dispose();
  }

  void _addFamilyMember() {
    if (_fullNameController.text.isEmpty ||
        _gotraController.text.isEmpty ||
        _nakshatraController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _familyMembers.add(FamilyMember(
        name: _fullNameController.text,
        gotra: _gotraController.text,
        nakshatra: _nakshatraController.text,
      ));
      
      // Clear text fields after adding
      _fullNameController.clear();
      _gotraController.clear();
      _nakshatraController.clear();
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  void _removeFamilyMember(int index) {
    setState(() {
      _familyMembers.removeAt(index);
    });
  }

  void _proceedToPayment() {
    if (_familyMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one family member'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to payment screen
    log('Proceeding to payment with ${_familyMembers.length} family members');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
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
          'Devotees Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Text
            const Text(
              'Enter devotees details for puja / seva',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Devotee Section Header
            _buildSectionHeader(
              icon: Icons.person,
              title: 'Primary Devotee',
            ),
            const SizedBox(height: 16),

            // Text Fields
            _buildTextField(
              controller: _fullNameController,
              label: 'Full Name',
              hintText: 'Enter your full name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _gotraController,
              label: 'Gotra',
              hintText: 'Enter your gotra',
              icon: Icons.family_restroom,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nakshatraController,
              label: 'Nakshatra',
              hintText: 'Enter your nakshatra',
              icon: Icons.star_outline,
            ),
            const SizedBox(height: 24),

            // Family Members Section
            _buildFamilyMembersSection(),
            const SizedBox(height: 24),

            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.orange.shade700,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.orange.shade700, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyMembersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Family Members Header with Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(
                icon: Icons.group,
                title: 'Family Members',
              ),
              ElevatedButton.icon(
                onPressed: _addFamilyMember,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info Text
          Text(
            'Fill the details above and tap "Add" to include family members',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Family Members List
          if (_familyMembers.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  'No family members added yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _familyMembers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = _familyMembers[index];
                return _buildFamilyMemberCard(member, index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(FamilyMember member, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Member Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.orange.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Member Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Gotra: ${member.gotra}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Nakshatra: ${member.nakshatra}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove Button
          IconButton(
            onPressed: () => _removeFamilyMember(index),
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyMember {
  final String name;
  final String gotra;
  final String nakshatra;

  FamilyMember({
    required this.name,
    required this.gotra,
    required this.nakshatra,
  });
}