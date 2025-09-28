import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';

class CompanyRevenueScreen extends HookConsumerWidget {
  const CompanyRevenueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyRevenue = useState<int>(45000);
    final transactions = useState<List<Map<String, dynamic>>>([
      {'date': '2025-09-01', 'amount': 2500, 'source': 'Rides'},
      {'date': '2025-09-03', 'amount': 1800, 'source': 'Subscriptions'},
      {'date': '2025-09-06', 'amount': 3200, 'source': 'Rides'},
      {'date': '2025-09-09', 'amount': 1400, 'source': 'Rides'},
      {'date': '2025-09-12', 'amount': 2100, 'source': 'Corporate'},
    ]);

    return ScreenWithTopAppbar(
      title: 'Revenue',
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This Month',
                style: montserrat(20, grey36, FontWeight.w600),
              ),
              12.verticalSpace,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAR ${monthlyRevenue.value}',
                      style: montserrat(24, grey36, FontWeight.w700),
                    ),
                    6.verticalSpace,
                    Text(
                      'Estimated gross revenue for the current month',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              Text(
                'Recent Transactions',
                style: montserrat(20, grey36, FontWeight.w600),
              ),
              12.verticalSpace,
              ...transactions.value.map((t) => Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money, color: accentPurple, size: 20.sp),
                        12.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SAR ${t['amount']}',
                                style: montserrat(16, grey36, FontWeight.w600),
                              ),
                              4.verticalSpace,
                              Text(
                                t['source'] as String,
                                style: montserrat(12, grey5F63, FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          t['date'] as String,
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}


