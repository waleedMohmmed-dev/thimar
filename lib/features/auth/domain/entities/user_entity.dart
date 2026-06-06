import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/models/user_role.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String token;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.token,
    required this.role,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? token,
    UserRole? role,
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
