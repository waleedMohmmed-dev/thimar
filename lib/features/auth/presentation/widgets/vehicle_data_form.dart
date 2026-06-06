import 'dart:io';

import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/auth/presentation/widgets/auth_widgets.dart';

class VehicleDataForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int currentStep;
  final ValueChanged<int>? onStepTap;

  // Image state
  final File? driverLicenseImage;
  final File? vehicleRegistrationImage;
  final File? vehicleInsuranceImage;
  final File? vehicleFrontImage;
  final File? vehicleRearImage;
  final ValueChanged<File?> onDriverLicenseChanged;
  final ValueChanged<File?> onVehicleRegistrationChanged;
  final ValueChanged<File?> onVehicleInsuranceChanged;
  final ValueChanged<File?> onVehicleFrontChanged;
  final ValueChanged<File?> onVehicleRearChanged;

  // Text controllers
  final TextEditingController vehicleTypeController;
  final TextEditingController vehicleModelController;
  final TextEditingController ibanController;
  final TextEditingController bankNameController;

  // Terms
  final bool agreedToTerms;
  final ValueChanged<bool?> onTermsChanged;

  // Submit
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const VehicleDataForm({
    super.key,
    required this.formKey,
    required this.currentStep,
    this.onStepTap,
    required this.driverLicenseImage,
    required this.vehicleRegistrationImage,
    required this.vehicleInsuranceImage,
    required this.vehicleFrontImage,
    required this.vehicleRearImage,
    required this.onDriverLicenseChanged,
    required this.onVehicleRegistrationChanged,
    required this.onVehicleInsuranceChanged,
    required this.onVehicleFrontChanged,
    required this.onVehicleRearChanged,
    required this.vehicleTypeController,
    required this.vehicleModelController,
    required this.ibanController,
    required this.bankNameController,
    required this.agreedToTerms,
    required this.onTermsChanged,
    required this.isLoading,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Form(
      key: formKey,
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
                        onTap: onBack,
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.outline),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16.r,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const AuthLogo(),
                  SizedBox(height: 24.h),
                  const AuthHeader(
                    title: 'مرحبا بك مرة أخرى',
                    subtitle: 'يمكنك تسجيل حساب جديد الآن',
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 24.h),
                  RegistrationStepIndicator(
                    currentStep: currentStep,
                    onStepTap: onStepTap,
                  ),
                  SizedBox(height: 24.h),

                  // Image uploads section
                  _buildSectionTitle(context, 'المستندات المطلوبة'),
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
                                  selectedImage: driverLicenseImage,
                                  onImageSelected: onDriverLicenseChanged,
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: cardWidth,
                                child: ImageUploadField(
                                  label: 'استمارة السيارة',
                                  selectedImage: vehicleRegistrationImage,
                                  onImageSelected: onVehicleRegistrationChanged,
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: cardWidth,
                                child: ImageUploadField(
                                  label: 'تأمين السيارة',
                                  selectedImage: vehicleInsuranceImage,
                                  onImageSelected: onVehicleInsuranceChanged,
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
                                  selectedImage: vehicleFrontImage,
                                  onImageSelected: onVehicleFrontChanged,
                                ),
                              ),
                              SizedBox(width: gap),
                              SizedBox(
                                width: cardWidth,
                                child: ImageUploadField(
                                  label: 'السيارة من الخلف',
                                  selectedImage: vehicleRearImage,
                                  onImageSelected: onVehicleRearChanged,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Text fields section
                  _buildSectionTitle(context, 'بيانات السيارة'),
                  SizedBox(height: 16.h),
                  VehicleTypeField(controller: vehicleTypeController),
                  SizedBox(height: 16.h),
                  VehicleModelField(controller: vehicleModelController),
                  SizedBox(height: 16.h),
                  IbanField(controller: ibanController),
                  SizedBox(height: 16.h),
                  BankNameField(controller: bankNameController),
                  SizedBox(height: 24.h),

                  // Terms & Conditions
                  TermsCheckbox(
                    value: agreedToTerms,
                    onChanged: onTermsChanged,
                  ),
                  SizedBox(height: 24.h),

                  // Submit button
                  AppButton(
                    label: 'تسجيل',
                    size: ButtonSize.large,
                    isDisabled: !agreedToTerms,
                    isLoading: isLoading,
                    onPressed: onSubmit,
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
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
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
}
