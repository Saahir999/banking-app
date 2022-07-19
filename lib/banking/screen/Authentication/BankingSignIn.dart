import 'package:bankingapp/banking/screen/BankingDashboard.dart';
import 'package:bankingapp/banking/screen/Authentication/BankingForgotPassword.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import '../../API/Authentication.dart';
import '../../utils/Alert.dart';

class BankingSignIn extends StatefulWidget {
  static var tag = "/BankingSignIn";

  const BankingSignIn({Key? key}) : super(key: key);

  @override
  BankingSignInState createState() => BankingSignInState();
}

class BankingSignInState extends State<BankingSignIn> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  final storage = const FlutterSecureStorage();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  bool _isAuthenticating = false;
  bool change = false;
  String? status = "";
  String? phone;
  String? custId;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final authClass = AuthClass();
  final FocusNode _focusNode1 = FocusNode();
  int f = 0;
  final FocusNode _focusNode2 = FocusNode();
  int f2 = 0;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    storage.read(key: "phone").then((value) {
       phone = value;
    });
    storage.read(key: "custId").then((value) {
      custId = value;
    });
    storage.read(key: "showIntro").then((value){
      if(value != null)
      {
        status = value;
      }
    });
    auth.isDeviceSupported().then(
          (bool isSupported) =>
          setState(() =>
          _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
    );
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
  }

  @override
  Widget build(BuildContext context) {
    f=0;
    f2=0;
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
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(heightFactor: 5,child: Text(Banking_lbl_SignIn, style: boldTextStyle(size: 30))),
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
                    8.height,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          Banking_lbl_Forgot, style: secondaryTextStyle(size: 16))
                          .onTap(
                            () {
                          const BankingForgotPassword().launch(context);
                        },
                      ),
                    ),
                    16.height,
                    BankingButton(
                      textContent: Banking_lbl_SignIn,
                      onPressed: () {
                        if(validateID(_controller2.text) == null && validatePhoneNo(_controller.text) == null) {
                          log("https://validated.com");
                          //TODO-> check for platform issues if web 'app' is used as end product
                          //storage.write(key: "showIntro", value: "false");
                          authClass.login(custId: _controller2.text,phone: _controller.text).then((val){
                            if(val == true){
                              Navigator.popAndPushNamed(context, "OTP",
                                  arguments: {
                                    "phone":_controller.text,
                                    "custId":_controller2.text
                                  });
                            }
                            else{
                              _controller.text = "";
                              _controller2.text = "";
                              showAlert(context: context, title: "Please Enter correct details");
                            }
                          });
                        }
                      },
                    ),
                    16.height,
                    Column(
                      children: [
                        TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, "Register");
                            },
                            child: const Text("Register"),
                        ),
                        FutureBuilder(
                            future: _init(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done && snapshot.hasData &&
                                  _canCheckBiometrics == true &&
                                  !_availableBiometrics!.length.isNegative) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    if (_isAuthenticating)
                                      ElevatedButton(
                                        onPressed: _cancelAuthentication,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const <Widget>[
                                            Text('Cancel Authentication'),
                                            Icon(Icons.cancel),
                                          ],
                                        ),
                                      ),
                                    if(!_isAuthenticating)
                                      TextButton(
                                        onPressed: () {
                                          _authenticate().then((value) {
                                            if (value == true && status!.isNotEmpty) {
                                            Navigator.popAndPushNamed(context, "OTP",
                                                arguments: {
                                                  "phone":phone ?? _controller.text,
                                                  "custId":custId ?? _controller2.text
                                                });
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const <Widget>[
                                            Text('Authenticate: Password/Pin'),
                                            Icon(Icons.numbers_rounded),
                                          ],
                                        ),
                                      ),
                                      if(!_isAuthenticating)
                                      TextButton(
                                        onPressed: () {
                                          _authenticateWithBiometrics().then((
                                              value) {
                                            if (value == true && status!.isNotEmpty) {
                                              Navigator.popAndPushNamed(context, "OTP",
                                                  arguments: {
                                                    "phone":phone ?? _controller.text,
                                                    "custId":custId ?? _controller2.text
                                                  });
                                            }
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const <Widget>[
                                            Text('Authenticate: biometrics only'),
                                            Icon(Icons.fingerprint),
                                          ],
                                        ),
                                      ),

                                  ],
                                );
                              }
                              else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              else {
                                return const Center(child: Text("Error"),);
                              }
                            }
                        ),
                        const Align(
                          heightFactor: 7,
                          alignment: Alignment.bottomCenter,
                          child: Text(" XXXX Bank",style: TextStyle(fontSize: 20)),
                        ),
                        // Text(Banking_lbl_Login_with_FaceID, style: primaryTextStyle(
                        //     size: 16, color: Banking_TextColorSecondary))
                        //     .onTap(() {}),
                        // 16.height,
                        // Image.asset(Banking_ic_face_id, color: Banking_Primary,
                        //     height: 40,
                        //     width: 40),
                      ],
                    ).center(),

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
    _controller.dispose();
    _controller2.dispose();
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

  Future<int> _init() async {
    await _checkBiometrics();
    await _getAvailableBiometrics();
    return 1;
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      log(e);
    }
    if (!mounted) {
      return;
    }
    _canCheckBiometrics = canCheckBiometrics;
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }
    _availableBiometrics = availableBiometrics;
  }

  Future<bool> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      // setState(() {
      //   _isAuthenticating = true;
      // });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      // setState(() {//TODO-> uncommented these 2 lines below
      // _isAuthenticating = false;
      // });
      return authenticated;
    } on PlatformException catch (e) {
      print(e);
      _isAuthenticating = false;
      showAlert(context: context,title: "Please register a FingerPrint on your device");
      return false;
    }
  }

  Future<bool> _authenticate() async {
    bool authenticated = false;
    try {
      // setState(() {
      //   _isAuthenticating = true;
      // });
      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with pattern/pin/passcode',
        // biometricOnly: false,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      // const storage = FlutterSecureStorage();
      // await storage.write(key: "test", value: "xy232yx");
      //_isAuthenticating = false;
      return authenticated;
    } on PlatformException catch (e) {
      print(e);
      _isAuthenticating = false;
      showAlert(context: context,title: "Please set up the Pin/Password in your device settings");
      return false;
    }
  }

}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}