import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/widgets/translated_text.dart';
import 'package:intl/intl.dart';

class UserDonationsScreen extends StatefulWidget {
  const UserDonationsScreen({super.key});

  @override
  State<UserDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<UserDonationsScreen> {
  // Dummy data - replace with real API later
  final List<Map<String, dynamic>> _donations = [
    {
      "type": "E-Hundi",
      "amount": 1001,
      "date": "2026-01-19 12:23:53",
      "status": "Success",
    },
    {
      "type": "Donation",
      "amount": 5000,
      "date": "2026-01-19 12:23:53",
      "status": "Success",
    },
    {
      "type": "Publication",
      "amount": 251,
      "date": "2026-01-19 12:23:53",
      "status": "Success",
    },
    {
      "type": "E-Hundi",
      "amount": 2100,
      "date": "2026-01-19 12:23:53",
      "status": "Success",
    },
  ];

  double get _totalDonated {
    return _donations.fold(0.0, (sum, d) => sum + (d['amount'] as num));
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
              : const Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: const Color(0xFF8B0000),
            title: TranslatedText(
              'My Donations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'aBeeZee',
              ),
            ),
            centerTitle: true,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Total Summary Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDark ? theme.cardColor : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TranslatedText(
                      'Total Donated',
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TranslatedText(
                      '₹ ${NumberFormat('#,##0').format(_totalDonated)}',
                      style: TextStyle(
                        fontFamily: 'aBeeZee',
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF8B0000),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _donations.isEmpty
                    ? Center(
                        child: TranslatedText(
                          'No donations yet',
                          style: TextStyle(
                            fontFamily: 'aBeeZee',
                            fontSize: 18.sp,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: _donations.length,
                        itemBuilder: (context, index) {
                          final donation = _donations[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            color: isDark ? theme.cardColor : Colors.white,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.w),
                              leading: CircleAvatar(
                                backgroundColor: const Color(
                                  0xFF8B0000,
                                ).withOpacity(0.15),
                                radius: 28.r,
                                child: Icon(
                                  Icons.volunteer_activism,
                                  color: const Color(0xFF8B0000),
                                  size: 28.w,
                                ),
                              ),
                              title: TranslatedText(
                                donation['type'],
                                style: TextStyle(
                                  fontFamily: 'aBeeZee',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.h),
                                  TranslatedText(
                                    '${donation['date']}',
                                    style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      fontSize: 13.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  TranslatedText(
                                    '₹ ${NumberFormat('#,###').format(donation['amount'])}',
                                    style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF8B0000),
                                    ),
                                  ),
                                  _statusChip(donation['status']),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: status == 'Success'
            ? Colors.green.shade100
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TranslatedText(
        status,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 12.sp,
          color: status == 'Success'
              ? Colors.green.shade800
              : Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
