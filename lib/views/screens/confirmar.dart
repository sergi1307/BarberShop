import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        // Aquí sí dejamos la flecha de volver por defecto para que el usuario pueda rectificar
        iconTheme: const IconThemeData(color: Colors.white), 
        title: const Text(
          'Beard Style Barbershop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView( // Usamos SingleChildScrollView por si la pantalla es pequeña
        child: Column(
          children: [
            const SizedBox(height: 30),
            // --- CABECERA ---
            const Text(
              'RESUMEN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333), letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            const Text(
              'Revisa los datos de tu reserva',
              style: TextStyle(fontSize: 14, color: Color(0xFF4A8E9F), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),

            // --- TARJETA DE RESUMEN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, spreadRadius: 2, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estos son datos simulados, en una app real vendrían de las variables que fuimos guardando
                    _buildSummaryRow(Icons.location_on_outlined, 'C/ Escultor Toran 2 Pta 4'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                    
                    _buildSummaryRow(Icons.person_outline, 'Jesús Huertas Mancebo'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                    
                    _buildSummaryRow(Icons.cut_outlined, 'Corte fade + Arreglo barba\nTotal: 27.00€'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                    
                    _buildSummaryRow(Icons.calendar_today_outlined, 'Jueves, 14 Mayo 2026\n18:30 h'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- BOTÓN CONFIRMAR ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para enviar al servidor y mostrar un "¡Reserva completada!"
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Reserva confirmada con éxito!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: const Text(
                    'CONFIRMAR RESERVA',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- BANNER PUBLICITARIO ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1593702295094-ada74bc1099a?w=500'), // Imagen de productos de barbería
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(0.65), // Overlay oscuro
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'AD',
                              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Kits de barba al 30% Dto.',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text('COMPRAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40), // Espacio extra al final para scroll cómodo
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para cada fila de información de la tarjeta
  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4A8E9F), size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}