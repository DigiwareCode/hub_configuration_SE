import 'package:flutter/material.dart';
import 'package:hub_config/src/business_logic/models/input_data.dart';
import 'package:hub_config/src/views/rounded_button.dart';
import 'package:provider/provider.dart';
import '../provider_manager/hub_manager.dart';
import 'hub_connection_success_screen.dart';
import 'input_field.dart';
import 'messenger.dart';
import 'skeleton.dart';

class HubWifiSetScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: routeName, key: ValueKey(routeName), child: HubWifiSetScreen());
  }

  static const String routeName = '/setHubWifi';

  const HubWifiSetScreen({Key? key}) : super(key: key);

  @override
  State<HubWifiSetScreen> createState() => _HubWifiSetScreenState();
}

class _HubWifiSetScreenState extends State<HubWifiSetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ssidController.text =
        Provider.of<HubManager>(context, listen: false).wifiSSID;
  }

  @override
  Widget build(BuildContext context) {
    HubManager myHubManager = Provider.of<HubManager>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Skeleton(
        title: "Connect hub to Wifi",
        maxTitleWidth: size.width * 0.7,
        subtitle:
            "Please enter Wifi name and password to connect your Hub to internet",
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Consumer<HubManager>(
                  builder: (_, manager, __) {
                    return InputField(
                      controller: _ssidController,
                      label: "Wifi name",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: const Icon(Icons.wifi),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Invalid name";
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_isPasswordVisible,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? (Icons.visibility)
                        : (Icons.visibility_off)),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  label: "Password",
                ),
              ],
            ),
          ),
          Column(
            children: [
              RoundedButton(
                onPressed: () {
                  _connectHub();
                 // InputData inputData = myHubManager.inputData;
/*
                  AlertDialog(
                    title: const Text('Your data'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Device Hotspot IP:${inputData.hubIP} ,\n'),
                          Text('Broker :${inputData.broker},\n'),
                          Text('Port: ${inputData.port}\n'),
                          Text('DataTopic: ${inputData.dataTopic}\n'),
                          Text('ProvisionTopic: ${inputData.provisionTopic}\n'),
                          Text(
                              'Provision Device Key: ${inputData.provisionDeviceKey}\n'),
                          Text(
                              'Provision Device Secret: ${inputData.provisionDeviceSecret}\n'),
                          Text(
                              'Credentials Type: ${inputData.credentialsType}\n'),
                          Text('SSID: ${inputData.ssid}\n'),
                          Text('Password: ${inputData.password}')
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HubConnectionSuccessPage(),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );*/
                },
                height: 60,
                radius: 30,
                text: "Connect",
                color: Colors.green,
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                onPressed: () {
                  myHubManager.quitHubWifiSetting();

                  Navigator.pop(context);
                },
                height: 60,
                radius: 30,
                text: "Previous",
                color: Colors.lightGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _connectHub() async {
    HubManager myHubManager = Provider.of<HubManager>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      Messenger.showLoading(context);

      final result = await myHubManager.connectHub(
        _ssidController.text,
        _passwordController.text,
      );
      myHubManager.inputData.ssid = _ssidController.text;
      myHubManager.inputData.password = _passwordController.text;

      Messenger.closeLoading(context);
      navigateToHubConnectionSuccessPage(context);

      if (!result.isSuccessful()) {
        Messenger.showErrorWithCode(context, result.errorCode!);
      }
    }
  }

  Future<void> navigateToHubConnectionSuccessPage(BuildContext context) async {
    await Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HubConnectionSuccessPage()),
      );
    });
  }
}
