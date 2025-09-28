import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/providers/company_data_provider.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';

class CompanyAddVehicleScreen extends HookConsumerWidget {
  const CompanyAddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final plateController = useTextEditingController();
    final makeController = useTextEditingController();
    final modelController = useTextEditingController();
    final yearController = useTextEditingController(text: '2024');
    final seatController = useTextEditingController(text: '4');
    final type = useState<String>('Sedan');
    final transmission = useState<String>('Auto');

    void onSubmit() {
      if (plateController.text.isEmpty || makeController.text.isEmpty || modelController.text.isEmpty) {
        showErrorFlushBar(message: l10n.plateMakeModelRequired, context: context);
        return;
      }
      ref.read(companyDataNotifierProvider.notifier).addVehicle({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'make': makeController.text,
        'model': modelController.text,
        'year': yearController.text,
        'plateNumber': plateController.text,
        'type': type.value,
        'status': 'active',
        'driver': 'Not Assigned',
        'mileage': '0',
        'fuelType': 'Gasoline',
        'seats': int.tryParse(seatController.text) ?? 4,
      });
      showSuccessFlushBar(message: l10n.vehicleCreated, context: context);
      context.pop();
    }

    return ScreenWithTopAppbar(
      title: l10n.addVehicle,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.basicInfo, style: montserrat(20, grey36, FontWeight.w600)),
              12.verticalSpace,
              CustomTextField(titleText: l10n.plateNumber, controller: plateController, hintText: 'ABC-1234'),
              12.verticalSpace,
              Row(children: [
                Expanded(child: CustomTextField(titleText: l10n.make, controller: makeController, hintText: 'Toyota')),
                12.horizontalSpace,
                Expanded(child: CustomTextField(titleText: l10n.model, controller: modelController, hintText: 'Camry')),
              ]),
              12.verticalSpace,
              Row(children: [
                Expanded(child: _dropdownField(l10n.type, type.value, [l10n.sedan, l10n.suv, l10n.van, l10n.bus], (v) => type.value = v ?? l10n.sedan)),
                12.horizontalSpace,
                Expanded(child: _dropdownField(l10n.transmission, transmission.value, [l10n.auto, l10n.manual], (v) => transmission.value = v ?? l10n.auto)),
              ]),
              12.verticalSpace,
              Row(children: [
                Expanded(child: CustomTextField(titleText: l10n.year, controller: yearController, hintText: '2024', inputType: TextInputType.number)),
                12.horizontalSpace,
                Expanded(child: CustomTextField(titleText: l10n.seatCapacity, controller: seatController, hintText: '4', inputType: TextInputType.number)),
              ]),

              24.verticalSpace,
              NormalCustomButton(label: l10n.createVehicle, syncCallback: onSubmit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(String title, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: montserrat(12, grey5F63, FontWeight.w500)),
        6.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: options
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e, style: montserrat(14, grey36, FontWeight.w500)),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}


