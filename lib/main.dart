import 'dart:io' show Platform;

import 'package:bharatx_flutter_alternatedata/bharatx_flutter_alternatedata.dart';
import 'package:bharatx_flutter_common/bharatx_flutter_common.dart';
import 'package:bharatx_flutter_startup/bharatx_flutter_startup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'BharatX Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void registeredTransaction() {
    String transactionId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // dummy; fetch from server
    BharatXCommonUtilManager.registerTransactionId(transactionId, () {
      BharatXCommonUtilManager.showTransactionStatusDialog(true, () {});
    }, () {
      BharatXCommonUtilManager.showTransactionStatusDialog(false, () {});
    });
  }

  void startTransaction() async {
    BharatXStartupTierManager.initialize(
        "testPartnerId", "testApiKey", Colors.deepOrange);
    BharatXCommonUtilManager.registerCreditAccess();
    BharatXCommonUtilManager.confirmTransactionWithUser(10000, () {
      registeredTransaction();
    }, () {
      AlternateDataManager.register();
    }, () {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("You cancelled the transaction")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (Platform.isAndroid)
              MaterialButton(
                onPressed: startTransaction,
                child: Text(
                  "Start Transaction",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepOrange,
              )
          ],
        ),
      ),
    );
  }
}
