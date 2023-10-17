import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'get_location.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Maps Example'),
        ),
        body: const MapWithButton(),
      ),
    );
  }
}

class MapWithButton extends StatefulWidget {
  const MapWithButton({super.key});

  @override
  _MapWithButtonState createState() => _MapWithButtonState();
}

class _MapWithButtonState extends State<MapWithButton> {
  GoogleMapController? _controller;

  double lat = 41.311081;
  double lon = 69.240562;

  Future<void> searchCity(String city) async {
    try {
      final url = Uri.parse('https://geocode.maps.co/search?q="${city.trim()}');
      final response = await http.get(url);
      List<Location> location = jsonDecode(response.body)
          .map((json) => Location.fromJson(json))
          .cast<Location>()
          .toList();
      lat = double.tryParse(location[0].lat) ?? 40.7770883;
      lon = double.tryParse(location[0].lon) ?? 68.3329752;
    } catch (e) {
      lat = 41.311081;
      lon = 69.240562;
      print('fiewjrhekdebhewfkadfqwh evc');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            setState(() {
              _controller = controller;
            });
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lon),
            zoom: 12,
          ),
          markers: {
            Marker(
              markerId: const MarkerId("Target"),
              position: LatLng(lat, lon),
              icon: BitmapDescriptor.defaultMarker,
            )
          },
        ),
        SearchBar(
          onSubmitted: (String value) {
            searchCity(value);
            _controller?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(lat, lon),
                  zoom: 12,
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 160,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  _controller?.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () {
                  _controller?.animateCamera(CameraUpdate.zoomOut());
                },
                child: Icon(Icons.remove),
                backgroundColor: Colors.red,
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () {
                  setState(() {});
                  _controller?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(lat, lon),
                        zoom: 12,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.search),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
