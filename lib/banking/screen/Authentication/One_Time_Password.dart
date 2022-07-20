import 'package:bankingapp/banking/API/Authentication.dart';
import 'package:bankingapp/banking/utils/Alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTP extends StatefulWidget {
  const OTP({Key? key}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {

  final otpkey = GlobalKey<FormState>();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();
  final controller5 = TextEditingController();
  final controller6 = TextEditingController();
  AuthClass authClass = AuthClass();


  @override
  Widget build(BuildContext context) {

    Map<String, String> data = ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(9),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Text("Please enter your Otp",style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Form(
                      key: otpkey,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: TextFormField(
                                controller: controller1,
                                onChanged: (value){
                                  if(value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: TextFormField(
                                controller: controller2,
                                onChanged: (value){
                                  if(value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else{
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: TextFormField(
                                controller: controller3,
                                onChanged: (value){
                                  if(value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else{
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            )
                          ),
                          Expanded(
                            child: Card(
                              child: TextFormField(
                                controller: controller4,
                                onChanged: (value){
                                  if(value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else{
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: TextFormField(
                                controller: controller5,
                                onChanged: (value){
                                  if(value.length == 1 ) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else{
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: TextFormField(
                                controller: controller6,
                                onChanged: (value){
                                  if(value.isEmpty ){
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            String otp = controller1.text + controller2.text + controller3.text + controller4.text + controller5.text + controller6.text;
                            if(await authClass.confirmOtp(otp: otp,
                              custId: data["custId"], phone: data["phone"],) ){
                                Navigator.popAndPushNamed(context, "DashBoard");
                            }
                            else{
                              showAlert(context: context,
                                  title: "Please retry with new otp");
                            }
                          },
                          child: const Text("Confirm")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }


}
