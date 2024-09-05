import 'package:get/get.dart';

import 'dart:typed_data';
import '../model/cafe.dart';
import '../data/database_handler.dart';

class CafeController extends GetxController {
  final DatabaseHandler _db;
  var cafes = <Cafe>[].obs;

  CafeController() : _db = Get.put(DatabaseHandler());

  @override
  void onInit() {
    super.onInit();
    loadCafes();
  }

  Future<void> loadCafes() async {
    final loadedCafes = await _db.getCafes();
    cafes.assignAll(loadedCafes);
  }

  Future<void> updateCafe(Cafe cafe) async {
    await _db.updateCafe(cafe);
    await loadCafes();
  }

  Future<void> addCafe(Cafe cafe, Uint8List? imageData) async {
    try {
      if (imageData != null) {
        cafe.imageData = await _processImage(imageData);
      }

      final id = await _db.insertCafe(cafe);
      cafe.id = id;

      cafes.add(cafe);
      update();
    } catch (e) {
      print('Error adding cafe: $e');
      // 에러 처리 로직 추가 (예: 사용자에게 알림)
    }
  }

  Future<Uint8List> _processImage(Uint8List imageData) async {
    // 이미지 처리 로직
    // 예: 이미지 크기 조정, 압축 등
    return imageData; // 처리된 이미지 데이터 반환
  }

  Future<void> deleteCafe(int id) async {
    await _db.deleteCafe(id);
    await loadCafes();
  }
}
