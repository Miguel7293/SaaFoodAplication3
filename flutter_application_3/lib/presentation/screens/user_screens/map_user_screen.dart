import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapUserScreen extends StatefulWidget {
  const MapUserScreen({super.key});

  @override
  State<MapUserScreen> createState() => _MapUserScreenState();
  
}

class _MapUserScreenState extends State<MapUserScreen> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _selectedRestaurant;

  final String? _apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  
  final LatLng _initialPosition = const LatLng(-15.8402, -70.0219); // Puno

  // 📍 Restaurantes en Puno
  final List<Map<String, dynamic>> _restaurants = [
    {
      "id": 1,
      "name": "Restaurante Puno Centro",
      "category": "Peruana",
      "location": const LatLng(-15.8402, -70.0219),
    },
    {
      "id": 2,
      "name": "Mirador del Titicaca",
      "category": "Internacional",
      "location": const LatLng(-15.8331, -70.0295),
    },
    {
      "id": 3,
      "name": "Sabores Andinos",
      "category": "Andina",
      "location": const LatLng(-15.8461, -70.0198),
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // 🛰️ Obtener ubicación del usuario
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    _loadMarkers();
  }

  // 📍 Cargar marcadores de restaurantes
  void _loadMarkers() {
    Set<Marker> markers = _restaurants.map((restaurant) {
      return Marker(
        markerId: MarkerId(restaurant["id"].toString()),
        position: restaurant["location"],
        infoWindow: InfoWindow(
          title: restaurant["name"],
          snippet: restaurant["category"],
        ),
        onTap: () {
          setState(() {
            _selectedRestaurant = restaurant["location"];
          });
          print("📍 Marcador seleccionado: ${restaurant["name"]}");
        },
      );
    }).toSet();

    // 📌 Agregar marcador de ubicación actual
    if (_currentPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "Tu ubicación"),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  // 📍 Obtener ruta desde Google Directions API con logs
  Future<void> _drawRoute(LatLng restaurantLocation) async {
    if (_currentPosition == null) {
      print("⚠️ No se encontró la ubicación actual.");
      return;
    }

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${restaurantLocation.latitude},${restaurantLocation.longitude}&key=$_apiKey";

    print("🔍 Enviando solicitud a Google Directions API...");
    print("🌍 URL: $url");

    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("✅ Respuesta de API Directions recibida.");
      print("📄 JSON Response: ${jsonEncode(data)}");

      if (data["status"] == "OK") {
        List<LatLng> polylineCoordinates = [];
        var steps = data["routes"][0]["legs"][0]["steps"];

        for (var step in steps) {
          polylineCoordinates.add(LatLng(
              step["start_location"]["lat"], step["start_location"]["lng"]));
          polylineCoordinates.add(
              LatLng(step["end_location"]["lat"], step["end_location"]["lng"]));
        }

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("route"),
              color: Colors.blue,
              width: 5,
              points: polylineCoordinates,
            ),
          };
        });

        print("🚀 Ruta dibujada con ${polylineCoordinates.length} puntos.");

        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                _currentPosition!.latitude < restaurantLocation.latitude
                    ? _currentPosition!.latitude
                    : restaurantLocation.latitude,
                _currentPosition!.longitude < restaurantLocation.longitude
                    ? _currentPosition!.longitude
                    : restaurantLocation.longitude,
              ),
              northeast: LatLng(
                _currentPosition!.latitude > restaurantLocation.latitude
                    ? _currentPosition!.latitude
                    : restaurantLocation.latitude,
                _currentPosition!.longitude > restaurantLocation.longitude
                    ? _currentPosition!.longitude
                    : restaurantLocation.longitude,
              ),
            ),
            100, // Padding
          ),
        );
      } else {
        print("⚠️ Google Directions API devolvió un error: ${data["status"]}");
      }
    } else {
      print("❌ Error al llamar a la API: ${response.statusCode}");
      print("📄 Respuesta: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Restaurantes")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          if (_selectedRestaurant != null) // 📌 Mostrar botón si se selecciona un restaurante
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: ElevatedButton.icon(
                onPressed: () => _drawRoute(_selectedRestaurant!),
                icon: const Icon(Icons.directions),
                label: const Text("Ir al restaurante"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
