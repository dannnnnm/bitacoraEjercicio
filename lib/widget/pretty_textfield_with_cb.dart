import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrettyTextfieldWithCb extends StatelessWidget{
  PrettyTextfieldWithCb(this.labelText,this.target, {super.key, this.keyboardType,this.updateCB});
  PrettyTextfieldWithCb.withCustomCB(this.labelText,this.customCB,{super.key,this.keyboardType}):target="".obs;
  RxString target;
  String labelText;
  TextInputType? keyboardType;
  Function(String)? customCB;
  void Function()? updateCB;
  @override
  Widget build(BuildContext context) {
    return TextField(
            onChanged: customCB ?? (txtValue){
              target.value=txtValue;
              if (updateCB!=null){
                updateCB!();
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: labelText,
            ),
            keyboardType: keyboardType,
          );
  }
  

}