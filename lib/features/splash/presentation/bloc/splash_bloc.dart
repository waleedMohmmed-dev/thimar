import 'dart:async';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/services/role_service.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final RoleService _roleService;

  SplashBloc({required RoleService roleService})
      : _roleService = roleService,
        super(const SplashState()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 2800));
    final destination = _roleService.isLoggedIn
        ? SplashDestination.home
        : SplashDestination.roleSelection;
    emit(state.copyWith(isNavigating: true, destination: destination));
  }
}
