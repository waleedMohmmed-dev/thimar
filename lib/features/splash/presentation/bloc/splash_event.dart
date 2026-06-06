import 'package:thimar/core/imports/packages_imports.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class SplashStarted extends SplashEvent {
  const SplashStarted();
}
