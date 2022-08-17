import 'package:first_project/custom_textfield.dart';
import 'package:first_project/customer.dart';
import 'package:first_project/database/customer_database.dart';
import 'package:first_project/scene_3.dart';
import 'package:first_project/scene_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late Customer customer;
  late final CustomerDatabase customerDatabase;
  @override
  void initState() {
    customer = widget.customer;
    nameController = TextEditingController(text: customer.name);
    surnameController = TextEditingController(text: customer.surname);
    phoneController = TextEditingController(text: customer.phoneNumber);
    _formKey = GlobalKey<FormState>();
    customerDatabase =
        CustomerDatabase(sharedPreferencesManager: SharedPreferencesManager());
    if (!customer.isApproved && customer.id > 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print(customer.approveCode.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmationCode(
                      customer: customer,
                    )));
      });
    }
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
          child: Column(
            children: [
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
                inputFormatter: [LengthLimitingTextInputFormatter(10)],
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
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Store()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Mağaza')),
            ],
          ),
        ));
  }

  MaterialButton get saveAndUpdateButton {
    var customerIsRegistered = customer.id > 0 ? true : false;

    return MaterialButton(
      child: Text(customerIsRegistered ? 'Güncelle' : 'Kaydet'),
      onPressed: () async {
        if (_formKey.currentState?.validate() == true) {
          customer.id > 0 ? await updateCustomer() : await createCustomer();
        }
      },
    );
  }

  Future createCustomer() async {
    var createdCustomer = Customer(
        id: 0,
        phoneNumber: phoneController.text,
        name: nameController.text,
        surname: surnameController.text,
        isApproved: true);

    var response = await customerDatabase.addCustomer(createdCustomer);
    if (!response.isSuccess) {
      final snackBar = SnackBar(
        content: Text(response.meessage),
        action: SnackBarAction(
          label: '',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (response.isSuccess) {
      setState(() {
        customer = response.customer as Customer;
      });
      final snackBar = SnackBar(
        content: Text(response.meessage),
        action: SnackBarAction(
          label: '',
          onPressed: () {},
        ),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmationCode(
                    customer: customer,
                  )));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future updateCustomer() async {
    var updatedCustomer = Customer(
        id: customer.id,
        phoneNumber: phoneController.text,
        name: nameController.text,
        surname: surnameController.text,
        isApproved: true);
    await customerDatabase.updateCustomer(updatedCustomer);
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
