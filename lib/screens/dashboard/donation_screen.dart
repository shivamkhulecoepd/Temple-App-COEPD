import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/services/theme_service.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  int _selectedDonationType = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.foregroundColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Donation',
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
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
                // Header Section
                _buildHeaderSection(),
                const SizedBox(height: 32),

                // Donation Options
                _buildDonationOptions(),
                const SizedBox(height: 32),

                // Proceed Button
                _buildProceedButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Select Donation Type',
            style: TextStyle(
              fontSize: 16, 
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Choose how you would like to contribute.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, 
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationOptions() {
    return Column(
      children: [
        // General Donation
        _buildDonationCard(
          title: 'General Donation',
          description:
              'Support the temple\'s daily operations and maintenance.',
          isSelected: _selectedDonationType == 0,
          onTap: () {
            setState(() {
              _selectedDonationType = 0;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildDonationCard(
          title: 'For a Specific Deity',
          description: 'Offer your donation to a deity of your choice.',
          isSelected: _selectedDonationType == 1,
          onTap: () {
            setState(() {
              _selectedDonationType = 1;
            });
          },
        ),
        const SizedBox(height: 16), // For a Specific Cause
        _buildDonationCard(
          title: 'For a Specific Cause',
          description:
              'Contribute to Annadanam, education, or temple festivals.',
          isSelected: _selectedDonationType == 2,
          onTap: () {
            setState(() {
              _selectedDonationType = 2;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDonationCard({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? TempleTheme.primaryOrange.withOpacity(0.1) : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? TempleTheme.primaryOrange : (Theme.of(context).dividerTheme.color ?? Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (Theme.of(context).dividerTheme.color ?? Colors.grey).withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? TempleTheme.primaryOrange : Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? TempleTheme.primaryOrange.withOpacity(0.8)
                    : Theme.of(context).textTheme.bodyMedium?.color,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Handle proceed action based on selected donation type
          switch (_selectedDonationType) {
            case 0:
              // Navigate to General Donation screen
              break;
            case 1:
              // Navigate to Specific Deity screen
              break;
            case 2:
              // Navigate to Specific Cause screen
              break;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TempleTheme.primaryOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Proceed',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}