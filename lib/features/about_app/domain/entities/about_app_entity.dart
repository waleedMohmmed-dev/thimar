import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class AboutAppEntity extends Equatable {
  final String phone;
  final String email;
  final String address;
  final String terms;

  const AboutAppEntity({
    required this.phone,
    required this.email,
    required this.address,
    required this.terms,
  });

  @override
  List<Object?> get props => [phone, email, address, terms];
}
