import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

const TextStyle kDropdownTextStyle = TextStyle(color: Colors.white);
const String apiKey = 'F66DFB04-C419-48FC-9DBE-4C89DC62A67B';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String dropdownMenuShownChoice;
  String BTCRate;
  String ETHRate;
  String LTCRate;

  Future<String> getRate(String country, String crypto) async{
    CoinData coinData = new CoinData();
    return await coinData.getRate(country, crypto);
  }
  
  CupertinoPicker getCupertinoPickerIOS() {
    List<Text> list = [];
    for (String s in currenciesList) {
      list.add(Text(s, style: kDropdownTextStyle,));
    }

    return CupertinoPicker(

      itemExtent: 32,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex)async{
        String temp = await getRate(dropdownMenuShownChoice, 'BTC');
        print(selectedIndex);
        setState(()  {
          dropdownMenuShownChoice = currenciesList[selectedIndex];
          BTCRate = temp;
        });
      },
      children: list,
    );
  }

  DropdownButton getDropdownButtonAndroid(){
    List<DropdownMenuItem> list = [];
    for (String s in currenciesList){
      list.add(new DropdownMenuItem(child: Text(s), value: s,));
    }

    return DropdownButton(
      onChanged: (value) async{
        print(value);

        setState(() {
          dropdownMenuShownChoice = value;
          BTCRate = '?';
          ETHRate = '?';
          LTCRate = '?';
        });
        String tempBTC = await getRate(value, cryptoList[0]);
        String tempETH = await getRate(value, cryptoList[1]);
        String tempLTC = await getRate(value, cryptoList[2]);
        setState(() {
          BTCRate = tempBTC;
          ETHRate = tempETH;
          LTCRate = tempLTC;
        });
      },
      items: list,
      value: dropdownMenuShownChoice,
    );
  }

  List<Widget> allCurrencyBlocks(){
    List<Widget> list = [];
    List<String> rates = [BTCRate, ETHRate, LTCRate];

    for (int i = 0; i < cryptoList.length; i++){
      String currency = cryptoList[i];
      String rate = rates[i];

      list.add(Padding(
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
              '1 $currency = $rate $dropdownMenuShownChoice',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
      );
    }

    list.add(Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? getCupertinoPickerIOS() : getDropdownButtonAndroid(),
    ));
    return list;
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
        children:
          allCurrencyBlocks(),
      ),
    );
  }
}


