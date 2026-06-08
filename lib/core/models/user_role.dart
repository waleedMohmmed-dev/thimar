enum UserRole {
  client('client'),
  driver('driver');

  final String apiValue;
  const UserRole(this.apiValue);

  bool get isDriver => this == UserRole.driver;
  String get storageValue => apiValue;

  static UserRole fromString(String? value) {
    if (value == null) return UserRole.client;
    return UserRole.values.firstWhere(
      (r) => r.apiValue == value.toLowerCase(),
      orElse: () => UserRole.client,
    );
  }
}
