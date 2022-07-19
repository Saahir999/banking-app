import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthClass{

  final String base = "http://40.80.91.121:5001";
  final String basic = "40.80.91.121";

  Future register({required String name,required String custId,required String phone})async{

    Map? info = await Verifylogin(custId: custId, phone: phone);
    if(info == null){
      return false;
    }
    bool verified = await confirmVerification(phone: info["PhoneNo"],custId: info["Membership_no"],refId: info["RefId"]);

    // String otp = await confirmVerification(phone: info["PhoneNo"],custId: info["Membership_no"],refId: info["RefId"]);
    // await confirmOtp(phone: info["PhoneNo"],custId: info["Membership_no"],otp: otp);

    return verified;
  }
  Future login({required String custId,required String phone})async{
    Map? info = await Verifylogin(custId: custId, phone: phone);
    if(info == null){
      return false;
    }
    return true;
  }

  Future Verifylogin({required String custId,required String phone})async{
    String Verifylogin = "/api/Verifylogin";

    Map jsonMap = {
      "phone":phone,
      "custId":custId
    };
    // Map<String,String> jsonMap = {
    //   //"name" : "string",
    //   "phone": "9449676077",
    //   "custId": "010000009"
    // };
    String jsonBody = json.encode(jsonMap);
    try {
      var response = await http.post(Uri.parse(base + Verifylogin),
          body: jsonBody,
          headers: {
            'access-control-allow-origin': '*',
            'Content-type': 'application/json',
            'accept': '*/*',
            'Connection': 'keep-alive',
            'transfer-encoding': 'chunked',
            'server': 'Kestrel',
          });
      print(json.decode(response.body));
      return (json.decode(response.body))["payload"][0];
    }catch(e){
      return null;
    }

  }
  Future confirmVerification({required String? phone,required String? custId,required String? refId})async{
    String Confirmverification = "/api/Confirmverification";
    if(phone!.isEmpty || refId!.isEmpty || custId!.isEmpty){
      return false;
    }
    Map<String,String> jsonMap = {
      "phone": phone,
      "custId": custId,
      "refId" : refId
    };
    // Map<String,String> jsonMap = {
    //   "phone": "9449676077",
    //   "custId": "010000009",
    //   "refId" : "000334"
    // };
    String jsonBody = json.encode(jsonMap);

    var response = await http.post(Uri.parse(base+Confirmverification),
        body: jsonBody,
        headers: {
          'access-control-allow-origin' : '*',
          'Content-type': 'application/json',
          'accept': '*/*',
          'Connection' : 'keep-alive',
          'transfer-encoding' : 'chunked',
          'server' : 'Kestrel',
        });
    print(json.decode(response.body));
    if(response.statusCode == 200){
      return true;
    }
    return false;

  }
  Future confirmOtp({required String? phone,required String? custId,required String? otp})async{
    String Confirmotp = "/api/Confirmotp";

    // Map<String,String> jsonMap = {
    //   "phone": phone,
    //   "custId": custId,
    //   "otp" : otp
    // };
    Map<String,String> jsonMap = {
      "phone": "9449676077",
      "custId": "010000009",
      "refId" : "123456"
    };
    String jsonBody = json.encode(jsonMap);

    var response = await http.post(Uri.parse(base+Confirmotp),
        body: jsonBody,
        headers: {
          'access-control-allow-origin' : '*',
          'Content-type': 'application/json',
          'accept': '*/*',
          'Connection' : 'keep-alive',
          'transfer-encoding' : 'chunked',
          'server' : 'Kestrel',
        });
    print(json.decode(response.body));
    if(response.statusCode == 200){
      return true;
    }
    return false;
  }

}