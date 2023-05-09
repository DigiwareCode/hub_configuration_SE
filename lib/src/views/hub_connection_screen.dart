import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:hub_config/src/views/scan_wifi_screen.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';

import '../business_logic/utils/api_utils.dart';
import '../provider_manager/hub_manager.dart';
import 'messenger.dart';
import 'rounded_button.dart';
import 'skeleton.dart';

class HubConnectionScreen extends StatefulWidget {
  static MaterialPage page() {
    return const MaterialPage(
        name: routeName,
        key: ValueKey(routeName),
        child: HubConnectionScreen());
  }

  static const String routeName = '/hubConnection';

  const HubConnectionScreen({Key? key}) : super(key: key);

  @override
  State<HubConnectionScreen> createState() => _HubConnectionScreenState();
}

class _HubConnectionScreenState extends State<HubConnectionScreen> {
  final wifiInfo = NetworkInfo();
  bool _waitingConnection = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Skeleton(
        title: "Connect to your hub",
        subtitle: "Open your wifi setting and connect to Access point",
        children: [
          Column(
            children: [
              RoundedButton(
                  color: Colors.green,
                  text: "Open device settings",
                  radius: 40,
                  height: 60,
                  onPressed: () async {
                    AppSettings.openWIFISettings();
                    if (!_waitingConnection) _waitConnectionToHub();
                  }),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                onPressed: () {
                  Provider.of<HubManager>(context, listen: false)
                      .quitHubConnection();
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

  void _waitConnectionToHub() async {
    setState(() {
      _waitingConnection = true;
    });
    Timer.periodic(const Duration(milliseconds: 10), (timer) async {
      final gatewayIP = (await wifiInfo.getWifiGatewayIP()) ?? '';
      if (gatewayIP == ApiUtils.hubIP) {
        timer.cancel();
        Provider.of<HubManager>(context, listen: false).hasConnectedToHub();
        Messenger.showSuccess(context, 'Successfully connected to Senergy Hub');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScanWifiScreen()));
      }
    });
  }
}
