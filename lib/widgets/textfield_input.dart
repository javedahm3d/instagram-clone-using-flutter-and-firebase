import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
   final TextEditingController textEditingController;
   final String hintText;
   final bool isPass;
   final TextInputType textInputType;



  const TextInputField({super.key,
    required this.textEditingController ,
    required this.hintText ,
    this.isPass = false ,
    required this.textInputType
     }
     );

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return TextField(
       controller: textEditingController,
    
       decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
       ),
       keyboardType: textInputType,
       obscureText: isPass,
    );
  }
}
