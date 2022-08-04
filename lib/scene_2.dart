import 'package:first_project/custom_textfield.dart';
import 'package:flutter/material.dart';

class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({Key? key}) : super(key: key);

  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  late TextEditingController nameController;
  @override
  void initState() {
    nameController =TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (body: Column(children: [CustomTextfield(labeText: 'ad',controller: nameController,),]));
  }
}
