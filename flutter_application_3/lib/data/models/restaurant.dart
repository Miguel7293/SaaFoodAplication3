import 'package:latlong2/latlong.dart';

class Restaurant {
  final int restaurantId;
  final String name;
  final String location;
  final String? imageOfLocal;
  final String contactNumber;
  final String horario;
  final String? category;
  final String? description;
  final String? state;
  final String idDueno;
  final DateTime createdAt;
  final LatLng? coordinates; //

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.location,
    this.imageOfLocal,
    required this.contactNumber,
    required this.horario,
    this.category,
    this.description,
    this.state,
    required this.idDueno,
    required this.createdAt,
    this.coordinates, // 📍 Agregado
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurant_id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      location: json['location'] as String? ?? 'Ubicación desconocida',
      imageOfLocal: json['image_of_local'] as String?,
      contactNumber: json['contact_number'] as String? ?? 'Sin contacto',
      horario: json['horario'] as String? ?? 'Horario no disponible',
      category: json['category'] as String?,
      description: json['description'] as String?,
      state: json['state'] as String?,
      idDueno: json['id_dueno'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      coordinates:
          _parseCoordinates(json['coordinates']), // 📍 Parseo de geometry
    );
  }

  /// 📌 Función para convertir `geometry(Point, 4326)` a `LatLng`
  static LatLng? _parseCoordinates(dynamic geometry) {
    if (geometry == null) return null;

    if (geometry is String) {
      // 📌 Caso 1: Formato "POINT(-70.0219 -15.8402)"
      final match =
          RegExp(r'POINT\(([-\d.]+) ([-\d.]+)\)').firstMatch(geometry);
      if (match != null) {
        double lng = double.parse(match.group(1)!);
        double lat = double.parse(match.group(2)!);
        return LatLng(lat, lng);
      }
    } else if (geometry is Map<String, dynamic> &&
        geometry["type"] == "Point") {
      // 📌 Caso 2: Formato JSON {"type": "Point", "coordinates": [-70.0219, -15.8402]}
      final List<dynamic>? coords = geometry["coordinates"];
      if (coords != null && coords.length == 2) {
        double lng = coords[0] as double;
        double lat = coords[1] as double;
        return LatLng(lat, lng);
      }
    }

    return null; // Si no coincide con ninguno, retorna `null`
  }
}
