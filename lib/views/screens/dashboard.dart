import 'package:flutter/material.dart';
import 'reservas.dart';
import 'networkoverview.dart';
import 'add_ad_screen.dart';

class ProfileDashboardScreen extends StatefulWidget {
  const ProfileDashboardScreen({super.key});

  @override
  State<ProfileDashboardScreen> createState() => _ProfileDashboardScreenState();
}

class _ProfileDashboardScreenState extends State<ProfileDashboardScreen> {
  final int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Fondo gris muy clarito de la imagen
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CABECERA ---
            const Text(
              'Analíticas de Anuncios',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF111827), letterSpacing: -0.5),
            ),
            const SizedBox(height: 6),
            const Text(
              'Información precisa sobre tu rendimiento.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 24),

            // --- BOTONES (Exportar y Nuevo Anuncio) ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Exportar', style: TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4361EE), // El azul vibrante de la imagen
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Nuevo Anuncio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- TARJETAS DE MÉTRICAS INDIVIDUALES ---
            _buildMetricCard(
              title: 'ALCANCE TOTAL',
              value: '1.2M',
              trendText: '+12.5%',
              isPositive: true,
              iconData: Icons.groups_outlined,
              iconColor: const Color(0xFF4361EE), // Azul
              iconBgColor: const Color(0xFFEFF6FF),
            ),
            const SizedBox(height: 16),
            _buildMetricCard(
              title: 'TASA DE INTERACCIÓN',
              value: '4.82%',
              trendText: '+0.4%',
              isPositive: true,
              iconData: Icons.ads_click, // Cursor
              iconColor: const Color(0xFF10B981), // Verde
              iconBgColor: const Color(0xFFECFDF5),
            ),
            const SizedBox(height: 16),
            _buildMetricCard(
              title: 'GASTO EN PUBLICIDAD',
              value: '\$14,250',
              trendText: '-2.1%',
              isPositive: false,
              iconData: Icons.credit_card, // Tarjeta
              iconColor: const Color(0xFFF97316), // Naranja
              iconBgColor: const Color(0xFFFFF7ED),
            ),
            const SizedBox(height: 24),

            // --- GRÁFICO (Impresiones vs Clics) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Impresiones vs Clics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                      Row(
                        children: [
                          _buildLegendDot(const Color(0xFFBFDBFE), 'Impresiones'),
                          const SizedBox(width: 12),
                          _buildLegendDot(const Color(0xFF4361EE), 'Clics'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Las barras del gráfico
                  SizedBox(
                    height: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBarDay('Lun', 0.4, 0.2),
                        _buildBarDay('Mar', 0.6, 0.4),
                        _buildBarDay('Mié', 0.8, 0.5),
                        _buildBarDay('Jue', 0.5, 0.3),
                        _buildBarDay('Vie', 0.7, 0.45),
                        _buildBarDay('Sáb', 0.9, 0.6),
                        _buildBarDay('Dom', 0.45, 0.25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- TÍTULO DE CAMPAÑAS ACTIVAS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Campañas Activas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                const Text('Ver Todo', style: TextStyle(color: Color(0xFF4361EE), fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 16),
            
            // --- IMAGEN INFERIOR ---
            Container(
              height: 120, // Altura ajustada
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=600'), 
                  fit: BoxFit.cover
                )
              ),
            ),
          ],
        ),
      ),

      // --- NAVBAR INFERIOR ---
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: const Color(0xFF3182CE), 
            unselectedItemColor: Colors.grey[400],
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReservationsScreen()));
              } else if (index == 2) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LuxeCutsScreen()));
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Reservas'),
              BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Locales'),
              BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Ads'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  // --- CONSTRUCTOR DE LAS TARJETAS ---
  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trendText,
    required bool isPositive,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // Icono con fondo de color
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(14)),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6B7280), letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
              ],
            ),
          ),
          // Píldora de porcentaje
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isPositive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down, 
                  color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444), 
                  size: 14
                ),
                const SizedBox(width: 4),
                Text(
                  trendText, 
                  style: TextStyle(
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444), 
                    fontWeight: FontWeight.bold, 
                    fontSize: 12
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- LEYENDA DEL GRÁFICO ---
  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      ],
    );
  }

  // --- BARRAS DEL GRÁFICO ---
  Widget _buildBarDay(String day, double h1, double h2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 100, 
          width: 24,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Barra clara (Impresiones)
              FractionallySizedBox(
                heightFactor: h1,
                child: Container(decoration: BoxDecoration(color: const Color(0xFFBFDBFE), borderRadius: BorderRadius.circular(6)))
              ),
              // Barra oscura (Clics)
              FractionallySizedBox(
                heightFactor: h2,
                child: Container(decoration: BoxDecoration(color: const Color(0xFF4361EE), borderRadius: BorderRadius.circular(6)))
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(day, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}