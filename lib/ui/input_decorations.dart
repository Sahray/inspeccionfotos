import 'package:flutter/material.dart';

class InputDecorations {

static InputDecoration authInputDecoration({
   required String hintText,
   required String labelText,
   IconData? prefixIcon

}){
  return InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromRGBO(6, 6, 68, 1),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                color: Color.fromRGBO(6, 6, 68, 1),
                      )
                    ),
                hintText: hintText,
                labelText: labelText,
                labelStyle: const TextStyle(
                color: Colors.grey 
                ), 
                prefixIcon: prefixIcon !=null
                 ? Icon(prefixIcon, color:  const Color.fromRGBO(6, 6, 68, 1))
                 : null
                 ); 
               
              }
            }