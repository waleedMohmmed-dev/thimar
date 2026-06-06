import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/account/domain/repositories/account_repository.dart';

class UpdateDriverProfileUseCase implements UseCase<void, DriverProfileParams> {
  final AccountRepository repository;

  UpdateDriverProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DriverProfileParams params) async {
    return await repository.updateDriverProfile(params);
  }
}

class DriverProfileParams extends Equatable {
  final String fullname;
  final String phone;
  final String identityNumber;
  final String iban;
  final String carType;
  final String carModel;
  final int cityId;
  final String? imagePath;
  final String? carLicenceImagePath;
  final String? carFormImagePath;
  final String? carInsuranceImagePath;
  final String? carFrontImagePath;
  final String? carBackImagePath;

  const DriverProfileParams({
    required this.fullname,
    required this.phone,
    required this.identityNumber,
    required this.iban,
    required this.carType,
    required this.carModel,
    required this.cityId,
    this.imagePath,
    this.carLicenceImagePath,
    this.carFormImagePath,
    this.carInsuranceImagePath,
    this.carFrontImagePath,
    this.carBackImagePath,
  });

  @override
  List<Object?> get props => [
        fullname,
        phone,
        identityNumber,
        iban,
        carType,
        carModel,
        cityId,
        imagePath,
        carLicenceImagePath,
        carFormImagePath,
        carInsuranceImagePath,
        carFrontImagePath,
        carBackImagePath,
      ];
}
