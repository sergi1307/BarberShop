import 'package:flutter/material.dart';
import 'fecha.dart'; // Asegúrate de que el import sea correcto

class SelectServicesScreen extends StatefulWidget {
  // 1. Recibimos los datos de la pantalla de profesionales
  final String location;
  final String professional;

  const SelectServicesScreen({
    super.key,
    required this.location,
    required this.professional,
  });

  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  Set<int> selectedServices = {};

  // Datos de ejemplo
  final List<Map<String, dynamic>> hairServices = [
    {'id': 1, 'name': 'Corte de pelo', 'time': '20 min', 'price': '12.00€', 'image': 'https://images.unsplash.com/photo-1599351431202-1e0f0137899a?w=500'},
    {'id': 2, 'name': 'Rapado', 'time': '10 min', 'price': '5.00€', 'image': 'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=500'},
    {'id': 3, 'name': 'Corte fade', 'time': '30 min', 'price': '19.00€', 'image': 'https://images.unsplash.com/photo-1634629377278-f99a5ce3a12a?w=500'},
  ];

  final List<Map<String, dynamic>> beardServices = [
    {'id': 4, 'name': 'Arreglo barba', 'time': '15 min', 'price': '8.00€', 'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=500'},
  ];

  void _toggleService(int id) {
    setState(() {
      if (selectedServices.contains(id)) {
        selectedServices.remove(id);
      } else {
        selectedServices.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Beard Style Barbershop', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('SERVICIOS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
            const SizedBox(height: 20),
            const Text('PELO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildGrid(hairServices),
            const SizedBox(height: 30),
            const Text('BARBA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildGrid(beardServices),
            const SizedBox(height: 100), // Espacio para el botón flotante
          ],
        ),
      ),
      
      // AQUÍ VA EL CÓDIGO POR EL QUE PREGUNTAS:
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedServices.isNotEmpty
          ? SizedBox(
              width: 200,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Lógica para juntar nombres de servicios
                  List<String> nombres = [];
                  if (selectedServices.contains(1)) nombres.add("Corte de pelo");
                  if (selectedServices.contains(2)) nombres.add("Rapado");
                  if (selectedServices.contains(3)) nombres.add("Corte fade");
                  if (selectedServices.contains(4)) nombres.add("Arreglo barba");

                  String serviciosFinales = nombres.join(" + ");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectDateScreen(
                        location: widget.location,
                        professional: widget.professional,
                        services: serviciosFinales,
                      ),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF2D2D2D),
                label: const Text('SIGUIENTE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          : null,

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Widgets auxiliares para mantener el código limpio
  Widget _buildGrid(List<Map<String, dynamic>> services) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
      itemCount: services.length,
      itemBuilder: (context, index) => _buildServiceCard(services[index]),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    bool isSelected = selectedServices.contains(service['id']);
    return GestureDetector(
      onTap: () => _toggleService(service['id']),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          children: [
            Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), child: Image.network(service['image'], fit: BoxFit.cover, width: double.infinity))),
            Padding(padding: const EdgeInsets.all(8.0), child: Text(service['name'], style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('VOLVER', style: TextStyle(color: Colors.black))),
            const Text('SIGUIENTE', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}