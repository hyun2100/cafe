import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:must_eat_place_app/view/addcafe.dart';
import 'package:must_eat_place_app/view/editcafe.dart';
import '../vm/cafe_controller.dart';

import 'dart:typed_data';
import 'cafe_detail.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final CafeController cafeController = Get.put(CafeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 224, 168),
        title: const Text('내가 경험한 CAFE 리스트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => AddCafePage()),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: cafeController.cafes.length,
          itemBuilder: (context, index) {
            final cafe = cafeController.cafes[index];
            return CafeListItem(cafe: cafe, cafeController: cafeController);
          },
        ),
      ),
    );
  }
}

class CafeListItem extends StatelessWidget {
  final dynamic cafe;
  final CafeController cafeController;

  const CafeListItem({
    super.key,
    required this.cafe,
    required this.cafeController,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(cafe.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Get.to(() => EditCafePage(cafe: cafe));
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '수정',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              if (cafe.id != null) {
                cafeController.deleteCafe(cafe.id!);
              } else {
                print('Cafe ID is null');
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '삭제',
          ),
        ],
      ),
      child: Card(
        color: const Color.fromARGB(255, 240, 246, 209),
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: ListTile(
          leading: _buildCafeImage(cafe.imageData),
          title: Text(cafe.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cafe.phone),
              Text(
                cafe.location,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          onTap: () {
            Get.to(() => MapPage(cafe: cafe));
          },
        ),
      ),
    );
  }

  Widget _buildCafeImage(Uint8List? imageData) {
    if (imageData == null || imageData.isEmpty) {
      return const Icon(Icons.image_not_supported);
    }
    return Image.memory(
      imageData,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // ignore: avoid_print
        print('Image error: $error');
        return const Icon(Icons.error);
      },
    );
  }
}
