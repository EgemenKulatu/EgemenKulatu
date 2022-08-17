import 'package:first_project/database/customer_database.dart';
import 'package:first_project/database/hive_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_textfield.dart';
import 'customer.dart';

class ConfirmationCode extends StatefulWidget {
  const ConfirmationCode({Key? key, required this.customer}) : super(key: key);
  final Customer customer;

  @override
  State<ConfirmationCode> createState() => _ConfirmationCodeState();
}

class _ConfirmationCodeState extends State<ConfirmationCode> {
  late final CustomerDatabase customerDatabase;
  final String appbarText = 'Onay Kodu';
  late final GlobalKey<FormState> _formKey;
  late TextEditingController confirmation;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    confirmation = TextEditingController();
    customerDatabase =
        CustomerDatabase(sharedPreferencesManager: SharedPreferencesManager());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: SizedBox.shrink(),
          title: Text(appbarText),
          centerTitle: true,
        ),
        body: Container(
            alignment: Alignment.bottomCenter,
            color: Colors.grey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Form(
                  key: _formKey,
                  child: CustomTextfield(
                      labeText: 'Onay Kodu',
                      controller: confirmation,
                      validator: (String? val) {
                        if (val == null || val == "") {
                          return 'Onay kodu boş olamaz';
                        }
                        if (val.length != 4) {
                          return 'Onay kodu 4 karakter olmalıdır';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4)
                      ])),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            var confirmationResult =
                                await customerDatabase.approveCustomer(
                                    int.parse(confirmation.text),
                                    widget.customer.phoneNumber);
                            if (confirmationResult.isSuccess) {
                              Navigator.of(context).pop();
                             
                            }
                             final snackBar = SnackBar(
                                content: Text(confirmationResult.meessage),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar); 
                          }
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text('Onayla')),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        child: Text('Kodu Tekrardan Gönder')),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: Text('Geri dön'))
                  ])
            ])));
  }
}
