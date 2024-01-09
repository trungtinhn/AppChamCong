import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/chamcong.model.dart';
import 'package:flutter_application_1/res/chamcong.responsitory.dart';

class ChamCongProvider extends ChangeNotifier {
  late ChamCongRepository chamCongRepository;

  ChamCongProvider() {
    chamCongRepository = ChamCongRepositoryImpl();
  }

  Future<void> addChamCong(ChamCong chamCong) async {
    await chamCongRepository.addChamCong(chamCong);
    notifyListeners();
  }

  Stream<List<ChamCong>> getChamCongByDate(DateTime specificDate) {
    return chamCongRepository.getChamCongByDate(specificDate);
  }

  Stream<List<ChamCong>> getChamCongByMaNVAndMonth(
      String maNV, DateTime specificDate) {
    return chamCongRepository.getChamCongByMaNVAndMonth(maNV, specificDate);
  }

  Future<ChamCong> getChamCong(String maCC) async {
    return await chamCongRepository.getChamCong(maCC);
  }

  Future<void> delChamCong(String maCC) async {
    await chamCongRepository.delChamCong(maCC);
    notifyListeners();
  }

  Future<void> updChamCong(ChamCong chamCong) async {
    await chamCongRepository.updChamCong(chamCong);
    notifyListeners();
  }
}
