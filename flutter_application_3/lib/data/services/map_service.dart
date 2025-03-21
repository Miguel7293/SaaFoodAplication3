import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; // Import correcto

class MapService {
  final String? _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

  /// Obtiene la ruta entre dos puntos usando Google Directions API.
  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "OK") {
        // Obtener la polyline codificada
        String encodedPolyline = data["routes"][0]["overview_polyline"]["points"];

        // Decodificar polyline usando PolylinePoints
        List<PointLatLng> decodedPolyline =
            PolylinePoints().decodePolyline(encodedPolyline);

        // Convertir a List<LatLng>
        List<LatLng> polylineCoordinates = decodedPolyline
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        return polylineCoordinates;
      } else {
        throw Exception("Error en Directions API: ${data["status"]}");
      }
    } else {
      throw Exception("Error en la solicitud HTTP: ${response.statusCode}");
    }
  }
}
