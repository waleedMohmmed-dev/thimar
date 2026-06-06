import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/privacy/domain/entities/privacy_entity.dart';

class PrivacyState extends Equatable {
  final PrivacyEntity? privacy;
  final bool isLoading;
  final String? errorMessage;

  const PrivacyState({
    this.privacy,
    this.isLoading = false,
    this.errorMessage,
  });

  PrivacyState copyWith({
    PrivacyEntity? privacy,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PrivacyState(
      privacy: privacy ?? this.privacy,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [privacy, isLoading, errorMessage];
}
