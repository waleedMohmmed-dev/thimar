import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/privacy/domain/entities/privacy_entity.dart';

abstract class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object> get props => [];
}

class PrivacyFetched extends PrivacyEvent {
  const PrivacyFetched();
}
