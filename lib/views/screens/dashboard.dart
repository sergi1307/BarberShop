import 'package:flutter/material.dart';
import 'reservas.dart'; // Para volver a la pantalla principal
import 'networkoverview.dart'; // Para ir a los anuncios

class ProfileDashboardScreen extends StatefulWidget {
  const ProfileDashboardScreen({super.key});

  @override
  State<ProfileDashboardScreen> createState() => _ProfileDashboardScreenState();
}

class _ProfileDashboardScreenState extends State<ProfileDashboardScreen> {
  // El índice seleccionado ahora es 3 (Perfil) para que coincida con el navbar global
  int _selectedIndex = 3; 

  // --- PALETA DE COLORES CLARA ---
  final Color bgColor = const Color(0xFFF9FAFB); 
  final Color surfaceColor = Colors.white; 
  final Color primaryText = const Color(0xFF1F2937); 
  final Color secondaryText = const Color(0xFF6B7280); 
  final Color accentColor = const Color(0xFF4A8E9F); 
  final Color borderColor = const Color(0xFFE5E7EB); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Text('Analíticas de Anuncios', style: TextStyle(color: primaryText, fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Información precisa sobre tu rendimiento.', style: TextStyle(color: secondaryText, fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryText,
                      side: BorderSide(color: borderColor, width: 1.5),
                      backgroundColor: surfaceColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Exportar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2D2D), 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Nuevo Anuncio', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- MÉTRICAS (Bento Grid) ---
            _buildMetricCard('Alcance Total', '1.2M', '+12.5%', Icons.groups, isPositive: true),
            const SizedBox(height: 16),
            _buildMetricCard('Tasa de Interacción', '4.82%', '+0.4%', Icons.ads_click, isPositive: true),
            const SizedBox(height: 16),
            _buildMetricCard('Gasto en Publicidad', '\$14,250', '-2.1%', Icons.payments, isPositive: false),
            const SizedBox(height: 30),

            // --- GRÁFICO SIMULADO ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Impresiones vs Clics', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildChartBar(0.4, 0.2),
                        _buildChartBar(0.6, 0.35),
                        _buildChartBar(0.8, 0.5),
                        _buildChartBar(0.5, 0.3),
                        _buildChartBar(0.7, 0.45),
                        _buildChartBar(0.9, 0.6),
                        _buildChartBar(0.45, 0.25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- CAMPAÑAS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Campañas Activas', style: TextStyle(color: primaryText, fontSize: 18, fontWeight: FontWeight.w800)),
                Text('Ver Todo', style: TextStyle(color: accentColor, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            _buildAdCard('Master\'s Edge Series', 'Campaña de Video', '3.2%', '\$1.42', '4.8x'),
            const SizedBox(height: 40), 
          ],
        ),
      ),

      // --- NAVBAR DE ABAJO IGUAL AL DE RESERVAS ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3182CE), // El azul de Reservas
        unselectedItemColor: Colors.grey[400],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) {
            // Volver a la pantalla de Reservas
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReservationsScreen()),
            );
          } else if (index == 2) {
            // Ir a la sección de Ads/Anuncios
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LuxeCutsScreen()),
            );
          }
          // Si es index 3 (Perfil), ya estamos aquí.
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Locales'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Ads'), 
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  // --- WIDGETS REUTILIZABLES ---
  Widget _buildMetricCard(String title, String value, String trend, IconData icon, {required bool isPositive}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: secondaryText, fontSize: 14, fontWeight: FontWeight.w600)),
              Icon(icon, color: accentColor, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: primaryText, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: isPositive ? Colors.green : Colors.red, size: 16),
              const SizedBox(width: 4),
              Text('$trend vs mes anterior', style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double h1, double h2) {
    return Container(
      width: 32,
      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FractionallySizedBox(heightFactor: h1, child: Container(decoration: BoxDecoration(color: accentColor.withOpacity(0.2), borderRadius: BorderRadius.circular(6)))),
          FractionallySizedBox(heightFactor: h2, child: Container(decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(6)))),
        ],
      ),
    );
  }

  Widget _buildAdCard(String title, String type, String ctr, String cpc, String roas) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=500'), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAdStat('CTR', ctr),
                    _buildAdStat('CPC', cpc),
                    _buildAdStat('ROAS', roas),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdStat(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: secondaryText, fontSize: 11, fontWeight: FontWeight.w700)),
      Text(value, style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.w800)),
    ]);
  }
}