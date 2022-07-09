import 'package:flutter/material.dart';

void showAlert({required BuildContext context,required String title,List<Widget>? buttonList}){
  buttonList ??= [];
  buttonList.insert(0, TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Ok")));
  showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          actions: buttonList,
        );
  });
}