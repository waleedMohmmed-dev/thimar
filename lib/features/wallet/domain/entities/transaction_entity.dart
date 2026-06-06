import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';
import 'package:thimar/core/injection/injection.dart';

enum TransactionType { deposit, withdrawal, payment, refund }

class TransactionEntity extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  final String description;
  final DateTime date;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, amount, type, description, date];
}
