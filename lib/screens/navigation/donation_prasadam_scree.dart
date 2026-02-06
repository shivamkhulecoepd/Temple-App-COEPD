import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/screens/authentication/auth_screen.dart';
import 'package:mslgd/services/db_functions.dart';
import 'package:mslgd/utils/auth_utils.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
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

class _DonationsPublicationScreenState extends State<DonationsPrasadamScreen> {
  late DonationSection _currentSection;
  String? _selectedSchemeType; // Track which specific scheme was selected

  // Controllers for E-Hundi form
  final TextEditingController _ehundiFullNameController =
      TextEditingController();
  final TextEditingController _ehundiMobileController = TextEditingController();
  final TextEditingController _ehundiEmailController = TextEditingController();
  final TextEditingController _ehundiGotraController = TextEditingController();
  final TextEditingController _ehundiNakshatramController =
      TextEditingController();
  final TextEditingController _ehundiAddressController =
      TextEditingController();
  final TextEditingController _ehundiCityController = TextEditingController();
  final TextEditingController _ehundiDonationAmountController =
      TextEditingController();
  final TextEditingController _ehundiSankalpamController =
      TextEditingController();
  final TextEditingController _ehundiTypeController = TextEditingController(
    text: 'E-Hundi',
  );

  // Controllers for Nitya Anna form
  final TextEditingController _nityaAnnaFullNameController =
      TextEditingController();
  final TextEditingController _nityaAnnaGotraController =
      TextEditingController();
  final TextEditingController _nityaAnnaNakshatramController =
      TextEditingController();
  final TextEditingController _nityaAnnaMobileController =
      TextEditingController();
  final TextEditingController _nityaAnnaEmailController =
      TextEditingController();
  final TextEditingController _nityaAnnaAddressController =
      TextEditingController();
  final TextEditingController _nityaAnnaCityController =
      TextEditingController();
  final TextEditingController _nityaAnnaTypeController = TextEditingController(
    text: 'Annaprasadam',
  );
  final TextEditingController _nityaAnnaDateController =
      TextEditingController();
  final TextEditingController _nityaAnnaSessionController =
      TextEditingController();
  final TextEditingController _nityaAnnaPersonsController =
      TextEditingController();
  final TextEditingController _nityaAnnaDonationAmountController =
      TextEditingController();
  final TextEditingController _nityaAnnaOccasionController =
      TextEditingController();
  final TextEditingController _nityaAnnaSankalpamController =
      TextEditingController();

  // Controllers for Bhoodhanam form
  final TextEditingController _bhoodhanamFullNameController =
      TextEditingController();
  final TextEditingController _bhoodhanamFatherNameController =
      TextEditingController();
  final TextEditingController _bhoodhanamDateController =
      TextEditingController();
  final TextEditingController _bhoodhanamGotraController =
      TextEditingController();
  final TextEditingController _bhoodhanamNakshatramController =
      TextEditingController();
  final TextEditingController _bhoodhanamMobileController =
      TextEditingController();
  final TextEditingController _bhoodhanamEmailController =
      TextEditingController();
  final TextEditingController _bhoodhanamAddressController =
      TextEditingController();
  final TextEditingController _bhoodhanamCityController =
      TextEditingController();
  final TextEditingController _bhoodhanamTypeController =
      TextEditingController();
  final TextEditingController _bhoodhanamPreferredDateController =
      TextEditingController();
  final TextEditingController _bhoodhanamDonationAmountController =
      TextEditingController();
  final TextEditingController _bhoodhanamSankalpamController =
      TextEditingController();

  // Controllers for Goshala form
  final TextEditingController _goshalaFullNameController =
      TextEditingController();
  final TextEditingController _goshalaFatherNameController =
      TextEditingController();
  final TextEditingController _goshalaMobileController =
      TextEditingController();
  final TextEditingController _goshalaEmailController = TextEditingController();
  final TextEditingController _goshalaAddressController =
      TextEditingController();
  final TextEditingController _goshalaCityController = TextEditingController();
  final TextEditingController _goshalaGoshalaNameController =
      TextEditingController();
  final TextEditingController _goshalaSupportTypeController =
      TextEditingController();
  final TextEditingController _goshalaDonationAmountController =
      TextEditingController();
  final TextEditingController _goshalaSankalpamController =
      TextEditingController();
  final TextEditingController _goshalaTypeController = TextEditingController(
    text: 'Goshala',
  );

  // Controllers for Education Fund form
  final TextEditingController _eduFullNameController = TextEditingController();
  final TextEditingController _eduGuardianNameController =
      TextEditingController();
  final TextEditingController _eduDateController = TextEditingController();
  final TextEditingController _eduMobileController = TextEditingController();
  final TextEditingController _eduEmailController = TextEditingController();
  final TextEditingController _eduAddressController = TextEditingController();
  final TextEditingController _eduCityController = TextEditingController();
  final TextEditingController _eduSupportTypeController =
      TextEditingController();
  final TextEditingController _eduStudentInfoController =
      TextEditingController();
  final TextEditingController _eduPeriodTypeController =
      TextEditingController();
  final TextEditingController _eduDonationAmountController =
      TextEditingController();
  final TextEditingController _eduSankalpamController = TextEditingController();
  final TextEditingController _eduTypeController = TextEditingController(
    text: 'Education Fund',
  );

  // Controllers for Temple Development form
  final TextEditingController _templeFullNameController =
      TextEditingController();
  final TextEditingController _templeFatherNameController =
      TextEditingController();
  final TextEditingController _templeDateController = TextEditingController();
  final TextEditingController _templeMobileController = TextEditingController();
  final TextEditingController _templeEmailController = TextEditingController();
  final TextEditingController _templeAddressController =
      TextEditingController();
  final TextEditingController _templeCityController = TextEditingController();
  final TextEditingController _templeProjectTypeController =
      TextEditingController();
  final TextEditingController _templePreferredDateController =
      TextEditingController();
  final TextEditingController _templeDonationAmountController =
      TextEditingController();
  final TextEditingController _templeSankalpamController =
      TextEditingController();
  final TextEditingController _templeTypeController = TextEditingController(
    text: 'Temple Development',
  );

  // Controllers for Publications form
  final TextEditingController _pubFullNameController = TextEditingController();
  final TextEditingController _pubMobileController = TextEditingController();
  final TextEditingController _pubEmailController = TextEditingController();
  final TextEditingController _pubAddressController = TextEditingController();
  final TextEditingController _pubQuantityController = TextEditingController();
  final TextEditingController _pubDonationAmountController =
      TextEditingController();
  final TextEditingController _pubTypeController = TextEditingController();

  // Controllers for Institutional form
  final TextEditingController _instOrgNameController = TextEditingController();
  final TextEditingController _instContactPersonController =
      TextEditingController();
  final TextEditingController _instDesignationController =
      TextEditingController();
  final TextEditingController _instMobileController = TextEditingController();
  final TextEditingController _instEmailController = TextEditingController();
  final TextEditingController _instAddressController = TextEditingController();
  final TextEditingController _instCityController = TextEditingController();
  final TextEditingController _instDonationAmountController =
      TextEditingController();
  final TextEditingController _instPurposeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSection = widget.initialSection;
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _ehundiFullNameController.dispose();
    _ehundiMobileController.dispose();
    _ehundiEmailController.dispose();
    _ehundiGotraController.dispose();
    _ehundiNakshatramController.dispose();
    _ehundiAddressController.dispose();
    _ehundiCityController.dispose();
    _ehundiDonationAmountController.dispose();
    _ehundiSankalpamController.dispose();
    _ehundiTypeController.dispose();

    _nityaAnnaFullNameController.dispose();
    _nityaAnnaGotraController.dispose();
    _nityaAnnaNakshatramController.dispose();
    _nityaAnnaMobileController.dispose();
    _nityaAnnaEmailController.dispose();
    _nityaAnnaAddressController.dispose();
    _nityaAnnaCityController.dispose();
    _nityaAnnaTypeController.dispose();
    _nityaAnnaDateController.dispose();
    _nityaAnnaSessionController.dispose();
    _nityaAnnaPersonsController.dispose();
    _nityaAnnaDonationAmountController.dispose();
    _nityaAnnaOccasionController.dispose();
    _nityaAnnaSankalpamController.dispose();

    _bhoodhanamFullNameController.dispose();
    _bhoodhanamFatherNameController.dispose();
    _bhoodhanamDateController.dispose();
    _bhoodhanamGotraController.dispose();
    _bhoodhanamNakshatramController.dispose();
    _bhoodhanamMobileController.dispose();
    _bhoodhanamEmailController.dispose();
    _bhoodhanamAddressController.dispose();
    _bhoodhanamCityController.dispose();
    _bhoodhanamTypeController.dispose();
    _bhoodhanamPreferredDateController.dispose();
    _bhoodhanamDonationAmountController.dispose();
    _bhoodhanamSankalpamController.dispose();

    _goshalaFullNameController.dispose();
    _goshalaFatherNameController.dispose();
    _goshalaMobileController.dispose();
    _goshalaEmailController.dispose();
    _goshalaAddressController.dispose();
    _goshalaCityController.dispose();
    _goshalaGoshalaNameController.dispose();
    _goshalaSupportTypeController.dispose();
    _goshalaDonationAmountController.dispose();
    _goshalaSankalpamController.dispose();
    _goshalaTypeController.dispose();

    _eduFullNameController.dispose();
    _eduGuardianNameController.dispose();
    _eduDateController.dispose();
    _eduMobileController.dispose();
    _eduEmailController.dispose();
    _eduAddressController.dispose();
    _eduCityController.dispose();
    _eduSupportTypeController.dispose();
    _eduStudentInfoController.dispose();
    _eduPeriodTypeController.dispose();
    _eduDonationAmountController.dispose();
    _eduSankalpamController.dispose();
    _eduTypeController.dispose();

    _templeFullNameController.dispose();
    _templeFatherNameController.dispose();
    _templeDateController.dispose();
    _templeMobileController.dispose();
    _templeEmailController.dispose();
    _templeAddressController.dispose();
    _templeCityController.dispose();
    _templeProjectTypeController.dispose();
    _templePreferredDateController.dispose();
    _templeDonationAmountController.dispose();
    _templeSankalpamController.dispose();
    _templeTypeController.dispose();

    _pubFullNameController.dispose();
    _pubMobileController.dispose();
    _pubEmailController.dispose();
    _pubAddressController.dispose();
    _pubQuantityController.dispose();
    _pubDonationAmountController.dispose();
    _pubTypeController.dispose();

    _instOrgNameController.dispose();
    _instContactPersonController.dispose();
    _instDesignationController.dispose();
    _instMobileController.dispose();
    _instEmailController.dispose();
    _instAddressController.dispose();
    _instCityController.dispose();
    _instDonationAmountController.dispose();
    _instPurposeController.dispose();

    super.dispose();
  }

  void _selectSection(DonationSection section) {
    setState(() => _currentSection = section);
    Navigator.pop(context);
  }

  // Method to set the specific scheme type when Order Now is clicked
  void _setSelectedSchemeType(String schemeType) {
    setState(() {
      _selectedSchemeType = schemeType;
    });
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
                  onPressed: () => _showDonationInfoBottomSheet('E-Hundi'),
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
                  onPressed: () => _showDonationInfoBottomSheet('Annaprasadam'),
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
                  onPressed: () => _showDonationInfoBottomSheet('Education'),
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
            final screenWidth = MediaQuery.of(context).size.width;
            return Container(
              // width: 150.w,
              width: (screenWidth - 20.w * 2 - 16.w) / 2,
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
                    onPressed: () async {
                      final token = await AuthUtils.getUserToken();
                      if (token == null) {
                        if (mounted) {
                          AppSnackbar.show(
                            context,
                            message: 'Please login to continue for donation',
                            type: SnackbarType.warning,
                            actionLabel: 'Login',
                            onActionPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => AuthScreen()),
                              );
                            },
                          );
                        }
                        return;
                      } else {
                        _showDonationInfoBottomSheet(title);
                      }
                    },
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
        String schemeType = '';
        if (item.contains('Bhoodhanam')) {
          schemeType = 'Bhoodhanam';
        } else if (item.contains('Goshala')) {
          schemeType = 'Goshala';
        } else if (item.contains('Education Fund')) {
          schemeType = 'Education_Fund';
        } else if (item.contains('Temple Development')) {
          schemeType = 'Temple_Development';
        }

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
                onPressed: () {
                  _setSelectedSchemeType(schemeType);
                  _showDonationInfoBottomSheet(_currentSection, schemeType);
                },
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

  // Add this method to show the donation info bottom sheet
  void _showDonationInfoBottomSheet(
    dynamic type, [
    String? specificSchemeType = '',
  ]) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Important: enables resize when keyboard appears
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return AnimatedPadding(
          padding: MediaQuery.of(
            context,
          ).viewInsets, // This handles keyboard appearance
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: _buildDonationForm(type, specificSchemeType),
          ),
        );
      },
    );
  }

  // Build the form based on current section
  Widget _buildDonationForm(dynamic type, [String? specificSchemeType]) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: TranslatedText(
                  "Donation Details",
                  style: TextStyle(
                    fontFamily: 'aBeeZee',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineSmall?.color,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Form based on section
          _buildFormBasedOnSection(type, specificSchemeType),
        ],
      ),
    );
  }

  Widget _buildFormBasedOnSection(dynamic type, [String? specificSchemeType]) {
    if (_currentSection == DonationSection.specificScheme &&
        specificSchemeType != null &&
        specificSchemeType.isNotEmpty) {
      return _buildSpecificSchemeFormByType(specificSchemeType);
    }

    switch (_currentSection) {
      case DonationSection.eHundi:
        return _buildEHundiForm(type);
      case DonationSection.nityaAnna:
        return _buildNityaAnnaForm(type);
      case DonationSection.specificScheme:
        return _buildSpecificSchemeForm();
      case DonationSection.publications:
        return _buildPublicationsForm();
      case DonationSection.institutional:
        return _buildInstitutionalForm();
    }
  }

  // E-Hundi Form
  Widget _buildEHundiForm(dynamic type) {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _ehundiFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _ehundiMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _ehundiEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _ehundiGotraController,
            "Gotra",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _ehundiNakshatramController,
            "Nakshatram / Rasi",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _ehundiAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _ehundiCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _ehundiDonationAmountController,
            "Donation Amount (₹) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _ehundiSankalpamController,
            "Sankalpam / Prayer",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _ehundiTypeController,
            "Type of Donation seva",
            TextInputType.text,
            false,
            isEnabled: false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _ehundiFullNameController,
            mobileController: _ehundiMobileController,
            emailController: _ehundiEmailController,
            gotraController: _ehundiGotraController,
            nakshatramController: _ehundiNakshatramController,
            addressController: _ehundiAddressController,
            cityController: _ehundiCityController,
            donationAmountController: _ehundiDonationAmountController,
            sankalpamController: _ehundiSankalpamController,
            typeController: _ehundiTypeController,
          ),
        ],
      ),
    );
  }

  // Nitya Anna Form
  Widget _buildNityaAnnaForm(dynamic type) {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _nityaAnnaFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _nityaAnnaGotraController,
            "Gotra",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _nityaAnnaNakshatramController,
            "Nakshatram / Rasi",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _nityaAnnaMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _nityaAnnaEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _nityaAnnaAddressController,
            "Address *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _nityaAnnaCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),

          _buildDateField(_nityaAnnaDateController, "Preferred Date"),
          _buildTextField(
            _nityaAnnaSessionController,
            "Session (Breakfast / Lunch / Dinner / Full Day)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _nityaAnnaPersonsController,
            "Approx. No. of Persons to be Fed",
            TextInputType.number,
            false,
          ),
          _buildTextField(
            _nityaAnnaDonationAmountController,
            "Donation Amount (₹) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _nityaAnnaOccasionController,
            "Occasion (Birthday / Anniversary / Memory Of)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _nityaAnnaSankalpamController,
            "Sankalpam / Prayer Intention",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _nityaAnnaTypeController,
            "Type of Annadanam Seva",
            TextInputType.text,
            false,
            isEnabled: false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _nityaAnnaFullNameController,
            mobileController: _nityaAnnaMobileController,
            emailController: _nityaAnnaEmailController,
            gotraController: _nityaAnnaGotraController,
            nakshatramController: _nityaAnnaNakshatramController,
            addressController: _nityaAnnaAddressController,
            cityController: _nityaAnnaCityController,
            donationAmountController: _nityaAnnaDonationAmountController,
            sankalpamController: _nityaAnnaSankalpamController,
            typeController: _nityaAnnaTypeController,
            preferredDateController: _nityaAnnaDateController,
            sessionTypeController: _nityaAnnaSessionController,
            personsCountController: _nityaAnnaPersonsController,
            occasionController: _nityaAnnaOccasionController,
          ),
        ],
      ),
    );
  }

  // Specific Scheme Form (Bhoodhanam, Goshala, Education, Temple)
  Widget _buildSpecificSchemeForm() {
    // Use the selected scheme type or default to Bhoodhanam
    String schemeType = _selectedSchemeType ?? 'Bhoodhanam';

    return _buildSpecificSchemeFormByType(schemeType);
  }

  // Build specific scheme form based on selected type
  Widget _buildSpecificSchemeFormByType(String schemeType) {
    switch (schemeType) {
      case "Bhoodhanam":
        return _buildBhoodhanamForm();
      case "Goshala":
        return _buildGoshalaForm();
      case "Education_Fund":
        return _buildEducationFundForm();
      case "Temple_Development":
        return _buildTempleDevelopmentForm();
      default:
        return _buildBhoodhanamForm(); // Default to Bhoodhanam
    }
  }

  // Bhoodhanam Form
  Widget _buildBhoodhanamForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _bhoodhanamFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _bhoodhanamFatherNameController,
            "Father / Husband Name",
            TextInputType.text,
            false,
          ),
          _buildDateField(_bhoodhanamDateController, "Date"),
          _buildTextField(
            _bhoodhanamGotraController,
            "Gotra",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _bhoodhanamNakshatramController,
            "Nakshatram / Rasi",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _bhoodhanamMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _bhoodhanamEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _bhoodhanamAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _bhoodhanamCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _bhoodhanamTypeController,
            "Type of Bhoodhanam",
            TextInputType.text,
            false,
          ),
          _buildDateField(_bhoodhanamPreferredDateController, "Preferred Date"),
          _buildTextField(
            _bhoodhanamDonationAmountController,
            "Donation Amount (₹) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _bhoodhanamSankalpamController,
            "Sankalpam / Message",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            TextEditingController(text: 'Bhoodhanam'),
            "Type of Donation Seva",
            TextInputType.text,
            false,
            isEnabled: false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _bhoodhanamFullNameController,
            mobileController: _bhoodhanamMobileController,
            emailController: _bhoodhanamEmailController,
            gotraController: _bhoodhanamGotraController,
            nakshatramController: _bhoodhanamNakshatramController,
            addressController: _bhoodhanamAddressController,
            cityController: _bhoodhanamCityController,
            donationAmountController: _bhoodhanamDonationAmountController,
            typeController: _bhoodhanamTypeController,
            fatherNameController: _bhoodhanamFatherNameController,
            preferredDateController: _bhoodhanamPreferredDateController,
            schemeType: "Bhoodhanam",
          ),
        ],
      ),
    );
  }

  // Goshala Form
  Widget _buildGoshalaForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _goshalaFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _goshalaFatherNameController,
            "Father / Husband Name",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _goshalaMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _goshalaEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _goshalaAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _goshalaCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _goshalaGoshalaNameController,
            "Goshala Name (If any)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _goshalaSupportTypeController,
            "Support Type (Feed / Medical / General)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _goshalaDonationAmountController,
            "Donation Amount (₹) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _goshalaSankalpamController,
            "Sankalpam / Message",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _goshalaTypeController,
            "Type of Donation Seva",
            TextInputType.text,
            false,
            isEnabled: false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _goshalaFullNameController,
            mobileController: _goshalaMobileController,
            emailController: _goshalaEmailController,
            addressController: _goshalaAddressController,
            cityController: _goshalaCityController,
            donationAmountController: _goshalaDonationAmountController,
            sankalpamController: _goshalaSankalpamController,
            typeController: _goshalaTypeController,
            fatherNameController: _goshalaFatherNameController,
            schemeType: "Goshala",
          ),
        ],
      ),
    );
  }

  // Education Fund Form
  Widget _buildEducationFundForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _eduFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _eduGuardianNameController,
            "Father / Mother / Guardian Name",
            TextInputType.text,
            false,
          ),
          _buildDateField(_eduDateController, "Date"),
          _buildTextField(
            _eduMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _eduEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _eduAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _eduCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _eduSupportTypeController,
            "Support For (Scholarship / Infrastructure / Stationery)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _eduStudentInfoController,
            "If for student: Student Name & Class (optional)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _eduPeriodTypeController,
            "Preferred Period (One-time / Monthly / Yearly)",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _eduDonationAmountController,
            "Donation Amount (INR) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _eduSankalpamController,
            "Sankalpam / Message",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _eduTypeController,
            "Type of Donation Seva",
            TextInputType.text,
            false,
            isEnabled: false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _eduFullNameController,
            mobileController: _eduMobileController,
            emailController: _eduEmailController,
            addressController: _eduAddressController,
            cityController: _eduCityController,
            donationAmountController: _eduDonationAmountController,
            sankalpamController: _eduSankalpamController,
            typeController: _eduTypeController,
            fatherNameController: _eduGuardianNameController,
            preferredDateController: _eduDateController,
            schemeType: "Education_Fund",
          ),
        ],
      ),
    );
  }

  // Temple Development Form
  Widget _buildTempleDevelopmentForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _templeFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _templeFatherNameController,
            "Father / Husband Name",
            TextInputType.text,
            false,
          ),
          _buildDateField(_templeDateController, "Date"),
          _buildTextField(
            _templeMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _templeEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _templeAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _templeCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _templeProjectTypeController,
            "Project (Sanctum / Compound / Electrification / General)",
            TextInputType.text,
            false,
          ),
          _buildDateField(
            _templePreferredDateController,
            "Preferred Date (If any)",
          ),
          _buildTextField(
            _templeDonationAmountController,
            "Donation Amount (INR) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _templeSankalpamController,
            "Sankalpam / Message",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _templeTypeController,
            "Type of Donation",
            TextInputType.text,
            false,
            isEnabled: false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _templeFullNameController,
            mobileController: _templeMobileController,
            emailController: _templeEmailController,
            addressController: _templeAddressController,
            cityController: _templeCityController,
            donationAmountController: _templeDonationAmountController,
            sankalpamController: _templeSankalpamController,
            typeController: _templeTypeController,
            fatherNameController: _templeFatherNameController,
            preferredDateController: _templePreferredDateController,
            schemeType: "Temple_Development",
          ),
        ],
      ),
    );
  }

  // Publications Form
  Widget _buildPublicationsForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _pubFullNameController,
            "Full Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _pubMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _pubEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _pubAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _pubQuantityController,
            "Quantity",
            TextInputType.number,
            false,
          ),
          _buildTextField(
            _pubDonationAmountController,
            "Donation Amount (₹) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _pubTypeController,
            "Type of Donation Seva",
            TextInputType.text,
            false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            fullNameController: _pubFullNameController,
            mobileController: _pubMobileController,
            emailController: _pubEmailController,
            addressController: _pubAddressController,
            donationAmountController: _pubDonationAmountController,
            typeController: _pubTypeController,
            quantityController: _pubQuantityController,
          ),
        ],
      ),
    );
  }

  // Institutional Form
  Widget _buildInstitutionalForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(
            _instOrgNameController,
            "Organization Name *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _instContactPersonController,
            "Contact Person *",
            TextInputType.text,
            true,
          ),
          _buildTextField(
            _instDesignationController,
            "Designation",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _instMobileController,
            "Mobile Number *",
            TextInputType.phone,
            true,
          ),
          _buildTextField(
            _instEmailController,
            "Email ID *",
            TextInputType.emailAddress,
            true,
          ),
          _buildTextField(
            _instAddressController,
            "Address",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _instCityController,
            "City / State / PIN",
            TextInputType.text,
            false,
          ),
          _buildTextField(
            _instDonationAmountController,
            "Donation Amount (₹) *",
            TextInputType.number,
            true,
          ),
          _buildTextField(
            _instPurposeController,
            "Purpose of Donation",
            TextInputType.text,
            false,
          ),
          SizedBox(height: 24.h),
          _buildSubmitButton(
            organizationNameController: _instOrgNameController,
            contactPersonController: _instContactPersonController,
            designationController: _instDesignationController,
            mobileController: _instMobileController,
            emailController: _instEmailController,
            addressController: _instAddressController,
            cityController: _instCityController,
            donationAmountController: _instDonationAmountController,
            purposeController: _instPurposeController,
          ),
        ],
      ),
    );
  }

  // Common text field builder
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    TextInputType inputType,
    bool isRequired, {
    bool isEnabled = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
        ),
        keyboardType: inputType,
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return "$label is required";
                }
                if (label.contains("Mobile") && value.length != 10) {
                  return "Enter valid 10-digit number";
                }
                if (label.contains("Email") && value.isNotEmpty) {
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return "Enter a valid email address";
                  }
                }
                if (label.contains("Amount") && value.isNotEmpty) {
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return "Enter a valid amount";
                  }
                }
                return null;
              }
            : null,
      ),
    );
  }

  // Date field builder
  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          suffixIcon: Icon(Icons.date_range),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            controller.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          }
        },
      ),
    );
  }

  // Submit button with integration
  Widget _buildSubmitButton({
    TextEditingController? fullNameController,
    TextEditingController? mobileController,
    TextEditingController? emailController,
    TextEditingController? gotraController,
    TextEditingController? nakshatramController,
    TextEditingController? addressController,
    TextEditingController? cityController,
    TextEditingController? donationAmountController,
    TextEditingController? sankalpamController,
    TextEditingController? typeController,
    TextEditingController? fatherNameController,
    TextEditingController? preferredDateController,
    TextEditingController? sessionTypeController,
    TextEditingController? personsCountController,
    TextEditingController? occasionController,
    TextEditingController? quantityController,
    TextEditingController? organizationNameController,
    TextEditingController? contactPersonController,
    TextEditingController? designationController,
    TextEditingController? purposeController,
    String? schemeType,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () async {
          // Validate form
          if (donationAmountController?.text.isEmpty ?? true) {
            AppSnackbar.error(context, "Please enter donation amount");
            return;
          }

          if (fullNameController != null && fullNameController.text.isEmpty) {
            AppSnackbar.error(context, "Please enter full name");
            return;
          }

          if (mobileController != null && mobileController.text.isEmpty) {
            AppSnackbar.error(context, "Please enter mobile number");
            return;
          }

          if (emailController != null && emailController.text.isEmpty) {
            AppSnackbar.error(context, "Please enter email ID");
            return;
          }

          // Prepare data for API call
          final donationData = {
            'donationType': _getDonationType(schemeType: schemeType),
            'sevaType': typeController?.text,
            'fullName':
                fullNameController?.text ??
                organizationNameController?.text ??
                '',
            'gotra': gotraController?.text,
            'nakshatram': nakshatramController?.text,
            'mobile':
                mobileController?.text ?? contactPersonController?.text ?? '',
            'email': emailController?.text,
            'address': addressController?.text,
            'cityStatePin': cityController?.text,
            'preferredDate': preferredDateController?.text,
            'sessionType': sessionTypeController?.text,
            'personsCount':
                int.tryParse(personsCountController?.text ?? '0') ?? 0,
            'occasion': occasionController?.text,
            'sankalpam': sankalpamController?.text,
            'quantity': int.tryParse(quantityController?.text ?? '0') ?? 0,
            'amount':
                double.tryParse(donationAmountController?.text ?? '0') ?? 0.0,
          };

          try {
            // Call the API to submit donation
            final db = DBFunctions();
            final token = await AuthUtils.getUserToken();
            if (token == null) {
              if (mounted) {
                AppSnackbar.show(
                  context,
                  message: 'Please login to continue for donation',
                  type: SnackbarType.warning,
                  actionLabel: 'Login',
                  onActionPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AuthScreen()),
                    );
                  },
                );
              }
              return;
            }
            // Using an empty token for now, but in a real scenario,
            // you'd get the user token if logged in
            final result = await db.submitDonation(
              token: token!,
              donationType: donationData['donationType'] as String,
              sevaType: donationData['sevaType'] as String?,
              fullName: donationData['fullName'] as String,
              gotra: donationData['gotra'] as String?,
              nakshatram: donationData['nakshatram'] as String?,
              mobile: donationData['mobile'] as String,
              email: donationData['email'] as String?,
              address: donationData['address'] as String?,
              cityStatePin: donationData['cityStatePin'] as String?,
              preferredDate: donationData['preferredDate'] as String?,
              sessionType: donationData['sessionType'] as String?,
              personsCount: donationData['personsCount'] as int,
              occasion: donationData['occasion'] as String?,
              sankalpam: donationData['sankalpam'] as String?,
              amount: donationData['amount'] as double,
            );

            // Show success message
            AppSnackbar.success(
              context,
              result['message'] ?? 'Donation submitted successfully!',
            );

            // Close the bottom sheet
            Navigator.pop(context);
          } catch (e) {
            // Show error message
            AppSnackbar.error(
              context,
              'Failed to submit donation: ${e.toString()}',
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Colors.white,
        ),
        child: TranslatedText(
          "Save & Continue »",
          style: TextStyle(
            fontFamily: 'aBeeZee',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper method to get donation type based on current section and scheme type
  String _getDonationType({String? schemeType}) {
    if (_currentSection == DonationSection.specificScheme &&
        schemeType != null) {
      switch (schemeType) {
        case "Bhoodhanam":
          return 'bhoodhanam';
        case "Goshala":
          return 'goshala';
        case "Education_Fund":
          return 'education-fund';
        case "Temple_Development":
          return 'temple-development';
      }
    }

    switch (_currentSection) {
      case DonationSection.eHundi:
        return 'e-hundi';
      case DonationSection.nityaAnna:
        return 'nitya-anna';
      case DonationSection.specificScheme:
        return 'specific-scheme';
      case DonationSection.publications:
        return 'publications';
      case DonationSection.institutional:
        return 'institutional';
    }
  }
}
