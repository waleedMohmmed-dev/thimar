import 'package:thimar/core/imports/core_imports.dart';

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onNextStep;

  const RegisterButton({
    super.key,
    required this.formKey,
    required this.onNextStep,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'التالي',
      size: ButtonSize.large,
      onPressed: () {
        if (formKey.currentState?.validate() ?? false) {
          onNextStep();
        }
      },
    );
  }
}
