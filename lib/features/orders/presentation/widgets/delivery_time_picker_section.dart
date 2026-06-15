import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/orders/presentation/widgets/time_picker_card.dart';

class DeliveryTimePickerSection extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const DeliveryTimePickerSection({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'set_delivery_time'.tr(),
          style: tt.bodyLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TimePickerCard(
                icon: Icons.access_time,
                label: 'choose_time'.tr(),
                value: selectedTime != null
                    ? selectedTime!.format(context)
                    : '',
                onTap: () => onTimeSelected(selectedTime ?? TimeOfDay.now()),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TimePickerCard(
                icon: Icons.calendar_today,
                label: 'choose_date'.tr(),
                value: selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}'
                    : '',
                onTap: () => onDateSelected(selectedDate ?? DateTime.now()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
