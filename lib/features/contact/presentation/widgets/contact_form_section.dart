import 'package:thimar/core/imports/core_imports.dart';

class ContactFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;

  const ContactFormSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.messageController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تواصل معنا',
          style: tt.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: nameController,
          labelText: 'الاسم',
          hintText: 'أدخل اسمك الكامل',
          prefixIcon: Icons.person_outline,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: phoneController,
          labelText: 'رقم الموبايل',
          hintText: 'أدخل رقم جوالك',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: messageController,
          labelText: 'الموضوع',
          hintText: 'اكتب رسالتك هنا...',
          prefixIcon: Icons.edit_outlined,
          maxLines: 5,
          minLines: 3,
        ),
        SizedBox(height: 24.h),
        AppButton(label: 'إرسال', onPressed: onSubmit),
      ],
    );
  }
}
