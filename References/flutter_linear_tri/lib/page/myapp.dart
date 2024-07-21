import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Triafem',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.cyan,
        fontFamily: "HarmonyOS_Sans"
      ),
      home: const MyHomePage(title: 'Triafem有限元教学软件'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('lib/res/image/icon.png', height: 300, width: 300),
              const Text(
                '点击按钮开始有限元建模，您已经建模',
              ),
              Text(
                '$_counter次',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: '点击支付有限元即可建模',
          child: const Icon(Icons.lens_outlined)
        ));
  }
}
