import 'package:thimar/core/imports/packages_imports.dart';

abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}

class FaqFetched extends FaqEvent {
  const FaqFetched();
}
