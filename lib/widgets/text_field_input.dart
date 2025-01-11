import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType  textInputType;
  const TextFieldInput({super.key,this.isPass=false,required this.hintText,required this.textInputType,required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    final inputBorder=OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    return TextField(

      controller: textEditingController,
      decoration: InputDecoration(

        labelText: hintText,
        border:inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(17),
        fillColor: mobileBackgroundColor,
        floatingLabelStyle: TextStyle(color:Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.auto, // Automatically moves the label


      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}

