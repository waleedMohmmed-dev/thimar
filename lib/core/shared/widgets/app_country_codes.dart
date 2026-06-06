import 'package:thimar/core/imports/core_imports.dart';

class AppCountryCodes extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const AppCountryCodes({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<Map<String, String>> countries = [
    {'code': '+966', 'flag': '🇸🇦', 'name': 'SA'},
    {'code': '+971', 'flag': '🇦🇪', 'name': 'AE'},
    {'code': '+974', 'flag': '🇶🇦', 'name': 'QA'},
    {'code': '+973', 'flag': '🇧🇭', 'name': 'BH'},
    {'code': '+965', 'flag': '🇰🇼', 'name': 'KW'},
    {'code': '+968', 'flag': '🇴🇲', 'name': 'OM'},
    {'code': '+20', 'flag': '🇪🇬', 'name': 'EG'},
    {'code': '+962', 'flag': '🇯🇴', 'name': 'JO'},
    {'code': '+961', 'flag': '🇱🇧', 'name': 'LB'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      width: 87.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outline),
      ),
      child: Align(
        alignment: AlignmentDirectional.center,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: Icon(Icons.arrow_drop_down, color: cs.primary, size: 20.sp),
            dropdownColor: cs.surface,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
            items: countries.map((c) {
              return DropdownMenuItem<String>(
                value: c['code'],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c['flag']!, style: TextStyle(fontSize: 18.sp)),
                    SizedBox(width: 6.w),
                    Text(c['code']!),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
          ),
        ),
      ),
    );
  }
}
