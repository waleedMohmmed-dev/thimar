part of 'addresses_cubit.dart';

abstract class AddressesState extends Equatable {
  const AddressesState();

  @override
  List<Object?> get props => [];
}

class AddressesInitial extends AddressesState {}

class AddressesLoading extends AddressesState {}

class AddressesLoaded extends AddressesState {
  final List<AddressEntity> addresses;

  const AddressesLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressesError extends AddressesState {
  final String message;

  const AddressesError(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressSelected extends AddressesState {
  final AddressEntity address;

  const AddressSelected(this.address);

  @override
  List<Object?> get props => [address];
}
