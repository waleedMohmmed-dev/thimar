import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:thimar/features/contact/presentation/bloc/contact_event.dart';
import 'package:thimar/features/contact/presentation/bloc/contact_state.dart';
import 'package:thimar/features/contact/presentation/widgets/contact_widgets.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return BlocProvider(
      create: (_) => sl<ContactBloc>(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'contact_us'.tr(),
            style: tt.titleLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const AppBackButton(),
        ),
        body: BlocListener<ContactBloc, ContactState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == ContactStatus.success) {
              context.showSnackBar('تم إرسال رسالتك بنجاح');
              _nameController.clear();
              _phoneController.clear();
              _messageController.clear();
            } else if (state.status == ContactStatus.failure) {
              context.showErrorSnackBar(
                state.errorMessage ?? 'حدث خطأ أثناء الإرسال',
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const ContactOptionsSection(),
                  SizedBox(height: 24.h),
                  ContactFormSection(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    messageController: _messageController,
                    onSubmit: _onSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ContactBloc>().add(
        ContactSubmitted(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
    }
  }
}
