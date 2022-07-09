import 'package:bankingapp/banking/screen/BankingHome1.dart';
import 'package:bankingapp/banking/screen/BankingMenu.dart';
import 'package:bankingapp/banking/screen/BankingPayment.dart';
import 'package:bankingapp/banking/screen/BankingSaving.dart';
import 'package:bankingapp/banking/screen/PurchaseMoreScreen.dart';
import 'package:bankingapp/banking/utils/BankingBottomNavigationBar.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:flutter/material.dart';


class BankingDashboard extends StatefulWidget {
  static var tag = "/BankingDashboard";

  const BankingDashboard({Key? key}) : super(key: key);

  @override
  BankingDashboardState createState() => BankingDashboardState();
}

class BankingDashboardState extends State<BankingDashboard> {
  var selectedIndex = 0;
  var pages = [
    const BankingHome1(),
    const PurchaseMoreScreen(),
    BankingPayment(),
    BankingSaving(),
    BankingMenu(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  void dispose(){
    super.dispose();
    //TODO-> End User session here
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      bottomNavigationBar: BankingBottomNavigationBar(
        selectedItemColor: Banking_Primary,
        unselectedItemColor: Banking_greyColor.withOpacity(0.5),
        items: const <BankingBottomNavigationBarItem>[
          BankingBottomNavigationBarItem(icon: Banking_ic_Home, title: Text(Banking_lbl_Home)),
          BankingBottomNavigationBarItem(icon: Banking_ic_Transfer, title: Text(Banking_lbl_Transfer)),
          BankingBottomNavigationBarItem(icon: Banking_ic_Payment, title: Text(Banking_lbl_Payment)),
          BankingBottomNavigationBarItem(icon: Banking_ic_Saving, title: Text(Banking_lbl_Saving)),
          BankingBottomNavigationBarItem(icon: Banking_ic_Menu, title: Text(Banking_lbl_Menu)),
        ],
        currentIndex: selectedIndex,
        unselectedIconTheme: IconThemeData(color: Banking_greyColor.withOpacity(0.5), size: 28),
        selectedIconTheme: const IconThemeData(color: Banking_Primary, size: 28),
        onTap: _onItemTapped,
        type: BankingBottomNavigationBarType.fixed,
      ),
      body: SafeArea(
        child: pages[selectedIndex],
      ),
    );
  }
}
