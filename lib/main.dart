import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hub_config/src/business_logic/services/http_hub_repository.dart';

import 'package:hub_config/src/provider_manager/hub_manager.dart';
import 'package:hub_config/src/views/scan_wifi_screen.dart';

import 'package:hub_config/src/views/serial_number_scan_screen.dart';
import 'package:provider/provider.dart';

import 'package:hub_config/src/business_logic/models/input_data.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Hub App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    InputData inputData = Provider.of<HubManager>(context).inputData;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Initial Input Screen'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      inputData.hubIP = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: '192.168.0.1',
                    labelText: 'Device Hotspot IP',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter device hotspot ip';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: inputData.broker,
                  onChanged: (value) {
                    setState(() {
                      inputData.broker = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Broker',
                    hintText: 'thingsboard IP Address (Mqtt Broker)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter broker value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: '1883',
                  onChanged: (value) {
                    setState(() {
                      inputData.port = int.tryParse(value) ?? 0;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Port',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter port value';
                    } else {
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'enter valid port value';
                      }
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: 'v1/devices/me/telemetry',
                  onChanged: (value) {
                    setState(() {
                      inputData.dataTopic = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Data Topic',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter data topic';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: '/provision',
                  onChanged: (value) {
                    setState(() {
                      inputData.provisionTopic = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Provision Topic',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter provision topic';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: inputData.provisionDeviceKey,
                  onChanged: (value) {
                    setState(() {
                      inputData.provisionDeviceKey = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Provision Device Key',
                      hintText: ' (retrieved from thingsboard)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter provision device key';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: inputData.provisionDeviceSecret,
                  onChanged: (value) {
                    setState(() {
                      inputData.provisionDeviceSecret = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Provision Device Secret',
                      hintText: ' (retrieved from thingsboard)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Device Secret';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: inputData.credentialsType,
                  onChanged: (value) {
                    setState(() {
                      inputData.credentialsType = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Credentials Type',
                    hintText: 'MQTT_BASIC',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter credentials type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SerialNumberScanScreen()));
                      }
                    },
                    child: const Text('SUBMIT'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
