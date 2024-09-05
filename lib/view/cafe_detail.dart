// lib/view/map.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/cafe.dart';

class MapPage extends StatefulWidget {
  final Cafe cafe;

  const MapPage({
    super.key,
    required this.cafe,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 184, 224, 168),
        title: const Text("카페 세부정보"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카페 정보 카드
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cafe.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.phone, widget.cafe.phone),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, widget.cafe.location),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.star, widget.cafe.rating),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                      Icons.access_time, "오전 9:00 - 오후 10:00"), // 예시 영업시간
                ],
              ),
            ),

            // 카페 이미지
            if (widget.cafe.imageData != null)
              Image.memory(
                widget.cafe.imageData!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey,
                child: const Icon(Icons.image, size: 100, color: Colors.white),
              ),

            const SizedBox(height: 16), // 이미지와 지도 사이 간격

            // 구글 맵
            SizedBox(
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.cafe.latitude, widget.cafe.longitude),
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('cafe_location'),
                    position:
                        LatLng(widget.cafe.latitude, widget.cafe.longitude),
                    infoWindow: InfoWindow(title: widget.cafe.name),
                  ),
                },
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
