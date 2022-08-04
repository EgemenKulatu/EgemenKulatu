import 'package:first_project/custom_textfield.dart';
import 'package:first_project/scene_2.dart';
import 'package:flutter/material.dart';

void main() {
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
  @override
  void initState() {
    search = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.grey,
        child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
           children: [CustomTextfield(labeText: 'Telefon Numarası',controller: search,),
          
            Row(
              children: [ElevatedButton(
                child: const Text('Satışa Devam'),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerInfoPage()));
                }
                )]
          )
           ]
        ),
      ),
    );
  }
}