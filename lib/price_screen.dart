import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  String exchangeRate;

  @override
  void initState() {
    super.initState();
    getExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $exchangeRate USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? cupertinoPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  CupertinoPicker cupertinoPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: getCurrencyTexts(),
    );
  }

  List<Widget> getCurrencyTexts() {
    List<Widget> currencies = [];
    currenciesList.forEach((currency) => currencies.add(Text(currency)));
    return currencies;
  }

  DropdownButton<String> androidDropdown() {
    return DropdownButton(
      value: selectedCurrency,
      items: dropdownMenuItemsForCurrencies(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  List<DropdownMenuItem> dropdownMenuItemsForCurrencies() {
    List<DropdownMenuItem<String>> items = [];
    currenciesList.forEach((currency) => items.add(DropdownMenuItem(
          child: Text(currency),
          value: currency,
        )));
    return items;
  }

  Future<void> getExchangeRate() async {
    var url =
        'https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=79F242CD-E5C0-4D6B-9F1D-E593A2FDE954';
    http.Response response = await http.get(url);

    setState(() {
      double exchangeRateDouble = jsonDecode(response.body)['rate'];
      exchangeRate = exchangeRateDouble.toStringAsFixed(2);
    });
  }
}
