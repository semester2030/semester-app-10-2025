import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/providers/company_data_provider.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class CompanyAddDriverScreen extends HookConsumerWidget {
  const CompanyAddDriverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final nameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final status = useState<String>('online');
    // Optional: selected vehicle plate (can be assigned later)
    final selectedVehiclePlate = useState<String?>(null);

    void onSubmit() {
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        showErrorFlushBar(message: l10n.nameAndPhoneRequired, context: context);
        return;
      }
      ref.read(companyDataNotifierProvider.notifier).addDriver({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'status': 'online',
        'rating': 0.0,
        'totalTrips': 0,
        'vehicle': selectedVehiclePlate.value ?? 'Not Assigned',
        'currentLocation': '—',
        'earnings': 0,
        'documents': {},
      });
      showSuccessFlushBar(message: l10n.driverCreated, context: context);
      context.pop();
    }

    return ScreenWithTopAppbar(
      title: l10n.addDriver,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.driverInfo, style: montserrat(20, grey36, FontWeight.w600)),
              12.verticalSpace,
              CustomTextField(titleText: l10n.fullName, controller: nameController, hintText: l10n.enterName),
              12.verticalSpace,
              CustomTextField(titleText: l10n.phoneNumber, controller: phoneController, hintText: '+9665XXXXXXXX', inputType: TextInputType.phone),
              12.verticalSpace,
              CustomTextField(titleText: l10n.emailOptional, controller: emailController, hintText: 'email@example.com'),
              16.verticalSpace,

              16.verticalSpace,
              Text(l10n.status, style: montserrat(20, grey36, FontWeight.w600)),
              8.verticalSpace,
              Wrap(spacing: 8.w, children: [
                _statusChip(l10n.online, status.value == 'online', () => status.value = 'online'),
                _statusChip(l10n.offline, status.value == 'offline', () => status.value = 'offline'),
                _statusChip(l10n.busy, status.value == 'busy', () => status.value = 'busy'),
              ]),

              16.verticalSpace,
              Text(l10n.assignVehicleOptional, style: montserrat(20, grey36, FontWeight.w600)),
              8.verticalSpace,
              _vehicleDropdown(context, selectedVehiclePlate.value, (value) => selectedVehiclePlate.value = value),

              24.verticalSpace,
              NormalCustomButton(label: l10n.createDriver, syncCallback: onSubmit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? accentPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(label, style: montserrat(12, selected ? Colors.white : grey36, FontWeight.w600)),
      ),
    );
  }

  Widget _vehicleDropdown(BuildContext context, String? selected, ValueChanged<String?> onChanged) {
    final l10n = AppLocalizations.of(context)!;
    final options = <String>[l10n.unassigned, 'ABC-1234', 'XYZ-5678'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected ?? l10n.unassigned,
          items: options
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e, style: montserrat(14, grey36, FontWeight.w500)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}


