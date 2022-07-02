import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _counter = 0;

  void _Scan() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              child: FloatingActionButton.large(
                onPressed: _Scan,
                child: Text(
                  'Scan',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                //label: Text('Scan'),

              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}