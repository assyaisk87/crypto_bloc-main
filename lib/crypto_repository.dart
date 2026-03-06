import 'dart:convert';

import 'package:crypto_bloc/models/crypto_model.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
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

      return cryptoList;
    } else {
      throw Exception('Ошибка API');
    }
  }
}
