import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/saved_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'holder.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spindle',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white
      ),
      home: const LoginPage(title: 'Spindle: Home Screen'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();


  void _login() {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userController.text, password: passController.text).then((value){
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(name: "/SavedPage"),
            builder: (context) => SavedPage(title: "Storage"),
          ),
        );
      }).catchError((error) {
        print("Login Failed");
      });
  }
  void _signup(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage(title: 'Sign Up')));
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
                'Spindle',
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
                style: Theme.of(context).textTheme.headline5,
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
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 16.0),
              child: TextField(
                  obscureText: true,
                  style: Theme.of(context).textTheme.headline5,
                  controller: passController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: "login",
                    onPressed: _login,
                    label: const Text('Login'),
                  ),
                  FloatingActionButton.extended(
                    heroTag: "signup",
                    onPressed: _signup,
                    label: const Text('Sign up'),
                  ),
                ]
              ),
            )
        ]),
      ),
    );
  }
}
