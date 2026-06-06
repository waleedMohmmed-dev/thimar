import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:thimar/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:thimar/features/wallet/presentation/widgets/wallet_widgets.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(const WalletFetched()),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatelessWidget {
  const _WalletView();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'wallet'.tr(),
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const AppBackButton(),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        buildWhen: (prev, curr) =>
            prev.isLoading != curr.isLoading ||
            prev.wallet != curr.wallet ||
            prev.errorMessage != curr.errorMessage,
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoading();
          }

          if (state.errorMessage != null) {
            return AppError(
              message: state.errorMessage!,
              onRetry: () {
                context.read<WalletBloc>().add(const WalletFetched());
              },
            );
          }

          if (state.wallet == null) {
            return const AppEmptyState(
              title: 'no_data',
              subtitle: 'check_back_later',
            );
          }

          final wallet = state.wallet!;

          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              WalletBalanceCard(balance: wallet.balance),
              SizedBox(height: 24.h),
              const ChargeButton(),
              SizedBox(height: 48.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'transaction_history'.tr(),
                    style: tt.titleMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'view_all'.tr(),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (wallet.transactions.isEmpty)
                AppEmptyState(
                  title: 'no_transactions'.tr(),
                  subtitle: 'no_transactions_desc'.tr(),
                )
              else
                ...wallet.transactions.map(
                  (t) => TransactionTile(transaction: t),
                ),
            ],
          );
        },
      ),
    );
  }
}
