import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import '../model/cafe.dart';
import '../vm/cafe_controller.dart';

class EditCafePage extends StatelessWidget {
  final Cafe cafe;
  final CafeController cafeController = Get.find<CafeController>();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ratingController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  final _imageData = Rx<Uint8List?>(null);

  EditCafePage({super.key, required this.cafe}) {
    _nameController = TextEditingController(text: cafe.name);
    _locationController = TextEditingController(text: cafe.location);
    _phoneController = TextEditingController(text: cafe.phone);
    _ratingController = TextEditingController(text: cafe.rating);
    _latitudeController = TextEditingController(text: cafe.latitude.toString());
    _longitudeController =
        TextEditingController(text: cafe.longitude.toString());
    _imageData.value = cafe.imageData;
  }

  Future<void> _getImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imageBytes = await File(pickedFile.path).readAsBytes();
        _imageData.value = imageBytes;
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('오류', '이미지를 선택하는 중 문제가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cafe 수정')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(() => GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _imageData.value == null
                            ? const Icon(Icons.add_a_photo, size: 50)
                            : Image.memory(_imageData.value!,
                                fit: BoxFit.cover),
                      ),
                    )),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '이름'),
                  validator: (value) => value!.isEmpty ? '이름을 입력하세요' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: '주소'),
                  validator: (value) => value!.isEmpty ? '위치를 입력하세요' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: '전화번호'),
                  validator: (value) => value!.isEmpty ? '전화번호를 입력하세요' : null,
                ),
                TextFormField(
                  controller: _ratingController,
                  decoration: const InputDecoration(labelText: '평가'),
                  validator: (value) => value!.isEmpty ? '평가를 입력하세요' : null,
                ),
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(labelText: '위도'),
                  validator: (value) => value!.isEmpty ? '위도를 입력하세요' : null,
                ),
                TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(labelText: '경도'),
                  validator: (value) => value!.isEmpty ? '경도를 입력하세요' : null,
                ),
                ElevatedButton(
                  child: const Text('수정'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedCafe = Cafe(
                        id: cafe.id,
                        name: _nameController.text.trim(),
                        location: _locationController.text.trim(),
                        phone: _phoneController.text.trim(),
                        rating: _ratingController.text.trim(),
                        imageData: _imageData.value,
                        latitude: double.parse(_latitudeController.text.trim()),
                        longitude:
                            double.parse(_longitudeController.text.trim()),
                      );
                      cafeController.updateCafe(updatedCafe);
                      Get.back();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
