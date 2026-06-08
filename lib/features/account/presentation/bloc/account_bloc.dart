import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/account/domain/entities/user_entity.dart';
import 'package:thimar/features/account/domain/repositories/account_repository.dart';
import 'package:thimar/features/account/domain/usecases/get_user_profile_usecase.dart';
import 'package:thimar/features/account/domain/usecases/logout_usecase.dart';
import 'package:thimar/features/account/presentation/bloc/account_event.dart';
import 'package:thimar/features/account/presentation/bloc/account_state.dart';
import 'package:thimar/features/account/domain/usecases/update_driver_profile_use_case.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateDriverProfileUseCase updateDriverProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final AccountRepository accountRepository;

  AccountBloc({
    required this.getUserProfileUseCase,
    required this.updateDriverProfileUseCase,
    required this.logoutUseCase,
    required this.accountRepository,
  }) : super(const AccountState()) {
    on<AccountStarted>(_onAccountStarted);
    on<AccountRefreshRequested>(_onRefreshRequested);
    on<AccountLogoutRequested>(_onLogoutRequested);
    on<AccountProfileImagePicked>(_onProfileImagePicked);
    on<AccountDriverProfileUpdated>(_onDriverProfileUpdated);
  }

  Future<void> _onAccountStarted(
    AccountStarted event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await getUserProfileUseCase(NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AccountStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            status: AccountStatus.success,
            user: user,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshRequested(
    AccountRefreshRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await getUserProfileUseCase(NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AccountStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        emit(
          state.copyWith(
            status: AccountStatus.success,
            user: user,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onProfileImagePicked(
    AccountProfileImagePicked event,
    Emitter<AccountState> emit,
  ) async {
    final result = await accountRepository.saveProfileImage(event.imagePath);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AccountStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        final updatedUser = state.user != null
            ? UserEntity(
                id: state.user!.id,
                name: state.user!.name,
                email: state.user!.email,
                phone: state.user!.phone,
                profileImage: event.imagePath,
                address: state.user!.address,
                createdAt: state.user!.createdAt,
                role: state.user!.role,
                vehicleType: state.user!.vehicleType,
                vehicleModel: state.user!.vehicleModel,
                iban: state.user!.iban,
                bankName: state.user!.bankName,
                driverLicenseImage: state.user!.driverLicenseImage,
                vehicleRegistrationImage: state.user!.vehicleRegistrationImage,
                vehicleInsuranceImage: state.user!.vehicleInsuranceImage,
                vehicleFrontImage: state.user!.vehicleFrontImage,
                vehicleRearImage: state.user!.vehicleRearImage,
              )
            : null;
        emit(
          state.copyWith(
            status: AccountStatus.success,
            user: updatedUser,
            clearError: true,
          ),
        );
      },
    );
  }

  Future<void> _onDriverProfileUpdated(
    AccountDriverProfileUpdated event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));
    final result = await updateDriverProfileUseCase(event.params);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AccountStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        // Refresh profile after update
        add(const AccountRefreshRequested());
      },
    );
  }

  Future<void> _onLogoutRequested(
    AccountLogoutRequested event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AccountStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: AccountStatus.logoutSuccess,
            user: null,
            clearError: true,
          ),
        );
      },
    );
  }
}
