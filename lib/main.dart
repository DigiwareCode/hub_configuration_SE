import 'package:flutter/material.dart';
import 'package:hub_config/src/business_logic/services/http_hub_repository.dart';

import 'package:hub_config/src/provider_manager/hub_manager.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider<HubManager>(
    create: (context) => HubManager(
      HttpHubRepository.instance,
    ),
    builder: (context, child) {
      return MyApp();
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hub App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Hub Configuration'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late HubManager hubManager;

/*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    hubManager = Provider.of<HubManager>(context);
  }*/

  @override
  Widget build(BuildContext context) {
    final hubManager = Provider.of<HubManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                hubManager.scanSerialNumber();
              },
              child: const Text('Scan QR'),
            ),
            ElevatedButton(
              onPressed: () {
                hubManager.quitHubConnection();
              },
              child: const Text('RESET'),
            ),
          ],
        ),
      ),
    );
  }
}
