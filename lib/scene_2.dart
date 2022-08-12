import 'package:first_project/custom_textfield.dart';
import 'package:first_project/customer.dart';
import 'package:first_project/database/customer_database.dart';
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

  late final CustomerDatabase customerDatabase;
  @override
  void initState() {
    nameController = TextEditingController(text: widget.customer.name);
    surnameController = TextEditingController(text: widget.customer.surname);
    phoneController = TextEditingController(text: widget.customer.phoneNumber);
    _formKey = GlobalKey<FormState>();
    customerDatabase =
        CustomerDatabase(sharedPreferencesManager: SharedPreferencesManager());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(appbarText),
            centerTitle: true,
            actions: [saveAndUpdateButton]),
        body: Form(
          key: _formKey,
          child: Column(children: [
            CustomTextfield(
              labeText: 'Numara',
              controller: phoneController,
              validator: (String? val) {
                if (val == null || val == "") {
                  return 'Telefon numarası alanı boş olamaz';
                }
                var firstCharacter = val[0];
                if (firstCharacter != '0') {
                  return 'Telefon numarası 0 ile başlamalıdır';
                }
                if (val.length != 10) {
                  return 'Telefon numarası 10 karakter olmalıdır';
                }
                return null;
              },
              keyboardType: TextInputType.name,
              inputFormatter: [],
            ),
            CustomTextfield(
              labeText: 'Ad',
              controller: nameController,
              validator: (String? val) {
                if (val == null || val.isEmpty == true) {
                  return 'Ad alanı boş olamaz';
                }
                
                if (val.length < 2) return 'Ad 2 karakterden küçük olamaz';
                return null;
              },
              keyboardType: TextInputType.name,
            ),
            CustomTextfield(
              labeText: 'Soyad',
              controller: surnameController,
              validator: (String? val) {
                if (val == null || val.isEmpty == true) {
                  return 'Soyad alanı boş olamaz';
                }
                if (val.length < 2) return 'Soyad 2 karakterden küçük olamaz';
                return null;
              },
              keyboardType: TextInputType.name,
            )
          ]),
        ));
  }

  MaterialButton get saveAndUpdateButton {
    var customerIsRegistered = widget.customer.id > 0 ? true : false;

    return MaterialButton(
      child: Text(customerIsRegistered ? 'GÜncelle' : 'Kaydet'),
      onPressed: () async {
        if (_formKey.currentState?.validate() == true) {
          widget.customer.id>0? await updateCustomer(): await createCustomer();
        }
      },
    );
  }

  Future createCustomer() async {
    var customer = Customer(
        id: 0,
        phoneNumber: phoneController.text,
        name: nameController.text,
        surname: surnameController.text,
        isApproved: true);
    await customerDatabase.addCustomer(customer);
    final snackBar = SnackBar(
      content: const Text('Müşteri Kaydedildi'),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  Future updateCustomer() async {
    var customer = Customer(
        id: widget.customer.id,
        phoneNumber: phoneController.text,
        name: nameController.text,
        surname: surnameController.text,
        isApproved: true);
    await customerDatabase.updateCustomer(customer);
    final snackBar = SnackBar(
      content: const Text('Müşteri Güncellendi'),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
