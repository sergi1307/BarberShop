import 'package:flutter/material.dart';

import 'fecha.dart';

class SelectServicesScreen extends StatefulWidget {
  const SelectServicesScreen({super.key});

  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  // Usamos un 'Set' porque el usuario puede elegir VARIOS servicios a la vez
  Set<int> selectedServices = {};

  // Datos de los servicios de Pelo
  final List<Map<String, dynamic>> hairServices = [
    {
      'id': 1,
      'name': 'Corte de pelo',
      'time': '20 min',
      'price': '12.00€',
      'image': 'https://images.unsplash.com/photo-1599351431202-1e0f0137899a?auto=format&fit=crop&w=500&q=80'
    },
    {
      'id': 2,
      'name': 'Rapado',
      'time': '10 min',
      'price': '5.00€',
      'image': 'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?auto=format&fit=crop&w=500&q=80'
    },
    {
      'id': 3,
      'name': 'Corte fade',
      'time': '30 min',
      'price': '19.00€',
      'image': 'https://images.unsplash.com/photo-1634629377278-f99a5ce3a12a?auto=format&fit=crop&w=500&q=80'
    },
  ];

  // Datos de los servicios de Barba
  final List<Map<String, dynamic>> beardServices = [
    {
      'id': 4,
      'name': 'Arreglo barba',
      'time': '15 min',
      'price': '8.00€',
      'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=500&q=80'
    },
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
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: const Icon(Icons.cut, color: Colors.amber, size: 16),
          ),
        ),
        title: const Text(
          'Beard Style Barbershop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // --- CABECERA DE TEXTOS ---
          const Text(
            'SERVICIOS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333), letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          const Text(
            'Selecciona los servicios',
            style: TextStyle(fontSize: 14, color: Color(0xFF4A8E9F), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // --- LISTA SCROLLEABLE DE SERVICIOS ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PELO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(), 
                    shrinkWrap: true, 
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85, 
                    ),
                    itemCount: hairServices.length,
                    itemBuilder: (context, index) {
                      return _buildServiceCard(hairServices[index]);
                    },
                  ),
                  
                  const SizedBox(height: 32),

                  const Text('BARBA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black87)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: beardServices.length,
                    itemBuilder: (context, index) {
                      return _buildServiceCard(beardServices[index]);
                    },
                  ),
                  const SizedBox(height: 100), // Más espacio aquí para que el botón flotante no tape contenido
                ],
              ),
            ),
          ),
        ],
      ),

      // --- EL NUEVO BOTÓN FLOTANTE ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedServices.isNotEmpty 
          ? SizedBox(
              width: 200,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  // --- NAVEGACIÓN AL CALENDARIO ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectDateScreen()),
                  );
                },
                backgroundColor: const Color(0xFF2D2D2D), // El tono gris oscuro de la foto
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                label: const Text(
                  'SIGUIENTE',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            )
          : null, // Si está vacío, devuelve null (no renderiza nada)
      
      // --- BARRA INFERIOR DE NAVEGACIÓN ---
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context), 
                child: const Text('VOLVER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              ),
              
              Row(
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: true), // Paso 3
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                ],
              ),
              
              // Mantenemos el texto Siguiente de abajo activo igual que en la captura
              GestureDetector(
                onTap: selectedServices.isNotEmpty ? () {
                  print("Siguiente paso con servicios: $selectedServices");
                } : null,
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14, 
                    color: selectedServices.isNotEmpty ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    bool isSelected = selectedServices.contains(service['id']);
    
    return GestureDetector(
      onTap: () => _toggleService(service['id']),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                service['image'],
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(height: 90, color: Colors.grey[200]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(service['time'], style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(
                        service['price'],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF4A8E9F), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6, width: 6,
      decoration: BoxDecoration(color: isActive ? Colors.black : Colors.grey[300], shape: BoxShape.circle),
    );
  }
}