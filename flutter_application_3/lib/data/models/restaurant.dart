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
    );
  }
}
