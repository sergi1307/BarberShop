import 'package:flutter/material.dart';
import 'reservas.dart';
import 'add_ad_screen.dart';
import 'dashboard.dart';
import 'editaranuncio.dart'; 
import '../widgets/ad_banner.dart';

class LuxeCutsScreen extends StatefulWidget {
  const LuxeCutsScreen({super.key});

  @override
  State<LuxeCutsScreen> createState() => _LuxeCutsScreenState();
}

class _LuxeCutsScreenState extends State<LuxeCutsScreen> {
  bool isShowingDashboard = false;
  bool isAdvertiser = true;

  // --- VARIABLES DE ESTADO ---
  bool _isCampaignDeleted = false; 
  String _tituloCampana = "Master's Edge Series"; 
  String _cpcCampana = "\$1.42"; 
  bool _isCampaignActive = true; 
  
  // --- SEARCH CONTROLLER ---
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // --- LISTA DE ANUNCIOS ---
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

  // --- FUNCIÓN NUEVA: Calcula los últimos 7 días terminando HOY ---
  List<String> _getLast7DaysLabels() {
    final now = DateTime.now();
    final List<String> labels = [];
    final List<String> weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    // Bucle que va desde hace 6 días hasta hoy (0)
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // date.weekday devuelve un número del 1 (Lunes) al 7 (Domingo)
      labels.add(weekDays[date.weekday - 1]);
    }
    return labels;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: Column(
          children: [
            if (isAdvertiser)
              Container(
                color: isShowingDashboard ? const Color(0xFFF4F6F9) : Colors.grey[50],
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Expanded(child: _buildTabButton('Anuncios', !isShowingDashboard, () => setState(() => isShowingDashboard = false))),
                      Expanded(child: _buildTabButton('Dashboard', isShowingDashboard, () => setState(() => isShowingDashboard = true))),
                    ],
                  ),
                ),
              ),

            Expanded(
              child: isShowingDashboard ? _buildDashboardContent() : _buildAdsContent(),
            ),
          ],
        ),
        
        floatingActionButton: (isAdvertiser && !isShowingDashboard) ? FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdScreen())),
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ) : null,
        
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : [],
        ),
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.grey[600])),
      ),
    );
  }

  Widget _buildAdsContent() {
    final filteredAds = adsData.where((ad) {
      final name = (ad['name'] ?? '').toString().toLowerCase();
      final desc = (ad['desc'] ?? '').toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de Búsqueda Premium
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar anuncios...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black54, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          Text(
            _searchQuery.isEmpty ? 'Featured Ads' : 'Resultados para "$_searchQuery"',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          
          if (filteredAds.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'No se encontraron anuncios',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: filteredAds.map<Widget>((ad) => _buildFeaturedCard(ad)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> ad) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: BannerAdWidget(
        id: ad['name'] ?? '',
        name: ad['name'] ?? '',
        desc: ad['desc'] ?? '',
        image: ad['image'] ?? '',
        tag: ad['tag'] ?? '',
        isActive: ad['active'] ?? true,
      ),
    );
  }

  Widget _buildDashboardContent() {
    // Llamamos a la función para tener las etiquetas de la semana actualizadas al día de hoy
    final labels = _getLast7DaysLabels();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Analíticas de Anuncios', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
          const SizedBox(height: 6),
          const Text('Información precisa sobre tu rendimiento.', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(child: SizedBox()), 
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdScreen())),
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

          // --- GRÁFICO DINÁMICO (Usando los labels calculados) ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Impresiones vs Clics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                const SizedBox(height: 8),
                Row(children: [_buildLegendDot(const Color(0xFFBFDBFE), 'Impresiones'), const SizedBox(width: 12), _buildLegendDot(const Color(0xFF4361EE), 'Clics')]),
                const SizedBox(height: 30),
                SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Usamos el array 'labels' que hemos creado dinámicamente arriba
                      _buildBarDay(labels[0], 0.4, 0.2), 
                      _buildBarDay(labels[1], 0.6, 0.4), 
                      _buildBarDay(labels[2], 0.8, 0.5), 
                      _buildBarDay(labels[3], 0.5, 0.3), 
                      _buildBarDay(labels[4], 0.7, 0.45), 
                      _buildBarDay(labels[5], 0.9, 0.6), 
                      _buildBarDay(labels[6], 0.45, 0.25)
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Campañas Activas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
              Text('Ver Todo', style: TextStyle(color: Color(0xFF4361EE), fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          _buildCampaignCard(_tituloCampana, "Campaña de Video", "3.2%", _cpcCampana, "4.8x"),
        ],
      ),
    );
  }

  // --- WIDGET ACTUALIZADO PARA USAR EL DISEÑO DE TU COMPAÑERO ---
  Widget _buildCampaignCard(String title, String type, String ctr, String cpc, String roas) {
    if (_isCampaignDeleted) return const SizedBox.shrink(); 

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditAdScreen(
              currentTitle: _tituloCampana,
              currentCpc: _cpcCampana,
              currentIsActive: _isCampaignActive,
            ),
          ),
        );

        if (result == true) {
          setState(() => _isCampaignDeleted = true);
        } else if (result is Map<String, dynamic>) {
          setState(() {
            _tituloCampana = result['titulo'] ?? _tituloCampana; 
            _cpcCampana = "\$${result['puja']}"; 
            _isCampaignActive = result['activo'] ?? true; 
          });
        }
      },
      child: Column(
        children: [
          // 1. La tarjeta estética que hizo tu compañero
          BannerAdWidget(
            id: 'dashboard_campaign',
            name: title,
            desc: "Promoción exclusiva para clientes de Beard Style.", // Descripción genérica para el dashboard
            image: 'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=600',
            tag: 'CAMPAIGN',
            isActive: _isCampaignActive,
          ),
          
          // 2. Las métricas pegadas justo debajo para el Dashboard
          Transform.translate(
            offset: const Offset(0, -10), // Subimos un poco el contenedor para que parezca pegado
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10), // Lo hacemos un poco más estrecho para dar efecto de "sombra"
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAdStat('CTR', ctr),
                  Container(height: 30, width: 1, color: Colors.grey.shade300), // Divisor visual
                  _buildAdStat('CPC', cpc),
                  Container(height: 30, width: 1, color: Colors.grey.shade300), // Divisor visual
                  _buildAdStat('ROAS', roas),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required String trendText, required bool isPositive, required IconData iconData, required Color iconColor, required Color iconBgColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(14)), child: Icon(iconData, color: iconColor, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))])),
          Text(trendText, style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) => Row(children: [Icon(Icons.circle, color: color, size: 10), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12))]);

  Widget _buildBarDay(String day, double h1, double h2) {
    return Column(
      children: [
        SizedBox(height: 100, width: 20, child: Stack(alignment: Alignment.bottomCenter, children: [Container(decoration: BoxDecoration(color: const Color(0xFFBFDBFE), borderRadius: BorderRadius.circular(4))), FractionallySizedBox(heightFactor: h2, child: Container(decoration: BoxDecoration(color: const Color(0xFF4361EE), borderRadius: BorderRadius.circular(4))))])),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildAdStat(String label, String value) => Column(children: [Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w600)), Text(value, style: const TextStyle(color: Color(0xFF111827), fontSize: 15, fontWeight: FontWeight.w800))]);

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF3182CE),
      onTap: (index) {
        if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReservationsScreen()));
        if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileDashboardScreen()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Reservas'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Locales'),
        BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Ads'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ],
    );
  }
}