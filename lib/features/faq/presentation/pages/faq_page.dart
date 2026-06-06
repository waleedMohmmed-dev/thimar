import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_event.dart';
import 'package:thimar/features/faq/presentation/bloc/faq_state.dart';
import 'package:thimar/features/faq/presentation/widgets/faq_tile.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FaqBloc>()..add(const FaqFetched()),
      child: const _FaqView(),
    );
  }
}

class _FaqView extends StatelessWidget {
  const _FaqView();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'faqs'.tr(),
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const AppBackButton(),
      ),
      body: BlocBuilder<FaqBloc, FaqState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoading();
          }

          if (state.errorMessage != null) {
            return AppError(
              message: state.errorMessage!,
              onRetry: () {
                context.read<FaqBloc>().add(const FaqFetched());
              },
            );
          }

          if (state.faqs.isEmpty) {
            return const AppEmptyState(
              title: 'no_faqs',
              subtitle: 'check_back_later',
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: state.faqs.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              return FaqTile(faq: state.faqs[index]);
            },
          );
        },
      ),
    );
  }
}
