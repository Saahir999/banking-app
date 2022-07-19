import 'package:bankingapp/banking/screen/Authentication/BankingSignIn.dart';
import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/BankingSplash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';

import 'banking/screen/Authentication/BankingRegister.dart';
import 'banking/screen/Authentication/One_Time_Password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final storage = const FlutterSecureStorage();

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capital Bank',
      scrollBehavior: SBehavior(),
      routes: {
        "LogIn" : (context) => const BankingSignIn(),
        "OTP" : (context) => const OTP(),
        "Register" : (context) => const BankingRegister(),
        "DashBoard" : (context) => const BankingDashboard(),
        "Splash" : (context) => BankingSplash(),
      },
      initialRoute: "LogIn",
      //initialRoute: (storage.read(key: "introScreen") == null)?("Splash"):((storage.read(key: "introScreen") as bool)?("Splash"):("LogIn")),
      // home: BankingSplash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//TODO-> Splash screen/ remember first registration has happened
//TODO-> Sign In Page
