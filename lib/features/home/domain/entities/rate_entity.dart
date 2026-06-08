import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class RateEntity extends Equatable {
  final int value;
  final String comment;
  final String clientName;
  final String clientImage;

  const RateEntity({
    required this.value,
    required this.comment,
    required this.clientName,
    required this.clientImage,
  });

  @override
  List<Object?> get props => [value, comment, clientName, clientImage];
}
