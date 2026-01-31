import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/core/services/db_functions.dart';
import 'package:mslgd/models/user_model.dart';
import 'package:mslgd/utils/auth_utils.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:intl/intl.dart';

class UserDonationsScreen extends StatefulWidget {
  const UserDonationsScreen({super.key});

  @override
  State<UserDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<UserDonationsScreen> {
  final DBFunctions _db = DBFunctions();
  List<dynamic> _donations = [];
  bool _isLoading = true;
  String? _errorMessage;
  // ignore: unused_field
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user and token
      final user = await AuthUtils.getCurrentUser();
      final token = await AuthUtils.getUserToken();
      
      if (user == null || token == null) {
        throw Exception('User not authenticated');
      }
      
      setState(() {
        _currentUser = user;
      });

      // Fetch donations from API
      final donations = await _db.fetchMyDonations(token);
      
      if (mounted) {
        setState(() {
          _donations = donations;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
        
        // Show error message
        AppSnackbar.error(context, 'Failed to load donation history: ${e.toString()}');
      }
    }
  }

  double get _totalDonated {
    return _donations.fold(0.0, (sum, d) => sum + (d['amount'] as num? ?? 0));
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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadDonations,
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B0000)),
                      ),
                      SizedBox(height: 16.h),
                      TranslatedText(
                        'Loading your donations...',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48.r,
                            color: Colors.red[300],
                          ),
                          SizedBox(height: 16.h),
                          TranslatedText(
                            'Error loading donations',
                            style: TextStyle(
                              fontFamily: 'aBeeZee',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: TranslatedText(
                              _errorMessage!,
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: _loadDonations,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B0000),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: TranslatedText(
                              'Try Again',
                              style: TextStyle(
                                fontFamily: 'aBeeZee',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
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
                                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.volunteer_activism_outlined,
                                        size: 48.r,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16.h),
                                      TranslatedText(
                                        'No donations found',
                                        style: TextStyle(
                                          fontFamily: 'aBeeZee',
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      TranslatedText(
                                        'You haven\'t made any donations yet',
                                        style: TextStyle(
                                          fontFamily: 'aBeeZee',
                                          fontSize: 14.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
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
                                          ).withValues(alpha: 0.15),
                                          radius: 28.r,
                                          child: Icon(
                                            Icons.volunteer_activism,
                                            color: const Color(0xFF8B0000),
                                            size: 28.w,
                                          ),
                                        ),
                                        title: TranslatedText(
                                          donation['seva_type']?.toString() ?? donation['donation_type']?.toString() ?? donation['type']?.toString() ?? 'Donation',
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
                                              '${donation['date_formatted']?.toString() ?? donation['created_at']?.toString() ?? 'N/A'} at ${donation['time_formatted']?.toString() ?? ''}',
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
                                              '₹ ${NumberFormat('#,###').format(donation['amount'] ?? 0)}',
                                              style: TextStyle(
                                                fontFamily: 'aBeeZee',
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF8B0000),
                                              ),
                                            ),
                                            _statusChip(donation['payment_status']?.toString() ?? donation['status']?.toString() ?? 'Success'),
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
    Color bgColor;
    Color textColor = Colors.white;

    switch (status.toUpperCase()) {
      case 'SUCCESS':
      case 'COMPLETED':
      case 'REGISTERED':
        bgColor = Colors.green;
        break;
      case 'PENDING':
      case 'PROCESSING':
        bgColor = Colors.orange;
        break;
      case 'CANCELLED':
      case 'FAILED':
      case 'REJECTED':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TranslatedText(
        status,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 12.sp,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
