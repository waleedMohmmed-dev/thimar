enum UserRole {
  user('user', 'client'),
  driver('driver', 'driver');

  final String storageValue;
  final String apiValue;

  const UserRole(this.storageValue, this.apiValue);

  static UserRole fromString(String? value) {
    if (value == 'driver') return UserRole.driver;
    return UserRole.user;
  }

  bool get isDriver => this == UserRole.driver;
  bool get isUser => this == UserRole.user;
}
