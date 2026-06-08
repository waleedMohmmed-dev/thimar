import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/complete_order_widgets.dart';
import 'package:thimar/features/orders/presentation/widgets/order_success_dialog.dart';

// ignore_for_file: unnecessary_import

class CompleteOrderPage extends StatefulWidget {
  final OrderEntity? order;
  const CompleteOrderPage({super.key, this.order});

  @override
  State<CompleteOrderPage> createState() => _CompleteOrderPageState();
}

class _CompleteOrderPageState extends State<CompleteOrderPage> {
  late TextEditingController _notesController;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  String? _selectedAddress;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  OrderEntity get _order =>
      widget.order ??
      const OrderEntity(
        id: '',
        dateKey: '',
        total: 0,
        status: OrderStatus.delivered,
        productImagePaths: [],
      );

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'complete_order_title'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerInfoSection(
                name: _order.customerName ?? 'عميل',
                phone: _order.phoneNumber ?? '',
              ),
              SizedBox(height: 24.h),

              AddressPickerSection(
                selectedAddress: _selectedAddress ?? _order.address,
                onAddAddress: () {}, // Client address picker disabled
              ),
              SizedBox(height: 24.h),

              DeliveryTimePickerSection(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelected: (_) => _selectDate(context),
                onTimeSelected: (_) => _selectTime(context),
              ),
              SizedBox(height: 24.h),

              NotesInputSection(controller: _notesController),
              SizedBox(height: 24.h),

              PaymentMethodSection(
                selectedMethod: _selectedPaymentMethod,
                onMethodChanged: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
              ),
              SizedBox(height: 50.h),

              CompleteOrderSummaryWidget(
                productsTotal:
                    _order.productsTotal ??
                    '${_order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                deliveryPrice: _order.deliveryPrice ?? '0 ${'sar'.tr()}',
                discount: _order.discount ?? '0 ${'sar'.tr()}',
              ),
              SizedBox(height: 24.h),

              AppButton(
                label: 'complete_order_btn'.tr(),
                onPressed: () {
                  final order = _buildOrderEntity();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => OrderSuccessDialog(
                      onViewDetails: () {
                        context.goPendingOrderDetails(order);
                      },
                    ),
                  );
                },
                size: ButtonSize.large,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  OrderEntity _buildOrderEntity() {
    final paymentLabel = switch (_selectedPaymentMethod) {
      PaymentMethod.mastercard => 'Mastercard',
      PaymentMethod.visa => 'Visa',
      PaymentMethod.cash => 'cash'.tr(),
    };

    final dateStr = _selectedDate != null
        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
        : _order.deliveryDate;
    final timeStr = _selectedTime != null
        ? _selectedTime!.format(context)
        : _order.deliveryTime;

    return _order.copyWith(
      address: _selectedAddress ?? _order.address,
      deliveryDate: dateStr,
      deliveryTime: timeStr,
      notes: _notesController.text.isNotEmpty
          ? _notesController.text
          : _order.notes,
      paymentMethod: paymentLabel,
    );
  }
}
