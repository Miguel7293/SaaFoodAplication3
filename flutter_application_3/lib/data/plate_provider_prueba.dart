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
}

class PlateProvider {
  static final List<Plate> plates = [
    Plate(
      plateId: 1,
      name: "Ceviche",
      description: "Plato a base de pescado crudo marinado en jugo de limón con ají y cebolla.",
      price: 25.50,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-006_0.jpg",
      cartId: 1,
      category: "Mariscos",
    ),
    Plate(
      plateId: 2,
      name: "Lomo Saltado",
      description: "Salteado de lomo de res con cebolla, tomate y papas fritas, acompañado de arroz.",
      price: 28.75,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-004_0.jpg",
      cartId: 2,
      category: "Carne",
    ),
    Plate(
      plateId: 3,
      name: "Ají de Gallina",
      description: "Guiso cremoso de gallina deshilachada con ají amarillo y especias.",
      price: 22.00,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-005_0.jpg",
      cartId: 3,
      category: "Pollo",
    ),
    Plate(
      plateId: 4,
      name: "Causa Limeña",
      description: "Pastel frío de papa amarilla relleno con pollo, atún o mariscos.",
      price: 15.50,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-008.jpg",
      cartId: 4,
      category: "Entrada",
    ),
    Plate(
      plateId: 5,
      name: "Pachamanca",
      description: "Cocción de carnes y tubérculos en piedras calientes bajo tierra.",
      price: 35.00,
      available: false,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-010.jpg",
      cartId: 5,
      category: "Tradicional",
    ),
    Plate(
      plateId: 6,
      name: "Arroz con Pollo",
      description: "Plato de arroz cocido con culantro, acompañado con pollo y salsa criolla.",
      price: 18.50,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-001.jpg",
      cartId: 6,
      category: "Arroz",
    ),
    Plate(
      plateId: 7,
      name: "Tallarines a la Huancaína",
      description: "Tallarines servidos con salsa huancaína a base de ají amarillo y queso fresco.",
      price: 20.00,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-009.jpg",
      cartId: 7,
      category: "Pasta",
    ),
    Plate(
      plateId: 8,
      name: "Aguadito de Pollo",
      description: "Sopa espesa de pollo con arroz y culantro, ideal para el invierno.",
      price: 14.00,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-007.jpg",
      cartId: 8,
      category: "Sopa",
    ),
    Plate(
      plateId: 9,
      name: "Tacu Tacu",
      description: "Mezcla de arroz y menestras sofrita en sartén, usualmente acompañado de carne.",
      price: 18.00,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-002.jpg",
      cartId: 9,
      category: "Criollo",
    ),
    Plate(
      plateId: 10,
      name: "Pollo a la Brasa",
      description: "Pollo asado al carbón con papas fritas y ensalada.",
      price: 24.00,
      available: true,
      image: "https://www.lima2019.pe/sites/default/files/inline-images/preview-gallery-003.jpg",
      cartId: 10,
      category: "Parrilla",
    ),
  ];
}
