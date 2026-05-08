import 'package:flutter/material.dart';
import 'reservas.dart';
import 'add_ad_screen.dart';
import 'dashboard.dart'; 

class LuxeCutsScreen extends StatefulWidget {
  const LuxeCutsScreen({super.key});

  @override
  State<LuxeCutsScreen> createState() => _LuxeCutsScreenState();
}

class _LuxeCutsScreenState extends State<LuxeCutsScreen> {
  // Estado para controlar qué vista mostrar (false = Anuncios, true = Dashboard)
  bool isShowingDashboard = false;
  
  // --- VARIABLE MÁGICA: Cambia a false para ocultar el panel de control al usuario normal ---
  bool isAdvertiser = true; 

  final List<Map<String, dynamic>> adsData = const [
    {
      'name': 'Modern Tech Gadgets',
      'desc': 'Discover the latest in minimalist technology and home automation solutions.',
      'image': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=800&q=80',
      'tag': 'TECHNOLOGY',
      'active': true,
    },
    {
      'name': 'Urban Barber Essentials',
      'desc': 'The best pomades and razors for the modern gentleman. Professional quality.',
      'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=800&q=80',
      'tag': 'FASHION',
      'active': true,
    },
    {
      'name': 'Mountain Coffee Roasters',
      'desc': 'Organic beans roasted at high altitude for a unique and bold flavor profile.',
      'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
      'tag': 'FOOD & BEV',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: (isAdvertiser && isShowingDashboard) ? const Color(0xFFF4F6F9) : Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Center(
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
            ),
          ),
          title: const Text(
            'LUXE CUTS AD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: Column(
          children: [
            // --- SELECTOR (Anuncios / Dashboard) ---
            if (isAdvertiser)
              Container(
                color: isShowingDashboard ? const Color(0xFFF4F6F9) : Colors.grey[50],
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isShowingDashboard = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isShowingDashboard ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: !isShowingDashboard 
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] 
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Anuncios',
                              style: TextStyle(fontWeight: FontWeight.bold, color: !isShowingDashboard ? Colors.black : Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isShowingDashboard = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isShowingDashboard ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: isShowingDashboard 
                                  ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] 
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Dashboard',
                              style: TextStyle(fontWeight: FontWeight.bold, color: isShowingDashboard ? Colors.black : Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // --- CONTENIDO ---
            Expanded(
              child: (isAdvertiser && isShowingDashboard)
                  ? _buildDashboardContent() 
                  : _buildAdsContent(),
            ),
          ],
        ),
        
        // --- BOTÓN FLOTANTE ---
        floatingActionButton: (isAdvertiser && !isShowingDashboard) ? FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdScreen()));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ) : null,
        
        // --- NAVBAR INFERIOR ---
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF3182CE),
              unselectedItemColor: Colors.grey[400],
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedIconTheme: const IconThemeData(size: 26),
              unselectedIconTheme: const IconThemeData(size: 24),
              currentIndex: 2, 
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const ReservationsScreen(), transitionDuration: Duration.zero));
                } else if (index == 3) {
                  Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const ProfileDashboardScreen(), transitionDuration: Duration.zero));
                }
              },
              items: const [
                BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.calendar_month_outlined)), activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.calendar_month)), label: 'Reservas'),
                BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.location_on_outlined)), activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.location_on)), label: 'Locales'),
                BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.campaign_outlined)), activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.campaign)), label: 'Ads'),
                BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)), activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person)), label: 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================================
  // VISTA 1: LISTA DE ANUNCIOS 
  // ======================================================================
  Widget _buildAdsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Featured Ads', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          Column(children: adsData.map((ad) => _buildFeaturedCard(ad)).toList()),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> ad) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            ad['image'],
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.grey[300], child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ad['tag'], style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    Icon(Icons.circle, size: 10, color: ad['active'] ? Colors.green : Colors.red),
                  ],
                ),
                const SizedBox(height: 6),
                Text(ad['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(ad['desc'], style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================================
  // VISTA 2: DASHBOARD (Estilo Replit, con el "overflow" solucionado)
  // ======================================================================
  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Analíticas de Anuncios', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF111827), letterSpacing: -0.5)),
          const SizedBox(height: 6),
          const Text('Información precisa sobre tu rendimiento.', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 24),

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
                    backgroundColor: const Color(0xFF4361EE),
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

          _buildMetricCard(title: 'ALCANCE TOTAL', value: '1.2M', trendText: '+12.5%', isPositive: true, iconData: Icons.groups_outlined, iconColor: const Color(0xFF4361EE), iconBgColor: const Color(0xFFEFF6FF)),
          const SizedBox(height: 16),
          _buildMetricCard(title: 'TASA DE INTERACCIÓN', value: '4.82%', trendText: '+0.4%', isPositive: true, iconData: Icons.ads_click, iconColor: const Color(0xFF10B981), iconBgColor: const Color(0xFFECFDF5)),
          const SizedBox(height: 16),
          _buildMetricCard(title: 'GASTO EN PUBLICIDAD', value: '\$14,250', trendText: '-2.1%', isPositive: false, iconData: Icons.credit_card, iconColor: const Color(0xFFF97316), iconBgColor: const Color(0xFFFFF7ED)),
          const SizedBox(height: 24),

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
                // --- ARREGLO DE OVERFLOW: He puesto la leyenda debajo en móviles ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Impresiones vs Clics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                    const SizedBox(height: 8),
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
                SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarDay('Lun', 0.4, 0.2), _buildBarDay('Mar', 0.6, 0.4), _buildBarDay('Mié', 0.8, 0.5), _buildBarDay('Jue', 0.5, 0.3), _buildBarDay('Vie', 0.7, 0.45), _buildBarDay('Sáb', 0.9, 0.6), _buildBarDay('Dom', 0.45, 0.25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // --- TARJETA DE CAMPAÑA RESTAURADA ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Campañas Activas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
              Text('Ver Todo', style: TextStyle(color: Color(0xFF4361EE), fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          _buildCampaignCard("Master's Edge Series", "Campaña de Video", "3.2%", "\$1.42", "4.8x"),
        ],
      ),
    );
  }

  // ======================================================================
  // WIDGETS AUXILIARES (Dashboard)
  // ======================================================================
  Widget _buildMetricCard({required String title, required String value, required String trendText, required bool isPositive, required IconData iconData, required Color iconColor, required Color iconBgColor}) {
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
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(14)), child: Icon(iconData, color: iconColor, size: 24)),
          const SizedBox(width: 16),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: isPositive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444), size: 14),
                const SizedBox(width: 4),
                Text(trendText, style: TextStyle(color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
      ],
    );
  }

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
              FractionallySizedBox(heightFactor: h1, child: Container(decoration: BoxDecoration(color: const Color(0xFFBFDBFE), borderRadius: BorderRadius.circular(6)))),
              FractionallySizedBox(heightFactor: h2, child: Container(decoration: BoxDecoration(color: const Color(0xFF4361EE), borderRadius: BorderRadius.circular(6)))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(day, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCampaignCard(String title, String type, String ctr, String cpc, String roas) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              image: const DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=600'), fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.w800), overflow: TextOverflow.ellipsis)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(6)),
                      child: const Text('ACTIVO', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(type, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAdStat('CTR', ctr),
                      Container(width: 1, height: 30, color: Colors.grey.shade300),
                      _buildAdStat('CPC', cpc),
                      Container(width: 1, height: 30, color: Colors.grey.shade300),
                      _buildAdStat('ROAS', roas),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF111827), fontSize: 16, fontWeight: FontWeight.w800)),
      ]
    );
  }
}