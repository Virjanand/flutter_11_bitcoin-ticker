import 'dart:io' show Platform;

import 'package:bitcoin_ticker/CryptoCurrencyModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CryptoCurrencyModel cryptoCurrencyModel = new CryptoCurrencyModel();

  String selectedCurrency = 'USD';
  Map<String, String> exchangeRates = new Map();

  @override
  void initState() {
    super.initState();
    for (String crypto in cryptoList) {
      cryptoCurrencyModel
          .getExchangeRateFromCryptoTo(crypto, selectedCurrency)
          .then((double exchangeRate) {
        exchangeRates[crypto] = exchangeRate.toStringAsFixed(2);
        updateUI(selectedCurrency);
      });
    }
  }

  Future<void> updateUI(String currency) async {
    setState(() {
      selectedCurrency = currency;
    });
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createExchangeRateCards(),
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

  List<Widget> createExchangeRateCards() {
    List<Widget> cryptoCards = new List();
    for (String cryptoCurrency in exchangeRates.keys) {
      cryptoCards.add(
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
                '1 $cryptoCurrency = ${exchangeRates[cryptoCurrency]} $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return cryptoCards;
  }

  CupertinoPicker cupertinoPicker() {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
          initialItem: currenciesList.indexOf(selectedCurrency)),
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        String currency = currenciesList[selectedIndex];
        await changeCurrency(currency);
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
      onChanged: (currency) async {
        await changeCurrency(currency);
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

  Future changeCurrency(String currency) async {
    double exchangeRate =
        await cryptoCurrencyModel.getExchangeRateFromCryptoTo('BTC', currency);
    exchangeRates['BTC'] = exchangeRate.toStringAsFixed(2);
    exchangeRate =
        await cryptoCurrencyModel.getExchangeRateFromCryptoTo('ETH', currency);
    exchangeRates['ETH'] = exchangeRate.toStringAsFixed(2);
    updateUI(currency);
  }
}
