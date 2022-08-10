import 'dart:math';

import 'package:first_project/custom_textfield.dart';
import 'package:first_project/customer.dart';
import 'package:flutter/material.dart';

import 'database/hive_manager.dart';

class CustomerInfoPage extends StatefulWidget {
  const CustomerInfoPage({Key? key, required this.customer}) : super(key: key);
  final Customer customer;
  @override
  State<CustomerInfoPage> createState() => _CustomerInfoPageState();
}

class _CustomerInfoPageState extends State<CustomerInfoPage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneController;
  late final GlobalKey<FormState> _formKey;
  final String appbarText = 'Müşteri Bilgileri';

  late final SharedPreferencesManager sharedPreferencesManager;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.customer.name);
    surnameController = TextEditingController(text: widget.customer.surname);
    phoneController = TextEditingController(text: widget.customer.phoneNumber);
    _formKey = GlobalKey<FormState>();
    sharedPreferencesManager = SharedPreferencesManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(appbarText),
            centerTitle: true,
            actions: [
              MaterialButton(
                child: Text('Kaydet'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    var customer = Customer(
                        id: 0,
                        phoneNumber: phoneController.text,
                        name: nameController.text,
                        surname: surnameController.text);
                    var customerJson = customer.toJson();
                    await sharedPreferencesManager.add(
                        customerJson, '5555555555');
                  }
                },
              )
            ]),
        body: Form(
          key: _formKey,
          child: Column(children: [
            CustomTextfield(
              labeText: 'Numara',
              controller: phoneController,
              validator: (val) {
                if (true) return;
              },
              keyboardType: TextInputType.name,
              inputFormatter: [],
            ),
            CustomTextfield(
              labeText: 'Ad',
              controller: nameController,
              validator: (val) {
                if (true) return;
              },
              keyboardType: TextInputType.name,
              inputFormatter: [],
            ),
            CustomTextfield(
              labeText: 'Soyad',
              controller: surnameController,
              validator: (val) {
                if (true) return;
              },
              keyboardType: TextInputType.name,
              inputFormatter: [],
            )
          ]),
        ));
  }
}
