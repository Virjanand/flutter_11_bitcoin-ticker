import 'networking.dart';

class CryptoCurrencyModel {
  Future<double> getExchangeRate() async {
    final String apikey = '79F242CD-E5C0-4D6B-9F1D-E593A2FDE954';
    String cryptoCurrency = 'BTC';
    String currency = 'USD';
    var url =
        'https://rest.coinapi.io/v1/exchangerate/$cryptoCurrency/$currency?apikey=$apikey';
    NetworkHelper networkHelper = new NetworkHelper(url);
    var exchangeData = await networkHelper.getData();

    return exchangeData['rate'];
  }
}
