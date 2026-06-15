import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';
import 'package:thimar/features/addresses/domain/usecases/get_addresses_use_case.dart';
import 'package:thimar/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:thimar/features/addresses/domain/usecases/update_address_use_case.dart';
import 'package:thimar/features/addresses/domain/usecases/delete_address_use_case.dart';

part 'addresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  final GetAddressesUseCase _getAddressesUseCase;
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  AddressesCubit({
    required GetAddressesUseCase getAddressesUseCase,
    required AddAddressUseCase addAddressUseCase,
    required UpdateAddressUseCase updateAddressUseCase,
    required DeleteAddressUseCase deleteAddressUseCase,
  })  : _getAddressesUseCase = getAddressesUseCase,
        _addAddressUseCase = addAddressUseCase,
        _updateAddressUseCase = updateAddressUseCase,
        _deleteAddressUseCase = deleteAddressUseCase,
        super(AddressesInitial());

  List<AddressEntity> _addresses = [];
  List<AddressEntity> get addresses => _addresses;

  AddressEntity? _selectedAddress;
  AddressEntity? get selectedAddress => _selectedAddress;

  void selectAddress(AddressEntity address) {
    _selectedAddress = address;
    emit(AddressSelected(address));
  }

  Future<void> loadAddresses() async {
    emit(AddressesLoading());
    final result = await _getAddressesUseCase();
    result.fold(
      (failure) => emit(AddressesError(failure.message)),
      (addresses) {
        _addresses = addresses;
        if (addresses.isNotEmpty && _selectedAddress == null) {
          _selectedAddress = addresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addresses.first,
          );
        }
        emit(AddressesLoaded(addresses));
      },
    );
  }

  Future<void> addAddress({
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    emit(AddressesLoading());
    final result = await _addAddressUseCase(
      type: type,
      phone: phone,
      description: description,
      location: location,
      lat: lat,
      lng: lng,
      isDefault: isDefault,
    );
    result.fold(
      (failure) => emit(AddressesError(failure.message)),
      (address) {
        _selectedAddress = address;
        loadAddresses();
      },
    );
  }

  Future<void> updateAddress({
    required int id,
    required String type,
    required String phone,
    required String description,
    required String location,
    required double lat,
    required double lng,
    required bool isDefault,
  }) async {
    emit(AddressesLoading());
    final result = await _updateAddressUseCase(
      id: id,
      type: type,
      phone: phone,
      description: description,
      location: location,
      lat: lat,
      lng: lng,
      isDefault: isDefault,
    );
    result.fold(
      (failure) => emit(AddressesError(failure.message)),
      (address) {
        _selectedAddress = address;
        loadAddresses();
      },
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(AddressesLoading());
    final result = await _deleteAddressUseCase(id);
    result.fold(
      (failure) => emit(AddressesError(failure.message)),
      (_) {
        if (_selectedAddress?.id == id) {
          _selectedAddress = null;
        }
        loadAddresses();
      },
    );
  }
}
