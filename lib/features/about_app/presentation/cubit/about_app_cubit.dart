import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/about_app/domain/usecases/get_about_app_use_case.dart';

part 'about_app_states.dart';

class AboutAppCubit extends Cubit<AboutAppStates> {
  final GetAboutAppUseCase _getAboutAppUseCase;

  AboutAppCubit(this._getAboutAppUseCase) : super(AboutAppInitial());

  Future<void> loadAbout() async {
    if (isClosed) return;
    emit(AboutAppLoading());
    final result = await _getAboutAppUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(AboutAppError(failure.message)),
      (about) => emit(AboutAppLoaded(
        phone: about.phone,
        email: about.email,
        address: about.address,
        terms: about.terms,
      )),
    );
  }
}
