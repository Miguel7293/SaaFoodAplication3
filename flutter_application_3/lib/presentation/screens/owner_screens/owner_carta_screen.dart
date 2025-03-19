import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/carta_repository.dart';
import '../../../data/models/carta.dart';
import '../../providers/auth_provider.dart';

class OwnerCartaScreen extends StatefulWidget {
  const OwnerCartaScreen({super.key});

  @override
  State<OwnerCartaScreen> createState() => _OwnerCartaScreenState();
}

class _OwnerCartaScreenState extends State<OwnerCartaScreen> {
  late final CartaRepository _cartaRepo;
  List<Carta> _cartas = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cartaRepo = CartaRepository();
    _loadCartas();
  }

  Future<void> _loadCartas() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) throw Exception('Usuario no autenticado');

      const restaurantId = 18; // Reemplazar con lógica real
      final rawCartas = await _cartaRepo.getCartasByRestaurant(restaurantId);

      // Ya obtenemos una lista de Carta, no necesitamos mapear otra vez
      setState(() {
        _cartas = rawCartas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Cartas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : ListView.builder(
                  itemCount: _cartas.length,
                  itemBuilder: (context, index) {
                    final carta = _cartas[index];
                    return ListTile(
                      title: Text(carta.type),
                      subtitle: Text(carta.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _updateCarta(carta.cartaId),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _updateCarta(int cartaId) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId!;

      await _cartaRepo.updateCarta(
        cartaId: cartaId,
        newDescription: 'Nueva descripción',
        userId: userId,
      );

      await _loadCartas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }
}
