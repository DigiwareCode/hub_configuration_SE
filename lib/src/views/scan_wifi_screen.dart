import 'package:flutter/material.dart';
import 'package:hub_config/src/views/popup.dart';
import 'package:hub_config/src/views/rounded_button.dart';
import 'package:hub_config/src/views/skeleton.dart';
import 'package:provider/provider.dart';

import '../provider_manager/hub_manager.dart';
import 'hub_wifi_set_screen.dart';
import 'messenger.dart';

class ScanWifiScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
      name: routeName,
      key: ValueKey(routeName),
      child: ScanWifiScreen(),
    );
  }

  static const String routeName = '/scanWifi';

  const ScanWifiScreen({Key? key}) : super(key: key);

  @override
  State<ScanWifiScreen> createState() => _ScanWifiScreenState();
}

class _ScanWifiScreenState extends State<ScanWifiScreen> {
  List<String> _wifiNetworks = [];

  Future<void> _scanWifi() async {
    Messenger.showLoading(context);

    final result = await Provider.of<HubManager>(context, listen: false)
        .scanAvailableNetworks();

    Messenger.closeLoading(context);

    if (result.isSuccessful()) {
      _wifiNetworks = result.data!;
      setState(() {});
    } else {
      _showMessage();
    }
  }

  Future _showMessage() {
    return showDialog(
        context: context,
        builder: (_) {
          return Popup(
            type: PopupType.fail,
            message: "Fail to scan WiFi Networks !",
            actions: RoundedButton(
              color: Colors.green,
              text: "Setup WiFi manually",
              onPressed: () {
                _openPasswordEntry('');
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Skeleton(
        title: "Connect Hub to Wifi",
        maxTitleWidth: size.width * 0.7,
        subtitle: "Choose Network Sub",
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WiFi',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_wifiNetworks.length}'
                    ' networks available',
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          const Divider(),
          _wifiNetworks.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: Center(
                      child: Image.asset(
                    "nowifi.png",
                    width: size.width * 0.8,
                    height: size.height * 0.3,
                  )),
                )
              : Expanded(
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      itemCount: _wifiNetworks.length,
                      itemBuilder: (_, index) => Card(
                            child: ListTile(
                              title: Text(
                                _wifiNetworks[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: const Icon(
                                Icons.wifi_lock_outlined,
                                color: Colors.green,
                              ),
                              trailing: const Icon(Icons.navigate_next),
                              onTap: () =>
                                  _openPasswordEntry(_wifiNetworks[index]),
                            ),
                          )),
                ),
          const Divider(),
          Column(
            children: [
              RoundedButton(
                onPressed: _scanWifi,
                height: 60,
                radius: 30,
                text: "Scan Wifi",
                color: Colors.lightGreen,
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                onPressed: () {
                  Provider.of<HubManager>(context, listen: false)
                      .quitScanWifi();
                  Navigator.pop(context);
                },
                height: 60,
                radius: 30,
                text: "Cancel",
                color: Colors.lightGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openPasswordEntry(String ssid) {
    Provider.of<HubManager>(context, listen: false).enterWifiPassword(ssid);
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => HubWifiSetScreen()));
  }
}
