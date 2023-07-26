import 'dart:convert';

import 'package:address_book/domain/viacep_model.dart';
import 'package:http/http.dart' as http;

class ViaCepRepository {
  Future<ViaCepModel?> searchViaCep(String postalCode) async {
    try {
      final url = Uri.https('viacep.com.br', 'ws/$postalCode/json');

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('erro')) {
        return null;
      }

      return ViaCepModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
