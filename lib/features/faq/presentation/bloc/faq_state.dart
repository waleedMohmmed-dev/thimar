import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/faq/domain/entities/faq_entity.dart';

class FaqState extends Equatable {
  final List<FaqEntity> faqs;
  final bool isLoading;
  final String? errorMessage;

  const FaqState({
    this.faqs = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FaqState copyWith({
    List<FaqEntity>? faqs,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FaqState(
      faqs: faqs ?? this.faqs,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [faqs, isLoading, errorMessage];
}
