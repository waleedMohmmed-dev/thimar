import 'package:thimar/core/imports/packages_imports.dart';

abstract class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object> get props => [];
}

class PrivacyFetched extends PrivacyEvent {
  const PrivacyFetched();
}
