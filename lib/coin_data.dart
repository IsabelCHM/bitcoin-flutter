import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'F66DFB04-C419-48FC-9DBE-4C89DC62A67B';
const String baseUrl = 'https://rest.coinapi.io/v1/exchangerate/';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<String> getRate (String country, String crypto) async {
    Uri uri = Uri.parse('$baseUrl$crypto/$country?apikey=$apiKey');
    http.Response response = await http.get(uri);
    if (response.statusCode == 200)
      {
        var data = jsonDecode(response.body);
        double rate = data['rate'];
        return rate.toStringAsFixed(0);
      }
    return null;
  }

}
