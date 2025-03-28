class Plate {
  final int? plateId; // Ahora es opcional, como en Rate
  final String name;
  final String description;
  final double price;
  final bool available;
  final String image;
  final int cartId;
  final String category;

  const Plate({
    this.plateId, // No es requerido al crear, se asigna automáticamente
    required this.name,
    required this.description,
    required this.price,
    required this.available,
    required this.image,
    required this.cartId,
    required this.category,
  });

  factory Plate.fromJson(Map<String, dynamic> json) {
    return Plate(
      plateId: json['plate_id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? 'Sin descripción',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      available: json['available'] as bool? ?? false,
      image: json['image'] as String? ?? 'https://via.placeholder.com/150',
      cartId: json['cart_id'] as int? ?? 0,
      category: json['category'] as String? ?? 'Sin categoría',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'available': available,
      'image': image,
      'cart_id': cartId,
      'category': category,
    };

    if (plateId != null && plateId != 0) {
      data['plate_id'] = plateId;
    }

    return data;
  }

  // Método copyWith para actualizar campos, siguiendo el patrón de Rate
  Plate copyWith({
    int? plateId,
    String? name,
    String? description,
    double? price,
    bool? available,
    String? image,
    int? cartId,
    String? category,
  }) {
    return Plate(
      plateId: plateId ?? this.plateId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      available: available ?? this.available,
      image: image ?? this.image,
      cartId: cartId ?? this.cartId,
      category: category ?? this.category,
    );
  }
}
