import 'package:flutter/material.dart';

import 'profesional.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  // Variable para saber qué tarjeta está seleccionada (0 = ninguna, 1 = la primera, 2 = la segunda)
  int selectedLocation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        // Quitamos la flecha de volver por defecto porque la pondremos abajo
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: const Icon(
              Icons.cut,
              color: Colors.amber,
              size: 16,
            ), // Simulando el logo dorado
          ),
        ),
        title: const Text(
          'Beard Style Barbershop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // --- CABECERA DE TEXTOS ---
          const Text(
            'DIRECCIÓN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecciona la dirección',
            style: TextStyle(
              fontSize: 14,
              color: Color(
                0xFF4A8E9F,
              ), // Ese tono azulado/verdoso de la captura
              fontWeight: FontWeight.w600,
            ),
          ),

          // Usamos Spacer para empujar las tarjetas hacia el centro
          const Spacer(),

          // --- TARJETAS DE DIRECCIÓN ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildLocationCard(
                    id: 1,
                    text: 'C/ Escultor\nToran 2 Pta 4',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildLocationCard(id: 2, text: 'Calle del Niu,\n40'),
                ),
              ],
            ),
          ),

          const Spacer(
            flex: 2,
          ), // Doble de espacio abajo para que quede como en la foto
        ],
      ),

      // --- BARRA INFERIOR DE NAVEGACIÓN (Pasos) ---
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
              // Botón Volver
              GestureDetector(
                onTap: () =>
                    Navigator.pop(context), // Vuelve a la pantalla anterior
                child: const Text(
                  'VOLVER',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Indicadores de progreso (Puntitos)
              Row(
                children: [
                  _buildDot(isActive: true),
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                ],
              ),

              // Botón Siguiente
              GestureDetector(
                onTap: selectedLocation != 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SelectProfessionalScreen(),
                          ),
                        );
                      }
                    : null, // Si no hay nada seleccionado, no hace nada (opcional)
                child: Text(
                  'SIGUIENTE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: selectedLocation != 0
                        ? Colors.black87
                        : Colors.grey, // Cambia de color si hay selección
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para las tarjetas
  Widget _buildLocationCard({required int id, required String text}) {
    bool isSelected = selectedLocation == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLocation = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
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
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para los puntitos
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
