import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/presentation/bloc/account_bloc.dart';
import 'package:thimar/features/account/presentation/bloc/account_event.dart';

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('confirm_logout'.tr()),
      content: Text('logout_message'.tr()),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text('cancel'.tr()),
        ),
        TextButton(
          onPressed: () {
            context.pop();
            context.read<AccountBloc>().add(const AccountLogoutRequested());
          },
          child: Text(
            'logout'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}
