import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/screens/navigation/donation_prasadam_scree.dart';
import 'package:mslgd/widgets/common/gallery_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: TranslatedText(
              'Donations',
              style: TextStyle(
                fontFamily: 'aBeeZee',
                color: Colors.white,
                fontSize: 20.sp,
              ),
            ),
          ),

          // 🔥 FIXED BACKGROUND + SCROLLABLE CONTENT
          body: Stack(
            children: [
              /// ✅ Fixed Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background/main_bg1.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              /// ✅ Dark Overlay (fixed)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.8)
                        : Colors.transparent,
                  ),
                ),
              ),

              /// ✅ Scrollable Content ONLY
              SafeArea(
                child: SingleChildScrollView(
                  // padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 30.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            donationSevaCard(
                              context: context,
                              theme: theme,
                              isDark: isDark,
                              image: 'assets/images/dashboard/gallery1.jpg',
                              title: 'Nitya Annadanam Seva',
                              description:
                                  'Donating food at a temple is a simple yet meaningful act that supports community meals and helps ensure every visitor is welcomed with care. It fosters compassion, brings a sense of fulfillment, and is often believed to invite blessings and positive energy into one\'s life.',
                              onDonate: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DonationsPrasadamScreen(
                                      initialSection: DonationSection.nityaAnna,
                                    ),
                                  ),
                                );
                              },
                            ),
                            donationSevaCard(
                              context: context,
                              theme: theme,
                              isDark: isDark,
                              image: 'assets/images/dashboard/gallery2.jpg',
                              title: 'Devalay Bhudanam Seva',
                              description:
                                  'Bhudanam, the offering of land, is seen as a deeply noble act that supports community growth and sacred service. It reflects true generosity and is believed to bring lasting blessings, harmony, and spiritual merit.',
                              onDonate: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DonationsPrasadamScreen(
                                      initialSection: DonationSection.specificScheme,
                                    ),
                                  ),
                                );
                              },
                            ),
                            donationSevaCard(
                              context: context,
                              theme: theme,
                              isDark: isDark,
                              image: 'assets/images/dashboard/gallery3.jpg',
                              title: 'General Donations',
                              description:
                                  'General donations for a temple\'s daily rituals help maintain the smooth flow of worship, lighting lamps, offering prayers, and preserving sacred traditions. Such support is considered highly meritorious, bringing blessings while ensuring the temple remains a vibrant spiritual center for all.',
                              onDonate: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DonationsPrasadamScreen(
                                      initialSection: DonationSection.eHundi,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 120.h, // ✅ controls banner height
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/background/bannerbg.png',
                            ),
                            fit: BoxFit.fill, // ✅ fills banner nicely
                          ),
                        ),
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          top: 9.h,
                          bottom: 15.h,
                        ), // ✅ spacing from edges
                        alignment: Alignment.center, // ✅ centers text
                        child: TranslatedText(
                          "Through Annadanam flows compassion,\n"
                          "Through Bhudanam rises righteousness,\n"
                          "Deeds that reflect the highest generosity of spirit,\n"
                          "Honored in the divine presence of Lakshmi-Ganapati",
                          textAlign: TextAlign.center, // ✅ center alignment
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            color: Colors.white,
                            fontSize: 10.sp,
                            height: 1.4, // ✅ line spacing
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GalleryWidget(title: 'Image Gallery',),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Donation Seva Card
  Widget donationSevaCard({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required String image,
    required String title,
    required String description,
    VoidCallback? onDonate,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          // color: theme.colorScheme.secondary.withValues(alpha: 0.5),
          color: isDark
              ? const Color.fromARGB(255, 3, 72, 129)
              : theme.colorScheme.secondary.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

          /// 🏷 Title
          TranslatedText(
            title,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF6A2C00),
            ),
          ),

          const SizedBox(height: 10),

          /// 📄 Description
          TranslatedText(
            description,
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.sp,
              height: 1.6,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 24),

          /// 🔥 Donate Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onDonate,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: const TranslatedText(
                'Donate Now',
                style: TextStyle(
                  fontFamily: 'aBeeZee',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
