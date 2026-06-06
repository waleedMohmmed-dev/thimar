part of 'about_app_cubit.dart';

@immutable
abstract class AboutAppStates extends Equatable {
  const AboutAppStates();

  @override
  List<Object> get props => [];
}

class AboutAppInitial extends AboutAppStates {}

class AboutAppLoading extends AboutAppStates {}

class AboutAppLoaded extends AboutAppStates {
  final String phone;
  final String email;
  final String address;
  final String terms;

  const AboutAppLoaded({
    required this.phone,
    required this.email,
    required this.address,
    required this.terms,
  });

  @override
  List<Object> get props => [phone, email, address, terms];
}

class AboutAppError extends AboutAppStates {
  final String message;

  const AboutAppError(this.message);

  @override
  List<Object> get props => [message];
}
