import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;
  final String role; // 'user' or 'driver'

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    this.role = 'user',
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? token,
    String? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, token, role];
}
