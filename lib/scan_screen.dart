
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learning_entity_extraction/learning_entity_extraction.dart' as ex;
import 'package:my_first_flutter_project/Receipt.dart';
import 'package:my_first_flutter_project/receipt_edit.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key, required this.title, required this.userID}) : super(key: key);

  final String title;
  final User? userID;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  void getImage(ImageSource source) async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage != null){
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
      }
    }catch(e){
      textScanning = false;
      imageFile = null;
      setState((){});
    }
}
  void getText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";

    for(TextBlock block in recognizedText.blocks){
      for(TextLine line in block.lines){
        scannedText = "$scannedText${line.text} ";
      }
    }
    ex.EntityExtractor extractor =
    ex.EntityExtractor();

    List<dynamic> result = await extractor.extract(scannedText);
    String name = "N/A";
    String address = "N/A";
    String date = "N/A";
    String charge = "N/A";

    print(result);
    for(var i = 0 ; i < result.length; i++){
        if (result[i]["entities"][0]["type"] == 'address'){
          address = result[i]["entities"][0]["address"];
          break;
        }
    }
    for(var i = 0 ; i < result.length; i++){
      if (result[i]["entities"][0]["type"] == 'datetime'){
        date = result[i]["annotation"];
        break;
      }
    }
    Receipt newReceipt = Receipt(name,address,date,charge,imageFile);

    setState(() {

      Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(name: "/EditPage"),
          builder: (context) => EditPage(receipt: newReceipt, userID: widget.userID, title: 'Edit Receipt'),
        ),
      );
    });

    print(address);
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0, bottom: 30.0),
              child: const Text(
                "Select a photo below",
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.deepPurpleAccent,
                  fontFamily: 'BetterGrade',
                )
              )
            ),
            Column(
              children: [
                if(!textScanning && imageFile == null)
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[300]!,
                    border: Border.all(
                      color: Colors.black,
                    )
                  )
                ),
                if(imageFile != null)
                  Container(
                      width: 300,
                      height: 300,
                      child: Image.file(File(imageFile!.path))
                  ),
            ]),
            Container(
              margin: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: "gallery",
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    label: const Text("Gallery"),
                    icon: const Icon(
                      Icons.image,
                    ),
                  ),
                  FloatingActionButton.extended(
                    heroTag: "camera",
                    onPressed: () {
                      getImage(ImageSource.camera);
                    },
                    label: const Text("Camera"),
                    icon: const Icon(
                      Icons.camera,
                    ),
                  ),
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(imageFile != null)
                  Container(
                    child: FloatingActionButton.extended(
                      heroTag: "confirmScan",
                      onPressed: () {
                        getText(imageFile!);
                      },
                      label: const Text("Confirm"),
                      icon: const Icon(
                        Icons.check,
                      ),
                    ),
                  )
                ],
            ),
      ]), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}