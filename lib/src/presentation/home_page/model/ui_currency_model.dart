import 'package:equatable/equatable.dart';

class UiCurrencyModel extends Equatable {
  final String code, description;
  final double rate;

  const UiCurrencyModel({
    required this.code,
    required this.description,
    required this.rate,
  });

  @override
  List<Object?> get props => [code, description, rate];
}
