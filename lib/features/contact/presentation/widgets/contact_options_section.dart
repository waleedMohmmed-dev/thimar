import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/contact/presentation/widgets/contact_option_item.dart';

class ContactOptionsSection extends StatelessWidget {
  const ContactOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContactOptionItem(
          icon: Icons.phone,
          title: 'phone_hint'.tr(),
          subtitle: '01276597628',
        ),
        SizedBox(height: 16.h),
        ContactOptionItem(
          icon: Icons.email,
          title: 'email'.tr(),
          subtitle: 'waleedmoh766@gmail.com',
        ),
        SizedBox(height: 16.h),
        ContactOptionItem(
          icon: Icons.chat,
          title: 'whatsapp'.tr(),
          subtitle: '01276597628',
        ),
      ],
    );
  }
}
