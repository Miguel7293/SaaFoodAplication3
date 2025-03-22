class Rate {
  final int? rateId; // ✅ Ahora es opcional
  final int points;
  final String? description;
  final String userRestaurantId; // UUID del usuario
  final int restaurantId;
  final DateTime createdAt;

  Rate({
    this.rateId, // 👈 Ya no es requerido
    required this.points,
    this.description,
    required this.userRestaurantId,
    required this.restaurantId,
    required this.createdAt,
  });

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      rateId: json['rate_id'] as int?, // 👈 Puede ser nulo
      points: json['points'] as int,
      description: json['description'] as String?,
      userRestaurantId: json['user_restaurant'] as String, // 🛠️ Corregido el nombre de la clave
      restaurantId: json['restaurant_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate_id': rateId, // ✅ Puede ser null al insertar
      'points': points,
      'description': description,
      'user_restaurant': userRestaurantId, // 🛠️ Corregido el nombre de la clave
      'restaurant_id': restaurantId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Método copyWith para actualizar campos
  Rate copyWith({
    int? rateId, // 👈 Ahora permite actualizar rateId después de la creación
    int? points,
    String? description,
    DateTime? createdAt,
  }) {
    return Rate(
      rateId: rateId ?? this.rateId, // ✅ Permite asignar un nuevo ID después de la inserción
      points: points ?? this.points,
      description: description ?? this.description,
      userRestaurantId: userRestaurantId,
      restaurantId: restaurantId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
