import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class ContactEntity extends Equatable {
  final String name;
  final String phone;
  final String message;

  const ContactEntity({
    required this.name,
    required this.phone,
    required this.message,
  });

  @override
  List<Object?> get props => [name, phone, message];
}
