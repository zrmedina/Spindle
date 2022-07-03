import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/receipt_edit.dart';
import 'package:my_first_flutter_project/scan_screen.dart';

import 'Receipt.dart';

class SavedPage extends StatefulWidget {
   const SavedPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<Receipt> receipts = <Receipt>[];
  User? user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    setState((){
      getReceipts();
    });
  }

  Future<void> getReceipts() async {
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic>? data;
    receipts.clear();

    DatabaseReference ref = FirebaseDatabase.instance.ref("${user?.uid}/receipts");
    ref.onValue.listen((DatabaseEvent event) {
      data = jsonDecode(jsonEncode(event.snapshot.value));
      receipts.clear();
      data?.forEach((key, value) {

        Receipt r = Receipt(value["name"], value["address"], value["date"], value["charge"], value["image"]);
        r.setID(int.parse(key));

        receipts.add(r);
        setState((){});
        print("added");
      });
    });
  }

  void _scan() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScanPage(title: 'Scan', userID: FirebaseAuth.instance.currentUser )),
      );
    });
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("${user?.uid}/receipts");
    ref.onValue.listen((DatabaseEvent event) {
      getReceipts();
      print("heard");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
      ) ,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text(
                          "Name",
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: "BetterGrade",
                          color: Colors.deepPurpleAccent
                        ),
                      ),
                  ),
                  Container(
                    child: Text(
                        "Date",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: "BetterGrade",
                          color: Colors.deepPurpleAccent
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                        "Charge",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: "BetterGrade",
                          color: Colors.deepPurpleAccent
                      ),
                    ),
                  )
                ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: receipts.length,
              itemBuilder: (_, int index){
              return ListTile(
                onTap: (){
                  setState((){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings: RouteSettings(name: "/EditPage"),
                        builder: (context) => EditPage(title: "Edit Receipt", receipt: receipts[index], userID: FirebaseAuth.instance.currentUser),
                      ),
                    );
                  });
                 },
                title: Container(
                  key: UniqueKey(),
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.grey[300],
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        receipts[index].name
                      ),
                      Text(
                        receipts[index].date
                      ),
                      Text(
                        receipts[index].charge
                      )
                    ])
                )
              );
    }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
      onPressed: _scan,
      child: const Text('Scan', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    ),
    );
  }
}