import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_transaction_entity.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _cashoutController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    _cashoutController.dispose();
    super.dispose();
  }

  void _showChargeSheet(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            24.w,
            24.w,
            24.w + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'شحن المحفظة',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'المبلغ',
                  hintText: 'أدخل المبلغ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  prefixText: '₪ ',
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _transactionIdController,
                decoration: InputDecoration(
                  labelText: 'رقم العملية',
                  hintText: 'أدخل رقم العملية',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  final isLoading = state.chargeStatus == WalletStatus.loading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              final amount =
                                  double.tryParse(_amountController.text.trim());
                              final txnId =
                                  _transactionIdController.text.trim();
                              if (amount == null || amount <= 0 || txnId.isEmpty) {
                                context.showErrorSnackBar(
                                  'يرجى إدخال المبلغ ورقم العملية',
                                );
                                return;
                              }
                              context.read<WalletBloc>().add(
                                WalletChargeRequested(
                                  amount: amount,
                                  transactionId: txnId,
                                ),
                              );
                            },
                      child: isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'شحن',
                              style: tt.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  void _showCashoutSheet(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24.w,
            24.w,
            24.w,
            24.w + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'سحب من المحفظة',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  return TextField(
                    controller: _cashoutController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'المبلغ',
                      hintText: 'أدخل المبلغ (الرصيد: ${state.balance.toStringAsFixed(1)} ₪)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixText: '₪ ',
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              BlocBuilder<WalletBloc, WalletState>(
                builder: (context, state) {
                  final isLoading =
                      state.cashoutStatus == WalletStatus.loading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              final amount = double.tryParse(
                                _cashoutController.text.trim(),
                              );
                              if (amount == null || amount <= 0) {
                                context.showErrorSnackBar(
                                  'يرجى إدخال مبلغ صحيح',
                                );
                                return;
                              }
                              if (amount > state.balance) {
                                context.showErrorSnackBar(
                                  'الرصيد غير كافٍ',
                                );
                                return;
                              }
                              context.read<WalletBloc>().add(
                                WalletCashoutRequested(amount: amount),
                              );
                            },
                      child: isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'سحب',
                              style: tt.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return BlocConsumer<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state.chargeSuccessMessage != null) {
          context.showSuccessSnackBar(state.chargeSuccessMessage!);
          context.read<WalletBloc>().add(const WalletClearMessages());
          Navigator.pop(context);
          _amountController.clear();
          _transactionIdController.clear();
        }
        if (state.cashoutSuccessMessage != null) {
          context.showSuccessSnackBar(state.cashoutSuccessMessage!);
          context.read<WalletBloc>().add(const WalletClearMessages());
          Navigator.pop(context);
          _cashoutController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'المحفظة',
              style: tt.headlineSmall?.copyWith(
                color: cs.primary,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            centerTitle: true,
            leading: const AppBackButton(),
          ),
          body: state.status == WalletStatus.loading && state.balance == 0
              ? const Center(child: AppLoading())
              : state.status == WalletStatus.failure && state.balance == 0
                  ? AppError(
                      message: state.errorMessage ?? 'unexpected_error'.tr(),
                      onRetry: () => context
                          .read<WalletBloc>()
                          .add(const WalletLoadRequested()),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<WalletBloc>()
                            .add(const WalletLoadRequested());
                      },
                      child: ListView(
                        padding: EdgeInsets.all(16.w),
                        children: [
                          _buildBalanceCard(context, state),
                          SizedBox(height: 20.h),
                          _buildActions(context, state),
                          SizedBox(height: 24.h),
                          if (state.transactions.isNotEmpty) ...[
                            Text(
                              'آخر المعاملات',
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ...state.transactions.map(
                              (txn) => _buildTransactionItem(
                                context, txn, state.transactions.last == txn,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildBalanceCard(BuildContext context, WalletState state) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'الرصيد الحالي',
            style: tt.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.balance.toStringAsFixed(1),
                style: tt.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 42.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  '₪',
                  style: tt.titleLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WalletState state) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.add_card,
            label: 'شحن',
            color: cs.primary,
            onTap: () => _showChargeSheet(context),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.money_off,
            label: 'سحب',
            color: cs.error,
            onTap: () => _showCashoutSheet(context),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    WalletTransactionEntity txn,
    bool isLast,
  ) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    final isCharge = txn.transactionType == 'charge';

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isCharge
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                isCharge ? Icons.add : Icons.remove,
                color: isCharge ? Colors.green : Colors.red,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.statusTrans,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    txn.date,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isCharge ? '+' : '-'}${txn.amount.toStringAsFixed(1)} ₪',
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isCharge ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          SizedBox(height: 12.h),
          Divider(height: 1, color: cs.outline.withValues(alpha: 0.2)),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }
}
