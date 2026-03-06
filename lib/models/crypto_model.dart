import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_model.freezed.dart';
part 'crypto_model.g.dart';

@freezed
abstract class CryptoModel with _$CryptoModel {
  const factory CryptoModel({
    required String id,
    required String name,
    required String symbol,
    required int rank,
    @JsonKey(name: 'price_usd') required String priceUsd,
    @JsonKey(name: 'percent_change_24h') required String percentChange24h
  }) = _CryptoModel;

  factory CryptoModel.fromJson(Map<String, dynamic> json) => 
  _$CryptoModelFromJson(json);
}
