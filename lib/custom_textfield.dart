import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatefulWidget {
 CustomTextfield({Key? key,required this.labeText, required this.controller,required this.validator,required this.keyboardType,required this.inputFormatter}) : super(key: key);
final String labeText;
final TextEditingController controller;
final String? Function(String?)? validator;
final TextInputType keyboardType;
final List<TextInputFormatter> inputFormatter;

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
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatter,
      ),
    );
  }
}