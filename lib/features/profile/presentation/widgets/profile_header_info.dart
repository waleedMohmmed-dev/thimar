import 'package:thimar/core/imports/core_imports.dart';

class ProfileHeaderInfo extends StatelessWidget {
  final String? name;
  final String? phone;

  const ProfileHeaderInfo({super.key, this.name, this.phone});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    return Column(
      children: [
        Text(
          name ?? '',
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          phone ?? '',
          style: tt.bodyLarge?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
