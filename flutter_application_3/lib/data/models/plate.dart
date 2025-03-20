class Plate {
  final int plateId;
  final String name;
  final String description;
  final double price;
  final bool available;
  final String image;
  final int cartId;
  final String category;

  const Plate({
    required this.plateId,
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
}
