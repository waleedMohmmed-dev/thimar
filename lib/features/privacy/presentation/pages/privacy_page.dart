import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:thimar/features/privacy/presentation/bloc/privacy_event.dart';
import 'package:thimar/features/privacy/presentation/bloc/privacy_state.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PrivacyBloc>()..add(const PrivacyFetched()),
      child: const _PrivacyView(),
    );
  }
}

class _PrivacyView extends StatelessWidget {
  const _PrivacyView();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'privacy_policy'.tr(),
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const AppBackButton(),
      ),
      body: BlocBuilder<PrivacyBloc, PrivacyState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoading();
          }

          if (state.errorMessage != null) {
            return AppError(
              message: state.errorMessage!,
              onRetry: () {
                context.read<PrivacyBloc>().add(const PrivacyFetched());
              },
            );
          }

          if (state.privacy == null) {
            return const AppEmptyState(
              title: 'no_data',
              subtitle: 'check_back_later',
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Text(
              state.privacy!.content,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.8,
              ),
              textAlign: TextAlign.justify,
            ),
          );
        },
      ),
    );
  }
}
