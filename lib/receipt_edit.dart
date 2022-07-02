import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'Receipt.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.title, required this.receipt, required this.userID}) : super(key: key);

  final String title;
  final Receipt receipt;
  final User? userID;

  @override
  State<EditPage> createState() => _EditState();
}

class _EditState extends State<EditPage> {
  String? newName;
  String? newAddress;
  String? newDate;
  String? newCharge;



  void save() {
    setState(() {
      if(newName != null){
        widget.receipt.name = newName!;
      }else{
      }
      if(newAddress != null){
        widget.receipt.address = newAddress!;
      }
      if(newDate != null){
        widget.receipt.date = newDate!;
      }
      if(newCharge != null){
        widget.receipt.charge = newCharge!;
      }
      print(newName);
      print(newAddress);
      print(newDate);
      print(newCharge);

      FirebaseDatabase.instance.ref().child("${widget.userID?.uid}/receipts/${widget.receipt.id}").set(widget.receipt.toMap());

      Navigator.of(context)
          .popUntil(ModalRoute.withName("/SavedPage"));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Container(
             margin: EdgeInsets.all(20),
             width: 500,
             child: TextFormField(
               initialValue: widget.receipt.name,
               onChanged: (String? name) {
                 newName = name!;
               },
               decoration: InputDecoration(
                 labelText: "Name"
               ),

             )
            ),
            Container(
                margin: EdgeInsets.all(20),
                width: 500,
                child: TextFormField(
                  initialValue: widget.receipt.address,
                  onChanged: (String? name) {
                    newAddress = name!;
                  },
                  decoration: InputDecoration(
                      labelText: "Address"
                  ),

                )
            ),
            Container(
                margin: EdgeInsets.all(20),
                width: 500,
                child: TextFormField(
                  initialValue: widget.receipt.date,
                  onChanged: (String? name) {
                    newDate = name!;
                  },
                  decoration: InputDecoration(
                      labelText: "Date"
                  ),

                )
            ),
            Container(
                margin: EdgeInsets.all(20),
                width: 500,
                child: TextFormField(
                  initialValue: widget.receipt.charge,
                  onChanged: (String? name) {
                    newCharge = name!;
                  },
                  decoration: InputDecoration(
                      labelText: "Charge"
                  ),

                )
            )
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: save,
        label: Text("Save"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}