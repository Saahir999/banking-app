// import 'dart:async';
//
// import 'package:bankingapp/banking/screen/BankingDashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
//
// class Fingerprint extends StatefulWidget {
//   const Fingerprint({Key? key}) : super(key: key);
//
//   @override
//   State<Fingerprint> createState() => _FingerprintState();
// }
//
// class _FingerprintState extends State<Fingerprint> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool? _canCheckBiometrics;
//   List<BiometricType>? _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (bool isSupported) => setState(() => _supportState = isSupported
//           ? _SupportState.supported
//           : _SupportState.unsupported),
//     );
//   }
//
//   Future<void> _checkBiometrics() async {
//     late bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) {
//       return;
//     }
//     _canCheckBiometrics = canCheckBiometrics;
//   }
//
//   Future<void> _getAvailableBiometrics() async {
//     late List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) {
//       return;
//     }
//       _availableBiometrics = availableBiometrics;
//   }
//
//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason: 'Let OS determine authentication method',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//
//         ),
//       );
//       setState(() {
//         _isAuthenticating = false;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Error - ${e.message}';
//       });
//       return;
//     }
//     if (!mounted) {
//       return;
//     }
//
//     setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
//   }
//
//   Future<bool> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = 'Authenticating';
//       });
//       authenticated = await auth.authenticate(
//         localizedReason:
//         'Scan your fingerprint to authenticate',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//       // setState(() {
//       //   _isAuthenticating = false;
//       //   _authorized = 'Authenticating';
//       // });
//       return authenticated;
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = 'Error - ${e.message}';
//       });
//       return false;
//     }
//     // if (!mounted) {
//     //   return;
//     // }
//     //
//     // final String message = authenticated ? 'Authorized' : 'Not Authorized';
//     // setState(() {
//     //   _authorized = message;
//     // });
//   }
//
//   Future<void> _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: <Widget>[
//             FutureBuilder(
//               future: _init(),
//               builder: (context,snapshot){
//                 if(snapshot.connectionState == ConnectionState.done && snapshot.hasData && _canCheckBiometrics == true && !_availableBiometrics!.length.isNegative){
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       if (_isAuthenticating)
//                         ElevatedButton(
//                           onPressed: _cancelAuthentication,
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const <Widget>[
//                               Text('Cancel Authentication'),
//                               Icon(Icons.cancel),
//                             ],
//                           ),
//                         )
//                       else
//                         ElevatedButton(
//                           onPressed: (){
//                             _authenticateWithBiometrics().then((value){
//                               if(value == true){
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (context) => const BankingDashboard()));
//                               }
//                             });
//                           },
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Text(_isAuthenticating
//                                   ? 'Cancel'
//                                   : 'Authenticate: biometrics only'),
//                               const Icon(Icons.fingerprint),
//                             ],
//                           ),
//                         ),
//                     ],
//                   );
//                 }
//                 else if(snapshot.connectionState == ConnectionState.waiting){
//                     return const Center(child: CircularProgressIndicator());
//                 }
//                 else{
//                   return const Center(child: Text("Error"),);
//                 }
//               }
//             ),
//           ],
//         ),
//       );
//   }
//
//   Future<int> _init()async{
//     var c = await _checkBiometrics();
//     var g = await _getAvailableBiometrics();
//     return 1;
//   }
// }
//
// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }