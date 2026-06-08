import 'package:thimar/core/imports/packages_imports.dart';

enum SplashDestination { roleSelection, home }

class SplashState extends Equatable {
  final bool isNavigating;
  final SplashDestination destination;

  const SplashState({
    this.isNavigating = false,
    this.destination = SplashDestination.roleSelection,
  });

  SplashState copyWith({bool? isNavigating, SplashDestination? destination}) {
    return SplashState(
      isNavigating: isNavigating ?? this.isNavigating,
      destination: destination ?? this.destination,
    );
  }

  @override
  List<Object?> get props => [isNavigating, destination];
}
