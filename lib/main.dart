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
    BharatXCommonUtilManager.showBharatXProgressDialog();
    String transactionId = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // dummy; fetch from server
    final onRegistered = () async {
      // transaction ID registered successfully
      await BharatXCommonUtilManager.closeBharatXProgressDialog();
      BharatXCommonUtilManager.showTransactionStatusDialog(true, () {});
    };

    final onFailure = () async {
      // registering this transaction failed
      await BharatXCommonUtilManager.closeBharatXProgressDialog();
      BharatXCommonUtilManager.showTransactionStatusDialog(false, () {});
    };

    BharatXCommonUtilManager.registerTransactionId(
        transactionId, onRegistered, onFailure);
  }

  void startTransaction() async {
    await BharatXStartupTierManager.initialize(
        "testPartnerId", "testApiKey", Colors.deepOrange);
    BharatXCommonUtilManager.registerCreditAccess();
    final onUserConfirmedTransaction = () {
      // user confirmed that they want to proceed with the transaction!
      registeredTransaction();
    };

    final onUserAcceptedPrivacyPolicy = () {
      // user accepted privacy policy
      AlternateDataManager.register();
    };

    final onUserCancelledTransaction = () {
      // user cancelled transaction. allow user to choose other payment options
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("You cancelled the transaction")));
    };
    BharatXCommonUtilManager.confirmTransactionWithUser(
        10000,
        onUserConfirmedTransaction,
        onUserAcceptedPrivacyPolicy,
        onUserCancelledTransaction);
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
