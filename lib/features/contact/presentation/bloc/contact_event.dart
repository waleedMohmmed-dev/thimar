import 'package:thimar/core/imports/packages_imports.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

class ContactSubmitted extends ContactEvent {
  final String name;
  final String phone;
  final String message;

  const ContactSubmitted({
    required this.name,
    required this.phone,
    required this.message,
  });

  @override
  List<Object> get props => [name, phone, message];
}
