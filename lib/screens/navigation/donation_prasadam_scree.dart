import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/widgets/translated_text.dart';

enum DonationSection {
  eHundi,
  nityaAnna,
  specificScheme,
  publications,
  institutional,
}

class DonationsPrasadamScreen extends StatefulWidget {
  final DonationSection initialSection;

  const DonationsPrasadamScreen({super.key, required this.initialSection});

  @override
  State<DonationsPrasadamScreen> createState() =>
      _DonationsPublicationScreenState();
}

class _DonationsPublicationScreenState
    extends State<DonationsPrasadamScreen> {
  late DonationSection _currentSection;

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;
  }

  void _selectSection(DonationSection section) {
    setState(() => _currentSection = section);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark
              ? theme.scaffoldBackgroundColor
              : const Color(0xFFFFE7B3),
          appBar: AppBar(
            title: TranslatedText(
              'Donation & Prasadam',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'aBeeZee',
              ),
            ),
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          drawer: _buildDrawer(theme, isDark),
          body: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background/main_bg1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Black overlay in dark mode
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.8)
                      : Colors.transparent,
                ),
              ),
              // Main Content
              SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: _buildSection(theme, isDark),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- DRAWER ----------------
  Drawer _buildDrawer(ThemeData theme, bool isDark) {
    return Drawer(
      backgroundColor: isDark ? theme.cardColor : null,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dashboard/gallery5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              width: double.infinity,
              height: double.infinity,
              child: TranslatedText(
                'Donation & Prasadam',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _drawerItem(
            'E-Hundi (Online Donations)',
            DonationSection.eHundi,
            theme,
            isDark,
          ),
          _drawerItem(
            'Nitya Anna Prasadam',
            DonationSection.nityaAnna,
            theme,
            isDark,
          ),
          _drawerItem(
            'Specific Donation Scheme',
            DonationSection.specificScheme,
            theme,
            isDark,
          ),
          _drawerItem(
            'Publications & Prasadam',
            DonationSection.publications,
            theme,
            isDark,
          ),
          _drawerItem(
            'Institutional Contributions',
            DonationSection.institutional,
            theme,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    String title,
    DonationSection section,
    ThemeData theme,
    bool isDark,
  ) {
    final isActive = _currentSection == section;

    return ListTile(
      tileColor: isActive ? theme.primaryColor : null,
      title: TranslatedText(
        title,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          color: isActive
              ? Colors.white
              : (isDark ? Colors.white : Colors.black),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => _selectSection(section),
    );
  }

  // ---------------- SECTION SWITCH ----------------

  Widget _buildSection(ThemeData theme, bool isDark) {
    switch (_currentSection) {
      case DonationSection.eHundi:
        return _eHundiSection(theme, isDark);
      case DonationSection.nityaAnna:
        return _nityaAnnaSection(theme, isDark);
      case DonationSection.specificScheme:
        return _specificDonationSection(
          'Specific Donation Scheme',
          'Donate for a special cause and get blessed',
          theme,
          isDark,
        );
      case DonationSection.publications:
        return _publicationsSection(
          'Publications & Prasadam',
          'Support Daily food distribution and recive divine blessings',
          theme,
          isDark,
        );
      case DonationSection.institutional:
        return _institutionalSection(theme, isDark);
    }
  }

  // ---------------- SECTION UIs ----------------

  Widget _eHundiSection(ThemeData theme, bool isDark) {
    final TextEditingController _amountController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suggested quick amounts (existing)
        _amountGridSection(
          title: 'E-Hundi (Online Donations)',
          subtitle: 'Make one time or recurring donations securely online.',
          amounts: [501, 1001, 5001, 10001],
          descriptions: ['', '', '', ''],
          theme: theme,
          isDark: isDark,
          buttonText: 'Donate',
        ),

        SizedBox(height: 32.h),

        // ── Custom amount input + Donate button ──
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: _cardDecoration(theme, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                'Enter Custom Amount',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Amount TextField ──
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? theme.cardColor.withValues(alpha: 0.7)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: theme.colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Optional: you can add LengthLimitingTextInputFormatter(7) if you want max ₹99,99,999
                ],
              ),

              SizedBox(height: 24.h),

              // ── Donate Button ──
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final amountText = _amountController.text.trim();
                    if (amountText.isEmpty ||
                        int.tryParse(amountText) == null) {
                      // TODO: show snackbar / dialog → "Please enter a valid amount"
                      return;
                    }
                    final amount = int.parse(amountText);
                    // Add minimum amount check
                    if (amount < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: TranslatedText('Minimum donation amount is ₹10'),
                        ),
                      );
                      return;
                    }

                    // TODO: proceed to payment gateway / next screen
                    // Example: context.read<DonationBloc>().add(InitPayment(amount));
                    log('Donating: ₹$amount'); // temporary
                  },
                  icon: const Icon(Icons.volunteer_activism, size: 22),
                  label: TranslatedText(
                    'Donate Now',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nityaAnnaSection(ThemeData theme, bool isDark) {
    final TextEditingController _amountController = TextEditingController();

    return Column(
      children: [
        _amountGridSection(
          title: 'Nitya Anna Prasadam',
          subtitle:
              'Support Daily food distribution and receive divine blessings.',
          amounts: [516, 1000, 1500, 2000],
          descriptions: [
            'Feeds 11 devotees for a day',
            'Full day Annadanam sponsorship',
            'Annadanam for 11 days',
            'Annadanam for 22 days',
          ],
          theme: theme,
          isDark: isDark,
          buttonText: 'Contribute',
        ),

        SizedBox(height: 32.h),

        // ── Custom amount input + Donate button ──
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: _cardDecoration(theme, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                'Enter Custom Amount',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              // ── Amount TextField ──
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? theme.cardColor.withValues(alpha: 0.7)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: theme.colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Optional: you can add LengthLimitingTextInputFormatter(7) if you want max ₹99,99,999
                ],
              ),

              SizedBox(height: 24.h),

              // ── Donate Button ──
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final amountText = _amountController.text.trim();
                    if (amountText.isEmpty ||
                        int.tryParse(amountText) == null) {
                      // TODO: show snackbar / dialog → "Please enter a valid amount"
                      return;
                    }
                    final amount = int.parse(amountText);
                    // Add minimum amount check
                    if (amount < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: TranslatedText('Minimum donation amount is ₹10'),
                        ),
                      );
                      return;
                    }

                    // TODO: proceed to payment gateway / next screen
                    // Example: context.read<DonationBloc>().add(InitPayment(amount));
                    log('Donating: ₹$amount'); // temporary
                  },
                  icon: const Icon(Icons.volunteer_activism, size: 22),
                  label: TranslatedText(
                    'Donate Now',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _specificDonationSection(
    String title,
    String subtitle,
    ThemeData theme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          title,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        _simpleCardSection(
          [
            'Bhoodhanam - Land donation for temple development',
            'Goshala Support - Cow protection and maintenance',
            'Education Fund - Help educate underprivileged children',
            'Temple Development - Expansion & upkeep',
          ],
          theme,
          isDark,
        ),
      ],
    );
  }

  Widget _publicationsSection(
    String title,
    String subtitle,
    ThemeData theme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          title,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        _simpleCardSection(
          [
            'Laddu Prasadam Box – ₹251',
            'Pulihora Pack – ₹151',
            'Temple Calendar – ₹101',
            'Devotional Book – ₹201',
          ],
          theme,
          isDark,
        ),
      ],
    );
  }

  Widget _institutionalSection(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(theme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            'Institutional Donations',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : null,
            ),
          ),
          SizedBox(height: 10.h),
          TranslatedText(
            'Corporates, NGOs, and institutions can contribute with tax benefits.',
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'aBeeZee',
              color: isDark ? Colors.grey.shade300 : null,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: isDark
                  ? theme.primaryColor.withValues(alpha: 0.4)
                  : Colors.grey[200],
            ),
            child: Column(
              spacing: 10.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  'Download 80G/12A certificates and compliance reports after donation.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'aBeeZee',
                    color: isDark ? Colors.grey.shade300 : null,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  child: TranslatedText(
                    'Donate as Institution',
                    style: TextStyle(fontSize: 14.sp, fontFamily: 'aBeeZee'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- COMMON WIDGETS ----------------

  Widget _amountGridSection({
    required String title,
    required String subtitle,
    required List<int> amounts,
    required List<String> descriptions,
    required ThemeData theme,
    required bool isDark,
    required String buttonText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          title,
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'aBeeZee',
            color: isDark ? Colors.grey.shade300 : null,
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: amounts.map((amt) {
            return Container(
              width: 150.w,
              padding: EdgeInsets.all(16.w),
              decoration: _cardDecoration(theme, isDark),
              child: Column(
                children: [
                  TranslatedText(
                    '₹$amt',
                    style: TextStyle(
                      fontFamily: 'aBeeZee',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : null,
                    ),
                  ),
                  // SizedBox(height: 12.h),
                  if (descriptions.isNotEmpty)
                    TranslatedText(
                      descriptions[amounts.indexOf(amt)].toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'aBeeZee',
                        color: isDark ? Colors.grey.shade300 : null,
                      ),
                    ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    child: TranslatedText(
                      buttonText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'aBeeZee',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _simpleCardSection(List<String> items, ThemeData theme, bool isDark) {
    return Wrap(
      spacing: 16.w,
      runSpacing: 16.h,
      children: items.map((item) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: _cardDecoration(theme, isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TranslatedText(
                item,
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : null,
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: TranslatedText(
                  'Order Now',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'aBeeZee',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  BoxDecoration _cardDecoration(ThemeData theme, bool isDark) {
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
