import 'dart:convert';

import 'package:crypto_bloc/models/crypto_model.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  final Box<CryptoModel> _cryptoBox = Hive.box<CryptoModel>('cryptoBox');
  final Box _settingsBox = Hive.box('settingsBox');

  List<CryptoModel> getLocaleCrypyoData() {
    return _cryptoBox.values.toList();
  }

  Future<void> clearCache() => _cryptoBox.clear();

  Future<List<CryptoModel>> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse('https://api.coinlore.net/api/tickers/'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final list = data['data'];
      List<CryptoModel> cryptoList = list
          .map<CryptoModel>((e) => CryptoModel.fromJson(e))
          .toList();

      await _cryptoBox.clear();
      await _cryptoBox.addAll(cryptoList);

      _settingsBox.put('last_update', DateTime.now().toString());
      return cryptoList;
    } else {
      throw Exception('Ошибка API');
    }
  }
}
