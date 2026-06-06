import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/privacy/domain/usecases/get_privacy_use_case.dart';
import 'privacy_event.dart';
import 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  final GetPrivacyUseCase _getPrivacyUseCase;

  PrivacyBloc(this._getPrivacyUseCase) : super(const PrivacyState()) {
    on<PrivacyFetched>(_onFetched);
  }

  Future<void> _onFetched(
    PrivacyFetched event,
    Emitter<PrivacyState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getPrivacyUseCase(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (privacy) => emit(state.copyWith(isLoading: false, privacy: privacy)),
    );
  }
}
