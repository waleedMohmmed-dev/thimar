import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/features/wallet/domain/entities/wallet_entity.dart';

class WalletState extends Equatable {
  final WalletEntity? wallet;
  final bool isLoading;
  final String? errorMessage;

  const WalletState({this.wallet, this.isLoading = false, this.errorMessage});

  WalletState copyWith({
    WalletEntity? wallet,
    bool? isLoading,
    String? errorMessage,
  }) {
    return WalletState(
      wallet: wallet ?? this.wallet,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [wallet, isLoading, errorMessage];
}
