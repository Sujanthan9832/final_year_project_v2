import 'package:flutter/material.dart';

class Camview extends StatefulWidget {
  const Camview({super.key});

  @override
  State<Camview> createState() => _CamviewState();
}

class _CamviewState extends State<Camview> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: _incrementCounter,
            child: Text('Add number +'),
          )
        ],
      ),
    );
  }
}
