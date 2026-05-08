import 'package:flutter/material.dart';
import 'reservas.dart';
import 'anuncios.dart';

class ProfileDashboardScreen extends StatefulWidget {
  const ProfileDashboardScreen({super.key});

  @override
  State<ProfileDashboardScreen> createState() => _ProfileDashboardScreenState();
}

class _ProfileDashboardScreenState extends State<ProfileDashboardScreen> {
  final int _selectedIndex = 3; // Índice del Perfil

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo limpio
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
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
          'MI PERFIL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      
      // --- CUERPO VACÍO (De momento) ---
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Perfil en construcción',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),

      // --- NAVBAR INFERIOR (Para poder volver atrás) ---
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
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const ReservationsScreen(),
                    transitionDuration: Duration.zero,
                  ),
                );
              } else if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LuxeCutsScreen(),
                    transitionDuration: Duration.zero,
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