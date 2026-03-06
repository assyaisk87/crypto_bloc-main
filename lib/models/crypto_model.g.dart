// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CryptoModel _$CryptoModelFromJson(Map<String, dynamic> json) => _CryptoModel(
  id: json['id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  rank: (json['rank'] as num).toInt(),
  priceUsd: json['price_usd'] as String,
  percentChange24h: json['percent_change_24h'] as String,
);

Map<String, dynamic> _$CryptoModelToJson(_CryptoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'rank': instance.rank,
      'price_usd': instance.priceUsd,
      'percent_change_24h': instance.percentChange24h,
    };
