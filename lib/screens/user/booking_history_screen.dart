import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temple_app/blocs/theme/theme_bloc.dart';
import 'package:temple_app/widgets/translated_text.dart';
import 'package:intl/intl.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  // Dummy data - replace with real API response later
  final List<Map<String, dynamic>> _bookings = [
    {
      "service": "Abhishekam - Ganapathi",
      "date": "2026-01-25",
      "time": "07:30 AM",
      "status": "Confirmed",
      "amount": 501,
      "paymentMethod": "UPI",
    },
    {
      "service": "VIP Room - 2 nights",
      "date": "2025-12-20 to 2025-12-22",
      "time": "-",
      "status": "Completed",
      "amount": 4500,
      "paymentMethod": "Credit Card",
    },
    {
      "service": "Special Darshan Pass",
      "date": "2025-11-15",
      "time": "05:00 PM",
      "status": "Cancelled",
      "amount": 0,
      "paymentMethod": "Debit Card",
      "cancelReason": "Personal reason",
    },
    {
      "service": "Satyanarayan Puja",
      "date": "2026-01-10",
      "time": "10:00 AM",
      "status": "Pending",
      "amount": 1101,
      "paymentMethod": "Cash",
    },
  ];

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
          ),
          body: _bookings.isEmpty
              ? Center(
                  child: TranslatedText(
                    'No bookings found',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _bookings[index];
                    final isCancelled = booking['status'] == 'Cancelled';
                    final isPending =
                        booking['status'] == 'Pending';

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
                                  child: Text(
                                    booking['service'],
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
                                _statusChip(booking['status']),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            _infoRow(
                              Icons.calendar_today,
                              'Date',
                              booking['date'],
                            ),
                            if (booking['time'] != '-')
                              _infoRow(
                                Icons.access_time,
                                'Time',
                                booking['time'],
                              ),
                            _infoRow(
                              Icons.receipt,
                              'Payment Method',
                              booking['paymentMethod'],
                            ),
                            if (isCancelled && booking['cancelReason'] != null)
                              _infoRow(
                                Icons.info,
                                'Reason',
                                booking['cancelReason'],
                              ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹ ${NumberFormat('#,###').format(booking['amount'])}',
                                  style: TextStyle(
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
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
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
          Text(
            '$label: ',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
