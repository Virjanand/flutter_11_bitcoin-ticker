import 'networking.dart';

class CryptoCurrencyModel {
  static const String apikey = '79F242CD-E5C0-4D6B-9F1D-E593A2FDE954';

  Future<double> getExchangeRateFromCryptoTo(
      String cryptoCurrency, String currency) async {
    String cryptoCurrency = 'BTC';
    String currency = 'USD';
    var url =
        'https://rest.coinapi.io/v1/exchangerate/$cryptoCurrency/$currency?apikey=$apikey';
    NetworkHelper networkHelper = new NetworkHelper(url);
    var exchangeData = await networkHelper.getData();

    return exchangeData['rate'];
  }
}
