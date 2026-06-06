import 'package:image_picker/image_picker.dart';
import 'package:thimar/core/extensions/context_extensions.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/account/presentation/bloc/account_bloc.dart';
import 'package:thimar/features/account/presentation/bloc/account_event.dart';
import 'package:thimar/features/account/presentation/bloc/account_state.dart';
import 'package:thimar/features/account/presentation/widgets/account_widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AccountView();
  }
}

class _AccountView extends StatefulWidget {
  const _AccountView();

  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<AccountBloc, AccountState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == AccountStatus.logoutSuccess) {
            context.goRoleSelection();
          }
        },
        child: BlocBuilder<AccountBloc, AccountState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.user != curr.user ||
              prev.errorMessage != curr.errorMessage,
          builder: (context, state) {
            if (state.status == AccountStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == AccountStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: context.theme.primaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.errorMessage ?? 'error_occurred'.tr(),
                      style: TextStyle(fontSize: 16.sp, color: Colors.red[400]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AccountBloc>().add(const AccountStarted());
                      },
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Header
                  ProfileHeader(
                    user: state.user,
                    onImagePick: () => _pickImage(context),
                  ),
                  SizedBox(height: 24.h),
                  // Menu Items
                  MenuItemsSection(
                    isDriver: state.user?.isDriver ?? false,
                    onLogout: () => showLogoutDialog(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null || !context.mounted) return;

    context.read<AccountBloc>().add(
      AccountProfileImagePicked(imagePath: picked.path),
    );
  }
}
