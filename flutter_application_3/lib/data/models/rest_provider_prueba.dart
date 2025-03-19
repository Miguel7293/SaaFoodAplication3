import 'package:flutter_application_example/data/models/cart_provider_prueba.dart';
import 'package:intl/intl.dart';

class Restaurant {
  final int restaurantId;
  final String name;
  final String location;
  final String imageOfLocal;
  final String contactNumber;
  final String horario;
  final String category;
  final String description;
  final String state;
  final int idDueno;
  final String createdAt;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.location,
    required this.imageOfLocal,
    required this.contactNumber,
    required this.horario,
    required this.category,
    required this.description,
    required this.state,
    required this.idDueno,
  }) : createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}


class RestaurantProvider {
  static List<Restaurant> restaurants = [
    Restaurant(
      restaurantId: 1,
      name: "Mayta Restaurant",
      location: "Av. Pardo y Aliaga, Lima, Perú",
      imageOfLocal: "https://elcomercio.pe/resizer/mrauq-1m2NOGbEMiCAlQGF42IT0=/1200x900/smart/filters:format(jpeg):quality(75)/cloudfront-us-east-1.images.arcpublishing.com/elcomercio/LIME7AFJ7BGSDINO4PPO4T4QGQ.jpg",
      contactNumber: "+51 123 456 789",
      horario: "08:00 - 22:00",
      category: "Italiana",
      description: "Un restaurante italiano con una gran variedad de pastas y pizzas.",
      state: "Abierto",
      idDueno: 1,
    ),
    Restaurant(
      restaurantId: 2,
      name: "Mantela Restaurant",
      location: "Jirón de la Unión, Lima, Perú",
      imageOfLocal: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/29/28/66/bienvenido-a-mantela.jpg",
      contactNumber: "+51 987 654 321",
      horario: "10:00 - 20:00",
      category: "Mexicana",
      description: "Disfruta de los mejores tacos, burritos y guacamole en un ambiente vibrante.",
      state: "Abierto",
      idDueno: 2,
    ),
    Restaurant(
      restaurantId: 3,
      name: "Sessions Restaurant",
      location: "Av. Pueyrredón, Buenos Aires, Argentina",
      imageOfLocal: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/e2/dc/48/sessions-restaurant-acceso.jpg",
      contactNumber: "+54 11 2345 6789",
      horario: "10:00 - 20:00",
      category: "Francesa",
      description: "Comida francesa gourmet con platos tradicionales y modernos.",
      state: "Abierto",
      idDueno: 3,
    ),
    Restaurant(
      restaurantId: 4,
      name: "Panela Ajonjolí Restaurant",
      location: "Calle Las Palmas, Bogotá, Colombia",
      imageOfLocal: "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2d/da/f1/f0/panela-ajonjoli.jpg",
      contactNumber: "+57 1 987 654 321",
      horario: "10:00 - 20:00",
      category: "Marisquería",
      description: "Ofrecemos lo mejor del mar con mariscos frescos y platos de la costa.",
      state: "Cerrado",
      idDueno: 4,
    ),
  ];
}



