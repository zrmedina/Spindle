import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/scan_screen.dart';
import 'package:my_first_flutter_project/screen_template.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SignupPage> createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void _confirm(){
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userController.text, password: passController.text).then((value){
      print("Success");
      Navigator.pop(context);
    }).catchError((error){
      print("Failed");
      print(error.toString());
    });
  }

  void _cancel(){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 200,
                    color: Colors.deepPurpleAccent,
                    fontFamily: 'BetterGrade',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: false,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                  controller: userController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 10,
                      ),
                    ),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, right: 8.0, bottom: 16.0),
                child: TextField(
                  obscureText: true,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                  controller: passController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton.extended(
                        heroTag: "confirm",
                        onPressed: _confirm,
                        label: const Text(''
                            'Confirm'),
                      ),
                      FloatingActionButton.extended(
                        heroTag: "cancel",
                        onPressed: _cancel,
                        label: const Text('Cancel'),
                      ),
                    ]
                ),
              )
            ]),
      ),
    );
  }
}