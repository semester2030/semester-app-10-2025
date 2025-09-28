import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class OfferCreationScreen extends HookConsumerWidget {
  const OfferCreationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Local state
    final offerAmountController = useTextEditingController();
    final offerDescriptionController = useTextEditingController();
    final selectedOfferType = useState<String>('fixed');
    final selectedCurrency = useState<String>('SAR');
    final isNegotiable = useState<bool>(true);
    final validUntilController = useTextEditingController();

    // Offer types
    final offerTypes = [
      {'key': 'fixed', 'title': 'Fixed Price', 'subtitle': 'Set a fixed amount'},
      {'key': 'range', 'title': 'Price Range', 'subtitle': 'Set min and max'},
      {'key': 'hourly', 'title': 'Hourly Rate', 'subtitle': 'Price per hour'},
    ];

    // Currencies
    final currencies = [
      {'key': 'SAR', 'title': 'Saudi Riyal', 'symbol': 'ر.س'},
      {'key': 'USD', 'title': 'US Dollar', 'symbol': '\$'},
      {'key': 'EUR', 'title': 'Euro', 'symbol': '€'},
    ];

    Future<void> onCreateOffer() async {
      if (offerAmountController.text.isEmpty) {
        // Show error
        return;
      }

      // Create offer logic here
      // TODO: Implement offer creation logic
      
      // Navigate back or to next screen
      context.pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Offer'),
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Create New Offer',
                style: montserrat(24, grey36, FontWeight.w600),
              ),
              8.verticalSpace,
              Text(
                'Set your pricing and terms',
                style: montserrat(16, grey5F63, FontWeight.w400),
              ),
              32.verticalSpace,

              // Offer Type Section
              _buildSectionHeader(
                icon: AppIcons.carIcon,
                title: 'Offer Type',
                subtitle: 'Choose how you want to price your service',
              ),
              16.verticalSpace,
              ...offerTypes.map((type) => _buildOfferTypeCard(
                type: type,
                isSelected: selectedOfferType.value == type['key'],
                onTap: () => selectedOfferType.value = type['key']!,
              )),

              32.verticalSpace,

              // Amount Section
              _buildSectionHeader(
                icon: AppIcons.carIcon,
                title: 'Amount',
                subtitle: 'Set your pricing',
              ),
              16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: offerAmountController,
                      titleText: 'Amount',
                      hintText: 'Enter amount',
                      prefixIcon: AppIcons.carIcon,
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: grey5F63),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCurrency.value,
                          isExpanded: true,
                          items: currencies.map((currency) {
                            return DropdownMenuItem<String>(
                              value: currency['key']!,
                              child: Text(
                                currency['symbol']!,
                                style: montserrat(16, grey36, FontWeight.w500),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              selectedCurrency.value = value;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              32.verticalSpace,

              // Description Section
              _buildSectionHeader(
                icon: AppIcons.carIcon,
                title: 'Description',
                subtitle: 'Add details about your offer',
              ),
              16.verticalSpace,
              CustomTextField(
                controller: offerDescriptionController,
                titleText: 'Offer Description',
                hintText: 'Describe your service and terms',
                prefixIcon: AppIcons.carIcon,
              ),

              32.verticalSpace,

              // Terms Section
              _buildSectionHeader(
                icon: AppIcons.clockIcon,
                title: 'Terms & Conditions',
                subtitle: 'Set offer validity and terms',
              ),
              16.verticalSpace,
              
              // Valid Until
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    validUntilController.text = '${date.day}/${date.month}/${date.year}';
                  }
                },
                child: CustomTextField(
                  controller: validUntilController,
                  titleText: 'Valid Until',
                  hintText: 'Select date',
                  prefixIcon: AppIcons.calendarIcon,
                ),
              ),

              24.verticalSpace,

              // Negotiable Toggle
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: accentPurple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: accentPurple.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Switch(
                      value: isNegotiable.value,
                      onChanged: (value) => isNegotiable.value = value,
                      activeColor: accentPurple,
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Negotiable',
                            style: montserrat(16, grey36, FontWeight.w600),
                          ),
                          4.verticalSpace,
                          Text(
                            'Allow customers to negotiate the price',
                            style: montserrat(14, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              32.verticalSpace,

              // Create Button
              NormalCustomButton(
                label: 'Create Offer',
                onPressed: onCreateOffer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentPurple.withOpacity(0.1),
            accentPurple.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accentPurple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            color: accentPurple,
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: montserrat(16, accentPurple, FontWeight.w600),
                ),
                4.verticalSpace,
                Text(
                  subtitle,
                  style: montserrat(14, grey5F63, FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferTypeCard({
    required Map<String, String> type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected ? accentPurple.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? accentPurple : grey5F63.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accentPurple : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? accentPurple : grey5F63,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 12.sp,
                        color: Colors.white,
                      )
                    : null,
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['title']!,
                      style: montserrat(
                        16,
                        isSelected ? accentPurple : grey36,
                        FontWeight.w600,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      type['subtitle']!,
                      style: montserrat(
                        14,
                        grey5F63,
                        FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
