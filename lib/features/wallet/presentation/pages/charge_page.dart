import 'package:thimar/core/imports/core_imports.dart';

class ChargePage extends StatefulWidget {
  const ChargePage({super.key});

  @override
  State<ChargePage> createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'شحن الان',
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const AppBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات المبلغ',
              style: tt.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            AppTextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              hintText: 'المبلغ الخاص بك',
              suffixWidget: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Text('ر.س', style: context.textTheme.bodyMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
