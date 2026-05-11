import 'package:flutter/material.dart';
import 'reservas.dart';
import 'dart:async';
import '../widgets/ad_banner.dart';

class SummaryScreen extends StatefulWidget {
  final String location;
  final String professional;
  final String services;
  final String date;
  final String time;

  const SummaryScreen({
    super.key,
    required this.location,
    required this.professional,
    required this.services,
    required this.date,
    required this.time,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Variable para controlar el desplegable (Dropdown)
  String selectedReminder = 'Sin recordatorio';
  int _currentAdIndex = 0;
  late Timer _bannerTimer;

  final List<Map<String, dynamic>> _ads = [
    {
      'id': '103',
      'name': 'Kits de barba al 30% Dto.',
      'desc': 'Todo lo que necesitas para el cuidado de tu barba con un descuento exclusivo.',
      'image': 'https://images.unsplash.com/photo-1593702295094-ada74bc1099a?w=500',
      'tag': 'OFFER',
    },
    {
      'id': '104',
      'name': 'Premium Aftershave',
      'desc': 'Frescura instantánea después de cada afeitado. Calidad profesional.',
      'image': 'https://images.unsplash.com/photo-1621607512214-68297480165e?w=600',
      'tag': 'SKINCARE',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentAdIndex = (_currentAdIndex + 1) % _ads.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- CABECERA ---
            const Text('RESUMEN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333), letterSpacing: 1)),
            const SizedBox(height: 4),
            const Text('Estos son los datos de la reserva', style: TextStyle(fontSize: 14, color: Color(0xFF4A8E9F), fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),

            // --- TARJETA DE RESUMEN (Igual a la imagen) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDataBlock('PROFESIONAL', widget.professional),
                    const SizedBox(height: 20),
                    
                    _buildDataBlock('SERVICIOS', widget.services.isNotEmpty ? widget.services : 'Servicios de prueba'),
                    const SizedBox(height: 20),
                    
                    // Mostramos la fecha y hora combinadas
                    _buildDataBlock('HORA', '${widget.date} ${widget.time}'),
                    const SizedBox(height: 20),

                    // --- DESPLEGABLE RECORDATORIO ---
                    const Text('RECORDATORIO', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF4A4A4A))),
                    const SizedBox(height: 4),
                    DropdownButton<String>(
                      value: selectedReminder,
                      isExpanded: true,
                      underline: const SizedBox(), 
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A8E9F)),
                      style: const TextStyle(color: Color(0xFF4A8E9F), fontWeight: FontWeight.w600, fontSize: 14),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedReminder = newValue!;
                        });
                      },
                      items: <String>['Sin recordatorio', '1 hora antes', '1 día antes']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),

                    // --- BOTÓN CONFIRMAR (Dentro de la tarjeta) ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción de confirmar: Vuelve a la primera pantalla
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Reserva confirmada con éxito!'), backgroundColor: Colors.green));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const ReservationsScreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D2D2D), // Gris oscuro
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('CONFIRMAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // --- BANNER PUBLICITARIO (Debajo de la tarjeta) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: BannerAdWidget(
                  key: ValueKey(_currentAdIndex),
                  id: _ads[_currentAdIndex]['id'],
                  name: _ads[_currentAdIndex]['name'],
                  desc: _ads[_currentAdIndex]['desc'],
                  image: _ads[_currentAdIndex]['image'],
                  tag: _ads[_currentAdIndex]['tag'],
                  onTap: () {
                    // Action for confirmation ads
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // --- BARRA INFERIOR ---
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
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
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: true), // Ya estamos en el final
                ],
              ),
              const Text('CONFIRMAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para los bloques de texto de la tarjeta
  Widget _buildDataBlock(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF4A4A4A))),
        const SizedBox(height: 4),
        Text(data, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF4A8E9F))),
      ],
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 6, width: 6, decoration: BoxDecoration(color: isActive ? Colors.black : Colors.grey[300], shape: BoxShape.circle));
  }
}