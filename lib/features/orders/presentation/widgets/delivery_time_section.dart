import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/delivery_time_card.dart';

class DeliveryTimeSection extends StatelessWidget {
  final OrderEntity order;

  const DeliveryTimeSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (order.deliveryDate != null) ...[
          Expanded(
            child: DeliveryTimeCard(
              icon: Icons.calendar_today,
              label: 'delivery_date'.tr(),
              value: order.deliveryDate!,
            ),
          ),
          SizedBox(width: 12.w),
        ],
        if (order.deliveryTime != null) ...[
          Expanded(
            child: DeliveryTimeCard(
              icon: Icons.access_time,
              label: 'delivery_time'.tr(),
              value: order.deliveryTime!,
            ),
          ),
        ],
      ],
    );
  }
}
