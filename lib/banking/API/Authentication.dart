import 'dart:convert';
import 'dart:io' as dhttp;
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class AuthClass{

  final String base = "http://40.80.91.121:5001";
  final dhttp.HttpClient httpClient = dhttp.HttpClient();

  Future register({required String name,required String custId,required String phone})async{

    await Verifylogin(custId: custId, phone: phone);

  }
  Future login({required String custId,required String phone})async{

  }

  Future Verifylogin({required String custId,required String phone})async{
    String Verifylogin = "/api/Mobilenumberverification";

    // Map jsonMap = {
    //   "phone":phone,
    //   "custId":custId
    // };
    Map<String,String> jsonMap = {
      //"name" : "string",
      "phone": "9611256039",
      "custId": "010000002"
    };
    String jsonBody = json.encode(jsonMap);
    var response = await http.post(Uri.parse(base+Verifylogin),
        //body: utf8.encode(jsonBody),
        body: jsonBody,
        //body: jsonMap,
        headers: {
          'access-control-allow-origin' : '*',
          'Content-type': 'application/json; charset=utf-8',
          //'content-type': 'application/json',
          //'Content-type': 'text/json',
          'accept': '*/*',
          'Connection' : 'keep-alive',
          'transfer-encoding' : 'chunked',
          'server' : 'Kestrel',
        });
    print(response.headers);
    print(response.request);
    print(response.bodyBytes);
    print(response.body);
    //print((json.decode(response.body) ));
    print(response.statusCode);

    //return (json.decode(response.body) as Map<String,dynamic>)["payload"];


    // dhttp.HttpClientRequest request = await httpClient.postUrl(Uri.parse(base+Verifylogin));
    // print(base+Verifylogin);
    // request.headers.set('content-type', 'application/json; charset=utf-8',preserveHeaderCase: true);
    // request.headers.set('transfer-encoding','compress',preserveHeaderCase: true);
    // request.add(utf8.encode(json.encode(jsonMap)));
    // dhttp.HttpClientResponse response = await request.close();
    // // todo - you should check the response.statusCode
    // print(response);
    // String reply = await response.transform(utf8.decoder).join();
    // print(reply);
    // return reply;

  }
  Future confirmVerification()async{
    String Confirmverification = "/api/Confirmverification";
  }
  Future confirmOtp()async{
    String Confirmotp = "/api/Confirmotp";
  }

  void closeConnection()async{
    httpClient.close();
  }

}