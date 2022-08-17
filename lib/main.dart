import 'package:first_project/custom_textfield.dart';
import 'package:first_project/database/customer_database.dart';
import 'package:first_project/database/hive_manager.dart';
import 'package:first_project/scene_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'customer.dart';

Future main() async {
  await Hive.initFlutter();
  var sharedPreferencesManager = SharedPreferencesManager();
  await sharedPreferencesManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Defacto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Sahne1(title: 'Müşteri Bilgileri'),
    );
  }
}

class Sahne1 extends StatefulWidget {
  const Sahne1({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Sahne1> createState() => _Sahne1State();
}

class _Sahne1State extends State<Sahne1> {
  late TextEditingController search;
  late final GlobalKey<FormState> _formKey;
  late final CustomerDatabase customerDatabase;
  @override
  void initState() {
    search = TextEditingController();
    _formKey = GlobalKey<FormState>();
    customerDatabase=CustomerDatabase(sharedPreferencesManager:SharedPreferencesManager());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.grey,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Form(
            key: _formKey,
            child: CustomTextfield(
              labeText: 'Telefon Numarası',
              controller: search,
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
              keyboardType: TextInputType.number,
              inputFormatter: [FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                child: const Text('Satışa Devam'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerInfoPage(
                                customer: Customer(
                                    id: 0,
                                    phoneNumber: '0',
                                    name: 'nihai',
                                    surname: 'müşteri',
                                    isApproved: true),
                              )));
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const Text('Müşteri Sorgula'),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    var customerResult =
                        customerDatabase.getCustomer(search.text);
                    if (customerResult == null) {
                      final snackBar = SnackBar(
                        content: const Text('Müşteri bulunamadı'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerInfoPage(
                                  customer: customerResult)));
                    }
                  }
                })
          ])
        ]),
      ),
    );
  }
}
