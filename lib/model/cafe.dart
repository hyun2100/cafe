// lib/model/cafe.dart
import 'dart:typed_data';

class Cafe {
  int? id;
  String name;
  String location;
  String phone;
  String rating;
  Uint8List? imageData;
  double latitude;
  double longitude;

  Cafe({
    this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.rating,
    this.imageData,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      'rating': rating,
      'image_data': imageData,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static Cafe fromMap(Map<String, dynamic> map) {
    return Cafe(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      phone: map['phone'],
      rating: map['rating'],
      imageData: map['image_data'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
