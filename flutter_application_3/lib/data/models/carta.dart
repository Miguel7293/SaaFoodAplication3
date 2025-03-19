class Carta {
  final int cartaId;
  final String type;
  final String description;
  final int restCart;
  final DateTime updatedAt;

  Carta({
    required this.cartaId,
    required this.type,
    required this.description,
    required this.restCart,
    required this.updatedAt,
  });

  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      cartaId: json['carta_id'] as int? ?? 0,
      type: json['type'] as String? ?? 'Sin tipo',
      description: json['description'] as String? ?? 'Sin descripción',
      restCart: json['rest_cart'] as int? ?? 0,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
