import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWithPolygon extends StatefulWidget {
  const MapWithPolygon({super.key});

  @override
  State<MapWithPolygon> createState() => _MapWithPolygonState();
}

class _MapWithPolygonState extends State<MapWithPolygon> {
  GoogleMapController? _mapController;
  final Set<Polygon> _polygons = {
    Polygon(
      polygonId: const PolygonId('polygon_id'),
      points: const [
        LatLng(37.7749, -122.4194),
        LatLng(34.0522, -118.2437),
        LatLng(36.7783, -119.4179),
        LatLng(37.7749, -122.4194),
      ],
      strokeColor: Colors.blue,
      strokeWidth: 2,
      fillColor: Colors.blue.withOpacity(0.1),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps with Polygon'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 10,
        ),
        polygons: _polygons,
      ),
    );
  }
}
