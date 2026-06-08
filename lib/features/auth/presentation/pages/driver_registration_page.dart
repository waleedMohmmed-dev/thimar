import 'dart:io';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/models/user_role.dart';
import 'package:thimar/core/networking/api_service.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_event.dart';
import 'package:thimar/features/auth/presentation/bloc/auth_state.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_bloc.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_event.dart';
import 'package:thimar/features/car_models/presentation/bloc/car_models_state.dart';

class RegistrationPage extends StatelessWidget {
  final UserRole userRole;

  const RegistrationPage({super.key, this.userRole = UserRole.driver});

  @override
  Widget build(BuildContext context) {
    final isClient = userRole == UserRole.client;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        if (!isClient) BlocProvider(create: (_) => sl<CarModelsBloc>()),
      ],
      child: _DriverRegistrationView(userRole: userRole),
    );
  }
}

class _DriverRegistrationView extends StatefulWidget {
  final UserRole userRole;

  const _DriverRegistrationView({required this.userRole});

  @override
  State<_DriverRegistrationView> createState() =>
      _DriverRegistrationViewState();
}

class _DriverRegistrationViewState extends State<_DriverRegistrationView> {
  // Step navigation
  final _pageController = PageController();
  int _currentStep = 1;

  // Step 1: Personal data
  final _step1FormKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  late TextEditingController _identityNumberController;
  late TextEditingController _locationController;
  String _selectedCountryCode = '+966';

  // City dropdown
  List<Map<String, String>> _cities = [];
  String? _selectedCityId;
  bool _isLoadingCities = true;

  // Step 2: Vehicle data
  final _step2FormKey = GlobalKey<FormState>();
  late TextEditingController _vehicleTypeController;
  String? _selectedModelId;
  late TextEditingController _ibanController;
  late TextEditingController _bankNameController;

  // Step 2 images
  File? _driverLicenseImage;
  File? _vehicleRegistrationImage;
  File? _vehicleInsuranceImage;
  File? _vehicleFrontImage;
  File? _vehicleRearImage;

  // Terms
  bool _agreedToTerms = false;

  bool get _isClient => widget.userRole == UserRole.client;

  @override
  void initState() {
    super.initState();
    // Step 1 controllers
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _identityNumberController = TextEditingController();
    _locationController = TextEditingController();
    // Step 2 controllers
    _vehicleTypeController = TextEditingController();
    _ibanController = TextEditingController();
    _bankNameController = TextEditingController();

    _fetchCities();
    if (!_isClient) {
      context.read<CarModelsBloc>().add(const CarModelsFetched());
    }
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
    _pageController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _identityNumberController.dispose();
    _locationController.dispose();
    _vehicleTypeController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _pageController.animateToPage(
      step - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = step);
  }

  void _onClientSubmit() {
    if (!(_step1FormKey.currentState?.validate() ?? false)) return;
    if (_selectedCityId == null || _selectedCityId!.isEmpty) {
      context.showErrorSnackBar('يرجى اختيار المدينة');
      return;
    }

    // Save user type locally since register API is disabled
    sl<HiveCacheService>().save(
      key: CacheKeys.userType,
      value: UserRole.client.apiValue,
      boxName: CacheConstants.userBox,
    );
    context.showSnackBar('تم التسجيل بنجاح');
    context.goVerifyOtp(_phoneController.text.trim());
  }

  void _onSubmit() {
    if (!(_step2FormKey.currentState?.validate() ?? false)) return;
    if (!_agreedToTerms) return;
    if (_selectedCityId == null || _selectedCityId!.isEmpty) {
      context.showErrorSnackBar('يرجى اختيار المدينة');
      return;
    }
    if (_selectedModelId == null || _selectedModelId!.isEmpty) {
      context.showErrorSnackBar('يرجى اختيار الموديل');
      return;
    }

    context.read<AuthBloc>().add(
      DriverRegisterSubmitted(
        name: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        cityId: _selectedCityId ?? '',
        password: _passwordController.text,
        identityNumber: _identityNumberController.text.trim(),
        lat: 24.7136, // Hardcoded Riyadh for now since address picker removed
        lng: 46.6753,
        locationDescription: _locationController.text.trim(),
        vehicleType: _vehicleTypeController.text.trim(),
        modelId: _selectedModelId ?? '',
        iban: _ibanController.text.trim(),
        bankName: _bankNameController.text.trim(),
        driverLicensePath: _driverLicenseImage?.path,
        vehicleRegistrationPath: _vehicleRegistrationImage?.path,
        vehicleInsurancePath: _vehicleInsuranceImage?.path,
        vehicleFrontPath: _vehicleFrontImage?.path,
        vehicleRearPath: _vehicleRearImage?.path,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            prev.successMessage != curr.successMessage ||
            prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.successMessage != null) {
            context.showSnackBar(state.successMessage!);
            context.goVerifyOtp(_phoneController.text.trim());
          }
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        child: SafeArea(
          child: _isClient
              ? _buildClientForm()
              : PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentStep = index + 1),
                  children: [_buildStep1(), _buildStep2()],
                ),
        ),
      ),
    );
  }

  Widget _buildClientForm() {
    return Form(
      key: _step1FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),
                  const AuthLogo(),
                  SizedBox(height: 24.h),
                  const AuthHeader(
                    title: 'تسجيل حساب مستخدم',
                    subtitle: 'أكمل بياناتك للتسجيل',
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 24.h),
                  UsernameField(controller: _usernameController),
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
                  PasswordField(controller: _passwordController),
                  SizedBox(height: 16.h),
                  ConfirmPasswordField(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                  ),
                  SizedBox(height: 32.h),
                  AppButton(
                    label: 'تسجيل',
                    size: ButtonSize.large,
                    onPressed: _onClientSubmit,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          AuthActionRow(
            label: ' لديك حساب بالفعل ؟',
            actionLabel: 'تسجيل الدخول',
            onActionTap: () => context.goLogin('user'),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),
                  const AuthLogo(),
                  SizedBox(height: 24.h),
                  const AuthHeader(
                    title: 'تسجيل حساب سائق',
                    subtitle: 'أكمل بياناتك الشخصية أولاً',
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 24.h),
                  RegistrationStepIndicator(
                    currentStep: _currentStep,
                    onStepTap: _goToStep,
                  ),
                  SizedBox(height: 24.h),
                  UsernameField(controller: _usernameController),
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
                  UsernameField(
                    controller: _locationController,
                    label: 'العنوان بالتفصيل',
                  ),
                  SizedBox(height: 16.h),
                  IdentityNumberField(controller: _identityNumberController),
                  SizedBox(height: 16.h),
                  EmailField(controller: _emailController),
                  SizedBox(height: 16.h),
                  PasswordField(controller: _passwordController),
                  SizedBox(height: 16.h),
                  ConfirmPasswordField(
                    controller: _confirmPasswordController,
                    passwordController: _passwordController,
                  ),
                  SizedBox(height: 32.h),
                  RegisterButton(
                    formKey: _step1FormKey,
                    onNextStep: () => _goToStep(2),
                  ),
                ],
              ),
            ),
          ),
          AuthActionRow(
            label: ' لديك حساب بالفعل ؟',
            actionLabel: 'تسجيل الدخول',
            onActionTap: () => context.goLogin('driver'),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
      builder: (context, state) {
        return Form(
          key: _step2FormKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24.h),
                      // Back button row
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _goToStep(1),
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.colorScheme.outline,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16.r,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      const AuthLogo(),
                      SizedBox(height: 24.h),
                      const AuthHeader(
                        title: 'بيانات المركبة',
                        subtitle: 'أدخل معلومات المركبة والمستندات المطلوبة',
                        align: TextAlign.start,
                      ),
                      SizedBox(height: 24.h),
                      RegistrationStepIndicator(
                        currentStep: _currentStep,
                        onStepTap: _goToStep,
                      ),
                      SizedBox(height: 24.h),

                      // Image uploads section
                      _buildSectionTitle('المستندات المطلوبة'),
                      SizedBox(height: 16.h),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final gap = 12.w;
                          final cardWidth =
                              (constraints.maxWidth - (2 * gap)) / 3;

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
                                      onImageSelected: (file) => setState(
                                        () => _driverLicenseImage = file,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: gap),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ImageUploadField(
                                      label: 'استمارة السيارة',
                                      selectedImage: _vehicleRegistrationImage,
                                      onImageSelected: (file) => setState(
                                        () => _vehicleRegistrationImage = file,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: gap),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ImageUploadField(
                                      label: 'تأمين السيارة',
                                      selectedImage: _vehicleInsuranceImage,
                                      onImageSelected: (file) => setState(
                                        () => _vehicleInsuranceImage = file,
                                      ),
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
                                      onImageSelected: (file) => setState(
                                        () => _vehicleFrontImage = file,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: gap),
                                  SizedBox(
                                    width: cardWidth,
                                    child: ImageUploadField(
                                      label: 'السيارة من الخلف',
                                      selectedImage: _vehicleRearImage,
                                      onImageSelected: (file) => setState(
                                        () => _vehicleRearImage = file,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Vehicle fields section
                      _buildSectionTitle('بيانات السيارة'),
                      SizedBox(height: 16.h),
                      VehicleTypeField(controller: _vehicleTypeController),
                      SizedBox(height: 16.h),
                      _buildModelDropdown(),
                      SizedBox(height: 16.h),
                      IbanField(controller: _ibanController),
                      SizedBox(height: 16.h),
                      BankNameField(controller: _bankNameController),
                      SizedBox(height: 24.h),

                      TermsCheckbox(
                        value: _agreedToTerms,
                        onChanged: (val) =>
                            setState(() => _agreedToTerms = val ?? false),
                      ),
                      SizedBox(height: 24.h),

                      // Submit button
                      AppButton(
                        label: 'تسجيل',
                        size: ButtonSize.large,
                        isDisabled: !_agreedToTerms,
                        isLoading: state.isLoading,
                        onPressed: _onSubmit,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              AuthActionRow(
                label: ' لديك حساب بالفعل ؟',
                actionLabel: 'تسجيل الدخول',
                onActionTap: () => context.goLogin('driver'),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
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
                (model) =>
                    DropdownMenuItem(value: model.id, child: Text(model.name)),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedModelId = val),
          validator: (val) {
            if (state.isLoading) return null;
            if (val == null || val.isEmpty) return 'يرجى اختيار الموديل';
            return null;
          },
        );
      },
    );
  }
}
