class Carta {
  final int cartaId;
  final String type;
  final String description;
  final int restCart; // ID del restaurante
  final DateTime updatedAt;

  const Carta({
    required this.cartaId,
    required this.type,
    required this.description,
    required this.restCart,
    required this.updatedAt,
  });
}

class CartaProvider {
  static final List<Carta> cartas = [
    Carta(
      cartaId: 1,
      type: "Bebida",
      description: "Jugos naturales, gaseosas y cócteles.",
      restCart: 1,
      updatedAt: DateTime.now(),
    ),
    Carta(
      cartaId: 2,
      type: "Comida",
      description: "Platos criollos y marinos tradicionales.",
      restCart: 2,
      updatedAt: DateTime.now(),
    ),
    Carta(
      cartaId: 3,
      type: "Postres",
      description: "Tortas, helados y mazamorra morada.",
      restCart: 3,
      updatedAt: DateTime.now(),
    ),
    Carta(
      cartaId: 4,
      type: "Piqueos",
      description: "Papas fritas, alitas y tequeños.",
      restCart: 4,
      updatedAt: DateTime.now(),
    ),
    Carta(
      cartaId: 5,
      type: "Sopas",
      description: "Caldo de gallina y sopa criolla.",
      restCart: 4,
      updatedAt: DateTime.now(),
    ),
  ];
}


