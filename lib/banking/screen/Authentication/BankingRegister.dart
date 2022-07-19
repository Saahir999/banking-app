import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../API/Authentication.dart';
import '../../utils/Alert.dart';
import '../../utils/BankingColors.dart';
import '../../utils/BankingStrings.dart';
import '../../utils/BankingWidget.dart';
import '../BankingDashboard.dart';

class BankingRegister extends StatefulWidget {
  const BankingRegister({Key? key}) : super(key: key);
  @override
  State<BankingRegister> createState() => _BankingRegisterState();
}

class _BankingRegisterState extends State<BankingRegister> {

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final authClass = AuthClass();

  final FocusNode _focusNode1 = FocusNode();
  int f = 0;
  final FocusNode _focusNode2 = FocusNode();
  int f2 = 0;
  final FocusNode _focusNode3 = FocusNode();
  int f3 = 0;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode1.addListener(() {
      if(f>0) {
        _formKey1.currentState?.validate();
      }
      else{
        f++;
      }
    });
    _focusNode2.addListener(() {
      if(f2>0){
        _formKey2.currentState?.validate();
      }
      else{
        f2++;
      }
    });
    _focusNode3.addListener(() {
      if(f3>0) {
        _formKey3.currentState?.validate();
      }
      else{
        f3++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    f=0;
    f2=0;
    f3=0;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(heightFactor: 5,child: Text("Register", style: boldTextStyle(size: 30))),
                  Form(
                    key: _formKey3,
                    child: ListTile(
                      leading: const Icon(Icons.message_rounded, color: Colors.blueAccent,),
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Name",
                          focusColor: Colors.deepOrange,
                        ),
                        focusNode: _focusNode3,
                        controller: _controller3,
                        validator: validateName,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey1,
                    child: ListTile(
                      leading: const Icon(Icons.message_rounded, color: Colors.blueAccent,),
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Phone No.",
                          focusColor: Colors.deepOrange,
                        ),
                        focusNode: _focusNode1,
                        controller: _controller,
                        validator: validatePhoneNo,
                      ),
                    ),
                  ),
                  8.height,
                  Form(
                    key: _formKey2,
                    child: ListTile(
                      leading: const Icon(Icons.key_rounded, color: Colors.black,),
                      title: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Customer ID",
                          focusColor: Colors.deepOrange,
                        ),
                        initialValue: null,
                        focusNode: _focusNode2,
                        controller: _controller2,
                        validator: validateID,
                      ),
                    ),
                  ),
                  16.height,
                  BankingButton(
                    textContent: "Register",
                    onPressed: ()async{
                      if(validateID(_controller2.text) == null && validatePhoneNo(_controller.text) == null && validateName(_controller3.text) == null) {
                        //TODO-> check for platform issues if web 'app' is used as end product
                        //storage.write(key: "showIntro", value: "false");
                        log(_controller.text + " " + _controller2.text);
                        ( await authClass.register(custId: _controller2.text,phone: _controller.text, name: _controller3.text))
                            ? Navigator.popAndPushNamed(context, "OTP",
                            arguments: {
                              "phone":_controller.text,
                              "custId":_controller2.text
                            })
                            :{
                          showAlert(context: context, title: 'Registration failed, please try again')
                        };
                        _controller.text = "";
                        _controller2.text = "";
                        _controller3.text = "";
                      }
                    },
                  ),
                  16.height,
                  Column(
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.popAndPushNamed(context, "LogIn");
                        },
                        child: const Text("Sign In"),
                      ),
                    ],
                  ).center(),
                  Align(
                    heightFactor: 7,
                    alignment: Alignment.bottomCenter,
                    child: Text(Banking_lbl_app_Name.toUpperCase(),
                        style: primaryTextStyle(
                            size: 16, color: Banking_TextColorSecondary)),
                  ).paddingBottom(16),
                ],
              ).center(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
  }

  String? validateName(String? s){
    if(s != null && s != ""){
      return null;
    }
    else{
      return "Please enter your Full Name";
    }
  }

  String? validatePhoneNo(String? s){
    if(s != null && s != ""){
      return null;
    }
    else{
      return "Please enter your Phone number";
    }
  }

  String? validateID(String? s){
    if(s != null && s != ""){
      return null;
    }
    else{
      return "Please enter your Unique Customer ID";
    }
  }

}