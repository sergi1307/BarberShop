import 'package:flutter/material.dart';
import 'anuncios.dart'; 
import 'localizacion.dart';
import 'dashboard.dart'; // <-- Asegúrate de que el nombre coincide con tu archivo del perfil
import 'dart:async';
import 'add_ad_screen.dart';
import '../widgets/ad_banner.dart';

// --- VARIABLE GLOBAL MÁGICA ---
// Esto permite que otras pantallas (como la de Editar) puedan apagar o encender el anuncio del carrusel
bool isCampaignActiveGlobal = true; 

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  int _currentAdIndex = 0;
  late Timer _bannerTimer;

  final List<Map<String, dynamic>> _ads = [
    {
      'id': '101',
      'name': "Master's Edge Series",
      'desc': 'The ultimate precision tools for professional barbers.',
      'image': 'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?w=600',
      'tag': 'PRO TOOLS',
    },
    {
      'id': '102',
      'name': 'Urban Style Pomade',
      'desc': 'Strong hold, natural shine. The perfect finish for every cut.',
      'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&w=800&q=80',
      'tag': 'STYLE',
    },
    {
      'id': 'PROMO',
      'name': '¿Quieres anunciarte aquí?',
      'desc': 'Llega a miles de clientes locales y haz crecer tu negocio.',
      'image': 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?q=80&w=800',
      'tag': 'PROMOTE',
      'isPromo': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[800],
            child: const Text('LOGO', style: TextStyle(fontSize: 8, color: Colors.white)),
          ),
        ),
        title: const Text(
          'Beard Barbershop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  '¡Uups!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No hay ninguna reserva pendiente',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Reservas Anteriores',
                    style: TextStyle(
                      color: Color(0xFF3182CE),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- CARRUSEL DINÁMICO ---
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
                  if (_ads[_currentAdIndex]['isPromo'] == true) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdScreen()));
                  }
                },
              ),
            ),
          ),

          // Botón Reservar
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SelectLocationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'RESERVAR',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
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
            currentIndex: 0,
            onTap: (index) {
              if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const LuxeCutsScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              } else if (index == 3) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => const ProfileDashboardScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.calendar_month_outlined)),
                activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.calendar_month)),
                label: 'Reservas'
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.location_on_outlined)),
                activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.location_on)),
                label: 'Locales'
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.campaign_outlined)),
                activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.campaign)),
                label: 'Ads'
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)),
                activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person)),
                label: 'Perfil'
              ),
            ],
          ),
        ),
      ),
    );
  }

}