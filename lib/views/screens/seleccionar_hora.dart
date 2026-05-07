import 'package:flutter/material.dart';
import 'confirmar.dart'; // Importamos la vista final del resumen

class SelectTimeScreen extends StatefulWidget {
  // Aquí recibimos los datos de las pantallas anteriores
  final String location;
  final String professional;
  final String services;
  final String date;

  const SelectTimeScreen({
    super.key,
    required this.location,
    required this.professional,
    required this.services,
    required this.date,
  });

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  String? selectedTime;

  // Datos de las horas
  final List<String> morningSlots = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30'];
  final List<String> afternoonSlots = ['12:00', '12:30', '13:00', '13:30', '17:00', '17:30', '18:00', '18:30'];
  final List<String> eveningSlots = ['19:00', '19:30'];

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
          const Text('HORAS DISPONIBLES', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF333333), letterSpacing: 1)),
          const SizedBox(height: 4),
          const Text('Selecciona la hora de la reserva', style: TextStyle(fontSize: 14, color: Color(0xFF4A8E9F), fontWeight: FontWeight.w600)),
          const SizedBox(height: 30),

          // --- LISTA DE HORAS ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimeSection('MAÑANA', morningSlots),
                  const SizedBox(height: 30),
                  _buildTimeSection('TARDE', afternoonSlots),
                  const SizedBox(height: 30),
                  _buildTimeSection('NOCHE', eveningSlots),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // --- BARRA INFERIOR ---
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
                  _buildDot(isActive: false),
                  _buildDot(isActive: false),
                  _buildDot(isActive: true), // ¡Paso 5 activo!
                ],
              ),
              GestureDetector(
                onTap: selectedTime != null ? () {
                  // Pasamos TODOS los datos al Resumen final
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(
                        location: widget.location,
                        professional: widget.professional,
                        services: widget.services,
                        date: widget.date,
                        time: selectedTime!,
                      ),
                    ),
                  );
                } : null,
                child: Text('SIGUIENTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: selectedTime != null ? Colors.black87 : Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(String title, List<String> times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.black87, letterSpacing: 1))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.2,
          ),
          itemCount: times.length,
          itemBuilder: (context, index) {
            String time = times[index];
            bool isSelected = selectedTime == time;
            
            return GestureDetector(
              onTap: () {
                setState(() { selectedTime = time; });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Center(
                  child: Text(time, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: isSelected ? Colors.black : Colors.black54)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 6, width: 6, decoration: BoxDecoration(color: isActive ? Colors.black : Colors.grey[300], shape: BoxShape.circle));
  }
}