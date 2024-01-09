import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class TimeKeepting extends StatefulWidget {
  final String maNV;
  const TimeKeepting({super.key, required this.maNV});

  @override
  State<TimeKeepting> createState() => _TimeKeeptingState();
}

class _TimeKeeptingState extends State<TimeKeepting> {
  WifiInfoWrapper? _wifiObject;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
    } on PlatformException {}
    if (!mounted) return;

    setState(() {
      _wifiObject = wifiObject;
    });
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String ipAddress =
        _wifiObject != null ? _wifiObject!.ipAddress.toString() : "...";

    return Scaffold(
      body: Center(
        child: ipAddress == "192.168.102.181"
            ? ElevatedButton(onPressed: () {}, child: const Text('Chấm công'))
            : const Text('Không được phép chấm công'),
      ),
    );
  }
}
