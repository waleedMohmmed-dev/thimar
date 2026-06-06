import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/transaction_history/presentation/bloc/transaction_history_bloc.dart';
import 'package:thimar/features/transaction_history/presentation/bloc/transaction_history_event.dart';
import 'package:thimar/features/transaction_history/presentation/bloc/transaction_history_state.dart';
import 'package:thimar/features/transaction_history/presentation/widgets/history_widgets.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionHistoryBloc>().add(
      const TransactionHistoryLoaded(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'transaction_history'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          if (state.status == TransactionHistoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.transactions.isEmpty) {
            return const HistoryEmptyState();
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.transactions.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return HistoryTransactionItem(transaction: transaction);
            },
          );
        },
      ),
    );
  }
}
