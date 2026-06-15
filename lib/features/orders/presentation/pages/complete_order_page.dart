import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/presentation/widgets/complete_order_widgets.dart';

class CompleteOrderPage extends StatefulWidget {
  final OrderEntity? order;
  final String? couponCode;
  const CompleteOrderPage({super.key, this.order, this.couponCode});

  @override
  State<CompleteOrderPage> createState() => _CompleteOrderPageState();
}

class _CompleteOrderPageState extends State<CompleteOrderPage> {
  late TextEditingController _notesController;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  AddressEntity? _selectedAddress;
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomerInfoSection(
                name: _order.customerName ?? 'عميل',
                phone: _order.phoneNumber ?? '',
              ),
              SizedBox(height: 28.h),

              AddressPickerSection(
                selectedAddress: _selectedAddress,
                onAddressSelected: (address) {
                  setState(() {
                    _selectedAddress = address;
                  });
                },
              ),
              SizedBox(height: 28.h),

              DeliveryTimePickerSection(
                selectedDate: _selectedDate,
                selectedTime: _selectedTime,
                onDateSelected: (_) => _selectDate(context),
                onTimeSelected: (_) => _selectTime(context),
              ),
              SizedBox(height: 28.h),

              NotesInputSection(controller: _notesController),
              SizedBox(height: 28.h),

              PaymentMethodSection(
                selectedMethod: _selectedPaymentMethod,
                onMethodChanged: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
              ),
              SizedBox(height: 28.h),

              CompleteOrderSummaryWidget(
                productsTotal:
                    _order.productsTotal ??
                    '${_order.total.toStringAsFixed(0)} ${'sar'.tr()}',
                deliveryPrice: _order.deliveryPrice ?? '0 ${'sar'.tr()}',
                discount: _order.discount ?? '0 ${'sar'.tr()}',
              ),
              SizedBox(height: 32.h),

              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: AppButton(
                  label: 'complete_order_btn'.tr(),
                  onPressed: () {
                    _submitOrder();
                  },
                  size: ButtonSize.large,
                ),
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

  Future<void> _submitOrder() async {
    if (_selectedAddress == null) {
      context.showErrorSnackBar('يرجى اختيار العنوان');
      return;
    }

    final dateStr = _selectedDate != null
        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
        : '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}';
    final timeStr = _selectedTime != null
        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
        : '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}';

    final paymentLabel = switch (_selectedPaymentMethod) {
      PaymentMethod.mastercard => 'mastercard',
      PaymentMethod.visa => 'visa',
      PaymentMethod.cash => 'cash',
    };

    final order = _order.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      address: _selectedAddress!.location,
      deliveryDate: dateStr,
      deliveryTime: timeStr,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : _order.notes,
      paymentMethod: paymentLabel,
      status: OrderStatus.pendingApproval,
    );

    context.push(AppRoutes.pendingOrderDetails, extra: order);
  }
}
