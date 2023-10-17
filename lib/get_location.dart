import 'dart:convert';
import 'package:http/http.dart' as http;

class Location {
  const Location({
    required this.placeId,
    required this.licence,
    required this.poweredBy,
    required this.osmType,
    required this.osmId,
    required this.boundingbox,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.klass,
    required this.type,
    required this.importance,
  });
  final int placeId;
  final String licence;
  final String poweredBy;
  final String osmType;
  final int osmId;
  final List<String> boundingbox;
  final String lat;
  final String lon;
  final String displayName;
  final String klass;
  final String type;
  final double importance;

  factory Location.fromJson(Map<String, dynamic> data) {
    return Location(
      placeId: data["place_id"] as int,
      licence: data["licence"] as String,
      poweredBy: data["powered_by"] as String,
      osmType: data["osm_type"] as String,
      osmId: data["osm_id"] as int,
      boundingbox: List<String>.from(data["boundingbox"] as List),
      lat: data["lat"] as String,
      lon: data["lon"] as String,
      displayName: data["display_name"] as String,
      klass: data["class"] as String,
      type: data["type"] as String,
      importance: data["importance"] as double,
    );
  }
}

Future<(double lat, double lon)> searchCity(String city) async {
  final url = Uri.parse('https://geocode.maps.co/search?q="$city');
  final response = await http.get(url);
  List<Location> location = jsonDecode(response.body)
      .map((json) => Location.fromJson(json))
      .cast<Location>()
      .toList();
  return (double.parse(location[0].lat), double.parse(location[0].lon));
}
