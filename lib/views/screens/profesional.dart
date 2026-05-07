import 'package:flutter/material.dart';

import 'servicios.dart';

class SelectProfessionalScreen extends StatefulWidget {
  const SelectProfessionalScreen({super.key});

  @override
  State<SelectProfessionalScreen> createState() => _SelectProfessionalScreenState();
}

class _SelectProfessionalScreenState extends State<SelectProfessionalScreen> {
  // Variable para saber qué profesional está seleccionado (0 = ninguno, 1 = Jesús, 2 = Ramón)
  int selectedProfessional = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        automaticallyImplyLeading: false, // Quitamos la flecha de volver por defecto
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
          const SizedBox(height: 30),
          // --- CABECERA DE TEXTOS ---
          const Text(
            'PROFESIONAL',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecciona la/el profesional',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4A8E9F), 
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const Spacer(),

          // --- TARJETAS DE PROFESIONALES ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildProfessionalCard(
                    id: 1,
                    name: 'Jesús Huertas\nMancebo',
                    imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=150&q=80', // Foto de prueba
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProfessionalCard(
                    id: 2,
                    name: 'Ramón\nDíaz',
                    imageUrl: 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?auto=format&fit=crop&w=150&q=80', // Foto de prueba
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(flex: 2),
        ],
      ),
      
      // --- BARRA INFERIOR DE NAVEGACIÓN ---
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
                child: const Text(
                  'VOLVER',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                ),
              ),
              
              // Indicadores de progreso (Paso 2 activo)
              Row(
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: true), 
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                ],
              ),
              
              GestureDetector(
                onTap: selectedProfessional != 0 ? () {
                  // --- AQUÍ ESTÁ LA MAGIA DE LA NAVEGACIÓN ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectServicesScreen()),
                  );
                } : null,
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14, 
                    color: selectedProfessional != 0 ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget modificado para tener Foto + Nombre
  Widget _buildProfessionalCard({required int id, required String name, required String imageUrl}) {
    bool isSelected = selectedProfessional == id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedProfessional = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 35, // Tamaño de la foto
              backgroundImage: NetworkImage(imageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Colors.black87,
                height: 1.2,
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
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}