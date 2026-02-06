import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mslgd/blocs/theme/theme_bloc.dart';
import 'package:mslgd/services/db_functions.dart';
import 'package:mslgd/models/user_model.dart';
import 'package:mslgd/utils/auth_utils.dart';
import 'package:mslgd/widgets/common/snackbar_widget.dart';
import 'package:mslgd/widgets/translated_text.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final DBFunctions _db = DBFunctions();
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;
  // ignore: unused_field
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
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

      // Fetch bookings from API
      final bookings = await _db.fetchMyBookings(token);

      if (mounted) {
        setState(() {
          _bookings = bookings;
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
        AppSnackbar.error(
          context,
          'Failed to load booking history: ${e.toString()}',
        );
      }
    }
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
              'Booking History',
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
                onPressed: _loadBookings,
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF8B0000),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TranslatedText(
                        'Loading your bookings...',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
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
                        'Error loading bookings',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
                        onPressed: _loadBookings,
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
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : _bookings.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 48.r,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      TranslatedText(
                        'No bookings found',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      TranslatedText(
                        'You haven\'t made any bookings yet',
                        style: TextStyle(
                          fontFamily: 'aBeeZee',
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    final isPending = booking['status'] == 'Pending';

                    return Card(
                      margin: EdgeInsets.only(bottom: 16.h),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      color: isDark ? theme.cardColor : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TranslatedText(
                                    booking['pooja_name']?.toString() ??
                                        'Unknown Service',
                                    style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF8B0000),
                                    ),
                                  ),
                                ),
                                _statusChip(
                                  booking['status']?.toString() ?? 'Unknown',
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _infoRow(
                              Icons.calendar_today,
                              'Date',
                              booking['booking_date']?.toString() ?? 'N/A',
                            ),
                            if (booking['booking_time'] != null)
                              _infoRow(
                                Icons.access_time,
                                'Time',
                                booking['booking_time'].toString(),
                              ),
                            if (booking['payment_method'] != null)
                              _infoRow(
                                Icons.receipt,
                                'Payment Method',
                                booking['payment_method'].toString(),
                              ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TranslatedText(
                                  '₹ ${NumberFormat('#,###').format(booking['amount'] ?? 0)}',
                                  style: TextStyle(
                                    fontFamily: 'aBeeZee',
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF8B0000),
                                  ),
                                ),
                                if (isPending)
                                  OutlinedButton(
                                    onPressed: () {
                                      // TODO: Pay now or view details
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: const Color(0xFF8B0000),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: TranslatedText(
                                      'Pay Now',
                                      style: TextStyle(
                                        fontFamily: 'aBeeZee',
                                        color: const Color(0xFF8B0000),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _statusChip(String status) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'Confirmed':
        bgColor = Colors.green;
        break;
      case 'Completed':
        bgColor = Colors.blue;
        break;
      case 'Cancelled':
        bgColor = Colors.red;
        break;
      case 'Pending':
        bgColor = Colors.orange;
        break;
      case 'Registered':
        bgColor = Colors.green;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: TranslatedText(
        status,
        style: TextStyle(
          fontFamily: 'aBeeZee',
          fontSize: 12.sp,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 18.w, color: Colors.grey[600]),
          SizedBox(width: 10.w),
          TranslatedText(
            '$label: ',
            style: TextStyle(
              fontFamily: 'aBeeZee',
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: TranslatedText(
              value,
              style: TextStyle(
                fontFamily: 'aBeeZee',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
