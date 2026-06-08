import 'dart:io';

import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/core/networking/endpoints.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';
import 'package:thimar/features/profile/presentation/cubit/driver_profile_cubit.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_bloc.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_event.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_state.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<DriverProfileCubit>()),
        BlocProvider(create: (context) => sl<CarModelsBloc>()),
      ],
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
  late TextEditingController _oldPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _ibanController;

  bool _isPersonalData = true;
  bool _isInitialized = false;
  String _selectedCountryCode = '+966';
  String? _selectedCityId;
  String? _selectedModelId;

  File? _profileImageFile;
  File? _driverLicenseImage;
  File? _vehicleRegistrationImage;
  File? _vehicleInsuranceImage;
  File? _vehicleFrontImage;
  File? _vehicleRearImage;

  List<Map<String, String>> _cities = [];
  bool _isLoadingCities = true;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _phoneController = TextEditingController();
    _identityNumberController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _vehicleTypeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _ibanController = TextEditingController();

    context.read<DriverProfileCubit>().getProfile();
    context.read<CarModelsBloc>().add(const CarModelsFetched());
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      final apiService = sl<ApiService>();
      final response = await apiService.get('cities/1');
      if (response['status'] == 'success' && response['data'] != null) {
        final list = (response['data'] as List)
            .map(
              (e) => {'id': e['id'].toString(), 'name': e['name'].toString()},
            )
            .toList();
        if (mounted) {
          setState(() {
            _cities = list;
            _isLoadingCities = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingCities = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingCities = false);
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _identityNumberController.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _vehicleTypeController.dispose();
    _vehicleModelController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  void _pickImage(ValueChanged<File?> onPicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final cacheService = sl<HiveCacheService>();
      await cacheService.save(
        key: CacheKeys.profileImage,
        value: pickedFile.path,
        boxName: CacheConstants.userBox,
      );
      onPicked(File(pickedFile.path));
    }
  }

  Future<void> _onSave() async {
    if (_selectedCityId == null) {
      context.showErrorSnackBar('يرجى اختيار المدينة');
      return;
    }

    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _passwordController.text.trim();
    if (oldPassword.isNotEmpty || newPassword.isNotEmpty) {
      if (oldPassword.isEmpty) {
        context.showErrorSnackBar('يرجى إدخال كلمة المرور القديمة');
        return;
      }
      if (newPassword.isEmpty) {
        context.showErrorSnackBar('يرجى إدخال كلمة المرور الجديدة');
        return;
      }
      try {
        final apiService = sl<ApiService>();
        await apiService.put(
          Endpoints.editPassword,
          body: {'old_password': oldPassword, 'password': newPassword},
        );
      } catch (e) {
        context.showErrorSnackBar('فشل تغيير كلمة المرور');
        return;
      }
    }

    final params = DriverProfileParams(
      fullname: _fullnameController.text.trim(),
      phone: _phoneController.text.trim(),
      identityNumber: _identityNumberController.text.trim(),
      iban: _ibanController.text.trim(),
      carType: _vehicleTypeController.text.trim(),
      carModel: _vehicleModelController.text.trim(),
      cityId: int.parse(_selectedCityId!),
      imagePath: _profileImageFile?.path,
      carLicenceImagePath: _driverLicenseImage?.path,
      carFormImagePath: _vehicleRegistrationImage?.path,
      carInsuranceImagePath: _vehicleInsuranceImage?.path,
      carFrontImagePath: _vehicleFrontImage?.path,
      carBackImagePath: _vehicleRearImage?.path,
    );
    context.read<DriverProfileCubit>().updateProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverProfileCubit, DriverProfileState>(
      listener: (context, state) {
        if (state.status == DriverProfileStatus.success &&
            state.successMessage != null) {
          context.showSnackBar(state.successMessage!);
        } else if (state.status == DriverProfileStatus.failure) {
          context.showErrorSnackBar(
            state.errorMessage ?? 'خطأ في تحديث البيانات',
          );
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
          _identityNumberController.text = user.identityNumber ?? '';
          _vehicleTypeController.text = user.vehicleType ?? '';
          _vehicleModelController.text = user.vehicleModel ?? '';
          _ibanController.text = user.iban ?? '';
          if (user.cityId != null) _selectedCityId = user.cityId.toString();
          _isInitialized = true;
        }

        return Scaffold(
          appBar: AppBar(title: Text('الملف الشخصي'.tr())),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: AppSegmentedControl<bool>(
                    value: _isPersonalData,
                    onChanged: (val) => setState(() => _isPersonalData = val),
                    items: [
                      AppSegmentedControlItem(
                        value: true,
                        labelKey: 'البيانات الشخصية',
                      ),
                      AppSegmentedControlItem(
                        value: false,
                        labelKey: 'بيانات السياره',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(
                            (f) => setState(() => _profileImageFile = f),
                          ),
                          child: CircleAvatar(
                            radius: 48.r,
                            backgroundColor:
                                context.colorScheme.primaryContainer,
                            child: _buildProfileImage(),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _isPersonalData
                            ? _buildPersonalDataSection(context, user, state)
                            : _buildCarDataSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    if (_profileImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(48.r),
        child: Image.file(
          _profileImageFile!,
          fit: BoxFit.cover,
          width: 96.r,
          height: 96.r,
        ),
      );
    }
    final user = context.read<DriverProfileCubit>().state.user;
    if (user?.profileImage != null && user!.profileImage!.isNotEmpty) {
      final imagePath = user.profileImage!;
      final resolved =
          imagePath.startsWith('http://') || imagePath.startsWith('https://')
          ? imagePath
          : '${Endpoints.baseUrl.replaceAll('/api/', '/')}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
      return ClipRRect(
        borderRadius: BorderRadius.circular(48.r),
        child: Image.network(
          resolved,
          fit: BoxFit.cover,
          width: 96.r,
          height: 96.r,
          errorBuilder: (_, __, ___) => Icon(
            Icons.camera_alt_outlined,
            size: 28.r,
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }
    return Icon(
      Icons.camera_alt_outlined,
      size: 28.r,
      color: context.colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildPersonalDataSection(
    BuildContext context,
    UserEntity? user,
    DriverProfileState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UsernameField(controller: _fullnameController, label: 'الاسم'),
        SizedBox(height: 16.h),
        PhoneField(
          controller: _phoneController,
          selectedCountryCode: _selectedCountryCode,
          onCountryCodeChanged: (val) =>
              setState(() => _selectedCountryCode = val),
        ),
        SizedBox(height: 16.h),
        _buildCityDropdown(),
        SizedBox(height: 16.h),
        IdentityNumberField(controller: _identityNumberController),
        SizedBox(height: 16.h),
        PasswordField(
          controller: _oldPasswordController,
          hintText: 'كلمة المرور القديمة',
        ),
        SizedBox(height: 16.h),
        PasswordField(
          controller: _passwordController,
          hintText: 'كلمة المرور الجديدة',
        ),
        SizedBox(height: 24.h),
        AppButton(
          label: 'تعديل البيانات',
          size: ButtonSize.large,
          isLoading: state.status == DriverProfileStatus.loading,
          onPressed: _onSave,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildCarDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('المستندات المطلوبة'),
        SizedBox(height: 16.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = 12.w;
            final cardWidth = (constraints.maxWidth - (2 * gap)) / 3;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: ImageUploadField(
                        label: 'صورة رخصة القيادة',
                        selectedImage: _driverLicenseImage,
                        onImageSelected: (f) =>
                            setState(() => _driverLicenseImage = f),
                      ),
                    ),
                    SizedBox(width: gap),
                    SizedBox(
                      width: cardWidth,
                      child: ImageUploadField(
                        label: 'استمارة السيارة',
                        selectedImage: _vehicleRegistrationImage,
                        onImageSelected: (f) =>
                            setState(() => _vehicleRegistrationImage = f),
                      ),
                    ),
                    SizedBox(width: gap),
                    SizedBox(
                      width: cardWidth,
                      child: ImageUploadField(
                        label: 'تأمين السيارة',
                        selectedImage: _vehicleInsuranceImage,
                        onImageSelected: (f) =>
                            setState(() => _vehicleInsuranceImage = f),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: ImageUploadField(
                        label: 'السيارة من الأمام',
                        selectedImage: _vehicleFrontImage,
                        onImageSelected: (f) =>
                            setState(() => _vehicleFrontImage = f),
                      ),
                    ),
                    SizedBox(width: gap),
                    SizedBox(
                      width: cardWidth,
                      child: ImageUploadField(
                        label: 'السيارة من الخلف',
                        selectedImage: _vehicleRearImage,
                        onImageSelected: (f) =>
                            setState(() => _vehicleRearImage = f),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        SizedBox(height: 24.h),
        _buildSectionTitle('بيانات السيارة'),
        SizedBox(height: 16.h),
        VehicleTypeField(controller: _vehicleTypeController),
        SizedBox(height: 16.h),
        _buildModelDropdown(),
        SizedBox(height: 16.h),
        IbanField(controller: _ibanController),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    return Text(
      title,
      style: tt.titleMedium?.copyWith(
        color: cs.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCityId,
      decoration: InputDecoration(
        hintText: 'المدينة',
        prefixIcon: const Icon(Icons.location_city_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      items: _cities
          .map(
            (city) =>
                DropdownMenuItem(value: city['id'], child: Text(city['name']!)),
          )
          .toList(),
      onChanged: (val) => setState(() => _selectedCityId = val),
      validator: (val) {
        if (_isLoadingCities) return null;
        if (val == null || val.isEmpty) return 'يرجى اختيار المدينة';
        return null;
      },
    );
  }

  Widget _buildModelDropdown() {
    return BlocBuilder<CarModelsBloc, CarModelsState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          value: _selectedModelId,
          decoration: InputDecoration(
            hintText: 'موديل السيارة',
            prefixIcon: const Icon(Icons.directions_car_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          items: state.carModels
              .map(
                (model) => DropdownMenuItem(
                  value: model.id.toString(),
                  child: Text(model.name),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedModelId = val),
          validator: (val) {
            if (state.isLoading) return null;
            if (val == null || val.isEmpty) return 'يرجى اختيار موديل السيارة';
            return null;
          },
        );
      },
    );
  }
}
