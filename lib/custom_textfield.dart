import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({Key? key,required this.labeText, required this.controller}) : super(key: key);
final String labeText;
final TextEditingController controller;
  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
      child: TextFormField(
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: widget.labeText,
      ),
      controller: widget.controller,
          
      ),
    );
  }
}