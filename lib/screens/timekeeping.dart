import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/failed_snackbar.dart';
import 'package:flutter_application_1/components/succses_snackbar.dart';
import 'package:flutter_application_1/models/chamcong.model.dart';
import 'package:flutter_application_1/provider/chamcong.provider.dart';
import 'package:flutter_application_1/provider/nguoidung.provider.dart';
import 'package:provider/provider.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class TimeKeepting extends StatefulWidget {
  final String maNV;
  const TimeKeepting({super.key, required this.maNV});

  @override
  State<TimeKeepting> createState() => _TimeKeeptingState();
}

class _TimeKeeptingState extends State<TimeKeepting> {
  DateTime? time = DateTime.now();
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
    final chamCongProvider = Provider.of<ChamCongProvider>(context);
    final nguoiDungProvider = Provider.of<NguoiDungProvider>(context);

    String ipAddress =
        _wifiObject != null ? _wifiObject!.ipAddress.toString() : "...";

    return Scaffold(
      body: Center(
        child: ipAddress == "10.45.11.101"
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          final date = DateTime.now();
                          final chamCong = ChamCong(
                              maCC:
                                  'CV${date.day}-${date.month}-${date.year}-${nguoiDungProvider.nguoiDung!.maNV}',
                              maNV: nguoiDungProvider.nguoiDung!.maNV,
                              ngayCC: Timestamp.fromDate(DateTime(
                                  date.year, date.month, date.day, 8, 0, 0)),
                              timeVao: Timestamp.fromDate(date),
                              timeVaoTT: Timestamp.fromDate(date),
                              timeRa: Timestamp.fromDate(DateTime(
                                  date.year, date.month, date.day, 17, 0, 0)),
                              timeRaTT: null,
                              status: null);
                          await chamCongProvider.addChamCong(chamCong);
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildSuccessSnackbar(
                                  'Chấm công vào thành công!'));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildFailedSnackbar('Chấm công vào thất bại!'));
                        }
                      },
                      child: const Text('Chấm công vào')),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          final date = DateTime.now();
                          final chamCong = await chamCongProvider.getChamCong(
                              'CV${date.day}-${date.month}-${date.year}-${nguoiDungProvider.nguoiDung!.maNV}');
                          chamCong.timeRaTT = Timestamp.fromDate(date);
                          if (chamCong.timeRaTT!
                                  .toDate()
                                  .isAfter(chamCong.timeRa!.toDate()) &&
                              chamCong.timeVaoTT!
                                  .toDate()
                                  .isBefore(chamCong.timeVao!.toDate())) {
                            chamCong.status = 'Đúng giờ';
                          } else {
                            chamCong.status = 'Đi trễ';
                          }

                          await chamCongProvider.updChamCong(chamCong);
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildSuccessSnackbar('Chấm công ra thành công!'));
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildFailedSnackbar('Chấm công ra thất bại!'));
                        }
                      },
                      child: const Text('Chấm công ra')),
                ],
              )
            : const Text('Không được phép chấm công'),
      ),
    );
  }
}
