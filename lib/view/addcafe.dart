import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../model/cafe.dart';
import '../vm/cafe_controller.dart';
import 'home.dart';

class AddCafePage extends StatelessWidget {
  AddCafePage({super.key});

  // 컨트롤러와 상태 변수들
  final CafeController cafeController = Get.find<CafeController>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ratingController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final Rx<Uint8List?> _imageData = Rx<Uint8List?>(null);

  // 상수 정의
  static const double _imageDimension = 200.0;
  static const double _paddingSize = 16.0;
  static const String _appBarTitle = '카페 추가';
  static const String _saveButtonText = '저장';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_appBarTitle)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(_paddingSize),
            child: Column(
              children: [
                _buildImagePicker(),
                const SizedBox(height: _paddingSize),
                _buildTextFormField(_nameController, '이름'),
                _buildTextFormField(_locationController, '주소'),
                _buildTextFormField(
                    _phoneController, '전화번호', TextInputType.phone),
                _buildTextFormField(
                    _ratingController, '평가', TextInputType.number),
                _buildTextFormField(_latitudeController, '위도',
                    const TextInputType.numberWithOptions(decimal: true)),
                _buildTextFormField(_longitudeController, '경도',
                    const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: _paddingSize),
                ElevatedButton(
                  child: const Text(_saveButtonText),
                  onPressed: _saveCafe,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() => GestureDetector(
          onTap: _getImage,
          child: Container(
            width: _imageDimension,
            height: _imageDimension,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
            ),
            child: _imageData.value == null
                ? const Icon(Icons.add_a_photo, size: 50)
                : Image.memory(_imageData.value!, fit: BoxFit.cover),
          ),
        ));
  }

  Widget _buildTextFormField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType ?? TextInputType.text,
      validator: (value) => value!.isEmpty ? '$label을(를) 입력하세요' : null,
    );
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
      Get.snackbar('오류', '이미지를 선택하는 중 문제가 발생했습니다.');
    }
  }

  Future<void> _saveCafe() async {
    if (_formKey.currentState!.validate()) {
      final cafe = Cafe(
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        rating: _ratingController.text.trim(),
        imageData: _imageData.value,
        latitude: double.parse(_latitudeController.text.trim()),
        longitude: double.parse(_longitudeController.text.trim()),
      );

      try {
        await cafeController.addCafe(cafe, _imageData());
        Get.snackbar(
          '성공',
          '카페 정보가 저장되었습니다.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
        await Future.delayed(const Duration(seconds: 2));
        await cafeController.loadCafes();
        Get.offAll(() => const Home());
      } catch (e) {
        Get.snackbar('오류', '데이터베이스 오류: $e');
      }
    }
  }
}
