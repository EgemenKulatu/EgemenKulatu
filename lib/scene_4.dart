import 'package:flutter/material.dart';


class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final String appbarText = 'Mağaza';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         
            leading: IconButton(
              
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(appbarText)
    ));
  }
}