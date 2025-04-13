import 'package:equatable/equatable.dart';

class UiConvertedAmount extends Equatable {
  final String code;
  final double amount;

  const UiConvertedAmount({
    required this.code,
    required this.amount,
  });

  @override
  List<Object?> get props => [code, amount];
}
