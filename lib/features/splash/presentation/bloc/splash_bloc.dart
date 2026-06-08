import 'dart:async';
import 'package:thimar/core/cache/cache_constants.dart';
import 'package:thimar/core/cache/cache_keys.dart';
import 'package:thimar/core/cache/cache_service.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final HiveCacheService _cacheService;

  SplashBloc({required HiveCacheService cacheService})
    : _cacheService = cacheService,
      super(const SplashState()) {
    on<SplashStarted>(_onStarted);
  }

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 2800));
    final token = _cacheService.get<String>(
      key: CacheKeys.token,
      boxName: CacheConstants.userBox,
    );
    final isLoggedIn = token != null && token.isNotEmpty;

    final destination = isLoggedIn
        ? SplashDestination.home
        : SplashDestination.roleSelection;
    emit(state.copyWith(isNavigating: true, destination: destination));
  }
}
