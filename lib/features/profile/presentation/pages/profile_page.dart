import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';
import 'package:thimar/features/profile/presentation/cubit/driver_profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DriverProfileCubit>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late TextEditingController _fullnameController;
  late TextEditingController _phoneController;
  late TextEditingController _identityNumberController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _ibanController;
  late TextEditingController _bankNameController;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _phoneController = TextEditingController();
    _identityNumberController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _ibanController = TextEditingController();
    _bankNameController = TextEditingController();
    
    context.read<DriverProfileCubit>().getProfile();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _identityNumberController.dispose();
    _vehicleTypeController.dispose();
    _vehicleModelController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  void _onSave(UserEntity user) {
    final params = DriverProfileParams(
      fullname: _fullnameController.text.trim(),
      phone: _phoneController.text.trim(),
      identityNumber: _identityNumberController.text.trim(),
      iban: _ibanController.text.trim(),
      carType: _vehicleTypeController.text.trim(),
      carModel: _vehicleModelController.text.trim(),
      cityId: 1, // Fix: Get from dropdown
    );
    context.read<DriverProfileCubit>().updateProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverProfileCubit, DriverProfileState>(
      listener: (context, state) {
        if (state.status == DriverProfileStatus.success && state.successMessage != null) {
          context.showSnackBar(state.successMessage!);
        } else if (state.status == DriverProfileStatus.failure) {
          context.showErrorSnackBar(state.errorMessage ?? 'خطأ في تحديث البيانات');
        }
      },
      builder: (context, state) {
        if (state.status == DriverProfileStatus.loading && state.user == null) {
          return const Scaffold(body: Center(child: AppLoading()));
        }

        final user = state.user;
        if (!_isInitialized && user != null) {
          _fullnameController.text = user.name ?? '';
          _phoneController.text = user.phone ?? '';
          _vehicleTypeController.text = user.vehicleType ?? '';
          _vehicleModelController.text = user.vehicleModel ?? '';
          _ibanController.text = user.iban ?? '';
          _bankNameController.text = user.bankName ?? '';
          _isInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(title: Text('الملف الشخصي'.tr())),
          body: user == null ? const SizedBox() : SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                AppTextField(controller: _fullnameController, labelText: 'الاسم'),
                AppTextField(controller: _phoneController, labelText: 'الهاتف'),
                AppButton(
                  label: 'حفظ',
                  onPressed: () => _onSave(user),
                  isLoading: state.status == DriverProfileStatus.loading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
