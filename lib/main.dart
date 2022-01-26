import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      title: "Currency Converter",
      home: CurrencyConverter(),
    ));

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String> currencies = [];
  String fromCurrency = "MYR";
  String toCurrency = "USD";
  // ignore: prefer_typing_uninitialized_variables
  String result = '';

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    //var apiid = "415921d0-7a94-11ec-88fb-d3a233718d5d ";
    var url = Uri.parse(
        "https://freecurrencyapi.net/api/v2/latest?apikey=415921d0-7a94-11ec-88fb-d3a233718d5d&base_currency=MYR");
    var response = await http.get(url);
    var responseBody = json.decode(response.body);
    Map<String, dynamic> curMap = responseBody['data'];
    currencies = curMap.keys.toList();
    setState(() {});
    // ignore: avoid_print
    print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    // var apiid = "415921d0-7a94-11ec-88fb-d3a233718d5d ";
    var url = Uri.parse(
        "https://freecurrencyapi.net/api/v2/latest?apikey=415921d0-7a94-11ec-88fb-d3a233718d5d&base=$fromCurrency&symbols=$toCurrency");
    var response = await http.get(url);
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        result = (double.parse(fromTextController.text) *
                (parsedJson["data"][toCurrency]))
            .toString();
        // ignore: void_checks
      });
    }
    // ignore: avoid_print
    print(result);
    return "Success";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
      ),
      // ignore: unnecessary_null_comparison
      body: currencies == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: fromTextController,
                          style: const TextStyle(
                              fontSize: 20.0, color: Colors.black),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                        trailing: _buildDropDownButton(fromCurrency),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: _doConversion,
                      ),
                      ListTile(
                        title: Chip(
                          // ignore: unnecessary_null_comparison
                          label: result != null
                              ? Text(
                                  result,
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                              : const Text(""),
                        ),
                        trailing: _buildDropDownButton(toCurrency),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[
                    Text(value),
                  ],
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (currencyCategory == fromCurrency) {
          _onFromChanged(value.toString());
        } else {
          _onToChanged(value.toString());
        }
      },
    );
  }
}
