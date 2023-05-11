import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hub_config/src/business_logic/services/http_hub_repository.dart';

import 'package:hub_config/src/provider_manager/hub_manager.dart';

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

  InputData inputData = InputData(
    'abc123',
    '12345',
    '192.168.0.1',
    'mqtt.example.com',
    1883,
    'provisionTopicValue',
    'provisionDeviceKeyValue',
    'provisionDeviceSecretValue',
    'MQTT_BASIC',
    'successTopicValue',
    'dataTopicValue',
  );

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (value) {
                    setState(() {
                      inputData.port = int.tryParse(value) ?? 0;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    hintText: 'MQTT PORT : default 1883',
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
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      inputData.successTopic = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Success Topic',
                    hintText: '{SERIAL_NUMBER}/success',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter success topic';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('your data'),
                              content: Text('Broker :${inputData.broker},\n'
                                  'Port: ${inputData.port}\n'
                                  'DataTopic: ${inputData.dataTopic}\n'
                                  'ProvisionTopic: ${inputData.provisionTopic}\n'
                                  'Provision Device Key: ${inputData.provisionDeviceKey}\n'
                                  'Provision Device Secret: ${inputData.provisionDeviceSecret}\n'
                                  'Credentials Type: ${inputData.credentialsType}\n'
                                  'Success Topic: ${inputData.successTopic}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const SerialNumberScanScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
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
