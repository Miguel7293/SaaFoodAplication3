import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/carta.dart';
import 'package:flutter_application_example/data/models/plate.dart';

class CartaProvider extends ChangeNotifier {
  List<Carta> _cartas = [];
  Map<int, List<Plate>> _platesByCarta = {};

  List<Carta> get cartas => _cartas;
  Map<int, List<Plate>> get platesByCarta => _platesByCarta;

  void setCartas(List<Carta> cartas) {
    _cartas = cartas;
    notifyListeners();
  }

  void setPlatesByCarta(Map<int, List<Plate>> platesByCarta) {
    _platesByCarta = platesByCarta;
    notifyListeners();
  }

  void addPlateToCarta(int cartaId, Plate plate) {
    if (_platesByCarta.containsKey(cartaId)) {
      _platesByCarta[cartaId]!.add(plate);
    } else {
      _platesByCarta[cartaId] = [plate];
    }
    notifyListeners();
  }
  void updatePlateInCarta(Plate plate) {
    for (final entry in _platesByCarta.entries) {
      final plates = entry.value;
      final plateIndex = plates.indexWhere((p) => p.plateId == plate.plateId);
      if (plateIndex != -1) {
        // Actualizar el plato en la lista
        plates[plateIndex] = plate;
        notifyListeners(); // Notificar a los listeners
        break;
      }
    }
  }
    void deletePlateFromCarta(int plateId) {
    for (final entry in _platesByCarta.entries) {
      final plates = entry.value;
      plates.removeWhere((plate) => plate.plateId == plateId);
      notifyListeners();
    }
  }

}