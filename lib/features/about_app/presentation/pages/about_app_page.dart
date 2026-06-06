import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/about_app/presentation/cubit/about_app_cubit.dart';
import 'package:thimar/features/about_app/presentation/widgets/about_app_widgets.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final cs = context.colorScheme;

    return BlocProvider(
      create: (_) => sl<AboutAppCubit>()..loadAbout(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'حول التطبيق',
            style: tt.titleLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const AppBackButton(),
        ),
        body: BlocBuilder<AboutAppCubit, AboutAppStates>(
          builder: (context, state) {
            if (state is AboutAppLoading) {
              return const Center(child: AppLoading());
            }

            if (state is AboutAppError) {
              return AppError(
                message: state.message,
                onRetry: () => context.read<AboutAppCubit>().loadAbout(),
              );
            }

            final data = state is AboutAppLoaded ? state : null;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 160.w,
                      height: 160.h,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  if (data != null && data.address.isNotEmpty)
                    AboutSectionWidget(
                      title: 'معلومات الاتصال',
                      body: '• العنوان: ${data.address}',
                    ),
                  if (data != null && data.phone.isNotEmpty)
                    AboutSectionWidget(
                      title: 'الهاتف',
                      body: '• الهاتف الموحد: ${data.phone}',
                    ),
                  if (data != null && data.email.isNotEmpty)
                    AboutSectionWidget(
                      title: 'البريد الإلكتروني',
                      body: '• البريد الإلكتروني: ${data.email}',
                    ),
                  if (data != null && data.terms.isNotEmpty)
                    AboutSectionWidget(
                      title: 'الشروط والأحكام',
                      body: data.terms,
                    ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Text(
                      'جميع الحقوق محفوظة © 2026 تطبيق ثمّار',
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
